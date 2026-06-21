import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Light Theme
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF5F5F5);
  static const Color lightPrimary = Color(0xFF1F315E);
  static const Color lightAccent = Color(0xFF1F315E);
  static const Color lightError = Color(0xFFE53935);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1a1a2e);
  static const Color lightTextSecondary = Color(0xFF6B6B6B);
  static const Color lightTextTertiary = Color(0xFF9E9E9E);
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color lightDivider = Color(0xFFF0F0F0);
  static const Color lightSuccess = Color(0xFF4CAF50);
  static const Color lightWarning = Color(0xFFFFC107);
  static const Color lightInfo = Color(0xFF2196F3);

  // Dark Theme
  static const Color darkBackground = Color(0xFF0D1321); // Deep navy tinted background
  static const Color darkSurface = Color(0xFF161F33);
  static const Color darkPrimary = Color(0xFF425A8B); // Slightly lighter navy for dark mode contrast
  static const Color darkAccent = Color(0xFF425A8B);
  static const Color darkError = Color(0xFFCF6679);
  static const Color darkOnPrimary = Color(0xFF121212);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFAAAAAA);
  static const Color darkTextTertiary = Color(0xFF808080);
  static const Color darkBorder = Color(0xFF424242);
  static const Color darkDivider = Color(0xFF2C2C2C);
  static const Color darkSuccess = Color(0xFF66BB6A);
  static const Color darkWarning = Color(0xFFFFD54F);
  static const Color darkInfo = Color(0xFF64B5F6);

  // Semantic Colors (used across both themes)
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
