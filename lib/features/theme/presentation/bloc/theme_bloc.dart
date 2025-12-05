import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/utils/logger.dart';
import 'theme_event.dart';
import 'theme_state.dart';

/// Theme BLoC
/// Manages theme state and handles theme change events
/// Saves theme preference to secure storage
/// 
/// Events handled:
/// - ThemeToggled: Toggles between light and dark theme
/// - ThemeLightRequested: Sets theme to light mode
/// - ThemeDarkRequested: Sets theme to dark mode
/// - ThemeSystemRequested: Sets theme to system default
/// - ThemeLoadRequested: Loads saved theme preference
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SecureStorageService _storage;
  static const String _themeKey = 'theme_mode';

  ThemeBloc({
    required SecureStorageService storage,
  })  : _storage = storage,
        super(const ThemeInitial()) {
    on<ThemeToggled>(_onThemeToggled);
    on<ThemeLightRequested>(_onThemeLightRequested);
    on<ThemeDarkRequested>(_onThemeDarkRequested);
    on<ThemeSystemRequested>(_onThemeSystemRequested);
    on<ThemeLoadRequested>(_onThemeLoadRequested);
  }

  /// Handles theme toggle event
  /// Switches between light and dark theme
  Future<void> _onThemeToggled(
    ThemeToggled event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final currentMode = state.themeMode;
      ThemeMode newMode;

      // Toggle between light and dark (skip system)
      if (currentMode == ThemeMode.light) {
        newMode = ThemeMode.dark;
      } else if (currentMode == ThemeMode.dark) {
        newMode = ThemeMode.light;
      } else {
        // If system, default to light
        newMode = ThemeMode.light;
      }

      Logger.info('Theme toggled to: ${newMode.name}');
      await _saveAndEmitTheme(emit, newMode);
    } catch (e) {
      Logger.error('Error toggling theme', e);
    }
  }

  /// Handles light theme request event
  Future<void> _onThemeLightRequested(
    ThemeLightRequested event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      Logger.info('Light theme requested');
      await _saveAndEmitTheme(emit, ThemeMode.light);
    } catch (e) {
      Logger.error('Error setting light theme', e);
    }
  }

  /// Handles dark theme request event
  Future<void> _onThemeDarkRequested(
    ThemeDarkRequested event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      Logger.info('Dark theme requested');
      await _saveAndEmitTheme(emit, ThemeMode.dark);
    } catch (e) {
      Logger.error('Error setting dark theme', e);
    }
  }

  /// Handles system theme request event
  Future<void> _onThemeSystemRequested(
    ThemeSystemRequested event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      Logger.info('System theme requested');
      await _saveAndEmitTheme(emit, ThemeMode.system);
    } catch (e) {
      Logger.error('Error setting system theme', e);
    }
  }

  /// Handles theme load request event
  /// Loads saved theme preference from storage
  Future<void> _onThemeLoadRequested(
    ThemeLoadRequested event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      Logger.info('Loading theme preference');
      final themeString = await _storage.getString(_themeKey);
      final mode = _parseThemeMode(themeString);
      Logger.info('Theme preference loaded: ${mode.name}');
      emit(ThemeLoaded(mode));
    } catch (e) {
      Logger.error('Error loading theme preference', e);
      emit(const ThemeLoaded(ThemeMode.system));
    }
  }

  /// Saves theme mode and emits new state
  Future<void> _saveAndEmitTheme(
    Emitter<ThemeState> emit,
    ThemeMode themeMode,
  ) async {
    try {
      final themeString = _themeModeToString(themeMode);
      await _storage.saveString(_themeKey, themeString);
      Logger.info('Theme saved: ${themeMode.name}');
      emit(ThemeLoaded(themeMode));
    } catch (e) {
      Logger.error('Error saving theme', e);
      emit(ThemeLoaded(themeMode)); // Still emit even if save fails
    }
  }

  /// Converts ThemeMode to string
  String _themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Parses string to ThemeMode
  ThemeMode _parseThemeMode(String? themeString) {
    if (themeString == null || themeString.isEmpty) {
      return ThemeMode.system;
    }
    
    switch (themeString.toLowerCase()) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}

