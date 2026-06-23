// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scratch_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScratchCardModel _$ScratchCardModelFromJson(Map<String, dynamic> json) =>
    ScratchCardModel(
      id: (json['id'] as num).toInt(),
      prizeType: $enumDecode(_$PrizeTypeEnumMap, json['prizeType']),
      prizeValue: (json['prizeValue'] as num).toDouble(),
      isScratched: json['isScratched'] as bool,
      scratchedAt: json['scratchedAt'] == null
          ? null
          : DateTime.parse(json['scratchedAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$ScratchCardModelToJson(ScratchCardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'prizeType': _$PrizeTypeEnumMap[instance.prizeType]!,
      'prizeValue': instance.prizeValue,
      'isScratched': instance.isScratched,
      'scratchedAt': instance.scratchedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
    };

const _$PrizeTypeEnumMap = {
  PrizeType.discount: 'discount',
  PrizeType.free_valet: 'free_valet',
  PrizeType.bonus_points: 'bonus_points',
};
