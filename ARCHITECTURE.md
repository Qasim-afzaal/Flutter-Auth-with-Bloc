# Flutter Authentication Bloc - Architecture

This project follows Clean Architecture principles with BLoC pattern for state management.

## 📁 Folder Structure

```
lib/
├── core/                           # Core functionality shared across the app
│   ├── constants/                  # App-wide constants
│   │   └── app_constants.dart     # API URLs, timeouts, storage keys
│   ├── errors/                     # Error handling
│   │   └── failures.dart          # Custom failure classes
│   ├── network/                    # Network layer
│   │   └── api_client.dart        # HTTP client wrapper
│   └── utils/                      # Utility functions
│
├── features/                       # Feature-based modules
│   └── auth/                       # Authentication feature
│       ├── data/                   # Data layer (external concerns)
│       │   ├── datasources/        # Data sources (API, local storage)
│       │   ├── models/             # Data models (JSON serialization)
│       │   └── repositories/       # Repository implementations
│       │       └── auth_repository_impl.dart
│       ├── domain/                 # Domain layer (business logic)
│       │   ├── entities/           # Business entities
│       │   │   ├── user.dart
│       │   │   └── auth_state.dart
│       │   ├── repositories/       # Repository interfaces
│       │   │   └── auth_repository.dart
│       │   └── usecases/           # Use cases (business logic)
│       └── presentation/           # Presentation layer (UI)
│           ├── bloc/               # BLoC files
│           │   └── auth_bloc.dart
│           ├── pages/              # Screen/Page widgets
│           └── widgets/            # Feature-specific widgets
│
├── shared/                         # Shared across features
│   ├── widgets/                    # Reusable UI components
│   ├── utils/                      # Shared utility functions
│   └── constants/                  # Shared constants
│
├── injection/                      # Dependency injection
│   └── injection_container.dart   # Service locator setup
│
└── main.dart                       # App entry point
```

## 🏗️ Architecture Layers

### 1. **Core Layer**
- **Constants**: App-wide configuration
- **Errors**: Centralized error handling
- **Network**: HTTP client and network utilities
- **Utils**: Shared utility functions

### 2. **Features Layer** (Feature-based modules)
Each feature follows Clean Architecture with three layers:

#### **Domain Layer** (Business Logic)
- **Entities**: Core business objects
- **Repositories**: Abstract interfaces for data access
- **Use Cases**: Business logic implementation

#### **Data Layer** (External Concerns)
- **Data Sources**: API calls, local storage
- **Models**: Data transfer objects with JSON serialization
- **Repository Implementations**: Concrete implementations of domain repositories

#### **Presentation Layer** (UI)
- **BLoC**: State management and business logic coordination
- **Pages**: Screen widgets
- **Widgets**: Feature-specific UI components

### 3. **Shared Layer**
- Reusable components and utilities across features

### 4. **Injection Layer**
- Dependency injection setup using GetIt

## 🔄 Data Flow

1. **UI** triggers an event in **BLoC**
2. **BLoC** calls **Use Case** (if needed)
3. **Use Case** calls **Repository** interface
4. **Repository Implementation** calls **Data Source**
5. **Data Source** makes API call or accesses local storage
6. Data flows back through the layers to **UI**

## 📦 Dependencies

- **flutter_bloc**: State management
- **equatable**: Value equality for states and events
- **http**: HTTP client for API calls
- **get_it**: Dependency injection

## 🚀 Getting Started

1. Initialize dependency injection in `main.dart`:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init(); // Initialize dependency injection
  runApp(MyApp());
}
```

2. Use BLoC in your widgets:
```dart
BlocProvider(
  create: (context) => sl<AuthBloc>(),
  child: YourWidget(),
)
```

## 📝 Best Practices

1. **Separation of Concerns**: Each layer has a single responsibility
2. **Dependency Inversion**: High-level modules don't depend on low-level modules
3. **Single Source of Truth**: BLoC manages state centrally
4. **Testability**: Each layer can be tested independently
5. **Scalability**: Easy to add new features following the same pattern
