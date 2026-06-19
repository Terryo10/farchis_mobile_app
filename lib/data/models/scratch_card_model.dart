import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part 'scratch_card_model.freezed.dart';
part 'scratch_card_model.g.dart';

@freezed
class ScratchCardModel with _$ScratchCardModel, EquatableMixin {
  const ScratchCardModel._();

  const factory ScratchCardModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'booking_id') String? bookingId,
    @JsonKey(name: 'prize_type') required String prizeType,
    @JsonKey(name: 'prize_value') required double prizeValue,
    @JsonKey(name: 'is_scratched') @Default(false) bool isScratched,
    @JsonKey(name: 'scratched_at') String? scratchedAt,
    @JsonKey(name: 'expires_at') required String expiresAt,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _ScratchCardModel;

  factory ScratchCardModel.fromJson(Map<String, dynamic> json) =>
      _$ScratchCardModelFromJson(json);

  @override
  List<Object?> get props => [id, userId, prizeType, isScratched];
}
