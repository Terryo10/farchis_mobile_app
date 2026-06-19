import 'package:dio/dio.dart';

import '../../core/error/failures.dart';
import '../../core/network/api_client.dart';
import '../models/user_model.dart';

class VehicleRepository {
  final ApiClient apiClient;

  VehicleRepository({required this.apiClient});

  /// Update vehicle information
  Future<Result<UserModel>> updateVehicle({
    required String vehicleMake,
    required String vehicleModel,
    required int vehicleYear,
    required String vehiclePlate,
  }) async {
    try {
      final user = await apiClient.updateVehicle({
        'vehicle_make': vehicleMake,
        'vehicle_model': vehicleModel,
        'vehicle_year': vehicleYear,
        'vehicle_plate': vehiclePlate,
      });
      return Result.success(user);
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
