import 'package:equatable/equatable.dart';

/// Base class for all theme events
/// All theme-related events must extend this class
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
  
  @override
  List<Object?> get props => [];
}

/// Event to toggle between light and dark theme
/// Switches from current theme to opposite theme
class ThemeToggled extends ThemeEvent {
  const ThemeToggled();
}

/// Event to set theme to light mode
class ThemeLightRequested extends ThemeEvent {
  const ThemeLightRequested();
}

/// Event to set theme to dark mode
class ThemeDarkRequested extends ThemeEvent {
  const ThemeDarkRequested();
}

/// Event to set theme to system default
/// Follows device theme settings
class ThemeSystemRequested extends ThemeEvent {
  const ThemeSystemRequested();
}

/// Event to load saved theme preference
/// Loads theme from secure storage on app start
class ThemeLoadRequested extends ThemeEvent {
  const ThemeLoadRequested();
}

