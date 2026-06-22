// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferredUserModel _$ReferredUserModelFromJson(Map<String, dynamic> json) =>
    ReferredUserModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
    );

Map<String, dynamic> _$ReferredUserModelToJson(ReferredUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'joinedAt': instance.joinedAt.toIso8601String(),
    };

ReferralModel _$ReferralModelFromJson(Map<String, dynamic> json) =>
    ReferralModel(
      referralCode: json['referralCode'] as String,
      referredUsers: (json['referredUsers'] as List<dynamic>)
          .map((e) => ReferredUserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalReferrals: (json['totalReferrals'] as num).toInt(),
    );

Map<String, dynamic> _$ReferralModelToJson(ReferralModel instance) =>
    <String, dynamic>{
      'referralCode': instance.referralCode,
      'referredUsers': instance.referredUsers.map((e) => e.toJson()).toList(),
      'totalReferrals': instance.totalReferrals,
    };
