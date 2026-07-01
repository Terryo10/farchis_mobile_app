// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleSizeCategoryModel _$VehicleSizeCategoryModelFromJson(
  Map<String, dynamic> json,
) => VehicleSizeCategoryModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
);

Map<String, dynamic> _$VehicleSizeCategoryModelToJson(
  VehicleSizeCategoryModel instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};

VehicleModel _$VehicleModelFromJson(Map<String, dynamic> json) => VehicleModel(
  id: (json['id'] as num).toInt(),
  make: json['make'] as String,
  model: json['model'] as String,
  year: (json['year'] as num?)?.toInt(),
  plate: json['plate'] as String?,
  color: json['color'] as String?,
  isPrimary: json['is_primary'] as bool? ?? false,
  vehicleSizeCategory: json['vehicle_size_category'] == null
      ? null
      : VehicleSizeCategoryModel.fromJson(
          json['vehicle_size_category'] as Map<String, dynamic>,
        ),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$VehicleModelToJson(VehicleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'make': instance.make,
      'model': instance.model,
      'year': instance.year,
      'plate': instance.plate,
      'color': instance.color,
      'is_primary': instance.isPrimary,
      'vehicle_size_category': instance.vehicleSizeCategory?.toJson(),
      'created_at': instance.createdAt?.toIso8601String(),
    };
