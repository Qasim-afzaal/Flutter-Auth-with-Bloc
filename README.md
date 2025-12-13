# Flutter Auth App with Multiple State Management Solutions

A comprehensive Flutter authentication application demonstrating **BLoC**, **Provider**, and **Riverpod** state management patterns, following Clean Architecture and SOLID principles.

## 🎯 Project Overview

This project is a learning resource that implements the same authentication features using three different state management approaches:
- **BLoC** - Event-driven, structured pattern
- **Provider** - Simple, direct method calls
- **Riverpod** - Modern, compile-time safe, performant

All implementations share the same:
- ✅ Clean Architecture structure
- ✅ Repository pattern
- ✅ Business logic
- ✅ UI design

## 📁 Project Structure

```
lib/
├── core/                          # Shared core functionality
│   ├── config/                    # App configuration
│   ├── constants/                 # App constants
│   ├── errors/                    # Error handling
│   ├── network/                   # API service
│   ├── router/                    # Navigation (BLoC, Provider, Riverpod versions)
│   ├── storage/                   # Secure storage service
│   ├── theme/                     # Theme management
│   └── utils/                     # Utility functions
│
├── features/                      # Feature-based architecture
│   ├── auth/                      # Authentication feature
│   │   ├── data/                  # Data layer
│   │   │   ├── models/            # DTOs
│   │   │   ├── mappers/           # DTO to Entity mappers
│   │   │   └── repositories/      # Repository implementations
│   │   ├── domain/                # Domain layer
│   │   │   ├── entities/          # Business entities
│   │   │   └── repositories/      # Repository contracts
│   │   └── presentation/          # Presentation layer
│   │       ├── bloc/              # BLoC implementation
│   │       ├── providers/         # Provider & Riverpod implementations
│   │       └── pages/             # UI pages (BLoC, Provider, Riverpod)
│   │
│   ├── dashboard/                 # Dashboard feature
│   ├── home/                      # Home feature
│   ├── profile/                   # Profile feature
│   └── notification/              # Notification feature
│
├── injection/                     # Dependency injection (GetIt)
└── main.dart                      # BLoC entry point
    main_provider.dart             # Provider entry point
    main_riverpod.dart             # Riverpod entry point
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart 3.9.2 or higher
- Android Studio / VS Code
- iOS Simulator / Android Emulator (for testing)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/auth_bloc.git
   cd auth_bloc
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment variables**
   ```bash
   cp .env.example .env
   # Edit .env and add your API_BASE_URL
   ```

4. **Run the app**
   ```bash
   # BLoC version (default)
   flutter run

   # Provider version
   flutter run lib/main_provider.dart

   # Riverpod version
   flutter run lib/main_riverpod.dart
   ```

## 🏗️ Architecture

### Clean Architecture

The project follows Clean Architecture principles with three layers:

1. **Domain Layer** (Business Logic)
   - Entities: Pure business objects
   - Repository Contracts: Interfaces defining data operations
   - No dependencies on external frameworks

2. **Data Layer** (Implementation)
   - DTOs: Data Transfer Objects for API responses
   - Mappers: Convert DTOs to Domain Entities
   - Repository Implementations: Concrete implementations of contracts
   - API Service: HTTP client for network requests

3. **Presentation Layer** (UI)
   - BLoC/Provider/Riverpod: State management
   - Pages: UI screens
   - Widgets: Reusable UI components

### SOLID Principles

- **S**ingle Responsibility: Each class has one reason to change
- **O**pen/Closed: Open for extension, closed for modification
- **L**iskov Substitution: Repository implementations are interchangeable
- **I**nterface Segregation: Small, focused interfaces
- **D**ependency Inversion: Depend on abstractions, not concretions

## 📚 State Management Comparison

### BLoC Pattern

**Entry Point:** `lib/main.dart`

**Key Features:**
- Event-driven architecture
- Type-safe state classes
- Clear separation of events and states
- Excellent for complex state machines

**Usage:**
```dart
// Dispatch event
context.read<AuthBloc>().add(LoginRequested(email, password));

