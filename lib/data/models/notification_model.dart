import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel, EquatableMixin {
  const NotificationModel._();

  const factory NotificationModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'body') required String body,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'data') Map<String, dynamic>? data,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  @override
  List<Object?> get props => [id, title, type];
}
