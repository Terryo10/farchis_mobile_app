// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoyaltyWalletModelImpl _$$LoyaltyWalletModelImplFromJson(
  Map<String, dynamic> json,
) => _$LoyaltyWalletModelImpl(
  balance: (json['balance'] as num?)?.toInt() ?? 0,
  tier: json['tier'] as String?,
  tierProgress: (json['tier_progress'] as num?)?.toDouble() ?? 0,
  nextTierPoints: (json['next_tier_points'] as num?)?.toInt(),
  transactions:
      (json['transactions'] as List<dynamic>?)
          ?.map(
            (e) => LoyaltyTransactionModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$$LoyaltyWalletModelImplToJson(
  _$LoyaltyWalletModelImpl instance,
) => <String, dynamic>{
  'balance': instance.balance,
  'tier': instance.tier,
  'tier_progress': instance.tierProgress,
  'next_tier_points': instance.nextTierPoints,
  'transactions': instance.transactions,
};
