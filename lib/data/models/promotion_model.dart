import 'package:json_annotation/json_annotation.dart';

part 'promotion_model.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum PromotionType { push_blast, in_app }

@JsonSerializable(explicitToJson: true)
class PromotionModel {
  final int id;
  final String title;
  final String body;
  final String? imageUrl;
  final PromotionType type;
  final bool isActive;

  const PromotionModel({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.type,
    required this.isActive,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) => _$PromotionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionModelToJson(this);

  PromotionModel copyWith({
    int? id,
    String? title,
    String? body,
    String? imageUrl,
    PromotionType? type,
    bool? isActive,
  }) {
    return PromotionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
    );
  }
}
