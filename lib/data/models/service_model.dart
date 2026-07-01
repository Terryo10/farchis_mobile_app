import 'package:json_annotation/json_annotation.dart';

part 'service_model.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum ServiceCategory {
  panel_beating,
  painting,
  repairs,
  custom,
  detailing,
  mechanical,
  paint,
  accessories,
  bodywork,
  wash,
  tyres,
  electrical,
  other
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class ServiceModel {
  final int id;
  final String name;
  final String slug;
  final String description;
  @JsonKey(unknownEnumValue: ServiceCategory.other)
  final ServiceCategory category;
  final double? price;
  final int? durationMinutes;
  final bool isActive;
  @JsonKey(name: 'image')
  final String? imageUrl;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.category,
    this.price,
    this.durationMinutes,
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

  factory ServiceModel.placeholder() => const ServiceModel(
        id: 0,
        name: 'Full Vehicle Service',
        slug: 'full-vehicle-service',
        description: 'Comprehensive inspection and maintenance service',
        category: ServiceCategory.mechanical,
        price: 150.0,
        durationMinutes: 120,
        isActive: true,
      );

  static List<ServiceModel> placeholderList(int count) =>
      List.generate(count, (index) => ServiceModel.placeholder().copyWith(id: index));
}
