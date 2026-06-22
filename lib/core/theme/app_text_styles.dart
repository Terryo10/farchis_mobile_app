import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  // Display Styles (Large headlines)
  static TextStyle displayLarge = GoogleFonts.outfit(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.25,
    letterSpacing: -0.5,
  );

  static TextStyle displayMedium = GoogleFonts.outfit(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.3,
    letterSpacing: -0.25,
  );

  static TextStyle displaySmall = GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
  );

  // Headline Styles
  static TextStyle headlineLarge = GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  static TextStyle headlineMedium = GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.45,
  );

  static TextStyle headlineSmall = GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.5,
  );

  // Title Styles
  static TextStyle titleLarge = GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static TextStyle titleMedium = GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.57,
  );

  static TextStyle titleSmall = GoogleFonts.outfit(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.67,
  );

  // Body Styles
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.57,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.67,
  );

  // Label Styles
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,
    letterSpacing: 0.1,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.67,
    letterSpacing: 0.5,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.45,
    letterSpacing: 0.5,
  );

  // Caption Style
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // Error Style
  static TextStyle error = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    color: const Color(0xFFDC2626),
  );
}
