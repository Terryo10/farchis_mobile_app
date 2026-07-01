import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum LoyaltyTier { bronze, silver, gold }

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  @JsonKey(name: 'avatar')
  final String? avatarUrl;
  final String? referralCode;
  final LoyaltyTier? loyaltyTier;
  final int? loyaltyPoints;
  final DateTime? lastServiceDate;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.referralCode,
    this.loyaltyTier,
    this.loyaltyPoints,
    this.lastServiceDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? referralCode,
    LoyaltyTier? loyaltyTier,
    int? loyaltyPoints,
    DateTime? lastServiceDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      referralCode: referralCode ?? this.referralCode,
      loyaltyTier: loyaltyTier ?? this.loyaltyTier,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      lastServiceDate: lastServiceDate ?? this.lastServiceDate,
    );
  }

  String? get fullAvatarUrl {
    if (avatarUrl == null || avatarUrl!.isEmpty) return null;
    if (avatarUrl!.startsWith('http://') || avatarUrl!.startsWith('https://')) {
      return avatarUrl;
    }
    if (avatarUrl!.startsWith('/')) {
      return 'https://farchis.com$avatarUrl';
    }
    return 'https://farchis.com/$avatarUrl';
  }
}
