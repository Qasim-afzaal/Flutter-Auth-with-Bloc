# Flutter Auth App - Multi-State Management Demo

A comprehensive Flutter authentication application demonstrating **three different state management approaches** (BLoC, Provider, and Riverpod) with Clean Architecture, SOLID principles, and CI/CD pipelines.

## 🎯 Project Overview

This project serves as a **learning resource** and **reference implementation** for:
- **State Management**: BLoC, Provider, and Riverpod patterns
- **Clean Architecture**: Domain, Data, and Presentation layers
- **SOLID Principles**: Applied throughout the codebase
- **CI/CD Pipelines**: Automated testing, building, and deployment
- **Best Practices**: Modern Flutter development patterns

## ✨ Features

- ✅ **Authentication**: Login, Signup, Auto-login, Logout
- ✅ **Dashboard**: Bottom navigation with Home, Notifications, Profile tabs
- ✅ **Theme Management**: Dark/Light mode with persistence
- ✅ **Secure Storage**: Token and user data storage
- ✅ **API Integration**: RESTful API with error handling
- ✅ **Three State Management Implementations**:
  - **BLoC**: Event-driven, structured approach
  - **Provider**: Simple, direct method calls
  - **Riverpod**: Modern, compile-time safe, performant

## 📁 Project Structure

```
lib/
├── core/                          # Shared core functionality
│   ├── config/                    # App configuration
│   ├── errors/                    # Error handling
│   ├── network/                   # API service
│   ├── router/                   # Navigation (BLoC, Provider, Riverpod)
│   ├── storage/                  # Secure storage service
│   ├── theme/                    # Theme management
│   └── utils/                    # Utility functions
│
├── features/                      # Feature-based architecture
│   ├── auth/                     # Authentication feature
│   │   ├── data/                 # Data layer (DTOs, Mappers, Repositories)
│   │   ├── domain/               # Domain layer (Entities, Contracts)
│   │   └── presentation/         # Presentation layer
│   │       ├── bloc/             # BLoC implementation
│   │       ├── providers/         # Provider & Riverpod implementations
│   │       └── pages/             # UI pages (BLoC, Provider, Riverpod)
│   │
│   ├── dashboard/                # Dashboard feature
│   │   ├── data/                 # Dashboard data layer
│   │   ├── domain/               # Dashboard domain layer
│   │   └── presentation/         # Dashboard UI & BLoC
│   │
│   ├── home/                     # Home feature
│   ├── profile/                  # Profile feature
│   └── notification/             # Notification feature
│
├── injection/                    # Dependency injection (GetIt)
│
├── main.dart                     # BLoC entry point
├── main_provider.dart            # Provider entry point
└── main_riverpod.dart            # Riverpod entry point
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart 3.9.2 or higher
- Android Studio / VS Code
- Git

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
   # Copy example environment file
   cp .env.example .env
   
   # Edit .env and add your API base URL
   API_BASE_URL=http://your-api-url.com/api
   ```

4. **Run the app**
   ```bash
   # BLoC version (default)
   flutter run lib/main.dart
   
   # Provider version
   flutter run lib/main_provider.dart
   
   # Riverpod version
   flutter run lib/main_riverpod.dart
   ```

## 📚 State Management Implementations

This project includes **three complete implementations** of the same authentication flow:

### 1. BLoC Implementation

**Entry Point**: `lib/main.dart`

**Key Files**:
- `lib/features/auth/presentation/bloc/auth_bloc.dart`
- `lib/features/auth/presentation/pages/login_page.dart`
- `lib/features/auth/presentation/pages/signup_page.dart`

**Characteristics**:
- Event-driven architecture
- Separate state classes
- Type-safe with strong state management
- Best for complex state machines

**Usage**:
```dart
// Dispatch events
context.read<AuthBloc>().add(LoginRequested(email, password));

// Listen to states
BlocBuilder<AuthBloc, AuthBlocState>(
  builder: (context, state) {
    if (state is AuthLoading) return CircularProgressIndicator();
    if (state is AuthAuthenticated) return HomePage();
    return LoginPage();
  },
)
```

### 2. Provider Implementation

**Entry Point**: `lib/main_provider.dart`

**Key Files**:
- `lib/features/auth/presentation/providers/auth_provider.dart`
- `lib/features/auth/presentation/pages/login_page_provider.dart`
- `lib/features/auth/presentation/pages/signup_page_provider.dart`

**Characteristics**:
- Simple, direct method calls
- Less boilerplate
- Easy to understand
- Good for medium complexity

**Usage**:
```dart
// Call methods directly
await context.read<AuthProvider>().login(email, password);

// Listen to state
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    if (authProvider.isLoading) return CircularProgressIndicator();
    return HomePage();
  },
)
```

### 3. Riverpod Implementation

**Entry Point**: `lib/main_riverpod.dart`

**Key Files**:
- `lib/features/auth/presentation/providers/auth_provider_riverpod.dart`
- `lib/features/auth/presentation/pages/login_page_riverpod.dart`
- `lib/features/auth/presentation/pages/signup_page_riverpod.dart`

