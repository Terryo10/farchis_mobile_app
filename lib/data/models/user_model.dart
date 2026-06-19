import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel, EquatableMixin {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String name,
    required String email,
    required String phone,
    String? avatar,
    @JsonKey(name: 'referral_code') String? referralCode,
    @JsonKey(name: 'referred_by') String? referredBy,
    @JsonKey(name: 'loyalty_tier') String? loyaltyTier,
    @JsonKey(name: 'loyalty_points') @Default(0) int loyaltyPoints,
    @JsonKey(name: 'total_points_earned') @Default(0) int totalPointsEarned,
    @JsonKey(name: 'vehicle_make') String? vehicleMake,
    @JsonKey(name: 'vehicle_model') String? vehicleModel,
    @JsonKey(name: 'vehicle_year') int? vehicleYear,
    @JsonKey(name: 'vehicle_plate') String? vehiclePlate,
    @JsonKey(name: 'last_service_date') String? lastServiceDate,
    @JsonKey(name: 'email_verified_at') String? emailVerifiedAt,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        avatar,
        referralCode,
        loyaltyTier,
        loyaltyPoints,
        vehicleMake,
        vehicleModel,
        vehicleYear,
        vehiclePlate,
      ];
}