// Listen to state
BlocBuilder<AuthBloc, AuthBlocState>(
  builder: (context, state) {
    if (state is AuthLoading) return CircularProgressIndicator();
    if (state is AuthAuthenticated) return HomePage();
    return LoginPage();
  },
)
```

### Provider Pattern

**Entry Point:** `lib/main_provider.dart`

**Key Features:**
- Simple, direct method calls
- Less boilerplate
- Easy to understand
- Good for simple to medium complexity

**Usage:**
```dart
// Call method directly
context.read<AuthProvider>().login(email, password);

// Listen to state
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    if (authProvider.isLoading) return CircularProgressIndicator();
    return LoginPage();
  },
)
```

### Riverpod Pattern

**Entry Point:** `lib/main_riverpod.dart`

**Key Features:**
- Compile-time safe
- Automatic rebuild optimization
- Built-in dependency injection
- Modern Flutter pattern
- Selective rebuilds for better performance

**Usage:**
```dart
// In ConsumerWidget
final isLoading = ref.watch(authIsLoadingProvider);
final authNotifier = ref.read(authNotifierProvider.notifier);

// Call method
await authNotifier.login(email, password);
```

## 📖 Documentation

- **[CI/CD Guide](CI_CD_GUIDE.md)** - Complete CI/CD pipeline documentation
- **[Provider vs BLoC](PROVIDER_VS_BLOC.md)** - Detailed comparison
- **[Riverpod vs BLoC vs Provider](RIVERPOD_VS_BLOC_PROVIDER.md)** - Complete comparison
- **[How to Test Provider](HOW_TO_TEST_PROVIDER.md)** - Provider testing guide
- **[How to Test Riverpod](HOW_TO_TEST_RIVERPOD.md)** - Riverpod testing guide
- **[CI/CD Explained](CI_CD_EXPLAINED.md)** - Visual CI/CD guide
- **[Setup CI/CD](SETUP_CI_CD.md)** - Quick setup instructions

## 🔐 Features

### Authentication
- ✅ Login with email and password
- ✅ Signup with name, email, and password
- ✅ Auto-login on app restart
- ✅ Secure token storage
- ✅ Logout functionality

### Dashboard
- ✅ Bottom navigation (Home, Notifications, Profile)
- ✅ User info display in header
- ✅ Tab state management in BLoC
- ✅ Clean Architecture for each feature

### State Management
- ✅ BLoC implementation
- ✅ Provider implementation
- ✅ Riverpod implementation
- ✅ All using same repository layer

### Theme
- ✅ Light/Dark mode support
- ✅ Theme persistence
- ✅ Theme toggle widget

## 🛠️ Tech Stack

- **Flutter** - UI Framework
- **BLoC** - State Management (Event-driven)
- **Provider** - State Management (Simple)
- **Riverpod** - State Management (Modern)
- **GetIt** - Dependency Injection
- **GoRouter** - Navigation
- **flutter_secure_storage** - Secure storage
- **http** - HTTP client
- **equatable** - Value equality

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Run Specific Test
```bash
flutter test test/features/auth/presentation/bloc/auth_bloc_test.dart
```

## 🚀 CI/CD

The project includes GitHub Actions workflows for:

- **CI Pipeline** (`.github/workflows/ci.yml`)
  - Code quality checks
  - Unit tests
  - Build Android, iOS, Web

- **CD Pipeline** (`.github/workflows/cd.yml`)
  - Automatic deployment to staging
  - Production deployment on tags

- **Quick Check** (`.github/workflows/quick-check.yml`)
  - Fast validation for PRs

View workflows in the **Actions** tab on GitHub.

## 📝 Environment Variables

Create a `.env` file in the root directory:

```env
API_BASE_URL=http://your-api-url.com/api/
```

**Important:** Never commit `.env` files to version control!

## 🎓 Learning Resources

### Clean Architecture
- Domain entities represent business logic
- Repository contracts define data operations
- DTOs handle API response parsing
- Mappers convert between layers

### State Management
- **BLoC**: Best for complex state machines
- **Provider**: Best for simple to medium complexity
- **Riverpod**: Best for modern Flutter apps with performance needs

### Best Practices
- ✅ Feature-based folder structure
- ✅ Dependency injection
- ✅ Error handling
- ✅ Secure storage for sensitive data
- ✅ Type-safe state management

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- BLoC library creators
- Provider package maintainers
- Riverpod creators
- All contributors to the Flutter ecosystem

## 📞 Contact

For questions or suggestions, please open an issue on GitHub.

---

**Happy Coding! 🚀**
