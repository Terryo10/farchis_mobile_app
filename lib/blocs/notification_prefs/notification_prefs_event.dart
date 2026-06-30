import 'package:equatable/equatable.dart';

sealed class NotificationPrefsEvent extends Equatable {
  const NotificationPrefsEvent();
  @override
  List<Object?> get props => [];
}

class LoadNotificationPrefs extends NotificationPrefsEvent {
  const LoadNotificationPrefs();
}

class ToggleNotificationPref extends NotificationPrefsEvent {
  final String key;
  const ToggleNotificationPref(this.key);
  @override
  List<Object?> get props => [key];
}
