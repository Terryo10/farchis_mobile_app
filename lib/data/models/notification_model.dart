import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic> data;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  NotificationModel copyWith({
    int? id,
    String? title,
    String? body,
    String? type,
    bool? isRead,
    DateTime? createdAt,
    Map<String, dynamic>? data,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      data: data ?? this.data,
    );
  }
}
