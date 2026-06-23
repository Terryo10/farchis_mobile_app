// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
  id: (json['id'] as num).toInt(),
  bookingId: (json['bookingId'] as num).toInt(),
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String?,
  isApproved: json['isApproved'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'rating': instance.rating,
      'comment': instance.comment,
      'isApproved': instance.isApproved,
      'createdAt': instance.createdAt.toIso8601String(),
    };
