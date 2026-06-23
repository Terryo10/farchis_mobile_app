// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaderboardEntryModel _$LeaderboardEntryModelFromJson(
  Map<String, dynamic> json,
) => LeaderboardEntryModel(
  rank: (json['rank'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  name: json['name'] as String,
  avatarUrl: json['avatarUrl'] as String?,
  referralCount: (json['referralCount'] as num).toInt(),
);

Map<String, dynamic> _$LeaderboardEntryModelToJson(
  LeaderboardEntryModel instance,
) => <String, dynamic>{
  'rank': instance.rank,
  'userId': instance.userId,
  'name': instance.name,
  'avatarUrl': instance.avatarUrl,
  'referralCount': instance.referralCount,
};
