import 'package:json_annotation/json_annotation.dart';

part 'chat_message_model.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum ChatSenderType { user, admin }

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class ChatMessageModel {
  final int id;
  final int conversationId;
  final ChatSenderType senderType;
  final int senderId;
  final String? body;
  final List<String> attachments;
  final DateTime? readAt;
  final DateTime createdAt;

  const ChatMessageModel({
    required this.id,
    required this.conversationId,
    required this.senderType,
    required this.senderId,
    this.body,
    this.attachments = const [],
    this.readAt,
    required this.createdAt,
  });

  bool get isFromUser => senderType == ChatSenderType.user;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);
}
