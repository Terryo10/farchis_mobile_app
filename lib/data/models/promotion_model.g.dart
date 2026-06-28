// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromotionModel _$PromotionModelFromJson(Map<String, dynamic> json) =>
    PromotionModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      body: json['body'] as String,
      imageUrl: json['image'] as String?,
      type: $enumDecode(_$PromotionTypeEnumMap, json['type']),
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$PromotionModelToJson(PromotionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'image': instance.imageUrl,
      'type': _$PromotionTypeEnumMap[instance.type]!,
      'is_active': instance.isActive,
    };

const _$PromotionTypeEnumMap = {
  PromotionType.push_blast: 'push_blast',
  PromotionType.in_app: 'in_app',
};
