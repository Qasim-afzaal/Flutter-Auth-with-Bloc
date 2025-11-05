# Auth BLoC - Flutter Clean Architecture Demo

A Flutter application demonstrating Clean Architecture principles with BLoC pattern for state management. This project showcases both authentication and counter features built with best practices.

## Features

- **Counter Feature**: Basic counter functionality (increment, decrement, reset)
- **Authentication Feature**: Complete authentication flow (ready for implementation)
- Clean Architecture with separation of concerns
- BLoC pattern for state management
- Dependency injection using GetIt
- Event-driven state management

## Architecture

This project follows **Clean Architecture** principles with **BLoC pattern** for state management. The codebase is organized into feature-based modules, each following a three-layer architecture:

- **Domain Layer**: Business logic, entities, and use cases
- **Data Layer**: Data sources, models, and repository implementations
- **Presentation Layer**: UI, BLoC, pages, and widgets

For detailed architecture documentation, see [ARCHITECTURE.md](./ARCHITECTURE.md).

## Project Structure

```
lib/
├── core/                    # Core functionality (constants, errors, network, utils)
├── features/                # Feature-based modules
│   ├── auth/               # Authentication feature
│   └── counter/            # Counter feature
├── shared/                 # Shared widgets, utils, constants
├── injection/              # Dependency injection setup
└── main.dart              # App entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK

### Installation

1. Clone the repository
   ```bash
   git clone <repository-url>
   cd auth_bloc
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Run the application
   ```bash
   flutter run
   ```

## BLoC Structure

### Counter Feature

- **Events**: `IncreaseNumber`, `DecreaseNumber`, `ResetNumber`
- **States**: `CounterInitial`, `CounterValueChanged`
- **Bloc**: `CounterBloc` - handles all counter logic

### Authentication Feature

- **Events**: Authentication-related events (login, logout, etc.)
- **States**: `AuthState` with various authentication states
- **Bloc**: `AuthBloc` - handles authentication logic

## Dependencies

- **flutter_bloc**: ^8.1.4 - State management
- **bloc**: ^8.1.4 - BLoC core library
- **equatable**: ^2.0.5 - Value equality for states and events
- **http**: ^1.2.0 - HTTP client for API calls
- **get_it**: ^7.6.7 - Dependency injection

## Development

This project serves as a template for building scalable Flutter applications with Clean Architecture and BLoC pattern. Each feature is self-contained and can be easily extended or modified without affecting other parts of the application.

## License

This project is for demonstration purposes.
