// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scratch_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScratchCardModelImpl _$$ScratchCardModelImplFromJson(
  Map<String, dynamic> json,
) => _$ScratchCardModelImpl(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  bookingId: json['booking_id'] as String?,
  prizeType: json['prize_type'] as String,
  prizeValue: (json['prize_value'] as num).toDouble(),
  isScratched: json['is_scratched'] as bool? ?? false,
  scratchedAt: json['scratched_at'] as String?,
  expiresAt: json['expires_at'] as String,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$$ScratchCardModelImplToJson(
  _$ScratchCardModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'booking_id': instance.bookingId,
  'prize_type': instance.prizeType,
  'prize_value': instance.prizeValue,
  'is_scratched': instance.isScratched,
  'scratched_at': instance.scratchedAt,
  'expires_at': instance.expiresAt,
  'created_at': instance.createdAt,
};
