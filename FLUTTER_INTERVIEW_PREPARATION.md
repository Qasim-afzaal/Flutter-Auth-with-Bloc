# Flutter Interview Preparation Guide

## 📚 Table of Contents

1. [BLoC Pattern Questions](#bloc-pattern-questions)
2. [Clean Architecture Questions](#clean-architecture-questions)
3. [State Management Questions](#state-management-questions)
4. [Mobile Development Questions](#mobile-development-questions)
5. [Architecture Patterns Questions](#architecture-patterns-questions)
6. [Coding Questions](#coding-questions)
7. [Senior Level Questions](#senior-level-questions)

---

## 🎯 BLoC Pattern Questions

### Q1: What is BLoC and why do we use it?

**Answer:**
BLoC (Business Logic Component) is a state management pattern that:
- Separates business logic from UI
- Makes code testable and maintainable
- Provides reactive programming
- Handles complex state management

**Key Concepts:**
- **Event** = User action (what user wants to do)
- **State** = Current app state (what UI should show)
- **Handler** = Processes event and emits state

---

### Q2: What is the difference between BlocBuilder and BlocListener?

**Answer:**

**BlocBuilder:**
- Rebuilds UI when state changes
- Used for displaying data
- Can rebuild multiple times
- Example: Show loading spinner, display user data

```dart
BlocBuilder<AuthBloc, AuthBlocState>(
  builder: (context, state) {
    if (state is AuthLoading) {
      return CircularProgressIndicator();
    }
    return Text('Data');
  },
)
```

**BlocListener:**
- Listens to state changes (side effects)
- Used for navigation, showing snackbars, etc.
- Called only once per state change
- Example: Navigate to home, show error message

```dart
BlocListener<AuthBloc, AuthBlocState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
    }
  },
  child: Widget(),
)
```

**When to use:**
- **BlocBuilder** = UI updates
- **BlocListener** = Side effects (navigation, dialogs)

---

### Q3: What is BlocConsumer and when to use it?

**Answer:**

**BlocConsumer** = BlocBuilder + BlocListener combined

```dart
BlocConsumer<AuthBloc, AuthBlocState>(
  listener: (context, state) {
    // Side effects (navigation, snackbars)
    if (state is AuthAuthenticated) {
      Navigator.push(...);
    }
  },
  builder: (context, state) {
    // UI updates
    if (state is AuthLoading) {
      return CircularProgressIndicator();
    }
    return Widget();
  },
)
```

**When to use:**
- Need both listener and builder
- Reduces widget nesting
- More efficient than separate BlocListener + BlocBuilder

---

### Q4: What is context.read() vs context.watch()?

**Answer:**

**context.read():**
- Gets BLoC instance without listening
- Use for dispatching events
- Doesn't rebuild when state changes
- Example: `context.read<AuthBloc>().add(LoginRequested())`

```dart
ElevatedButton(
  onPressed: () {
    context.read<AuthBloc>().add(LoginRequested()); // Dispatch event
  },
)
```

**context.watch():**
- Gets BLoC and listens to changes
- Rebuilds when state changes
- Use for reading state
- Example: `context.watch<AuthBloc>().state`

```dart
final state = context.watch<AuthBloc>().state; // Rebuilds on state change
```

**Best Practice:**
- Use `read()` for events (one-time actions)
- Use `watch()` for state (reactive updates)

---

### Q5: What is emit() and how does it work?

**Answer:**

**emit()** = Emits a new state, triggering UI rebuilds

```dart
Future<void> _onLoginRequested(
  LoginRequested event,
  Emitter<AuthBlocState> emit,
) async {
  emit(AuthLoading()); // Emit loading state → UI shows spinner
  
  try {
    final user = await _repository.login(...);
    emit(AuthAuthenticated(user)); // Emit success → UI shows home
  } catch (e) {
    emit(AuthError(e.toString())); // Emit error → UI shows error
  }
}
```

**How it works:**
1. `emit()` is called with new state
2. BLoC updates internal state
3. All BlocBuilder/BlocListener widgets are notified
4. UI rebuilds with new state

**Important:**
- Can only emit one state at a time
- Must use `emit()` in handlers
- Triggers rebuilds automatically

---

### Q6: What is the difference between BlocProvider and MultiBlocProvider?

**Answer:**

**BlocProvider:**
- Provides single BLoC to widget tree
- Children can access via `context.read<Bloc>()`

```dart
BlocProvider(
  create: (context) => AuthBloc(),
  child: MyWidget(),
)
```

**MultiBlocProvider:**
- Provides multiple BLoCs
- Reduces nesting

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => AuthBloc()),
    BlocProvider(create: (_) => ThemeBloc()),
  ],
  child: MyWidget(),
)
```

---

### Q7: What is BlocProvider.value and when to use it?

**Answer:**

**BlocProvider.value:**
- Provides existing BLoC instance
- Doesn't create new instance
- Use when BLoC is already created (singleton)

```dart
// BLoC created elsewhere (singleton)
final authBloc = di.sl<AuthBloc>();

BlocProvider.value(
  value: authBloc, // Use existing instance
  child: MyWidget(),
)
```

**vs BlocProvider:**
- `BlocProvider` = Creates new instance
- `BlocProvider.value` = Uses existing instance

---

### Q8: How do you handle errors in BLoC?

**Answer:**

**Error States:**
```dart
class AuthError extends AuthBlocState {
  final String message;
  AuthError(this.message);
}
```

**Error Handling:**
```dart
try {
  final user = await _repository.login(...);
  emit(AuthAuthenticated(user));
} on NetworkFailure catch (e) {
  emit(AuthError('Network error: ${e.message}'));
} on AuthFailure catch (e) {
  emit(AuthError('Auth failed: ${e.message}'));
} catch (e) {
  emit(AuthError('Unexpected error: $e'));
}
```

**Display Errors:**
```dart
BlocListener<AuthBloc, AuthBlocState>(
  listener: (context, state) {
    if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
)
```

---

### Q9: What is the difference between Equatable and why use it?

**Answer:**

**Equatable:**
- Compares objects by value, not reference
- Prevents unnecessary rebuilds
- Must override `props` getter

```dart
class AuthState extends Equatable {
  final User user;
  
  @override
  List<Object?> get props => [user]; // Compare by user
}

// Without Equatable:
state1 == state2 // false (different references)

// With Equatable:
state1 == state2 // true (same user value)
```

**Why use it:**
- BLoC only rebuilds when state actually changes
- Prevents unnecessary UI rebuilds
- Better performance

---

### Q10: How do you test BLoC?

**Answer:**

**Unit Testing:**
```dart
test('emits AuthAuthenticated when login succeeds', () async {
  // Arrange
  final mockRepository = MockAuthRepository();
  when(mockRepository.login(...)).thenAnswer((_) async => User(...));
  final bloc = AuthBloc(mockRepository);

  // Act
  bloc.add(LoginRequested(email: 'test@test.com', password: 'password'));

  // Assert
  expect(bloc.stream, emitsInOrder([
    AuthLoading(),
    AuthAuthenticated(user),
  ]));
});
```

**Key Testing Concepts:**
- Mock repositories
- Test event handlers
- Verify state emissions
- Test error cases

---

## 🏛️ Clean Architecture Questions

### Q11: What is Clean Architecture?

**Answer:**

Clean Architecture is a way to organize code in layers:

**Layers:**
1. **Domain Layer** (Inner) - Business logic, entities, contracts
2. **Data Layer** (Middle) - API, database, implementations
3. **Presentation Layer** (Outer) - UI, BLoC, widgets

**Dependency Rule:**
- Inner layers don't depend on outer layers
- Outer layers depend on inner layers
- Domain layer is independent

**Benefits:**
- Testable
- Maintainable
- Flexible
- Scalable

---

### Q12: What is the difference between Entity, DTO, and Model?

**Answer:**

**Entity (Domain Layer):**
- Business logic representation
- Pure Dart classes
- No dependencies
- Example: `User` entity

```dart
class User {
  final String id;
  final String email;
  final DateTime createdAt; // Proper types
}
```

**DTO (Data Layer):**
- Matches API structure exactly
- All nullable
- Example: `UserDataDto`

```dart
class UserDataDto {
  String? id;
  String? email;
  String? createdAt; // String from API
}
```

**Model:**
- Can be Entity or DTO
- General term for data structure

**Why separate:**
- API changes don't break business logic
- Domain layer independent of API
- Clear separation of concerns

---

### Q13: What is Repository Pattern?

**Answer:**

**Repository Pattern** = Contract (interface) + Implementation

**Contract (Domain):**
```dart
abstract class AuthRepository {
  Future<User> login(String email, String password);
}
```

**Implementation (Data):**
```dart
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<User> login(...) {
    // Actual implementation
  }
}
```

**Benefits:**
- Business logic depends on contract, not implementation
- Can swap implementations (API, mock, local)
- Easy to test
- Follows Dependency Inversion Principle

---

### Q14: What is the difference between Use Case and Repository?

**Answer:**

**Repository:**
- Data access layer
- Gets/saves data
- Example: `getUser()`, `saveUser()`

**Use Case:**
- Business logic layer
- Contains business rules
- Uses repository to get data
- Example: `LoginUseCase` (validates, then calls repository)

```dart
class LoginUseCase {
  final AuthRepository _repository;
  
  Future<User> call(String email, String password) {
    // Business Rule 1: Validate email
    if (!isValidEmail(email)) throw ValidationFailure();
    
    // Business Rule 2: Validate password
    if (password.length < 8) throw ValidationFailure();
    
    // Business Rule 3: Execute login
    return _repository.login(email, password);
  }
}
```

**Difference:**
- **Repository** = How to get data
- **Use Case** = What to do with data (business rules)

---

### Q15: What is Dependency Injection and why use it?

**Answer:**

**Dependency Injection (DI)** = Providing dependencies from outside

**Without DI (Bad):**
```dart
class AuthBloc {
  final repository = AuthRepositoryImpl(); // Hard-coded dependency
}
```

**With DI (Good):**
```dart
class AuthBloc {
  final AuthRepository _repository; // Depends on interface
  AuthBloc(this._repository); // Injected from outside
}
```

**Benefits:**
- Testable (can inject mocks)
- Flexible (can swap implementations)
- Follows SOLID principles
- Loose coupling

**DI Patterns:**
- Constructor injection (recommended)
- GetIt service locator
- Provider

---

## 🔄 State Management Questions

### Q16: What is the difference between BLoC, Provider, and GetX?

**Answer:**

**BLoC:**
- Complex state management
- Event-driven
- Good for business logic
- Example: Authentication, shopping cart

**Provider:**
- Simple state management
- Direct method calls
- Good for simple state
- Example: Theme, settings

**GetX:**
- All-in-one solution
- State management + routing + DI
- Less boilerplate
- Example: Quick prototypes

**When to use:**
- **BLoC** = Complex features (Auth, E-commerce)
- **Provider** = Simple features (Theme, Settings)
- **GetX** = Small projects, rapid development

---

### Q17: What is ChangeNotifier and how does it work?

**Answer:**

**ChangeNotifier:**
- Notifies listeners when state changes
- Built-in Flutter class
- Used by Provider

```dart
class ThemeService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  
  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners(); // Notifies all listeners
  }
}
```

**How it works:**
1. Extend `ChangeNotifier`
2. Call `notifyListeners()` when state changes
3. Provider detects change
4. Consumer widgets rebuild

---

### Q18: What is the difference between Consumer and Provider.of?

**Answer:**

**Consumer:**
- Rebuilds when value changes
- More efficient (only rebuilds specific widget)
- Example: `Consumer<ThemeService>`

```dart
Consumer<ThemeService>(
  builder: (context, themeService, child) {
    return Text(themeService.themeMode.name);
  },
)
```

**Provider.of:**
- Gets value without listening
- Doesn't rebuild
- Example: `Provider.of<ThemeService>(context, listen: false)`

```dart
final themeService = Provider.of<ThemeService>(context, listen: false);
themeService.setTheme(ThemeMode.dark); // No rebuild
```

**When to use:**
- **Consumer** = Need to rebuild on changes
- **Provider.of** = Just need value, no rebuild

---

## 📱 Mobile Development Questions

### Q19: What is Decoupling and why is it important?

**Answer:**

**Decoupling** = Reducing dependencies between components

**Coupled (Bad):**
```dart
class LoginPage {
  final api = ApiService(); // Direct dependency
  final storage = SecureStorage(); // Direct dependency
}
```

**Decoupled (Good):**
```dart
class LoginPage {
  final AuthBloc _bloc; // Depends on interface
  LoginPage(this._bloc); // Injected
}
```

**Benefits:**
- Easy to test
- Easy to maintain
- Easy to change
- Follows SOLID principles

---

### Q20: What is Debouncing and when to use it?

**Answer:**

**Debouncing** = Delaying execution until user stops action

**Example: Search:**
```dart
Timer? _debounceTimer;

void _onSearchChanged(String query) {
  _debounceTimer?.cancel();
  _debounceTimer = Timer(Duration(milliseconds: 500), () {
    // Execute search after 500ms of no typing
    _performSearch(query);
  });
}
```

**When to use:**
- Search input (wait for user to stop typing)
- API calls (prevent multiple calls)
- Button clicks (prevent double clicks)

**Benefits:**
- Reduces API calls
- Better performance
- Better UX

---

### Q21: What is the difference between StatelessWidget and StatefulWidget?

**Answer:**

**StatelessWidget:**
- Immutable
- No internal state
- Builds once
- Example: Display static data

**StatefulWidget:**
- Mutable
- Has internal state
- Can rebuild
- Example: Form inputs, animations

**When to use:**
- **StatelessWidget** = No state needed
- **StatefulWidget** = Need state (controllers, toggles)

---

### Q22: What is BuildContext and why is it important?

**Answer:**

**BuildContext:**
- Location in widget tree
- Provides access to:
  - Theme
  - MediaQuery
  - InheritedWidgets
  - Navigation

**Uses:**
```dart
// Get theme
Theme.of(context).colorScheme

// Get screen size
MediaQuery.of(context).size

// Navigate
Navigator.of(context).push(...)

// Get BLoC
context.read<AuthBloc>()
```

**Important:**
- Don't store BuildContext
- Use it immediately
- Can become invalid after async operations

---

## 🏗️ Architecture Patterns Questions

### Q23: What is MVC, MVVM, and Clean Architecture?

**Answer:**

**MVC (Model-View-Controller):**
- Model = Data
- View = UI
- Controller = Logic
- Controller updates Model, View observes Model

**MVVM (Model-View-ViewModel):**
- Model = Data
- View = UI
- ViewModel = State management
- View binds to ViewModel

**Clean Architecture:**
- Domain = Business logic
- Data = External data sources
- Presentation = UI
- Clear layer separation

**Comparison:**
- **MVC** = Simple, good for small apps
- **MVVM** = Good for complex UI
- **Clean Architecture** = Best for large, maintainable apps

---

### Q24: What is SOLID and how do you apply it in Flutter?

**Answer:**

**SOLID Principles:**

**S - Single Responsibility:**
- One class = One responsibility
- Example: `ApiService` only handles HTTP

**O - Open/Closed:**
- Open for extension, closed for modification
- Example: Repository interface

**L - Liskov Substitution:**
- Subtypes must be substitutable
- Example: Mock repository can replace real repository

**I - Interface Segregation:**
- Small, focused interfaces
- Example: `AuthRepository` only has auth methods

**D - Dependency Inversion:**
- Depend on abstractions, not concretions
- Example: BLoC depends on `AuthRepository` interface

---

## 💻 Coding Questions

### Q25: How do you handle async operations in Flutter?

**Answer:**

**Future/Async-Await:**
```dart
Future<User> login() async {
  final response = await _apiService.post(...);
  return User.fromJson(response);
}
```

**Stream:**
```dart
Stream<int> countStream() async* {
  for (int i = 0; i < 10; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}
```

**BLoC:**
```dart
Future<void> _onLoginRequested(...) async {
  emit(AuthLoading());
  final user = await _repository.login(...);
  emit(AuthAuthenticated(user));
}
```

---

### Q26: How do you optimize Flutter app performance?

**Answer:**

**Performance Tips:**
1. Use `const` constructors
2. Avoid unnecessary rebuilds
3. Use `ListView.builder` for long lists
4. Image optimization
5. Lazy loading
6. Debouncing
7. Use `RepaintBoundary`
8. Profile with DevTools

---

### Q27: How do you handle navigation in Flutter?

**Answer:**

**Navigator 1.0:**
```dart
Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
Navigator.pop(context);
```

**GoRouter (Declarative):**
```dart
context.go('/home');
context.push('/details');
```

**Named Routes:**
```dart
Navigator.pushNamed(context, '/home');
```

**Best Practice:**
- Use GoRouter for complex navigation
- Use Navigator for simple navigation

---

## 🎓 Senior Level Questions

### Q28: How do you structure a large Flutter project?

**Answer:**

**Feature-Based Structure:**
```
lib/
├── core/           # Shared utilities
├── features/        # Feature modules
│   ├── auth/
│   ├── profile/
│   └── settings/
└── shared/         # Shared components
```

**Clean Architecture:**
- Domain layer (business logic)
- Data layer (API, storage)
- Presentation layer (UI)

**Best Practices:**
- Feature-based organization
- Clear layer separation
- Dependency injection
- SOLID principles

---

### Q29: How do you handle app state persistence?

**Answer:**

**Options:**
1. **SharedPreferences** - Simple key-value
2. **SecureStorage** - Sensitive data (tokens)
3. **Hive/SQLite** - Complex data
4. **Firebase** - Cloud storage

**Example:**
```dart
// Save
await _storage.saveToken(token);

// Load
final token = await _storage.getToken();
```

---

### Q30: How do you handle offline-first architecture?

**Answer:**

**Strategy:**
1. Cache data locally
2. Sync when online
3. Show cached data when offline
4. Queue operations when offline

**Tools:**
- Hive for local storage
- Connectivity package
- Background sync

---

## 📋 Quick Reference

### BLoC Concepts:
- **Event** = User action
- **State** = App state
- **emit()** = Emit new state
- **BlocBuilder** = Rebuild UI
- **BlocListener** = Side effects
- **context.read()** = Get BLoC (no rebuild)
- **context.watch()** = Get BLoC (rebuilds)

### Architecture:
- **Entity** = Business logic
- **DTO** = API structure
- **Repository** = Data access
- **Use Case** = Business rules

### State Management:
- **BLoC** = Complex state
- **Provider** = Simple state
- **GetX** = All-in-one

---

## 🎯 Interview Tips

1. **Explain your thinking** - Don't just code, explain why
2. **Ask questions** - Clarify requirements
3. **Think out loud** - Show your problem-solving process
4. **Start simple** - Build up complexity
5. **Test your code** - Show you think about edge cases
6. **Know the trade-offs** - Every solution has pros/cons

---

## 📚 Study Resources

1. **BLoC Documentation** - https://bloclibrary.dev
2. **Clean Architecture** - Robert C. Martin's book
3. **Flutter Documentation** - https://flutter.dev
4. **Your Project** - Review your own code!

---

Good luck with your interview! 🎉

