import 'package:json_annotation/json_annotation.dart';

part 'service_model.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum ServiceCategory { panel_beating, painting, repairs, custom }

@JsonSerializable(explicitToJson: true)
class ServiceModel {
  final int id;
  final String name;
  final String slug;
  final String description;
  final ServiceCategory category;
  final double price;
  final int durationMinutes;
  final bool isActive;
  final String? imageUrl;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.category,
    required this.price,
    required this.durationMinutes,
    required this.isActive,
    this.imageUrl,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => _$ServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);

  ServiceModel copyWith({
    int? id,
    String? name,
    String? slug,
    String? description,
    ServiceCategory? category,
    double? price,
    int? durationMinutes,
    bool? isActive,
    String? imageUrl,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isActive: isActive ?? this.isActive,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
