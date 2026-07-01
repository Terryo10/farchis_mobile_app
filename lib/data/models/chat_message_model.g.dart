// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) =>
    ChatMessageModel(
      id: (json['id'] as num).toInt(),
      conversationId: (json['conversation_id'] as num).toInt(),
      senderType: $enumDecode(_$ChatSenderTypeEnumMap, json['sender_type']),
      senderId: (json['sender_id'] as num).toInt(),
      body: json['body'] as String?,
      attachments:
          (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      readAt: json['read_at'] == null
          ? null
          : DateTime.parse(json['read_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ChatMessageModelToJson(ChatMessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversation_id': instance.conversationId,
      'sender_type': _$ChatSenderTypeEnumMap[instance.senderType]!,
      'sender_id': instance.senderId,
      'body': instance.body,
      'attachments': instance.attachments,
      'read_at': instance.readAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$ChatSenderTypeEnumMap = {
  ChatSenderType.user: 'user',
  ChatSenderType.admin: 'admin',
};
