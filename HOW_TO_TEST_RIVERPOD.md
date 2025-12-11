# How to Test Riverpod Implementation

Quick guide to test the Riverpod implementation alongside BLoC and Provider.

## 🚀 Quick Start

### Step 1: Install Dependencies
```bash
flutter pub get
```

### Step 2: Run Riverpod Version

**Option 1: Run directly**
```bash
flutter run lib/main_riverpod.dart
```

**Option 2: Change main.dart temporarily**
```dart
// In main.dart, comment out BLoC version and use:
import 'main_riverpod.dart' as riverpod_app;

void main() {
  riverpod_app.main();
}
```

## 📋 What's Different in Riverpod Version?

### 1. **AuthNotifier** (instead of AuthBloc/AuthProvider)
- Location: `lib/features/auth/presentation/providers/auth_provider_riverpod.dart`
- Uses `StateNotifier` instead of `Bloc`/`ChangeNotifier`
- Uses `state = newState` instead of `emit()`/`notifyListeners()`
- Compile-time safe with better performance

### 2. **Login/Signup Pages**
- `login_page_riverpod.dart` - Uses `ConsumerWidget` and `ref.watch()`
- `signup_page_riverpod.dart` - Uses `ConsumerWidget` and `ref.watch()`

### 3. **Router**
- `app_router_riverpod.dart` - Uses `Provider` for router with `ref.read()`

### 4. **Main Entry Point**
- `main_riverpod.dart` - Uses `ProviderScope` instead of `MultiBlocProvider`/`MultiProvider`

## 🔍 Key Differences to Observe

### In UI (Login Page):

**BLoC:**
```dart
BlocBuilder<AuthBloc, AuthBlocState>(
  builder: (context, state) {
    if (state is AuthLoading) { ... }
  },
)
context.read<AuthBloc>().add(LoginRequested(...));
```

**Provider:**
```dart
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    if (authProvider.isLoading) { ... }
  },
)
context.read<AuthProvider>().login(...);
```

**Riverpod:**
```dart
class LoginPage extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authIsLoadingProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);
    await authNotifier.login(...);
  }
}
```

### In State Management:

**BLoC:**
- Events → States
- `emit(newState)`
- Type-safe state classes

**Provider:**
- Direct method calls
- `notifyListeners()`
- Property-based state

**Riverpod:**
- StateNotifier with state class
- `state = newState`
- Compile-time safe ✅
- Automatic rebuild optimization ✅

## ✅ Testing Checklist

- [ ] Login works with Riverpod
- [ ] Signup works with Riverpod
- [ ] Auto-login on app restart works
- [ ] Navigation redirects work
- [ ] Error handling works
- [ ] Loading states work
- [ ] Compare performance with BLoC/Provider

## 🎯 Learning Points

1. **Riverpod is compile-time safe** - Catches errors at compile time
2. **Better performance** - Automatic rebuild optimization
3. **Built-in DI** - No need for GetIt (though we still use it for consistency)
4. **Selective rebuilds** - Watch only what you need
5. **Modern pattern** - Recommended for new Flutter projects

## 📚 Next Steps

1. Compare the code side-by-side with BLoC and Provider
2. Try implementing a new feature with Riverpod
3. See which pattern you prefer for your use case
4. Read `RIVERPOD_VS_BLOC_PROVIDER.md` for detailed comparison

## 🔧 Troubleshooting

### Error: "ProviderScope not found"
- Make sure `flutter_riverpod` is in `pubspec.yaml`
- Run `flutter pub get`

### Error: "ref is not defined"
- Make sure widget extends `ConsumerWidget` or uses `Consumer`
- Use `ref.watch()` to read state
- Use `ref.read()` to call methods

### Router not working
- Make sure `ProviderScope` wraps the app
- Check router provider is watched correctly

---

**Remember**: Riverpod is the modern, recommended approach for Flutter state management! 🚀

