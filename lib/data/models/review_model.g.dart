// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewModelImpl _$$ReviewModelImplFromJson(Map<String, dynamic> json) =>
    _$ReviewModelImpl(
      id: json['id'] as String,
      bookingId: json['booking_id'] as String,
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String?,
      isApproved: json['is_approved'] as bool? ?? false,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$$ReviewModelImplToJson(_$ReviewModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booking_id': instance.bookingId,
      'rating': instance.rating,
      'comment': instance.comment,
      'is_approved': instance.isApproved,
      'created_at': instance.createdAt,
    };
