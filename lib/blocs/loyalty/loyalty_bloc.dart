import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/loyalty_repository.dart';
import 'loyalty_event.dart';
import 'loyalty_state.dart';

/// LoyaltyBloc manages the user's loyalty wallet and points
class LoyaltyBloc extends Bloc<LoyaltyEvent, LoyaltyState> {
  final LoyaltyRepository loyaltyRepository;

  LoyaltyBloc({required this.loyaltyRepository}) : super(const LoyaltyInitial()) {
    on<GetLoyaltyWalletEvent>(_onGetLoyaltyWallet);
    on<GetLoyaltyTransactionsEvent>(_onGetLoyaltyTransactions);
    on<RedeemPointsEvent>(_onRedeemPoints);
    on<RefreshLoyaltyEvent>(_onRefreshLoyalty);
  }

  Future<void> _onGetLoyaltyWallet(
    GetLoyaltyWalletEvent event,
    Emitter<LoyaltyState> emit,
  ) async {
    emit(const LoyaltyLoading());

    final walletResult = await loyaltyRepository.getWallet();
    final transactionsResult = await loyaltyRepository.getTransactions();

    walletResult.when(
      onSuccess: (wallet) {
        transactionsResult.when(
          onSuccess: (transactions) {
            emit(LoyaltyLoaded(wallet: wallet, transactions: transactions));
          },
          onFailure: (failure) {
            emit(LoyaltyLoaded(wallet: wallet, transactions: const []));
          },
        );
      },
      onFailure: (failure) {
        emit(LoyaltyLoadFailed(failure));
      },
    );
  }

  Future<void> _onGetLoyaltyTransactions(
    GetLoyaltyTransactionsEvent event,
    Emitter<LoyaltyState> emit,
  ) async {
    final result = await loyaltyRepository.getTransactions();

    result.when(
      onSuccess: (transactions) {
        if (state is LoyaltyLoaded) {
          final current = state as LoyaltyLoaded;
          emit(LoyaltyLoaded(wallet: current.wallet, transactions: transactions));
        }
      },
      onFailure: (failure) {
        emit(LoyaltyLoadFailed(failure));
      },
    );
  }

  Future<void> _onRedeemPoints(
    RedeemPointsEvent event,
    Emitter<LoyaltyState> emit,
  ) async {
    emit(PointsRedeeming(event.points));

    final result = await loyaltyRepository.redeemPoints(
      points: event.points,
      rewardId: event.rewardId,
    );

    result.when(
      onSuccess: (data) {
        // Refresh wallet after redeeming
        add(const GetLoyaltyWalletEvent());
      },
      onFailure: (failure) {
        emit(PointsRedeemFailed(failure));
      },
    );
  }

  Future<void> _onRefreshLoyalty(
    RefreshLoyaltyEvent event,
    Emitter<LoyaltyState> emit,
  ) async {
    add(const GetLoyaltyWalletEvent());
  }
}
