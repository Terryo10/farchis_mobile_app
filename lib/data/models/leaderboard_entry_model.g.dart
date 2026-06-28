// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaderboardEntryModel _$LeaderboardEntryModelFromJson(
  Map<String, dynamic> json,
) => LeaderboardEntryModel(
  rank: (json['rank'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  name: json['name'] as String,
  avatarUrl: json['avatar_url'] as String?,
  referralCount: (json['referral_count'] as num).toInt(),
);

Map<String, dynamic> _$LeaderboardEntryModelToJson(
  LeaderboardEntryModel instance,
) => <String, dynamic>{
  'rank': instance.rank,
  'user_id': instance.userId,
  'name': instance.name,
  'avatar_url': instance.avatarUrl,
  'referral_count': instance.referralCount,
};
