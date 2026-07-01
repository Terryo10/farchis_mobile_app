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
  category: $enumDecode(
    _$ServiceCategoryEnumMap,
    json['category'],
    unknownValue: ServiceCategory.other,
  ),
  price: (json['price'] as num?)?.toDouble(),
  durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
  isActive: json['is_active'] as bool,
  imageUrl: json['image'] as String?,
);

Map<String, dynamic> _$ServiceModelToJson(ServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'category': _$ServiceCategoryEnumMap[instance.category]!,
      'price': instance.price,
      'duration_minutes': instance.durationMinutes,
      'is_active': instance.isActive,
      'image': instance.imageUrl,
    };

const _$ServiceCategoryEnumMap = {
  ServiceCategory.panel_beating: 'panel_beating',
  ServiceCategory.painting: 'painting',
  ServiceCategory.repairs: 'repairs',
  ServiceCategory.custom: 'custom',
  ServiceCategory.detailing: 'detailing',
  ServiceCategory.mechanical: 'mechanical',
  ServiceCategory.paint: 'paint',
  ServiceCategory.accessories: 'accessories',
  ServiceCategory.bodywork: 'bodywork',
  ServiceCategory.wash: 'wash',
  ServiceCategory.tyres: 'tyres',
  ServiceCategory.electrical: 'electrical',
  ServiceCategory.other: 'other',
};
