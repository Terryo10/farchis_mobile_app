import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Monochromatic Navy & Silver Palette
  static const Color navyDarkest = Color(0xFF0A1321); // Darker shade for contrast
  static const Color navyDark = Color(0xFF111F36);
  static const Color navyPrimary = Color(0xFF182B49); // The requested color
  static const Color navyLight = Color(0xFF2C446B);
  static const Color silverLight = Color(0xFFF5F6FA); // Exact background from screenshot
  static const Color silver = Color(0xFFCBD5E1);
  static const Color silverDark = Color(0xFF94A3B8);

  // Light Theme
  static const Color lightBackground = silverLight;
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightPrimary = navyPrimary;
  static const Color lightAccent = navyLight;
  static const Color lightError = Color(0xFFDC2626);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = navyDarkest;
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextTertiary = silverDark;
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightDivider = Color(0xFFE2E8F0);
  static const Color lightSuccess = Color(0xFF10B981);
  static const Color lightWarning = Color(0xFFF59E0B);
  static const Color lightInfo = Color(0xFF3B82F6);

  // Dark Theme
  static const Color darkBackground = navyDarkest;
  static const Color darkSurface = navyDark;
  static const Color darkPrimary = silverLight;
  static const Color darkAccent = navyLight;
  static const Color darkError = Color(0xFFEF4444);
  static const Color darkOnPrimary = navyDarkest;
  static const Color darkTextPrimary = silverLight;
  static const Color darkTextSecondary = silver;
  static const Color darkTextTertiary = silverDark;
  static const Color darkBorder = navyPrimary;
  static const Color darkDivider = navyPrimary;
  static const Color darkSuccess = Color(0xFF34D399);
  static const Color darkWarning = Color(0xFFFBBF24);
  static const Color darkInfo = Color(0xFF60A5FA);

  // Semantic Colors
  static const Color transparent = Color(0x00000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Loyalty Tier Colors
  static const Color tierSilver = Color(0xFFC0C0C0);
  static const Color tierGold = Color(0xFFc9a84c);
  static const Color tierPlatinum = Color(0xFFE5E4E2);

  // Service Category Colors
  static const Color categoryMaintenance = Color(0xFF4CAF50);
  static const Color categoryRepair = Color(0xFFE53935);
  static const Color categoryDetailing = Color(0xFF2196F3);
  static const Color categoryCustom = Color(0xFFFF9800);
}

class FarchisColors {
  FarchisColors._();

  static const Color navy = Color(0xFF253971);
  static const Color dark = Color(0xFF16223F);
  static const Color light = Color(0xFF5A6FA3);
}
