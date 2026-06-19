import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part 'leaderboard_entry_model.freezed.dart';
part 'leaderboard_entry_model.g.dart';

@freezed
class LeaderboardEntryModel with _$LeaderboardEntryModel, EquatableMixin {
  const LeaderboardEntryModel._();

  const factory LeaderboardEntryModel({
    @JsonKey(name: 'rank') required int rank,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'avatar') String? avatar,
    @JsonKey(name: 'referral_count') @Default(0) int referralCount,
  }) = _LeaderboardEntryModel;

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryModelFromJson(json);

  @override
  List<Object?> get props => [rank, userId];
}
