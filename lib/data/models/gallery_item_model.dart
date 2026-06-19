import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part 'gallery_item_model.freezed.dart';
part 'gallery_item_model.g.dart';

@freezed
class GalleryItemModel with _$GalleryItemModel, EquatableMixin {
  const GalleryItemModel._();

  const factory GalleryItemModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'booking_id') required String bookingId,
    @JsonKey(name: 'before_image') String? beforeImage,
    @JsonKey(name: 'after_image') String? afterImage,
    @JsonKey(name: 'caption') String? caption,
    @JsonKey(name: 'is_public') @Default(false) bool isPublic,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _GalleryItemModel;

  factory GalleryItemModel.fromJson(Map<String, dynamic> json) =>
      _$GalleryItemModelFromJson(json);

  @override
  List<Object?> get props => [id, bookingId];
}
