import 'package:json_annotation/json_annotation.dart';

part 'gallery_item_model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class GalleryItemModel {
  final int id;
  final int bookingId;
  @JsonKey(name: 'before_image')
  final String beforeImageUrl;
  @JsonKey(name: 'after_image')
  final String afterImageUrl;
  final String? caption;
  final bool isPublic;

  const GalleryItemModel({
    required this.id,
    required this.bookingId,
    required this.beforeImageUrl,
    required this.afterImageUrl,
    this.caption,
    required this.isPublic,
  });

  factory GalleryItemModel.fromJson(Map<String, dynamic> json) => _$GalleryItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$GalleryItemModelToJson(this);

  GalleryItemModel copyWith({
    int? id,
    int? bookingId,
    String? beforeImageUrl,
    String? afterImageUrl,
    String? caption,
    bool? isPublic,
  }) {
    return GalleryItemModel(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      beforeImageUrl: beforeImageUrl ?? this.beforeImageUrl,
      afterImageUrl: afterImageUrl ?? this.afterImageUrl,
      caption: caption ?? this.caption,
      isPublic: isPublic ?? this.isPublic,
    );
  }

  factory GalleryItemModel.placeholder() => const GalleryItemModel(
        id: 0,
        bookingId: 0,
        beforeImageUrl: '',
        afterImageUrl: '',
        caption: 'Loading gallery item...',
        isPublic: true,
      );

  static List<GalleryItemModel> placeholderList(int count) =>
      List.generate(count, (index) => GalleryItemModel.placeholder().copyWith(id: index));
}
