import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/http_client.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FarchisHttpClient client;

  AuthRepository(this.client);

  Future<Result<UserModel>> login(String email, String password) async {
    try {
      final response = await client.post(
        ApiConstants.authLogin,
        body: {'email': email, 'password': password},
      );
      return Result.success(UserModel.fromJson(response['data']['user']));
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Result<UserModel>> register(String name, String email, String password, String phone) async {
    try {
      final response = await client.post(
        ApiConstants.authRegister,
        body: {'name': name, 'email': email, 'password': password, 'phone': phone},
      );
      return Result.success(UserModel.fromJson(response['data']['user']));
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Result<UserModel>> googleSignIn(String idToken) async {
    try {
      final response = await client.post(
        ApiConstants.authGoogle,
        body: {'id_token': idToken},
      );
      return Result.success(UserModel.fromJson(response['data']['user']));
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Result<UserModel>> getMe() async {
    try {
      final response = await client.get(ApiConstants.authMe);
      return Result.success(UserModel.fromJson(response['data']));
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
