import 'package:equatable/equatable.dart';

sealed class ReferralEvent extends Equatable {
  const ReferralEvent();

  @override
  List<Object?> get props => [];
}

class GetReferralStatsEvent extends ReferralEvent {
  const GetReferralStatsEvent();
}

class GetReferralLeaderboardEvent extends ReferralEvent {
  const GetReferralLeaderboardEvent();
}
