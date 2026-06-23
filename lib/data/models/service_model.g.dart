// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceModel _$ServiceModelFromJson(Map<String, dynamic> json) => ServiceModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  slug: json['slug'] as String,
  description: json['description'] as String,
  category: $enumDecode(_$ServiceCategoryEnumMap, json['category']),
  price: (json['price'] as num).toDouble(),
  durationMinutes: (json['durationMinutes'] as num).toInt(),
  isActive: json['isActive'] as bool,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$ServiceModelToJson(ServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'category': _$ServiceCategoryEnumMap[instance.category]!,
      'price': instance.price,
      'durationMinutes': instance.durationMinutes,
      'isActive': instance.isActive,
      'imageUrl': instance.imageUrl,
    };

const _$ServiceCategoryEnumMap = {
  ServiceCategory.panel_beating: 'panel_beating',
  ServiceCategory.painting: 'painting',
  ServiceCategory.repairs: 'repairs',
  ServiceCategory.custom: 'custom',
};
