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
  vehicleMake: json['vehicle_make'] as String?,
  vehicleModel: json['vehicle_model'] as String?,
  vehicleYear: (json['vehicle_year'] as num?)?.toInt(),
  vehiclePlate: json['vehicle_plate'] as String?,
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
  'vehicle_make': instance.vehicleMake,
  'vehicle_model': instance.vehicleModel,
  'vehicle_year': instance.vehicleYear,
  'vehicle_plate': instance.vehiclePlate,
  'last_service_date': instance.lastServiceDate?.toIso8601String(),
};

const _$LoyaltyTierEnumMap = {
  LoyaltyTier.bronze: 'bronze',
  LoyaltyTier.silver: 'silver',
  LoyaltyTier.gold: 'gold',
};
