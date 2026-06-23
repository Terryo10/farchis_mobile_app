import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/http_client.dart';
import '../models/loyalty_wallet_model.dart';
import '../models/loyalty_transaction_model.dart';

class LoyaltyRepository {
  final FarchisHttpClient client;

  LoyaltyRepository(this.client);

  Future<Result<LoyaltyWalletModel>> getWallet() async {
    try {
      final response = await client.get(ApiConstants.loyaltyWallet);
      return Result.success(LoyaltyWalletModel.fromJson(response['data']));
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Result<List<LoyaltyTransactionModel>>> getTransactions() async {
    try {
      final response = await client.get(ApiConstants.loyaltyTransactions);
      final data = response['data'] as List;
      return Result.success(data.map((e) => LoyaltyTransactionModel.fromJson(e)).toList());
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Result<bool>> redeemPoints({required int points, required String? rewardId}) async {
    try {
      await client.post(
        ApiConstants.loyaltyRedeem,
        body: {'points': points, 'reward_id': rewardId},
      );
      return Result.success(true);
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
