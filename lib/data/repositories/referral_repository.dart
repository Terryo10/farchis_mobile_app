import 'package:dio/dio.dart';

import '../../core/error/failures.dart';
import '../../core/network/api_client.dart';
import '../models/referral_model.dart';

class ReferralRepository {
  final ApiClient apiClient;

  ReferralRepository({required this.apiClient});

  /// Get referral information
  Future<Result<ReferralModel>> getReferrals() async {
    try {
      final referral = await apiClient.getReferrals();
      return Result.success(referral);
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
