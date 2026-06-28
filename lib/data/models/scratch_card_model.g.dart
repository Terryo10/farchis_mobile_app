// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scratch_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScratchCardModel _$ScratchCardModelFromJson(Map<String, dynamic> json) =>
    ScratchCardModel(
      id: (json['id'] as num).toInt(),
      prizeType: $enumDecode(_$PrizeTypeEnumMap, json['prize_type']),
      prizeValue: (json['prize_value'] as num).toDouble(),
      isScratched: json['is_scratched'] as bool,
      scratchedAt: json['scratched_at'] == null
          ? null
          : DateTime.parse(json['scratched_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$ScratchCardModelToJson(ScratchCardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'prize_type': _$PrizeTypeEnumMap[instance.prizeType]!,
      'prize_value': instance.prizeValue,
      'is_scratched': instance.isScratched,
      'scratched_at': instance.scratchedAt?.toIso8601String(),
      'expires_at': instance.expiresAt.toIso8601String(),
    };

const _$PrizeTypeEnumMap = {
  PrizeType.discount: 'discount',
  PrizeType.free_valet: 'free_valet',
  PrizeType.bonus_points: 'bonus_points',
};
