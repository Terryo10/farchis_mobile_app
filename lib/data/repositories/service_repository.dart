import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/http_client.dart';
import '../models/service_model.dart';

class ServiceRepository {
  final FarchisHttpClient client;

  ServiceRepository(this.client);

  Future<Result<List<ServiceModel>>> getServices() async {
    try {
      final response = await client.get(ApiConstants.services);
      final data = response['data'] as List;
      return Result.success(data.map((e) => ServiceModel.fromJson(e)).toList());
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Result<ServiceModel>> getService(String id) async {
    try {
      final response = await client.get('${ApiConstants.services}/$id');
      return Result.success(ServiceModel.fromJson(response['data']));
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
