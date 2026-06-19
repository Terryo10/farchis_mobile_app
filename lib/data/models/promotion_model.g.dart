// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PromotionModelImpl _$$PromotionModelImplFromJson(Map<String, dynamic> json) =>
    _$PromotionModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String?,
      image: json['image'] as String?,
      type: json['type'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$$PromotionModelImplToJson(
  _$PromotionModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
  'image': instance.image,
  'type': instance.type,
  'is_active': instance.isActive,
  'created_at': instance.createdAt,
};
