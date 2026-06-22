import 'package:json_annotation/json_annotation.dart';
import 'loyalty_transaction_model.dart';
import 'user_model.dart';

part 'loyalty_wallet_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LoyaltyWalletModel {
  final int balance;
  final LoyaltyTier tier;
  final List<LoyaltyTransactionModel> transactions;

  const LoyaltyWalletModel({
    required this.balance,
    required this.tier,
    required this.transactions,
  });

  factory LoyaltyWalletModel.fromJson(Map<String, dynamic> json) => _$LoyaltyWalletModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoyaltyWalletModelToJson(this);

  LoyaltyWalletModel copyWith({
    int? balance,
    LoyaltyTier? tier,
    List<LoyaltyTransactionModel>? transactions,
  }) {
    return LoyaltyWalletModel(
      balance: balance ?? this.balance,
      tier: tier ?? this.tier,
      transactions: transactions ?? this.transactions,
    );
  }
}
