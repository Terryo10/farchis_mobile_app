// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoyaltyWalletModel _$LoyaltyWalletModelFromJson(Map<String, dynamic> json) =>
    LoyaltyWalletModel(
      balance: (json['balance'] as num).toInt(),
      tier: $enumDecode(_$LoyaltyTierEnumMap, json['tier']),
      transactions: (json['transactions'] as List<dynamic>)
          .map(
            (e) => LoyaltyTransactionModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$LoyaltyWalletModelToJson(LoyaltyWalletModel instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'tier': _$LoyaltyTierEnumMap[instance.tier]!,
      'transactions': instance.transactions.map((e) => e.toJson()).toList(),
    };

const _$LoyaltyTierEnumMap = {
  LoyaltyTier.bronze: 'bronze',
  LoyaltyTier.silver: 'silver',
  LoyaltyTier.gold: 'gold',
  LoyaltyTier.platinum: 'platinum',
};
