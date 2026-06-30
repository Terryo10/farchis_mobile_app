// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferredUserModel _$ReferredUserModelFromJson(Map<String, dynamic> json) =>
    ReferredUserModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      joinedAt: DateTime.parse(json['joined_at'] as String),
    );

Map<String, dynamic> _$ReferredUserModelToJson(ReferredUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'joined_at': instance.joinedAt.toIso8601String(),
    };

ReferralModel _$ReferralModelFromJson(Map<String, dynamic> json) =>
    ReferralModel(
      referralCode: json['referral_code'] as String,
      referredUsers: (json['referred_users'] as List<dynamic>)
          .map((e) => ReferredUserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalReferrals: (json['total_referrals'] as num).toInt(),
    );

Map<String, dynamic> _$ReferralModelToJson(ReferralModel instance) =>
    <String, dynamic>{
      'referral_code': instance.referralCode,
      'referred_users': instance.referredUsers.map((e) => e.toJson()).toList(),
      'total_referrals': instance.totalReferrals,
    };
