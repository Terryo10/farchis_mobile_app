import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/http_client.dart';
import '../models/booking_model.dart';
import '../models/available_slot_model.dart';

class BookingRepository {
  final FarchisHttpClient client;

  BookingRepository(this.client);

  Future<Result<List<BookingModel>>> getBookings() async {
    try {
      final response = await client.get(ApiConstants.bookings);
      final data = response['data'] as List;
      return Result.success(data.map((e) => BookingModel.fromJson(e)).toList());
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Result<BookingModel>> createBooking(Map<String, dynamic> payload) async {
    try {
      final response = await client.post(ApiConstants.bookings, body: payload);
      return Result.success(BookingModel.fromJson(response['data']));
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Result<List<AvailableSlotModel>>> getAvailableSlots(String date) async {
    try {
      final response = await client.get('${ApiConstants.availableSlots}?date=$date');
      final data = response['data'] as List;
      return Result.success(data.map((e) => AvailableSlotModel.fromJson(e)).toList());
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
