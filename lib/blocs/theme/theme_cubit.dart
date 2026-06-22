import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences prefs;

  ThemeCubit(this.prefs) : super(_getInitialTheme(prefs));

  static ThemeMode _getInitialTheme(SharedPreferences prefs) {
    try {
      final themeValue = prefs.get('theme_mode');
      if (themeValue is String) {
        if (themeValue == 'light') return ThemeMode.light;
        if (themeValue == 'dark') return ThemeMode.dark;
      } else if (themeValue is bool) {
        return themeValue ? ThemeMode.dark : ThemeMode.light;
      }
    } catch (_) {}
    return ThemeMode.system;
  }

  void toggleTheme() {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    prefs.setString('theme_mode', newMode.name);
    emit(newMode);
  }

  void setTheme(ThemeMode mode) {
    prefs.setString('theme_mode', mode.name);
    emit(mode);
  }
}
