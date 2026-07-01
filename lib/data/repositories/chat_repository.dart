import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/http_client.dart';
import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';

class ChatRepository {
  final FarchisHttpClient client;

  ChatRepository(this.client);

  /// Calling this always ensures a `general` support conversation exists for
  /// the current user.
  Future<Result<List<ConversationModel>>> getConversations() async {
    try {
      final response = await client.get(ApiConstants.conversations);
      final data = response['data'] as List;
      return Result.success(data.map((e) => ConversationModel.fromJson(e)).toList());
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Result<List<ChatMessageModel>>> getMessages(int conversationId) async {
    try {
      final response = await client.get(ApiConstants.conversationMessages(conversationId.toString()));
      final data = response['data'] as List;
      return Result.success(data.map((e) => ChatMessageModel.fromJson(e)).toList());
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Result<ChatMessageModel>> sendMessage(
    int conversationId, {
    String? body,
    List<String> attachmentPaths = const [],
  }) async {
    try {
      final fields = <String, String>{
        if (body != null && body.isNotEmpty) 'body': body,
      };

      final files = <http.MultipartFile>[];
      for (final path in attachmentPaths) {
        files.add(await http.MultipartFile.fromPath('attachments[]', path));
      }

      final response = await client.uploadFiles(
        ApiConstants.conversationMessages(conversationId.toString()),
        fields,
        files,
      );
      return Result.success(ChatMessageModel.fromJson(response['data']));
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Result<void>> markRead(int conversationId) async {
    try {
      await client.post(ApiConstants.markConversationRead(conversationId.toString()));
      return Result.success(null);
    } catch (e) {
      return _handleError(e);
    }
  }

  FailureResult<T> _handleError<T>(Object e) {
    if (e is ValidationException) {
      final errors = e.errors.map((key, value) => MapEntry(key, value.toString()));
      return FailureResult<T>(Failure.validation(errors));
    } else if (e is UnauthorizedException) {
      return FailureResult<T>(Failure.unauthorized(e.message));
    } else if (e is NetworkException) {
      return FailureResult<T>(Failure.network(e.message));
    } else if (e is NotFoundException) {
      return FailureResult<T>(Failure.notFound(e.message));
    } else if (e is ServerException) {
      return FailureResult<T>(Failure.server(e.message, statusCode: e.statusCode));
    }
    return FailureResult<T>(Failure.unknown(e.toString()));
  }
}
