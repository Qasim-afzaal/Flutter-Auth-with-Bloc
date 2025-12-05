import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Base class for all theme states
/// All theme-related states must extend this class
abstract class ThemeState extends Equatable {
  final ThemeMode themeMode;
  
  const ThemeState(this.themeMode);
  
  @override
  List<Object?> get props => [themeMode];
}

/// Initial theme state
/// Defaults to system theme
class ThemeInitial extends ThemeState {
  const ThemeInitial() : super(ThemeMode.system);
}

/// Theme state with current theme mode
/// Contains the active theme mode (light, dark, or system)
class ThemeLoaded extends ThemeState {
  const ThemeLoaded(ThemeMode themeMode) : super(themeMode);
  
  /// Gets whether current theme is light
  bool get isLight => themeMode == ThemeMode.light;
  
  /// Gets whether current theme is dark
  bool get isDark => themeMode == ThemeMode.dark;
  
  /// Gets whether current theme follows system
  bool get isSystem => themeMode == ThemeMode.system;
}

