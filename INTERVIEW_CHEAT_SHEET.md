# Flutter Interview Cheat Sheet - Quick Reference

## 🎯 BLoC Quick Reference

### Key Concepts:
```
Event → Handler → State → UI Rebuild
```

### Widgets:
- **BlocBuilder** = Rebuilds UI on state change
- **BlocListener** = Side effects (navigation, snackbars)
- **BlocConsumer** = BlocBuilder + BlocListener
- **BlocProvider** = Provides BLoC to widget tree

### Methods:
- **emit()** = Emits new state
- **context.read()** = Get BLoC (no rebuild) - for events
- **context.watch()** = Get BLoC (rebuilds) - for state

### Example:
```dart
// Dispatch event
context.read<AuthBloc>().add(LoginRequested());

// Listen to state
BlocBuilder<AuthBloc, AuthBlocState>(
  builder: (context, state) {
    if (state is AuthLoading) return CircularProgressIndicator();
    if (state is AuthAuthenticated) return HomePage();
    return LoginPage();
  },
)
```

---

## 🏛️ Clean Architecture Quick Reference

### Layers:
```
Presentation (UI, BLoC)
    ↓ depends on
Domain (Entities, Contracts)
    ↓ implemented by
Data (DTOs, Implementations)
```

### Key Terms:
- **Entity** = Business logic (Domain)
- **DTO** = API structure (Data)
- **Repository** = Contract (Domain) + Implementation (Data)
- **Use Case** = Business rules (Domain)

### Dependency Rule:
- Inner layers (Domain) don't depend on outer layers
- Outer layers depend on inner layers

---

## 🔄 State Management Comparison

| Feature | BLoC | Provider | GetX |
|---------|------|----------|------|
| **Complexity** | High | Medium | Low |
| **Best For** | Complex state | Simple state | Quick dev |
| **Pattern** | Event-driven | Direct calls | Reactive |
| **Learning Curve** | Steep | Medium | Easy |

---

## 📱 Mobile Dev Concepts

### Decoupling:
- Reduce dependencies between components
- Use interfaces/contracts
- Dependency injection

### Debouncing:
- Delay execution until user stops action
- Use Timer for delays
- Example: Search input

### StatefulWidget vs StatelessWidget:
- **StatelessWidget** = No state, immutable
- **StatefulWidget** = Has state, mutable

---

## 🎓 SOLID Principles

- **S** - Single Responsibility (one class, one job)
- **O** - Open/Closed (extend, don't modify)
- **L** - Liskov Substitution (subtypes replaceable)
- **I** - Interface Segregation (small interfaces)
- **D** - Dependency Inversion (depend on abstractions)

---

## 💻 Common Patterns

### Repository Pattern:
```dart
// Contract
abstract class Repository {
  Future<Data> getData();
}

// Implementation
class RepositoryImpl implements Repository {
  @override
  Future<Data> getData() { ... }
}
```

### Dependency Injection:
```dart
// Register
sl.registerLazySingleton<Repository>(() => RepositoryImpl());

// Use
final repo = sl<Repository>();
```

---

## 🎯 Interview Tips

1. **Explain your thinking** - Don't just code
2. **Ask questions** - Clarify requirements
3. **Start simple** - Build incrementally
4. **Handle errors** - Show edge case thinking
5. **Write tests** - Show you think about quality

---

## 📚 Key Files to Review

1. `FLUTTER_INTERVIEW_PREPARATION.md` - Full questions and answers
2. `CODING_INTERVIEW_QUESTIONS.md` - Coding challenges
3. Your project code - Real examples!

---

Good luck! 🚀

