import 'package:dio/dio.dart';

import '../../core/error/failures.dart';
import '../../core/network/api_client.dart';
import '../models/service_model.dart';

class ServiceRepository {
  final ApiClient apiClient;

  ServiceRepository({required this.apiClient});

  /// Get all services
  Future<Result<List<ServiceModel>>> getServices() async {
    try {
      final services = await apiClient.getServices();
      return Result.success(services);
    } on DioException catch (e) {
      return Result.failure(_mapDioException(e));
    } catch (e) {
      return Result.failure(Failure.unknown('Unexpected error: $e'));
    }
  }

  /// Get service by ID
  Future<Result<ServiceModel>> getService(String id) async {
    try {
      final service = await apiClient.getService(id);
      return Result.success(service);
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
