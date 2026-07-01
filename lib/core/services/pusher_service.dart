import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../constants/api_constants.dart';

/// Thin wrapper around [PusherChannelsFlutter] wired up for the backend's
/// self-hosted Laravel Reverb server (Pusher-protocol compatible) and its
/// Sanctum-authenticated `/broadcasting/auth` endpoint.
///
/// KNOWN LIMITATION (read before touching connection config): the published
/// `pusher_channels_flutter` package's public Dart `init()` method only ever
/// forwards `apiKey`/`cluster` (plus timeouts/auth options) to the native
/// platform layer — it has no `host`/`wsPort`/`wssPort` parameters, even
/// though iOS's native `SwiftPusherChannelsFlutterPlugin` *does* honor those
/// keys when present in the raw method-channel arguments (Android's Kotlin
/// plugin in this version never reads a host key at all, so self-hosted
/// Reverb cannot work there with this plugin release). To point the socket
/// at our local Reverb server instead of Pusher's cloud, we call the public
/// `init()` first (so the callback plumbing + auth wiring gets registered),
/// then immediately re-invoke the same method channel directly with the
/// extra native keys. This means real-time works end-to-end on iOS; Android
/// will silently try to reach Pusher's cloud cluster until either the plugin
/// adds native host support or this app switches to a raw WebSocket
/// implementation of the Pusher protocol.
class PusherService {
  PusherService(this._secureStorage);

  final FlutterSecureStorage _secureStorage;
  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();
  bool _initialized = false;
  bool _connected = false;

  Future<void> ensureConnected() async {
    if (!_initialized) {
      await _pusher.init(
        apiKey: ApiConstants.reverbAppKey,
        cluster: 'mt1', // required by the wrapper; overridden below for self-hosted Reverb
        onAuthorizer: _authorizer,
        onConnectionStateChange: (current, previous) {},
        onError: (message, code, error) {},
      );

      // See class doc comment above for why this second raw call exists.
      await _pusher.methodChannel.invokeMethod('init', {
        'apiKey': ApiConstants.reverbAppKey,
        'host': ApiConstants.reverbHost,
        'wsPort': ApiConstants.reverbPort,
        'wssPort': ApiConstants.reverbPort,
        'useTLS': ApiConstants.reverbScheme == 'https',
        'authorizer': true,
      });
      _initialized = true;
    }

    if (!_connected) {
      await _pusher.connect();
      _connected = true;
    }
  }

  Future<dynamic> _authorizer(String channelName, String socketId, dynamic options) async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      final response = await http.post(
        Uri.parse(ApiConstants.broadcastingAuthUrl),
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: {'channel_name': channelName, 'socket_id': socketId},
      );

      if (response.statusCode != 200) return null;

      final decoded = json.decode(response.body) as Map<String, dynamic>;
      final auth = decoded['auth'] as String?;
      if (auth == null) return null;

      return {
        'auth': auth,
        if (decoded['channel_data'] != null) 'channel_data': decoded['channel_data'].toString(),
      };
    } catch (_) {
      return null;
    }
  }

  /// Laravel's broadcasting protocol requires the wire-level channel name to
  /// carry the `private-`/`presence-` prefix (Echo adds it automatically for
  /// browser clients); `Broadcast::auth()` strips it server-side before
  /// matching against `routes/channels.php`. `Broadcast::channel()`
  /// definitions there are written without the prefix, so callers of this
  /// service pass the bare name (e.g. `conversation.5`) and this helper adds it.
  static String privateChannel(String name) => 'private-$name';

  Future<PusherChannel> subscribe({
    required String channelName,
    required void Function(PusherEvent event) onEvent,
  }) async {
    await ensureConnected();
    return _pusher.subscribe(channelName: channelName, onEvent: onEvent);
  }

  Future<void> unsubscribe(String channelName) async {
    try {
      await _pusher.unsubscribe(channelName: channelName);
    } catch (_) {}
  }
}
