import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part 'loyalty_transaction_model.freezed.dart';
part 'loyalty_transaction_model.g.dart';

@freezed
class LoyaltyTransactionModel with _$LoyaltyTransactionModel, EquatableMixin {
  const LoyaltyTransactionModel._();

  const factory LoyaltyTransactionModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'booking_id') String? bookingId,
    @JsonKey(name: 'points') required int points,
    @JsonKey(name: 'type') required String type,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _LoyaltyTransactionModel;

  factory LoyaltyTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyTransactionModelFromJson(json);

  @override
  List<Object?> get props => [id, userId, points, type];
}
