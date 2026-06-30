// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoyaltyTransactionModel _$LoyaltyTransactionModelFromJson(
  Map<String, dynamic> json,
) => LoyaltyTransactionModel(
  id: (json['id'] as num).toInt(),
  points: (json['points'] as num).toInt(),
  type: $enumDecode(_$LoyaltyTransactionTypeEnumMap, json['type']),
  description: json['description'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$LoyaltyTransactionModelToJson(
  LoyaltyTransactionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'points': instance.points,
  'type': _$LoyaltyTransactionTypeEnumMap[instance.type]!,
  'description': instance.description,
  'created_at': instance.createdAt.toIso8601String(),
};

const _$LoyaltyTransactionTypeEnumMap = {
  LoyaltyTransactionType.earn: 'earn',
  LoyaltyTransactionType.redeem: 'redeem',
};
