# Theme System Documentation

## 🎨 Overview

The app includes a professional theme management system that supports:
- **Light Theme** - Bright, clean interface
- **Dark Theme** - Easy on the eyes, modern look
- **System Theme** - Follows device settings
- **Persistent Storage** - Saves user preference
- **Clean Architecture** - Follows the same pattern as auth feature

## 📁 Structure

```
lib/
├── core/
│   └── theme/
│       └── app_theme.dart          # Theme configuration (Light/Dark)
│
└── features/
    └── theme/
        ├── domain/
        │   └── repositories/
        │       └── theme_repository.dart      # Contract
        ├── data/
        │   └── repositories/
        │       └── theme_repository_impl.dart # Implementation
        └── presentation/
            ├── bloc/
            │   ├── theme_bloc.dart            # State management
            │   ├── theme_event.dart            # Events
            │   └── theme_state.dart           # States
            └── widgets/
                ├── theme_toggle_button.dart    # Quick toggle
                └── theme_selector.dart         # Full menu
```

## 🏗️ Architecture

### Domain Layer
- **ThemeRepository** (Contract) - Defines what you can do
  - `getThemeMode()` - Get saved theme
  - `saveThemeMode()` - Save theme preference

### Data Layer
- **ThemeRepositoryImpl** - Implements the contract
  - Uses `SecureStorageService` to save/load theme
  - Converts ThemeMode to/from string

### Presentation Layer
- **ThemeBloc** - Manages theme state
- **Theme Events**:
  - `ThemeToggled` - Toggle between light/dark
  - `ThemeLightRequested` - Set to light
  - `ThemeDarkRequested` - Set to dark
  - `ThemeSystemRequested` - Set to system
  - `ThemeLoadRequested` - Load saved preference
- **Theme States**:
  - `ThemeInitial` - Default state
  - `ThemeLoaded` - Theme mode loaded

## 🎯 How It Works

### 1. App Start
```dart
// main.dart
ThemeBloc loads saved theme preference on initialization
```

### 2. Theme Change
```dart
// User taps theme button
ThemeBloc receives ThemeToggled event
→ Saves to secure storage
→ Emits ThemeLoaded state
→ MaterialApp rebuilds with new theme
```

### 3. Theme Persistence
```dart
// Theme preference saved to secure storage
// Loaded automatically on app restart
```

## 🎨 Theme Configuration

### Light Theme
- Primary: Deep Purple
- Background: White (#FFFFFF)
- Surface: Light Gray (#F5F5F5)
- Material Design 3 compliant

### Dark Theme
- Primary: Deep Purple
- Background: Dark Gray (#121212)
- Surface: Darker Gray (#1E1E1E)
- Material Design 3 compliant

## 🚀 Usage

### Using Theme Toggle Button
```dart
import 'package:auth_bloc/features/theme/presentation/widgets/theme_toggle_button.dart';

// In AppBar actions
actions: [
  ThemeToggleButton(), // Quick toggle
]
```

### Using Theme Selector
```dart
import 'package:auth_bloc/features/theme/presentation/widgets/theme_selector.dart';

// In AppBar actions
actions: [
  ThemeSelector(), // Full menu (Light/Dark/System)
]
```

### Accessing Theme in Code
```dart
// Get current theme mode
final themeBloc = context.read<ThemeBloc>();
final themeMode = themeBloc.state.themeMode;

// Toggle theme
context.read<ThemeBloc>().add(const ThemeToggled());

// Set specific theme
context.read<ThemeBloc>().add(const ThemeLightRequested());
context.read<ThemeBloc>().add(const ThemeDarkRequested());
context.read<ThemeBloc>().add(const ThemeSystemRequested());
```

## 📱 UI Components

### Theme Toggle Button
- Quick toggle between light/dark
- Shows sun icon (light mode) or moon icon (dark mode)
- Located in AppBar

### Theme Selector
- Full menu with 3 options:
  - Light Mode
  - Dark Mode
  - System (follows device)
- Shows checkmark for current selection
- Located in AppBar

## 🔧 Customization

### Changing Colors
Edit `lib/core/theme/app_theme.dart`:
```dart
// Change primary color
static const Color _primaryColor = Colors.blue; // Your color

// Change background colors
static const Color _lightBackground = Color(0xFFF0F0F0); // Your color
```

### Adding Custom Themes
1. Add new theme method in `AppTheme`
2. Add new state in `ThemeState`
3. Add new event in `ThemeEvent`
4. Handle in `ThemeBloc`

## ✅ Features

- ✅ Light/Dark/System themes
- ✅ Persistent storage
- ✅ Clean Architecture
- ✅ BLoC state management
- ✅ Material Design 3
- ✅ Professional UI components
- ✅ Easy to customize

## 🎓 Learning Points

1. **Follows Clean Architecture** - Same pattern as auth feature
2. **BLoC Pattern** - State management for theme
3. **Secure Storage** - Persists user preference
4. **Material Design 3** - Modern, beautiful themes
5. **Reusable Widgets** - Theme toggle and selector

## 📚 Related Files

- `lib/core/theme/app_theme.dart` - Theme definitions
- `lib/features/theme/` - Theme feature (Clean Architecture)
- `lib/main.dart` - App setup with theme BLoC
- `lib/features/auth/presentation/pages/home_page.dart` - Example usage

## 🎉 Summary

The theme system is:
- ✅ Professional and well-structured
- ✅ Follows Clean Architecture
- ✅ Easy to use and customize
- ✅ Persists user preference
- ✅ Supports Light/Dark/System modes

Enjoy your beautiful, themed app! 🎨

