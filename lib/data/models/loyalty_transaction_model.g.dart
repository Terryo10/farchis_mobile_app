// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoyaltyTransactionModelImpl _$$LoyaltyTransactionModelImplFromJson(
  Map<String, dynamic> json,
) => _$LoyaltyTransactionModelImpl(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  bookingId: json['booking_id'] as String?,
  points: (json['points'] as num).toInt(),
  type: json['type'] as String,
  description: json['description'] as String?,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$$LoyaltyTransactionModelImplToJson(
  _$LoyaltyTransactionModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'booking_id': instance.bookingId,
  'points': instance.points,
  'type': instance.type,
  'description': instance.description,
  'created_at': instance.createdAt,
};
