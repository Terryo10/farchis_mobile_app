import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_prefs_event.dart';
import 'notification_prefs_state.dart';

class NotificationPrefsBloc
    extends Bloc<NotificationPrefsEvent, NotificationPrefsState> {
  final SharedPreferences prefs;

  NotificationPrefsBloc({required this.prefs})
      : super(const NotificationPrefsState()) {
    on<LoadNotificationPrefs>(_onLoad);
    on<ToggleNotificationPref>(_onToggle);
  }

  void _onLoad(
      LoadNotificationPrefs event, Emitter<NotificationPrefsState> emit) {
    final loaded = <String, bool>{};
    for (final key in NotifPrefKeys.all) {
      // Default to true if never set (opt-in by default for booking updates).
      loaded[key] = prefs.getBool(key) ??
          (key == NotifPrefKeys.newServices ? false : true);
    }
    emit(state.copyWith(prefs: loaded, isLoading: false));
  }

  Future<void> _onToggle(
      ToggleNotificationPref event, Emitter<NotificationPrefsState> emit) async {
    final current = state.prefs[event.key] ?? true;
    final updated = Map<String, bool>.from(state.prefs)
      ..[event.key] = !current;
    await prefs.setBool(event.key, !current);
    emit(state.copyWith(prefs: updated));
  }
}
