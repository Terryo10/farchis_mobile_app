// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GalleryItemModelImpl _$$GalleryItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$GalleryItemModelImpl(
  id: json['id'] as String,
  bookingId: json['booking_id'] as String,
  beforeImage: json['before_image'] as String?,
  afterImage: json['after_image'] as String?,
  caption: json['caption'] as String?,
  isPublic: json['is_public'] as bool? ?? false,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$$GalleryItemModelImplToJson(
  _$GalleryItemModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'booking_id': instance.bookingId,
  'before_image': instance.beforeImage,
  'after_image': instance.afterImage,
  'caption': instance.caption,
  'is_public': instance.isPublic,
  'created_at': instance.createdAt,
};
