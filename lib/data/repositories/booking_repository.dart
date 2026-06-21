import 'package:dio/dio.dart';

import '../../core/error/failures.dart';
import '../../core/network/api_client.dart';
import '../models/booking_model.dart';
import '../models/available_slot_model.dart';

class BookingRepository {
  final ApiClient apiClient;

  BookingRepository({required this.apiClient});

  /// Get all bookings
  Future<Result<List<BookingModel>>> getBookings() async {
    try {
      final bookings = await apiClient.getBookings();
      return Result.success(bookings);
    } on DioException catch (e) {
      return Result.failure(_mapDioException(e));
    } catch (e) {
      return Result.failure(Failure.unknown('Unexpected error: $e'));
    }
  }

  /// Get booking by ID
  Future<Result<BookingModel>> getBooking(String id) async {
    try {
      final booking = await apiClient.getBooking(id);
      return Result.success(booking);
    } on DioException catch (e) {
      return Result.failure(_mapDioException(e));
    } catch (e) {
      return Result.failure(Failure.unknown('Unexpected error: $e'));
    }
  }

  /// Create a new booking
  Future<Result<BookingModel>> createBooking({
    required String serviceId,
    required String bookingDate,
    required String bookingTime,
    String? notes,
    List<String>? damagePhotos,
  }) async {
    try {
      final data = <String, dynamic>{
        'service_id': serviceId,
        'booking_date': bookingDate,
        'booking_time': bookingTime,
      };

      if (notes != null) data['notes'] = notes;
      if (damagePhotos != null) data['damage_photos'] = damagePhotos;

      final booking = await apiClient.createBooking(data);
      return Result.success(booking);
    } on DioException catch (e) {
      return Result.failure(_mapDioException(e));
    } catch (e) {
      return Result.failure(Failure.unknown('Unexpected error: $e'));
    }
  }

  /// Update booking
  Future<Result<BookingModel>> updateBooking({
    required String id,
    String? bookingDate,
    String? bookingTime,
    String? notes,
    List<String>? damagePhotos,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (bookingDate != null) data['booking_date'] = bookingDate;
      if (bookingTime != null) data['booking_time'] = bookingTime;
      if (notes != null) data['notes'] = notes;
      if (damagePhotos != null) data['damage_photos'] = damagePhotos;

      final booking = await apiClient.updateBooking(id, data);
      return Result.success(booking);
    } on DioException catch (e) {
      return Result.failure(_mapDioException(e));
    } catch (e) {
      return Result.failure(Failure.unknown('Unexpected error: $e'));
    }
  }

  /// Cancel booking
  Future<Result<BookingModel>> cancelBooking(String id) async {
    try {
      final booking = await apiClient.cancelBooking(id);
      return Result.success(booking);
    } on DioException catch (e) {
      return Result.failure(_mapDioException(e));
    } catch (e) {
      return Result.failure(Failure.unknown('Unexpected error: $e'));
    }
  }

  /// Get available slots for a service
  Future<Result<List<AvailableSlotModel>>> getAvailableSlots({
    required String serviceId,
    required String date,
  }) async {
    try {
      final slots = await apiClient.getAvailableSlots({
        'service_id': serviceId,
        'date': date,
      });
      return Result.success(slots);
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
        } else if (statusCode == 422) {
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
