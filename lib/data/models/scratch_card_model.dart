import 'package:json_annotation/json_annotation.dart';

part 'scratch_card_model.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum PrizeType { discount, free_valet, bonus_points }

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class ScratchCardModel {
  final int id;
  final PrizeType prizeType;
  final double prizeValue;
  final bool isScratched;
  final DateTime? scratchedAt;
  final DateTime expiresAt;

  const ScratchCardModel({
    required this.id,
    required this.prizeType,
    required this.prizeValue,
    required this.isScratched,
    this.scratchedAt,
    required this.expiresAt,
  });

  factory ScratchCardModel.fromJson(Map<String, dynamic> json) => _$ScratchCardModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScratchCardModelToJson(this);

  ScratchCardModel copyWith({
    int? id,
    PrizeType? prizeType,
    double? prizeValue,
    bool? isScratched,
    DateTime? scratchedAt,
    DateTime? expiresAt,
  }) {
    return ScratchCardModel(
      id: id ?? this.id,
      prizeType: prizeType ?? this.prizeType,
      prizeValue: prizeValue ?? this.prizeValue,
      isScratched: isScratched ?? this.isScratched,
      scratchedAt: scratchedAt ?? this.scratchedAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
