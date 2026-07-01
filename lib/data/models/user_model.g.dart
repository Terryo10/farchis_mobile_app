// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String?,
  avatarUrl: json['avatar'] as String?,
  referralCode: json['referral_code'] as String?,
  loyaltyTier: $enumDecodeNullable(_$LoyaltyTierEnumMap, json['loyalty_tier']),
  loyaltyPoints: (json['loyalty_points'] as num?)?.toInt(),
  lastServiceDate: json['last_service_date'] == null
      ? null
      : DateTime.parse(json['last_service_date'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'avatar': instance.avatarUrl,
  'referral_code': instance.referralCode,
  'loyalty_tier': _$LoyaltyTierEnumMap[instance.loyaltyTier],
  'loyalty_points': instance.loyaltyPoints,
  'last_service_date': instance.lastServiceDate?.toIso8601String(),
};

const _$LoyaltyTierEnumMap = {
  LoyaltyTier.bronze: 'bronze',
  LoyaltyTier.silver: 'silver',
  LoyaltyTier.gold: 'gold',
};
