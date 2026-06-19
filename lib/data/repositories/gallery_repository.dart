import 'package:dio/dio.dart';

import '../../core/error/failures.dart';
import '../../core/network/api_client.dart';
import '../models/gallery_item_model.dart';

class GalleryRepository {
  final ApiClient apiClient;

  GalleryRepository({required this.apiClient});

  /// Get all gallery items
  Future<Result<List<GalleryItemModel>>> getGallery() async {
    try {
      final items = await apiClient.getGallery();
      return Result.success(items);
    } on DioException catch (e) {
      return Result.failure(_mapDioException(e));
    } catch (e) {
      return Result.failure(Failure.unknown('Unexpected error: $e'));
    }
  }

  /// Upload gallery item
  Future<Result<GalleryItemModel>> uploadGalleryItem({
    required String bookingId,
    required String beforeImagePath,
    required String afterImagePath,
    String? caption,
    bool? isPublic,
  }) async {
    try {
      final formData = FormData();
      formData.fields.add(MapEntry('booking_id', bookingId));

      if (caption != null) {
        formData.fields.add(MapEntry('caption', caption));
      }
      if (isPublic != null) {
        formData.fields.add(MapEntry('is_public', isPublic.toString()));
      }

      formData.files.add(
        MapEntry(
          'before_image',
          await MultipartFile.fromFile(beforeImagePath),
        ),
      );

      formData.files.add(
        MapEntry(
          'after_image',
          await MultipartFile.fromFile(afterImagePath),
        ),
      );

      final item = await apiClient.uploadGalleryItem(formData);
      return Result.success(item);
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
