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
      return Result.failure(Failure.validation(errors)) as FailureResult<T>;
    } else if (e is UnauthorizedException) {
      return Result.failure(Failure.unauthorized(e.message)) as FailureResult<T>;
    } else if (e is NetworkException) {
      return Result.failure(Failure.network(e.message)) as FailureResult<T>;
    } else if (e is NotFoundException) {
      return Result.failure(Failure.notFound(e.message)) as FailureResult<T>;
    } else if (e is ServerException) {
      return Result.failure(Failure.server(e.message, statusCode: e.statusCode)) as FailureResult<T>;
    }
    return Result.failure(Failure.unknown(e.toString())) as FailureResult<T>;
  }
}
