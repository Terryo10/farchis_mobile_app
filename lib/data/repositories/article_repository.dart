import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/http_client.dart';
import '../models/article_model.dart';

class ArticleRepository {
  final FarchisHttpClient client;

  ArticleRepository(this.client);

  Future<Result<List<ArticleModel>>> getArticles() async {
    try {
      final response = await client.get(ApiConstants.articles);
      final data = response['data'] as List;
      return Result.success(data.map((e) => ArticleModel.fromJson(e)).toList());
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
