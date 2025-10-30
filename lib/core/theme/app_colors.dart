import 'package:flutter/material.dart';

// All app colors in one place
// Based on the design you showed me (dark theme with cyan/purple accents)

class AppColors {
  // Private constructor - this is just a container for constants
  AppColors._();

  // Dark Theme Colors
  static const darkBackground = Color(0xFF0A0A0A);
  static const darkCard = Color(0xFF1A1A1A);
  static const darkText = Color(0xFFFFFFFF);
  static const darkTextSecondary = Color(0xFF9E9E9E);

  // Light Theme Colors
  static const lightBackground = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFF5F5F5);
  static const lightText = Color(0xFF000000);
  static const lightTextSecondary = Color(0xFF757575);

  // Accent Colors (same for both themes)
  static const accentCyan = Color(0xFF00BCD4);
  static const accentPurple = Color(0xFF9C27B0);
  static const accentRed = Color(0xFFE53935);

  // Gradient (for buttons)
  static const gradientColors = [accentCyan, accentPurple];
}
