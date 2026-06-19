// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaderboardEntryModelImpl _$$LeaderboardEntryModelImplFromJson(
  Map<String, dynamic> json,
) => _$LeaderboardEntryModelImpl(
  rank: (json['rank'] as num).toInt(),
  userId: json['user_id'] as String,
  name: json['name'] as String,
  avatar: json['avatar'] as String?,
  referralCount: (json['referral_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$LeaderboardEntryModelImplToJson(
  _$LeaderboardEntryModelImpl instance,
) => <String, dynamic>{
  'rank': instance.rank,
  'user_id': instance.userId,
  'name': instance.name,
  'avatar': instance.avatar,
  'referral_count': instance.referralCount,
};
