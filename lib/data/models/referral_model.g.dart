// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReferralModelImpl _$$ReferralModelImplFromJson(Map<String, dynamic> json) =>
    _$ReferralModelImpl(
      referralCode: json['referral_code'] as String,
      totalReferrals: (json['total_referrals'] as num?)?.toInt() ?? 0,
      referredUsers: json['referred_users'] as List<dynamic>? ?? const [],
    );

Map<String, dynamic> _$$ReferralModelImplToJson(_$ReferralModelImpl instance) =>
    <String, dynamic>{
      'referral_code': instance.referralCode,
      'total_referrals': instance.totalReferrals,
      'referred_users': instance.referredUsers,
    };
