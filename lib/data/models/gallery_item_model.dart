import 'package:json_annotation/json_annotation.dart';

part 'gallery_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GalleryItemModel {
  final int id;
  final int bookingId;
  final String beforeImageUrl;
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
}
