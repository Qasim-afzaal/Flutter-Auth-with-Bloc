# Auth BLoC - Flutter Clean Architecture with BLoC Pattern

A production-ready Flutter application demonstrating **Clean Architecture**, **BLoC Pattern**, **Dependency Injection**, and **GoRouter** for navigation. This project serves as a comprehensive example of how to structure a scalable Flutter application following SOLID principles.

## 📋 Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [How It Works](#how-it-works)
- [Why This Architecture?](#why-this-architecture)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Flow Explanation](#flow-explanation)
- [Key Concepts](#key-concepts)
- [Dependencies](#dependencies)
- [Documentation](#documentation)

## ✨ Features

- ✅ **Authentication Flow**: Complete login/logout with secure storage
- ✅ **BLoC State Management**: Reactive state management with BLoC pattern
- ✅ **GoRouter Navigation**: Declarative routing with route guards
- ✅ **Dependency Injection**: GetIt for managing dependencies
- ✅ **DTO Pattern**: Data Transfer Objects for API response parsing
- ✅ **Secure Storage**: Flutter Secure Storage for sensitive data
- ✅ **Clean Architecture**: Separation of concerns across layers
- ✅ **Error Handling**: Comprehensive error handling with custom failures
- ✅ **Type Safety**: Strong typing throughout the application

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation between layers:

```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                    │
│  (UI, BLoC, Pages, Widgets)                             │
│  - Handles user interaction                             │
│  - Manages UI state                                     │
│  - Dispatches events to BLoC                            │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ Uses
                     ▼
┌─────────────────────────────────────────────────────────┐
│                     DOMAIN LAYER                        │
│  (Entities, Repository Interfaces, Use Cases)          │
│  - Business logic                                       │
│  - Domain entities                                      │
│  - Repository contracts                                 │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ Implemented by
                     ▼
┌─────────────────────────────────────────────────────────┐
│                      DATA LAYER                         │
│  (Repository Implementations, DTOs, Data Sources)      │
│  - API calls                                            │
│  - Data parsing (DTOs)                                  │
│  - Local storage                                        │
└─────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

1. **Presentation Layer**: UI components, BLoC for state management, pages
2. **Domain Layer**: Business logic, entities, repository interfaces
3. **Data Layer**: API calls, DTOs, repository implementations, local storage

## 📁 Project Structure

```
lib/
├── core/                           # Core functionality shared across features
│   ├── config/                     # App configuration (environment variables)
│   │   └── app_config.dart
│   ├── constants/                  # App-wide constants
│   │   └── app_constants.dart
│   ├── errors/                     # Custom error types
│   │   └── failures.dart
│   ├── network/                    # Network layer
│   │   └── api_service.dart       # Generic HTTP client (GET, POST, PUT, DELETE, PATCH)
│   ├── router/                     # Navigation
│   │   └── app_router.dart        # GoRouter configuration
│   ├── storage/                    # Local storage
│   │   └── secure_storage_service.dart
│   └── utils/                      # Utility functions
│       ├── logger.dart
│       ├── validation_utils.dart
│       └── ...
│
├── features/                       # Feature-based modules
│   └── auth/                       # Authentication feature
│       ├── data/                   # Data layer
│       │   ├── models/             # DTOs (Data Transfer Objects)
│       │   │   ├── login_response_dto.dart
│       │   │   └── user_data_dto.dart
│       │   ├── mappers/            # DTO ↔ Entity converters
│       │   │   └── user_mapper.dart
│       │   └── repositories/       # Repository implementations
│       │       └── auth_repository_impl.dart
│       ├── domain/                 # Domain layer
│       │   ├── entities/           # Business entities
│       │   │   └── user.dart
│       │   └── repositories/       # Repository interfaces
│       │       └── auth_repository.dart
│       └── presentation/           # Presentation layer
│           ├── bloc/               # BLoC state management
│           │   ├── auth_bloc.dart
│           │   ├── auth_event.dart
│           │   └── auth_bloc_state.dart
│           └── pages/              # UI pages
│               ├── login_page.dart
│               ├── signup_page.dart
│               └── home_page.dart
│
├── injection/                      # Dependency injection
│   └── injection_container.dart   # GetIt service locator setup
│
└── main.dart                      # App entry point
```

## 🔄 How It Works

### Complete Flow: Login Example

```
1. User Action (UI)
   └─> User enters email/password, taps "Login"
       └─> Dispatches LoginRequested event

2. BLoC (State Management)
   └─> Receives LoginRequested event
       └─> Emits AuthLoading state (shows spinner)
       └─> Calls repository.login()

3. Repository (Data Layer)
   └─> Calls apiService.post('/auth/login', {...})
       └─> Receives response
       └─> Parses to LoginResponseDto
       └─> Converts DTO to User entity using mapper
       └─> Saves token and user data to secure storage
       └─> Returns User entity

4. API Service (Network Layer)
   └─> Makes HTTP POST request
       └─> Handles timeout, errors, response parsing
       └─> Returns JSON response

5. Backend API
   └─> Validates credentials
       └─> Returns user data + token

6. Response Flow (Backwards)
   └─> API Service → Repository → BLoC → UI
       └─> BLoC emits AuthAuthenticated state
       └─> UI navigates to /home
```

### State Management Flow

```
AuthInitial
    │
    ├─> AuthCheckRequested
    │   ├─ User found → AuthAuthenticated → Show Home
    │   └─ No user → AuthUnauthenticated → Show Login
    │
    ├─> LoginRequested
    │   ├─> AuthLoading (shows spinner)
    │   ├─ Success → AuthAuthenticated → Navigate to /home
    │   └─ Error → AuthError → Show error message
    │
    └─> LogoutRequested
        └─> AuthUnauthenticated → Navigate to /login
```

## 🤔 Why This Architecture?

### 1. **Clean Architecture**
- **Separation of Concerns**: Each layer has a single responsibility
- **Independence**: Business logic doesn't depend on UI or data sources
- **Testability**: Easy to test each layer independently
- **Maintainability**: Changes in one layer don't affect others

### 2. **BLoC Pattern**
- **Reactive**: UI automatically updates when state changes
- **Predictable**: Unidirectional data flow
- **Testable**: Business logic separated from UI
- **Scalable**: Easy to add new features

### 3. **Dependency Injection (GetIt)**
- **Loose Coupling**: Components don't create their dependencies
- **Testability**: Easy to mock dependencies in tests
- **Flexibility**: Swap implementations without changing code
- **Single Responsibility**: Each component focuses on its job

### 4. **DTO Pattern**
- **Type Safety**: Strong typing for API responses
- **Separation**: API structure separate from business logic
- **Flexibility**: API can change without breaking domain logic
- **Maintainability**: Clear mapping between API and domain

### 5. **GoRouter**
- **Declarative**: Routes defined in one place
- **Type Safe**: Compile-time route checking
- **Route Guards**: Automatic authentication checks
- **Deep Linking**: Easy to handle deep links

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
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
   # API_BASE_URL=http://your-api-url.com/api
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

## ⚙️ Configuration

### Environment Variables

The app uses environment variables for configuration. Never commit sensitive data to git!

1. **Create `.env` file** (copy from `.env.example`):
   ```bash
   cp .env.example .env
   ```

2. **Add your configuration**:
   ```env
   API_BASE_URL=http://your-api-url.com/api
   ```

3. **The `.env` file is gitignored** - it won't be committed to git

### App Configuration

Configuration is loaded from:
- Environment variables (via `--dart-define`)
- Default values (for development)

**File**: `lib/core/config/app_config.dart`

```dart
static const String baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:3005/api',
);
```

**To run with custom URL**:
```bash
flutter run --dart-define=API_BASE_URL=http://your-url.com/api
```

## 📚 Flow Explanation

For detailed flow explanations, see:

- **[FLOW_EXPLANATION.md](./FLOW_EXPLANATION.md)** - Complete flow with code examples
- **[FLOW_DIAGRAM.md](./FLOW_DIAGRAM.md)** - Visual diagrams
- **[DTO_EXPLANATION.md](./DTO_EXPLANATION.md)** - DTO pattern explanation

## 🎯 Key Concepts

### 1. **Unidirectional Data Flow**
```
UI → BLoC → Repository → API Service → Backend
     ↑                                    ↓
     └──────── Response flows back ──────┘
```

### 2. **Dependency Injection Chain**
```
AuthBloc
  ├─ AuthRepository (interface)
  │   └─ AuthRepositoryImpl
  │       ├─ ApiService
  │       └─ SecureStorageService
  └─ SecureStorageService
```

### 3. **DTO to Entity Conversion**
```
API Response (JSON)
    ↓
LoginResponseDto.fromJson()
    ↓
UserDataDto
    ↓
UserMapper.toEntity()
    ↓
User (Domain Entity)
```

### 4. **Error Handling**
- Errors caught at each layer
- Converted to appropriate Failure types
- Propagated to BLoC
- UI displays user-friendly messages

## 📦 Dependencies

### Core Dependencies

- **flutter_bloc**: ^8.1.4 - State management
- **bloc**: ^8.1.4 - BLoC core library
- **equatable**: ^2.0.5 - Value equality for states and events
- **http**: ^1.2.0 - HTTP client for API calls
- **get_it**: ^7.6.7 - Dependency injection
- **go_router**: ^14.2.0 - Declarative routing
- **flutter_secure_storage**: ^9.2.2 - Secure local storage

### Why These Packages?

- **BLoC**: Industry-standard state management for Flutter
- **GetIt**: Lightweight, fast dependency injection
- **GoRouter**: Modern, type-safe routing solution
- **Secure Storage**: Encrypted storage for sensitive data
- **HTTP**: Standard HTTP client (can be replaced with Dio if needed)

## 📖 Documentation

### Architecture Documentation

- **[FLOW_EXPLANATION.md](./FLOW_EXPLANATION.md)** - Detailed flow with examples
- **[FLOW_DIAGRAM.md](./FLOW_DIAGRAM.md)** - Visual flow diagrams
- **[DTO_EXPLANATION.md](./DTO_EXPLANATION.md)** - DTO pattern guide

### Code Documentation

All code is well-documented with:
- Class-level documentation
- Method documentation
- Inline comments for complex logic
- Type annotations

## 🧪 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

### Test Structure

Tests follow the same structure as the app:
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for complete flows

## 🔒 Security

### Secure Storage

- Authentication tokens stored securely
- User data encrypted at rest
- Platform-specific secure storage

### Best Practices

- ✅ Never commit API keys or secrets
- ✅ Use environment variables for configuration
- ✅ Validate all user inputs
- ✅ Handle errors gracefully
- ✅ Use HTTPS in production

## 🛠️ Development

### Adding a New Feature

1. **Create feature folder** in `lib/features/`
2. **Set up layers**:
   - Domain: entities, repository interfaces
   - Data: DTOs, mappers, repository implementations
   - Presentation: BLoC, pages, widgets
3. **Register dependencies** in `injection_container.dart`
4. **Add routes** in `app_router.dart`

### Code Style

- Follow Dart/Flutter style guide
- Use meaningful variable names
- Add documentation for public APIs
- Keep functions small and focused

## 📝 Git Structure

### Branch Strategy

- `main` - Production-ready code
- `develop` - Development branch
- `feature/*` - Feature branches
- `bugfix/*` - Bug fix branches

### Commit Messages

Follow conventional commits:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation
- `refactor:` - Code refactoring
- `test:` - Tests
- `chore:` - Maintenance

### What's NOT in Git

- `.env` files (contains sensitive data)
- Build artifacts
- IDE configuration
- Dependencies cache

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is for educational purposes.

## 🙏 Acknowledgments

- Clean Architecture by Robert C. Martin
- BLoC Pattern by Google
- Flutter Team for the amazing framework

## 📞 Support

For questions or issues:
- Open an issue on GitHub
- Check the documentation files
- Review the code comments

---

**Built with ❤️ using Flutter, Clean Architecture, and BLoC Pattern**
