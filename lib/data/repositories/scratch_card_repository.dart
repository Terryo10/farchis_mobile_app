import 'package:dio/dio.dart';

import '../../core/error/failures.dart';
import '../../core/network/api_client.dart';
import '../models/scratch_card_model.dart';

class ScratchCardRepository {
  final ApiClient apiClient;

  ScratchCardRepository({required this.apiClient});

  /// Get all scratch cards
  Future<Result<List<ScratchCardModel>>> getScratchCards() async {
    try {
      final cards = await apiClient.getScratchCards();
      return Result.success(cards);
    } on DioException catch (e) {
      return Result.failure(_mapDioException(e));
    } catch (e) {
      return Result.failure(Failure.unknown('Unexpected error: $e'));
    }
  }

  /// Scratch a card
  Future<Result<ScratchCardModel>> scratchCard(String id) async {
    try {
      final card = await apiClient.scratchCard(id);
      return Result.success(card);
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
        if (statusCode == 404) {
          return Failure.notFound(message);
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
