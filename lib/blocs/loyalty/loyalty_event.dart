import 'package:equatable/equatable.dart';

sealed class LoyaltyEvent extends Equatable {
  const LoyaltyEvent();

  @override
  List<Object?> get props => [];
}

class GetLoyaltyWalletEvent extends LoyaltyEvent {
  const GetLoyaltyWalletEvent();
}

class GetLoyaltyTransactionsEvent extends LoyaltyEvent {
  const GetLoyaltyTransactionsEvent();
}

class RedeemPointsEvent extends LoyaltyEvent {
  final int points;
  final String? rewardId;

  const RedeemPointsEvent({required this.points, this.rewardId});

  @override
  List<Object?> get props => [points, rewardId];
}

class RefreshLoyaltyEvent extends LoyaltyEvent {
  const RefreshLoyaltyEvent();
}
