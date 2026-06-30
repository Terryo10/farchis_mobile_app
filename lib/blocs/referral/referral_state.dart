import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../data/models/referral_model.dart';
import '../../data/models/leaderboard_entry_model.dart';

class ReferralState extends Equatable {
  final bool isLoading;
  final ReferralModel? stats;
  final List<LeaderboardEntryModel>? leaderboard;
  final Failure? failure;

  const ReferralState({
    this.isLoading = false,
    this.stats,
    this.leaderboard,
    this.failure,
  });

  ReferralState copyWith({
    bool? isLoading,
    ReferralModel? stats,
    List<LeaderboardEntryModel>? leaderboard,
    Failure? failure,
  }) {
    return ReferralState(
      isLoading: isLoading ?? this.isLoading,
      stats: stats ?? this.stats,
      leaderboard: leaderboard ?? this.leaderboard,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [isLoading, stats, leaderboard, failure];
}
