// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationModel _$ConversationModelFromJson(Map<String, dynamic> json) =>
    ConversationModel(
      id: (json['id'] as num).toInt(),
      type: $enumDecode(_$ConversationTypeEnumMap, json['type']),
      relatedId: (json['related_id'] as num?)?.toInt(),
      status: json['status'] as String,
      lastMessageAt: json['last_message_at'] == null
          ? null
          : DateTime.parse(json['last_message_at'] as String),
      unreadCount: (json['unread_count'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ConversationModelToJson(ConversationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ConversationTypeEnumMap[instance.type]!,
      'related_id': instance.relatedId,
      'status': instance.status,
      'last_message_at': instance.lastMessageAt?.toIso8601String(),
      'unread_count': instance.unreadCount,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$ConversationTypeEnumMap = {
  ConversationType.general: 'general',
  ConversationType.inspection: 'inspection',
};
