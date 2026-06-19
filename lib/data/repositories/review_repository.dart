import 'package:dio/dio.dart';

import '../../core/error/failures.dart';
import '../../core/network/api_client.dart';
import '../models/review_model.dart';

class ReviewRepository {
  final ApiClient apiClient;

  ReviewRepository({required this.apiClient});

  /// Get all reviews
  Future<Result<List<ReviewModel>>> getReviews() async {
    try {
      final reviews = await apiClient.getReviews();
      return Result.success(reviews);
    } on DioException catch (e) {
      return Result.failure(_mapDioException(e));
    } catch (e) {
      return Result.failure(Failure.unknown('Unexpected error: $e'));
    }
  }

  /// Create a review
  Future<Result<ReviewModel>> createReview({
    required String bookingId,
    required int rating,
    required String comment,
  }) async {
    try {
      final review = await apiClient.createReview({
        'booking_id': bookingId,
        'rating': rating,
        'comment': comment,
      });
      return Result.success(review);
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
