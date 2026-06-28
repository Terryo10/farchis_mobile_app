import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../data/models/notification_model.dart';

class NotificationState extends Equatable {
  final bool isLoading;
  final List<NotificationModel> notifications;
  final Failure? failure;

  const NotificationState({
    this.isLoading = false,
    this.notifications = const [],
    this.failure,
  });

  NotificationState copyWith({
    bool? isLoading,
    List<NotificationModel>? notifications,
    Failure? failure,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [isLoading, notifications, failure];
}
