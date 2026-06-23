import 'package:json_annotation/json_annotation.dart';

part 'review_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ReviewModel {
  final int id;
  final int bookingId;
  final int rating;
  final String? comment;
  final bool isApproved;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.bookingId,
    required this.rating,
    this.comment,
    required this.isApproved,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);

  ReviewModel copyWith({
    int? id,
    int? bookingId,
    int? rating,
    String? comment,
    bool? isApproved,
    DateTime? createdAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      isApproved: isApproved ?? this.isApproved,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
