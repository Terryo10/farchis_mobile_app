// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationModelImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  body: json['body'] as String,
  type: json['type'] as String?,
  isRead: json['is_read'] as bool? ?? false,
  data: json['data'] as Map<String, dynamic>?,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$$NotificationModelImplToJson(
  _$NotificationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
  'type': instance.type,
  'is_read': instance.isRead,
  'data': instance.data,
  'created_at': instance.createdAt,
};
