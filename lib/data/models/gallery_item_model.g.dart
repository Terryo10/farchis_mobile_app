// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GalleryItemModel _$GalleryItemModelFromJson(Map<String, dynamic> json) =>
    GalleryItemModel(
      id: (json['id'] as num).toInt(),
      bookingId: (json['booking_id'] as num).toInt(),
      beforeImageUrl: json['before_image'] as String,
      afterImageUrl: json['after_image'] as String,
      caption: json['caption'] as String?,
      isPublic: json['is_public'] as bool,
    );

Map<String, dynamic> _$GalleryItemModelToJson(GalleryItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booking_id': instance.bookingId,
      'before_image': instance.beforeImageUrl,
      'after_image': instance.afterImageUrl,
      'caption': instance.caption,
      'is_public': instance.isPublic,
    };
