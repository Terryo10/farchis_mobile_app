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
      imageUrl: json['imageUrl'] as String?,
      type: $enumDecode(_$PromotionTypeEnumMap, json['type']),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$PromotionModelToJson(PromotionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'imageUrl': instance.imageUrl,
      'type': _$PromotionTypeEnumMap[instance.type]!,
      'isActive': instance.isActive,
    };

const _$PromotionTypeEnumMap = {
  PromotionType.push_blast: 'push_blast',
  PromotionType.in_app: 'in_app',
};
