import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class ThemeState {
  final ThemeMode themeMode;
  
  ThemeState({required this.themeMode});
  
  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }
  
  String get label {
    switch (themeMode) {
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.system:
        return 'System';
    }
  }
  
  IconData get icon {
    switch (themeMode) {
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(ThemeState(themeMode: ThemeMode.system)) {
    _loadTheme();
  }
  
  void _loadTheme() {
    final box = Hive.box('app');
    final savedTheme = box.get('themeMode', defaultValue: 'system');
    state = ThemeState(themeMode: _themeModeFromString(savedTheme));
  }
  
  void setThemeMode(ThemeMode mode) {
    state = ThemeState(themeMode: mode);
    final box = Hive.box('app');
    box.put('themeMode', _themeModeToString(mode));
  }
  
  void toggleTheme() {
    switch (state.themeMode) {
      case ThemeMode.dark:
        setThemeMode(ThemeMode.light);
        break;
      case ThemeMode.light:
        setThemeMode(ThemeMode.system);
        break;
      case ThemeMode.system:
        setThemeMode(ThemeMode.dark);
        break;
    }
  }
  
  ThemeMode _themeModeFromString(String value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
  
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.system:
        return 'system';
    }
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});
