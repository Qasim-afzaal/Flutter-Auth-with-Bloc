# Provider vs BLoC - Learning Guide

This document explains the differences between Provider and BLoC implementations in this project.

## 📁 File Structure

### BLoC Implementation (Current)
```
lib/
├── features/auth/presentation/
│   ├── bloc/
│   │   ├── auth_bloc.dart          # State management
│   │   ├── auth_event.dart          # Events
│   │   └── auth_bloc_state.dart     # States
│   └── pages/
│       ├── login_page.dart          # Uses BlocBuilder/BlocListener
│       └── signup_page.dart
└── main.dart                        # Uses MultiBlocProvider
```

### Provider Implementation (New)
```
lib/
├── features/auth/presentation/
│   ├── providers/
│   │   └── auth_provider.dart       # ChangeNotifier (state management)
│   └── pages/
│       ├── login_page_provider.dart # Uses Consumer/Selector
│       └── signup_page_provider.dart
└── main_provider.dart               # Uses MultiProvider
```

## 🔄 Key Differences

### 1. **State Management Pattern**

#### BLoC
```dart
// BLoC uses Events and States
class AuthBloc extends Bloc<AuthEvent, AuthBlocState> {
  // Handle events, emit states
  on<LoginRequested>(_onLoginRequested);
}

// States are separate classes
class AuthAuthenticated extends AuthBlocState {
  final User user;
}
```

#### Provider
```dart
// Provider uses ChangeNotifier with properties
class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  
  // Direct property access
  User? get user => _user;
  
  // Notify listeners when state changes
  void login() {
    _isLoading = true;
    notifyListeners(); // Like emit() in BLoC
  }
}
```

### 2. **UI Integration**

#### BLoC
```dart
// BlocBuilder for reading state
BlocBuilder<AuthBloc, AuthBlocState>(
  builder: (context, state) {
    if (state is AuthLoading) {
      return CircularProgressIndicator();
    }
    return Text('Loaded');
  },
)

// BlocListener for side effects
BlocListener<AuthBloc, AuthBlocState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      Navigator.push(...);
    }
  },
  child: ...,
)

// Dispatching events
context.read<AuthBloc>().add(LoginRequested(email, password));
```

#### Provider
```dart
// Consumer for reading state
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    if (authProvider.isLoading) {
      return CircularProgressIndicator();
    }
    return Text('Loaded');
  },
)

// Direct method calls (no events)
context.read<AuthProvider>().login(email, password);

// Selector for specific properties (optimization)
Selector<AuthProvider, bool>(
  selector: (_, provider) => provider.isLoading,
  builder: (context, isLoading, child) {
    return isLoading ? CircularProgressIndicator() : Text('Loaded');
  },
)
```

### 3. **Setup in main.dart**

#### BLoC
```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => di.sl<AuthBloc>()),
  ],
  child: MaterialApp.router(...),
)
```

#### Provider
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>()),
  ],
  child: MaterialApp.router(...),
)
```

## 📊 Comparison Table

| Feature | BLoC | Provider |
|---------|------|----------|
| **Pattern** | Event-driven | Property-based |
| **State Classes** | Separate state classes | Properties in provider |
| **State Changes** | `emit(newState)` | `notifyListeners()` |
| **UI Reading** | `BlocBuilder` | `Consumer` / `Selector` |
| **Side Effects** | `BlocListener` | Direct in methods |
| Side Effects | Separate listener | Direct in methods |
| **Dispatching** | `context.read<Bloc>().add(Event)` | `context.read<Provider>().method()` |
| **Learning Curve** | Steeper (Events/States) | Easier (Direct methods) |
| **Boilerplate** | More (Events, States) | Less (Just methods) |
| **Type Safety** | Strong (State classes) | Moderate (Properties) |
| **Testing** | Test events/states | Test methods directly |
| **Best For** | Complex state machines | Simple to medium complexity |

## 🎯 When to Use Which?

### Use BLoC when:
- ✅ Complex state machines with many states
- ✅ Need strict separation of events and states
- ✅ Team prefers event-driven architecture
- ✅ Need to track state history/debugging
- ✅ Multiple features with complex interactions

### Use Provider when:
- ✅ Simple to medium complexity state
- ✅ Direct method calls are preferred
- ✅ Less boilerplate needed
- ✅ Team is more familiar with OOP patterns
- ✅ Quick prototyping

## 🔍 Code Examples

### Login Flow Comparison

#### BLoC
```dart
// 1. Define Event
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
}

// 2. Handle in BLoC
on<LoginRequested>(_onLoginRequested);

// 3. Emit States
emit(AuthLoading());
emit(AuthAuthenticated(user));

// 4. UI dispatches event
context.read<AuthBloc>().add(LoginRequested(email, password));
```

#### Provider
```dart
// 1. Direct method in Provider
Future<bool> login(String email, String password) async {
  _isLoading = true;
  notifyListeners();
  
  // ... logic ...
  
  _isLoading = false;
  notifyListeners();
}

// 2. UI calls method directly
await context.read<AuthProvider>().login(email, password);
```

## 🚀 Running Provider Version

To test the Provider implementation:

1. **Option 1: Create separate entry point**
   ```dart
   // In main_provider.dart
   void main() {
     runApp(MyAppProvider());
   }
   ```

2. **Option 2: Switch in main.dart**
   ```dart
   // Comment out BLoC setup, use Provider setup
   ```

## 📝 Notes

- Both implementations use the **same repository layer** (Clean Architecture)
- Both follow **SOLID principles**
- Both support **dependency injection**
- Provider is **simpler** but BLoC is **more structured**
- You can use **both** in the same app for different features!

## 🎓 Learning Path

1. **Start with Provider** - Easier to understand
2. **Learn BLoC** - More structured, better for complex apps
3. **Choose based on project needs** - Both are valid!

---

**Remember**: The best state management is the one your team understands and can maintain! 🚀

