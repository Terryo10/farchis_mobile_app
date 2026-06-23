import 'package:json_annotation/json_annotation.dart';

part 'loyalty_transaction_model.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum LoyaltyTransactionType { earn, redeem }

@JsonSerializable(explicitToJson: true)
class LoyaltyTransactionModel {
  final int id;
  final int points;
  final LoyaltyTransactionType type;
  final String description;
  final DateTime createdAt;

  const LoyaltyTransactionModel({
    required this.id,
    required this.points,
    required this.type,
    required this.description,
    required this.createdAt,
  });

  factory LoyaltyTransactionModel.fromJson(Map<String, dynamic> json) => _$LoyaltyTransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoyaltyTransactionModelToJson(this);

  LoyaltyTransactionModel copyWith({
    int? id,
    int? points,
    LoyaltyTransactionType? type,
    String? description,
    DateTime? createdAt,
  }) {
    return LoyaltyTransactionModel(
      id: id ?? this.id,
      points: points ?? this.points,
      type: type ?? this.type,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
