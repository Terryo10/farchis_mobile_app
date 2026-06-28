import 'package:json_annotation/json_annotation.dart';

part 'promotion_model.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum PromotionType { push_blast, in_app }

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class PromotionModel {
  final int id;
  final String title;
  final String body;
  @JsonKey(name: 'image')
  final String? imageUrl;
  final PromotionType type;
  @JsonKey(defaultValue: true)
  final bool isActive;

  const PromotionModel({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.type,
    this.isActive = true,
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

  factory PromotionModel.placeholder() => const PromotionModel(
        id: 0,
        title: 'Loading promotion title',
        body: 'Loading promotion body and description text here...',
        type: PromotionType.in_app,
        isActive: true,
      );

  static List<PromotionModel> placeholderList(int count) =>
      List.generate(count, (index) => PromotionModel.placeholder().copyWith(id: index));
}
