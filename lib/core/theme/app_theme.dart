import 'package:flutter/material.dart';
import 'app_colors.dart';

// Simple theme configuration
// One class with 2 static methods: light and dark

class AppTheme {
  // Private constructor
  AppTheme._();

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,

      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightText,
        elevation: 0,
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Text theme
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.lightText),
        bodyMedium: TextStyle(color: AppColors.lightTextSecondary),
      ),

      // Primary color
      primaryColor: AppColors.accentCyan,
      colorScheme: ColorScheme.light(
        primary: AppColors.accentCyan,
        secondary: AppColors.accentPurple,
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,

      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkText,
        elevation: 0,
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Text theme
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.darkText),
        bodyMedium: TextStyle(color: AppColors.darkTextSecondary),
      ),

      // Primary color
      primaryColor: AppColors.accentCyan,
      colorScheme: ColorScheme.dark(
        primary: AppColors.accentCyan,
        secondary: AppColors.accentPurple,
      ),
    );
  }
}
