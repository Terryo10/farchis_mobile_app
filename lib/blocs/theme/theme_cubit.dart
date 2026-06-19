import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'theme_mode';

  ThemeCubit() : super(const ThemeLightState()) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_themeKey) ?? false;
      emit(isDark ? const ThemeDarkState() : const ThemeLightState());
    } catch (e) {
      emit(const ThemeLightState());
    }
  }

  Future<void> toggleTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = state is ThemeDarkState;
      await prefs.setBool(_themeKey, !isDark);
      emit(!isDark ? const ThemeDarkState() : const ThemeLightState());
    } catch (e) {
      // Handle error silently
    }
  }

  bool get isDarkMode => state is ThemeDarkState;
}