**Characteristics**:
- Compile-time safe
- Automatic rebuild optimization
- Built-in dependency injection
- Modern, recommended approach

**Usage**:
```dart
// In ConsumerWidget
class LoginPage extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authIsLoadingProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);
    
    await authNotifier.login(email, password);
  }
}
```

## 📖 Documentation

- **[PROVIDER_VS_BLOC.md](./PROVIDER_VS_BLOC.md)** - Detailed comparison between Provider and BLoC
- **[RIVERPOD_VS_BLOC_PROVIDER.md](./RIVERPOD_VS_BLOC_PROVIDER.md)** - Complete comparison of all three approaches
- **[HOW_TO_TEST_PROVIDER.md](./HOW_TO_TEST_PROVIDER.md)** - Guide to test Provider implementation
- **[HOW_TO_TEST_RIVERPOD.md](./HOW_TO_TEST_RIVERPOD.md)** - Guide to test Riverpod implementation
- **[CI_CD_GUIDE.md](./CI_CD_GUIDE.md)** - Comprehensive CI/CD pipeline documentation
- **[CI_CD_EXPLAINED.md](./CI_CD_EXPLAINED.md)** - Visual guide to CI/CD concepts
- **[SETUP_CI_CD.md](./SETUP_CI_CD.md)** - Quick setup guide for CI/CD

## 🏗️ Architecture

### Clean Architecture Layers

1. **Domain Layer** (Business Logic)
   - Entities: Pure business objects
   - Repository Contracts: Interfaces defining data operations
   - Use Cases: Business logic operations (optional)

2. **Data Layer** (Implementation)
   - DTOs: Data Transfer Objects for API responses
   - Mappers: Convert DTOs to Domain Entities
   - Repository Implementations: Concrete implementations of contracts
   - Data Sources: API, Local Storage

3. **Presentation Layer** (UI)
   - BLoC/Provider/Riverpod: State management
   - Pages: UI screens
   - Widgets: Reusable UI components

### SOLID Principles Applied

- **Single Responsibility**: Each class has one reason to change
- **Open/Closed**: Open for extension, closed for modification
- **Liskov Substitution**: Repository implementations are interchangeable
- **Interface Segregation**: Small, focused interfaces
- **Dependency Inversion**: Depend on abstractions, not concretions

## 🔄 Data Flow

```
UI (Presentation Layer)
    ↓
BLoC/Provider/Riverpod (State Management)
    ↓
Repository Interface (Domain Layer)
    ↓
Repository Implementation (Data Layer)
    ↓
API Service / Secure Storage
    ↓
Backend API / Local Storage
```

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Run Specific Test
```bash
flutter test test/features/auth/presentation/bloc/auth_bloc_test.dart
```

### Generate Coverage
```bash
flutter test --coverage
```

## 🚀 CI/CD Pipelines

This project includes automated CI/CD pipelines using GitHub Actions:

### CI Pipeline (`.github/workflows/ci.yml`)
- ✅ Code quality checks (lint, format)
- ✅ Unit and widget tests
- ✅ Build Android APK
- ✅ Build iOS app
- ✅ Build Web app
- ✅ Upload build artifacts

### CD Pipeline (`.github/workflows/cd.yml`)
- 🚀 Deploy to staging (automatic on main branch)
- 🚀 Deploy to production (on version tags)
- 🚀 Create GitHub releases

### Quick Check (`.github/workflows/quick-check.yml`)
- ⚡ Fast validation for pull requests
- ⚡ Quick feedback without full builds

**View pipelines**: Go to GitHub → Actions tab

## 🔐 Environment Configuration

### Required Environment Variables

Create a `.env` file in the root directory:

```env
API_BASE_URL=http://your-api-url.com/api
```

**Important**: Never commit `.env` files to Git! The `.env.example` file shows the required format.

## 📦 Dependencies

### State Management
- `bloc` & `flutter_bloc` - BLoC pattern
- `provider` - Provider pattern
- `flutter_riverpod` - Riverpod pattern

### Core
- `get_it` - Dependency injection
- `go_router` - Declarative routing
- `flutter_secure_storage` - Secure local storage
- `http` - HTTP requests
- `equatable` - Value equality

See `pubspec.yaml` for complete list.

## 🎓 Learning Resources

### State Management
- [BLoC Documentation](https://bloclibrary.dev/)
- [Provider Documentation](https://pub.dev/packages/provider)
- [Riverpod Documentation](https://riverpod.dev/)

### Architecture
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)

### CI/CD
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter CI/CD Guide](https://docs.flutter.dev/deployment/cd)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- BLoC, Provider, and Riverpod maintainers
- Clean Architecture by Robert C. Martin

## 📧 Contact

For questions or suggestions, please open an issue on GitHub.

---

**Happy Coding! 🚀**

*This project is designed for learning and demonstration purposes. Feel free to use it as a reference for your own projects.*
