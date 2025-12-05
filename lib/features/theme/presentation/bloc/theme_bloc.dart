import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/repositories/theme_repository.dart';
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
  final ThemeRepository _themeRepository;

  ThemeBloc({
    required ThemeRepository themeRepository,
  })  : _themeRepository = themeRepository,
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
      final themeMode = await _themeRepository.getThemeMode();
      final mode = themeMode ?? ThemeMode.system;
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
    await _themeRepository.saveThemeMode(themeMode);
    emit(ThemeLoaded(themeMode));
  }
}

