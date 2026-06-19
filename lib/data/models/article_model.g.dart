// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArticleModelImpl _$$ArticleModelImplFromJson(Map<String, dynamic> json) =>
    _$ArticleModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      body: json['body'] as String,
      category: json['category'] as String?,
      image: json['image'] as String?,
      publishedAt: json['published_at'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$$ArticleModelImplToJson(_$ArticleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'body': instance.body,
      'category': instance.category,
      'image': instance.image,
      'published_at': instance.publishedAt,
      'created_at': instance.createdAt,
    };
