import 'package:dio/dio.dart';

import '../../core/error/failures.dart';
import '../../core/network/api_client.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient apiClient;

  AuthRepository({required this.apiClient});

  /// Send OTP to user's phone
  Future<Result<Map<String, dynamic>>> sendOtp({required String phone}) async {
    try {
      final response = await apiClient.sendOtp({'phone': phone});
      return Result.success(response);
    } on DioException catch (e) {
      return Result.failure(_mapDioException(e));
    } catch (e) {
      return Result.failure(Failure.unknown('Unexpected error: $e'));
    }
  }

  /// Verify OTP and authenticate
  Future<Result<UserModel>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await apiClient.verifyOtp({
        'phone': phone,
        'otp': otp,
      });

      if (response.containsKey('token')) {
        // Token will be persisted separately in the Dio client
        return Result.success(UserModel.fromJson(response['user']));
      } else {
        return Result.failure(Failure.server('No token in response'));
      }
    } on DioException catch (e) {
      return Result.failure(_mapDioException(e));
    } catch (e) {
      return Result.failure(Failure.unknown('Unexpected error: $e'));
    }
  }

  /// Get current user profile
  Future<Result<UserModel>> getProfile() async {
    try {
      final user = await apiClient.getProfile();
      return Result.success(user);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Result.failure(Failure.unauthorized('Unauthorized'));
      }
      return Result.failure(_mapDioException(e));
    } catch (e) {
      return Result.failure(Failure.unknown('Unexpected error: $e'));
    }
  }

  /// Update user profile
  Future<Result<UserModel>> updateProfile({
    required String name,
    String? email,
    String? phone,
    String? vehicleMake,
    String? vehicleModel,
    int? vehicleYear,
    String? vehiclePlate,
  }) async {
    try {
      final data = <String, dynamic>{
        'name': name,
      };

      if (email != null) data['email'] = email;
      if (phone != null) data['phone'] = phone;
      if (vehicleMake != null) data['vehicle_make'] = vehicleMake;
      if (vehicleModel != null) data['vehicle_model'] = vehicleModel;
      if (vehicleYear != null) data['vehicle_year'] = vehicleYear;
      if (vehiclePlate != null) data['vehicle_plate'] = vehiclePlate;

      final user = await apiClient.updateProfile(data);
      return Result.success(user);
    } on DioException catch (e) {
      return Result.failure(_mapDioException(e));
    } catch (e) {
      return Result.failure(Failure.unknown('Unexpected error: $e'));
    }
  }

  /// Update FCM token for push notifications
  Future<Result<Map<String, dynamic>>> updateFcmToken({
    required String token,
  }) async {
    try {
      final response = await apiClient.updateFcmToken({'fcm_token': token});
      return Result.success(response);
    } on DioException catch (e) {
      return Result.failure(_mapDioException(e));
    } catch (e) {
      return Result.failure(Failure.unknown('Unexpected error: $e'));
    }
  }

  /// Logout user
  Future<Result<void>> logout() async {
    try {
      await apiClient.logout();
      return Result.success(null);
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
        if (statusCode == 401) {
          return Failure.unauthorized(message);
        } else if (statusCode == 403) {
          return Failure.forbidden(message);
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
