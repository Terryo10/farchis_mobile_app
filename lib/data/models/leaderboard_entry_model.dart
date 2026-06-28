import 'package:json_annotation/json_annotation.dart';

part 'leaderboard_entry_model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class LeaderboardEntryModel {
  final int rank;
  final int userId;
  final String name;
  final String? avatarUrl;
  final int referralCount;

  const LeaderboardEntryModel({
    required this.rank,
    required this.userId,
    required this.name,
    this.avatarUrl,
    required this.referralCount,
  });

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) => _$LeaderboardEntryModelFromJson(json);

  Map<String, dynamic> toJson() => _$LeaderboardEntryModelToJson(this);

  LeaderboardEntryModel copyWith({
    int? rank,
    int? userId,
    String? name,
    String? avatarUrl,
    int? referralCount,
  }) {
    return LeaderboardEntryModel(
      rank: rank ?? this.rank,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      referralCount: referralCount ?? this.referralCount,
    );
  }
}
