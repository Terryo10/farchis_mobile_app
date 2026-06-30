import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/referral_repository.dart';
import 'referral_event.dart';
import 'referral_state.dart';

class ReferralBloc extends Bloc<ReferralEvent, ReferralState> {
  final ReferralRepository referralRepository;

  ReferralBloc({required this.referralRepository}) : super(const ReferralState()) {
    on<GetReferralStatsEvent>(_onGetReferralStats);
    on<GetReferralLeaderboardEvent>(_onGetReferralLeaderboard);
  }

  Future<void> _onGetReferralStats(
      GetReferralStatsEvent event, Emitter<ReferralState> emit) async {
    emit(state.copyWith(isLoading: true, failure: null));
    final result = await referralRepository.getReferralStats();
    result.when(
      onSuccess: (stats) => emit(state.copyWith(isLoading: false, stats: stats)),
      onFailure: (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
    );
  }

  Future<void> _onGetReferralLeaderboard(
      GetReferralLeaderboardEvent event, Emitter<ReferralState> emit) async {
    emit(state.copyWith(isLoading: true, failure: null));
    final result = await referralRepository.getLeaderboard();
    result.when(
      onSuccess: (leaderboard) => emit(state.copyWith(isLoading: false, leaderboard: leaderboard)),
      onFailure: (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
    );
  }
}
