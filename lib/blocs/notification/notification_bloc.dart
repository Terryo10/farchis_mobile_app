import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/notification_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository notificationRepository;

  NotificationBloc({required this.notificationRepository}) : super(const NotificationState()) {
    on<GetNotificationsEvent>(_onGetNotifications);
    on<MarkNotificationReadEvent>(_onMarkNotificationRead);
    on<MarkAllNotificationsReadEvent>(_onMarkAllNotificationsRead);
  }

  Future<void> _onGetNotifications(
      GetNotificationsEvent event, Emitter<NotificationState> emit) async {
    emit(state.copyWith(isLoading: true, failure: null));
    final result = await notificationRepository.getNotifications();
    result.when(
      onSuccess: (notifications) => emit(state.copyWith(isLoading: false, notifications: notifications)),
      onFailure: (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
    );
  }

  Future<void> _onMarkNotificationRead(
      MarkNotificationReadEvent event, Emitter<NotificationState> emit) async {
    // Optimistic UI update: mark read locally
    final updatedList = state.notifications.map((notification) {
      if (notification.id == event.id) {
        return notification.copyWith(isRead: true);
      }
      return notification;
    }).toList();
    emit(state.copyWith(notifications: updatedList));

    final result = await notificationRepository.markAsRead(event.id);
    result.when(
      onSuccess: (_) {},
      onFailure: (failure) {
        // If API fails, roll back or show error
        emit(state.copyWith(failure: failure));
      },
    );
  }

  Future<void> _onMarkAllNotificationsRead(
      MarkAllNotificationsReadEvent event, Emitter<NotificationState> emit) async {
    // Optimistic UI update
    final updatedList = state.notifications.map((notification) {
      return notification.copyWith(isRead: true);
    }).toList();
    emit(state.copyWith(notifications: updatedList));

    final result = await notificationRepository.markAllAsRead();
    result.when(
      onSuccess: (_) {},
      onFailure: (failure) {
        emit(state.copyWith(failure: failure));
      },
    );
  }
}
