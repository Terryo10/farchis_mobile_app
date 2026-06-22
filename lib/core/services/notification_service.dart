import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../presentation/router/app_router.dart';
import '../../data/models/notification_model.dart';
import '../di/injection.dart';
import '../../blocs/auth/auth_event.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Handle background message if needed
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  static Future<void> initialize(AppRouter router) async {
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await messaging.getToken();
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', token);
      }

      messaging.onTokenRefresh.listen((newToken) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', newToken);
        // Trigger update event if auth bloc is initialized
        try {
          Injection.authBloc.add(UpdateFcmTokenEvent(token: newToken));
        } catch (_) {}
      });

      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosInit = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

      await _localNotifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (details) {
          if (details.payload != null) {
            try {
              final payloadData = jsonDecode(details.payload!);
              final n = NotificationModel.fromJson(payloadData);
              AppRouter.navigateFromNotification(n, router);
            } catch (_) {}
          }
        },
      );

      // Foreground handler
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final notification = message.notification;
        if (notification != null) {
          _localNotifications.show(
            id: notification.hashCode,
            title: notification.title,
            body: notification.body,
            notificationDetails: const NotificationDetails(
              android: AndroidNotificationDetails(
                'farchis_channel',
                'Farchis Notifications',
                channelDescription: 'Notifications for Farchis App',
                importance: Importance.max,
                priority: Priority.high,
              ),
              iOS: DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
            payload: jsonEncode(message.data),
          );
        }
      });

      // Tap handler when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        try {
          final n = NotificationModel.fromJson(message.data);
          AppRouter.navigateFromNotification(n, router);
        } catch (_) {}
      });
    }
  }
}
