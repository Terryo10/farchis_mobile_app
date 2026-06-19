import 'package:equatable/equatable.dart';

import '../../core/error/failures.dart';
import '../../data/models/loyalty_wallet_model.dart';

sealed class LoyaltyState extends Equatable {
  const LoyaltyState();

  @override
  List<Object?> get props => [];
}

class LoyaltyInitial extends LoyaltyState {
  const LoyaltyInitial();
}

class LoyaltyLoading extends LoyaltyState {
  const LoyaltyLoading();
}

class LoyaltyLoaded extends LoyaltyState {
  final LoyaltyWalletModel wallet;
  final List<Map<String, dynamic>> transactions;

  const LoyaltyLoaded({
    required this.wallet,
    required this.transactions,
  });

  @override
  List<Object?> get props => [wallet, transactions];
}

class LoyaltyLoadFailed extends LoyaltyState {
  final Failure failure;

  const LoyaltyLoadFailed(this.failure);

  @override
  List<Object?> get props => [failure];
}

class PointsRedeeming extends LoyaltyState {
  final int points;

  const PointsRedeeming(this.points);

  @override
  List<Object?> get props => [points];
}

class PointsRedeemed extends LoyaltyState {
  final LoyaltyWalletModel wallet;

  const PointsRedeemed(this.wallet);

  @override
  List<Object?> get props => [wallet];
}

class PointsRedeemFailed extends LoyaltyState {
  final Failure failure;

  const PointsRedeemFailed(this.failure);

  @override
  List<Object?> get props => [failure];
}
