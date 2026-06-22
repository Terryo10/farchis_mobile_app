import 'package:json_annotation/json_annotation.dart';

part 'referral_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ReferredUserModel {
  final int id;
  final String name;
  final DateTime joinedAt;

  const ReferredUserModel({
    required this.id,
    required this.name,
    required this.joinedAt,
  });

  factory ReferredUserModel.fromJson(Map<String, dynamic> json) => _$ReferredUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReferredUserModelToJson(this);

  ReferredUserModel copyWith({
    int? id,
    String? name,
    DateTime? joinedAt,
  }) {
    return ReferredUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ReferralModel {
  final String referralCode;
  final List<ReferredUserModel> referredUsers;
  final int totalReferrals;

  const ReferralModel({
    required this.referralCode,
    required this.referredUsers,
    required this.totalReferrals,
  });

  factory ReferralModel.fromJson(Map<String, dynamic> json) => _$ReferralModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReferralModelToJson(this);

  ReferralModel copyWith({
    String? referralCode,
    List<ReferredUserModel>? referredUsers,
    int? totalReferrals,
  }) {
    return ReferralModel(
      referralCode: referralCode ?? this.referralCode,
      referredUsers: referredUsers ?? this.referredUsers,
      totalReferrals: totalReferrals ?? this.totalReferrals,
    );
  }
}
