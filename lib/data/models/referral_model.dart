import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part 'referral_model.freezed.dart';
part 'referral_model.g.dart';

@freezed
class ReferralModel with _$ReferralModel, EquatableMixin {
  const ReferralModel._();

  const factory ReferralModel({
    @JsonKey(name: 'referral_code') required String referralCode,
    @JsonKey(name: 'total_referrals') @Default(0) int totalReferrals,
    @JsonKey(name: 'referred_users') @Default([]) List<dynamic> referredUsers,
  }) = _ReferralModel;

  factory ReferralModel.fromJson(Map<String, dynamic> json) =>
      _$ReferralModelFromJson(json);

  @override
  List<Object?> get props => [referralCode, totalReferrals];
}
