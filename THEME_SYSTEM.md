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
│       ├── app_theme.dart          # Theme configuration (Light/Dark)
│       └── theme_service.dart       # Simple theme management (ChangeNotifier)
│
└── features/
    └── theme/
        └── presentation/
            └── widgets/
                ├── theme_toggle_button.dart    # Quick toggle
                └── theme_selector.dart         # Full menu
```

## 🏗️ Architecture (Ultra Simple)

**Simple and Professional Approach:**
- **ThemeService** - Simple ChangeNotifier (no BLoC needed!)
- Uses `SecureStorageService` directly
- Provider for dependency injection
- Clean and minimal - perfect for simple state like theme

### Components

- **ThemeService** - Simple state management
  - Extends `ChangeNotifier` (built-in Flutter)
  - Handles all theme operations
  - Saves/loads from SecureStorageService directly
  - Converts ThemeMode to/from string
  - Methods: `toggleTheme()`, `setLight()`, `setDark()`, `setSystem()`

**Why ChangeNotifier instead of BLoC?**
- Theme is simple state (just one value: ThemeMode)
- No complex business logic
- No need for events/states pattern
- ChangeNotifier is perfect for simple reactive state

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
final themeService = context.read<ThemeService>();
final themeMode = themeService.themeMode;

// Toggle theme
context.read<ThemeService>().toggleTheme();

// Set specific theme
context.read<ThemeService>().setLight();
context.read<ThemeService>().setDark();
context.read<ThemeService>().setSystem();
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
- ✅ Simple & Professional (no over-engineering)
- ✅ BLoC state management
- ✅ Material Design 3
- ✅ Professional UI components
- ✅ Easy to customize

## 🎓 Learning Points

1. **Simple & Professional** - No over-engineering for simple features
2. **ChangeNotifier** - Perfect for simple state (no BLoC needed!)
3. **Direct Storage** - Uses SecureStorageService directly
4. **Material Design 3** - Modern, beautiful themes
5. **Reusable Widgets** - Theme toggle and selector

**Key Takeaway:** 
- **BLoC** = For complex state with business logic (like Auth)
- **ChangeNotifier** = For simple state (like Theme)
- Don't use BLoC for everything - choose the right tool!

## 📚 Related Files

- `lib/core/theme/app_theme.dart` - Theme definitions
- `lib/features/theme/` - Theme feature (Clean Architecture)
- `lib/main.dart` - App setup with theme BLoC
- `lib/features/auth/presentation/pages/home_page.dart` - Example usage

## 🎉 Summary

The theme system is:
- ✅ Professional and well-structured
- ✅ Ultra simple (ChangeNotifier, no BLoC)
- ✅ Easy to use and customize
- ✅ Persists user preference
- ✅ Supports Light/Dark/System modes

**Key Takeaway:** 
- **Don't use BLoC for everything!**
- For simple state like theme → Use **ChangeNotifier**
- For complex state like auth → Use **BLoC**
- Choose the right tool for the job! 🎨

