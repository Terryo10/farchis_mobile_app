// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GalleryItemModel _$GalleryItemModelFromJson(Map<String, dynamic> json) =>
    GalleryItemModel(
      id: (json['id'] as num).toInt(),
      bookingId: (json['bookingId'] as num).toInt(),
      beforeImageUrl: json['beforeImageUrl'] as String,
      afterImageUrl: json['afterImageUrl'] as String,
      caption: json['caption'] as String?,
      isPublic: json['isPublic'] as bool,
    );

Map<String, dynamic> _$GalleryItemModelToJson(GalleryItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'beforeImageUrl': instance.beforeImageUrl,
      'afterImageUrl': instance.afterImageUrl,
      'caption': instance.caption,
      'isPublic': instance.isPublic,
    };
