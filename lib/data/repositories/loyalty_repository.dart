import 'package:dio/dio.dart';

import '../../core/error/failures.dart';
import '../../core/network/api_client.dart';
import '../models/loyalty_wallet_model.dart';

class LoyaltyRepository {
  final ApiClient apiClient;

  LoyaltyRepository({required this.apiClient});

  /// Get loyalty wallet
  Future<Result<LoyaltyWalletModel>> getLoyaltyWallet() async {
    try {
      final wallet = await apiClient.getLoyaltyWallet();
      return Result.success(wallet);
    } on DioException catch (e) {
      return Result.failure(_mapDioException(e));
    } catch (e) {
      return Result.failure(Failure.unknown('Unexpected error: $e'));
    }
  }

  /// Get loyalty transactions
  Future<Result<List<Map<String, dynamic>>>> getLoyaltyTransactions() async {
    try {
      final transactions = await apiClient.getLoyaltyTransactions();
      return Result.success(transactions);
    } on DioException catch (e) {
      return Result.failure(_mapDioException(e));
    } catch (e) {
      return Result.failure(Failure.unknown('Unexpected error: $e'));
    }
  }

  /// Redeem loyalty points
  Future<Result<Map<String, dynamic>>> redeemPoints({
    required int points,
    String? rewardId,
  }) async {
    try {
      final data = <String, dynamic>{
        'points': points,
      };

      if (rewardId != null) {
        data['reward_id'] = rewardId;
      }

      final response = await apiClient.redeemPoints(data);
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
