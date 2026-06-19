import 'package:dio/dio.dart';

import '../../core/error/failures.dart';
import '../../core/network/api_client.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final ApiClient apiClient;

  NotificationRepository({required this.apiClient});

  /// Get all notifications
  Future<Result<List<NotificationModel>>> getNotifications() async {
    try {
      final notifications = await apiClient.getNotifications();
      return Result.success(notifications);
    } on DioException catch (e) {
      return Result.failure(_mapDioException(e));
    } catch (e) {
      return Result.failure(Failure.unknown('Unexpected error: $e'));
    }
  }

  /// Mark notification as read
  Future<Result<void>> markNotificationRead(String id) async {
    try {
      await apiClient.markNotificationRead(id);
      return Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_mapDioException(e));
    } catch (e) {
      return Result.failure(Failure.unknown('Unexpected error: $e'));
    }
  }

  /// Mark all notifications as read
  Future<Result<void>> markAllNotificationsRead() async {
    try {
      await apiClient.markAllNotificationsRead();
      return Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_mapDioException(e));
    } catch (e) {
      return Result.failure(Failure.unknown('Unexpected error: $e'));
    }
  }

  Failure _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return Failure.network('Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        final message =
            e.response?.data['message'] ?? 'Server error: $statusCode';
        return Failure.server(message);
      case DioExceptionType.cancel:
        return Failure.network('Request cancelled');
      default:
        return Failure.network('Network error: ${e.message}');
    }
  }
}
