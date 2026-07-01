import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/http_client.dart';
import '../models/inspection_request_model.dart';

class InspectionRequestRepository {
  final FarchisHttpClient client;

  InspectionRequestRepository(this.client);

  Future<Result<List<InspectionRequestModel>>> getInspectionRequests() async {
    try {
      final response = await client.get(ApiConstants.inspectionRequests);
      final data = response['data'] as List;
      return Result.success(data.map((e) => InspectionRequestModel.fromJson(e)).toList());
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Result<InspectionRequestModel>> getInspectionRequest(int id) async {
    try {
      final response = await client.get(ApiConstants.inspectionRequest(id.toString()));
      return Result.success(InspectionRequestModel.fromJson(response['data']));
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Result<InspectionRequestModel>> createInspectionRequest({
    required int vehicleId,
    required String inspectionMode,
    String? address,
    required String preferredDate,
    String? preferredTime,
    required String description,
    List<String> photoPaths = const [],
  }) async {
    try {
      final fields = <String, String>{
        'vehicle_id': vehicleId.toString(),
        'inspection_mode': inspectionMode,
        'preferred_date': preferredDate,
        'description': description,
        'address': ?address,
        'preferred_time': ?preferredTime,
      };

      final files = <http.MultipartFile>[];
      for (final path in photoPaths) {
        files.add(await http.MultipartFile.fromPath('photos[]', path));
      }

      final response = await client.uploadFiles(ApiConstants.inspectionRequests, fields, files);
      return Result.success(InspectionRequestModel.fromJson(response['data']));
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Result<int>> acceptQuote(int id) async {
    try {
      final response = await client.post(ApiConstants.acceptInspectionQuote(id.toString()));
      return Result.success(response['data']['booking_id'] as int);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Result<InspectionRequestModel>> decline(int id, {String? reason}) async {
    try {
      final response = await client.post(
        ApiConstants.declineInspectionRequest(id.toString()),
        body: reason != null ? {'reason': reason} : null,
      );
      return Result.success(InspectionRequestModel.fromJson(response['data']));
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
