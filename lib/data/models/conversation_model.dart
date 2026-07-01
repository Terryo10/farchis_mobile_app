import 'package:json_annotation/json_annotation.dart';

part 'conversation_model.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum ConversationType { general, inspection }

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class ConversationModel {
  final int id;
  final ConversationType type;
  final int? relatedId;
  final String status;
  final DateTime? lastMessageAt;
  final int? unreadCount;
  final DateTime createdAt;

  const ConversationModel({
    required this.id,
    required this.type,
    this.relatedId,
    required this.status,
    this.lastMessageAt,
    this.unreadCount,
    required this.createdAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationModelToJson(this);
}
