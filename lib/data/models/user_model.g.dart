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
  avatarUrl: json['avatarUrl'] as String?,
  referralCode: json['referralCode'] as String?,
  loyaltyTier: $enumDecodeNullable(_$LoyaltyTierEnumMap, json['loyaltyTier']),
  loyaltyPoints: (json['loyaltyPoints'] as num?)?.toInt(),
  vehicleMake: json['vehicleMake'] as String?,
  vehicleModel: json['vehicleModel'] as String?,
  vehicleYear: (json['vehicleYear'] as num?)?.toInt(),
  vehiclePlate: json['vehiclePlate'] as String?,
  lastServiceDate: json['lastServiceDate'] == null
      ? null
      : DateTime.parse(json['lastServiceDate'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'avatarUrl': instance.avatarUrl,
  'referralCode': instance.referralCode,
  'loyaltyTier': _$LoyaltyTierEnumMap[instance.loyaltyTier],
  'loyaltyPoints': instance.loyaltyPoints,
  'vehicleMake': instance.vehicleMake,
  'vehicleModel': instance.vehicleModel,
  'vehicleYear': instance.vehicleYear,
  'vehiclePlate': instance.vehiclePlate,
  'lastServiceDate': instance.lastServiceDate?.toIso8601String(),
};

const _$LoyaltyTierEnumMap = {
  LoyaltyTier.bronze: 'bronze',
  LoyaltyTier.silver: 'silver',
  LoyaltyTier.gold: 'gold',
  LoyaltyTier.platinum: 'platinum',
};
