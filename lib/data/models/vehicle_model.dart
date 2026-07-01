import 'package:json_annotation/json_annotation.dart';

part 'vehicle_model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class VehicleSizeCategoryModel {
  final int id;
  final String name;

  const VehicleSizeCategoryModel({
    required this.id,
    required this.name,
  });

  factory VehicleSizeCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleSizeCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleSizeCategoryModelToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class VehicleModel {
  final int id;
  final String make;
  final String model;
  final int? year;
  final String? plate;
  final String? color;
  final bool isPrimary;
  final VehicleSizeCategoryModel? vehicleSizeCategory;
  final DateTime? createdAt;

  const VehicleModel({
    required this.id,
    required this.make,
    required this.model,
    this.year,
    this.plate,
    this.color,
    this.isPrimary = false,
    this.vehicleSizeCategory,
    this.createdAt,
  });

  int? get vehicleSizeCategoryId => vehicleSizeCategory?.id;

  String get displayName => '$make $model'.trim();

  factory VehicleModel.fromJson(Map<String, dynamic> json) => _$VehicleModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleModelToJson(this);

  VehicleModel copyWith({
    int? id,
    String? make,
    String? model,
    int? year,
    String? plate,
    String? color,
    bool? isPrimary,
    VehicleSizeCategoryModel? vehicleSizeCategory,
    DateTime? createdAt,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      plate: plate ?? this.plate,
      color: color ?? this.color,
      isPrimary: isPrimary ?? this.isPrimary,
      vehicleSizeCategory: vehicleSizeCategory ?? this.vehicleSizeCategory,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
