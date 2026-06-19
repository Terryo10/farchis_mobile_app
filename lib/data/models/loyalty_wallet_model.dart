import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';
import 'loyalty_transaction_model.dart';

part 'loyalty_wallet_model.freezed.dart';
part 'loyalty_wallet_model.g.dart';

@freezed
class LoyaltyWalletModel with _$LoyaltyWalletModel, EquatableMixin {
  const LoyaltyWalletModel._();

  const factory LoyaltyWalletModel({
    @JsonKey(name: 'balance') @Default(0) int balance,
    @JsonKey(name: 'tier') String? tier,
    @JsonKey(name: 'tier_progress') @Default(0) double tierProgress,
    @JsonKey(name: 'next_tier_points') int? nextTierPoints,
    @JsonKey(name: 'transactions') @Default([]) List<LoyaltyTransactionModel> transactions,
  }) = _LoyaltyWalletModel;

  factory LoyaltyWalletModel.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyWalletModelFromJson(json);

  @override
  List<Object?> get props => [balance, tier];
}
