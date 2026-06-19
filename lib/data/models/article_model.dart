import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part 'article_model.freezed.dart';
part 'article_model.g.dart';

@freezed
class ArticleModel with _$ArticleModel, EquatableMixin {
  const ArticleModel._();

  const factory ArticleModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'slug') required String slug,
    @JsonKey(name: 'body') required String body,
    @JsonKey(name: 'category') String? category,
    @JsonKey(name: 'image') String? image,
    @JsonKey(name: 'published_at') String? publishedAt,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _ArticleModel;

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

  @override
  List<Object?> get props => [id, title, slug];
}
