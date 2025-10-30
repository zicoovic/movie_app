import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Simple Cubit to manage theme (Light/Dark)
// Saves user choice in shared_preferences

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences _prefs;

  // Constructor - starts with saved theme or dark by default
  ThemeCubit(this._prefs) : super(ThemeMode.dark) {
    _loadTheme();
  }

  // Load saved theme from storage
  void _loadTheme() {
    final isDark = _prefs.getBool('isDarkMode') ?? true; // Default to dark
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  // Toggle between light and dark
  void toggleTheme() {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(newMode);
    _saveTheme(newMode == ThemeMode.dark);
  }

  // Save theme choice
  void _saveTheme(bool isDark) {
    _prefs.setBool('isDarkMode', isDark);
  }

  // Check if dark mode
  bool get isDarkMode => state == ThemeMode.dark;
}
