import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/http_client.dart';
import '../models/vehicle_model.dart';

class VehicleRepository {
  final FarchisHttpClient client;

  VehicleRepository(this.client);

  Future<Result<List<VehicleModel>>> getVehicles() async {
    try {
      final response = await client.get(ApiConstants.vehicles);
      final data = response['data'] as List;
      return Result.success(data.map((e) => VehicleModel.fromJson(e)).toList());
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Result<VehicleModel>> addVehicle(Map<String, dynamic> payload) async {
    try {
      final response = await client.post(ApiConstants.vehicles, body: payload);
      return Result.success(VehicleModel.fromJson(response['data']));
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Result<VehicleModel>> updateVehicle(int id, Map<String, dynamic> payload) async {
    try {
      final response = await client.put(ApiConstants.vehicle(id.toString()), body: payload);
      return Result.success(VehicleModel.fromJson(response['data']));
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Result<void>> deleteVehicle(int id) async {
    try {
      await client.delete(ApiConstants.vehicle(id.toString()));
      return Result.success(null);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Result<VehicleModel>> setPrimary(int id) async {
    try {
      final response = await client.post(ApiConstants.setPrimaryVehicle(id.toString()));
      return Result.success(VehicleModel.fromJson(response['data']));
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Result<List<VehicleSizeCategoryModel>>> getSizeCategories() async {
    try {
      final response = await client.get(ApiConstants.vehicleSizeCategories);
      final data = response['data'] as List;
      return Result.success(data.map((e) => VehicleSizeCategoryModel.fromJson(e)).toList());
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
