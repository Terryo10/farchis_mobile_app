import 'package:json_annotation/json_annotation.dart';

part 'article_model.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum ArticleCategory { maintenance, paint_care, faq }

@JsonSerializable(explicitToJson: true)
class ArticleModel {
  final int id;
  final String title;
  final String slug;
  final String body;
  final ArticleCategory category;
  final String? imageUrl;
  final DateTime publishedAt;

  const ArticleModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.body,
    required this.category,
    this.imageUrl,
    required this.publishedAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) => _$ArticleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);

  ArticleModel copyWith({
    int? id,
    String? title,
    String? slug,
    String? body,
    ArticleCategory? category,
    String? imageUrl,
    DateTime? publishedAt,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      body: body ?? this.body,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }
}
