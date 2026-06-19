import 'package:dio/dio.dart';

import '../../core/error/failures.dart';
import '../../core/network/api_client.dart';

class PaymentRepository {
  final ApiClient apiClient;

  PaymentRepository({required this.apiClient});

  /// Initiate payment
  Future<Result<Map<String, dynamic>>> initiatePayment({
    required String bookingId,
    required double amount,
    required String method,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final data = {
        'booking_id': bookingId,
        'amount': amount,
        'method': method,
      };

      if (metadata != null) {
        data.addAll(metadata);
      }

      final response = await apiClient.initiatePayment(data);
      return Result.success(response);
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
        if (statusCode == 422) {
          final errors = e.response?.data['errors'] ?? {};
          return Failure.validation(Map<String, String>.from(errors));
        } else if (statusCode >= 500) {
          return Failure.server(message);
        }
        return Failure.server(message);
      case DioExceptionType.cancel:
        return Failure.network('Request cancelled');
      default:
        return Failure.network('Network error: ${e.message}');
    }
  }
}
