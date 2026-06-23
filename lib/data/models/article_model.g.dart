// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleModel _$ArticleModelFromJson(Map<String, dynamic> json) => ArticleModel(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  slug: json['slug'] as String,
  body: json['body'] as String,
  category: $enumDecode(_$ArticleCategoryEnumMap, json['category']),
  imageUrl: json['imageUrl'] as String?,
  publishedAt: DateTime.parse(json['publishedAt'] as String),
);

Map<String, dynamic> _$ArticleModelToJson(ArticleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'body': instance.body,
      'category': _$ArticleCategoryEnumMap[instance.category]!,
      'imageUrl': instance.imageUrl,
      'publishedAt': instance.publishedAt.toIso8601String(),
    };

const _$ArticleCategoryEnumMap = {
  ArticleCategory.maintenance: 'maintenance',
  ArticleCategory.paint_care: 'paint_care',
  ArticleCategory.faq: 'faq',
};
