# Auto-Login on App Restart - How It Works

## 🎯 What You Want to Understand

**When you:**
1. Login successfully
2. Kill the app
3. Open app again

**The app should:**
- Check if you're logged in
- Automatically show home page (skip login)

## 🔍 Where This Logic Lives

### 1. App Startup (main.dart)

**File:** `lib/main.dart`

**What happens:**
```dart
BlocProvider(
  create: (context) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
  //                                    ↑ This triggers auth check!
)
```

**When:** App starts → Immediately checks if user is logged in

---

### 2. Auth Check Event

**File:** `lib/features/auth/presentation/bloc/auth_event.dart`

```dart
class AuthCheckRequested extends AuthEvent {}
```

**What it is:** Event that says "Check if user is logged in"

---

### 3. Auth Check Handler (BLoC)

**File:** `lib/features/auth/presentation/bloc/auth_bloc.dart`

**Method:** `_onAuthCheckRequested`

**What it does:**
1. Checks secure storage for login status
2. Gets user data if logged in
3. Emits `AuthAuthenticated` if user found
4. Emits `AuthUnauthenticated` if no user

---

### 4. Router Redirect Logic

**File:** `lib/core/router/app_router.dart`

**What it does:**
- Checks AuthBloc state
- Redirects to `/home` if authenticated
- Redirects to `/login` if not authenticated

---

## 🔄 Complete Flow

### Step-by-Step Process:

```
┌─────────────────────────────────────────────────────────┐
│              APP STARTS (main.dart)                     │
│  runApp(MyApp())                                        │
└────────────────────┬────────────────────────────────┘
                     │
                     │ 1. BlocProvider creates AuthBloc
                     ▼
┌─────────────────────────────────────────────────────────┐
│              AUTH CHECK TRIGGERED                       │
│  AuthBloc()..add(AuthCheckRequested())                  │
│  ↑ This immediately dispatches the event                │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 2. Event received
                     ▼
┌─────────────────────────────────────────────────────────┐
│              BLoC HANDLER                               │
│  _onAuthCheckRequested()                                │
│  └─> Checks secure storage                             │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 3. Check storage
                     ▼
┌─────────────────────────────────────────────────────────┐
│              SECURE STORAGE CHECK                       │
│  _secureStorage.isLoggedIn()                           │
│  └─> Returns true if token/user data exists             │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 4. If logged in
                     ▼
┌─────────────────────────────────────────────────────────┐
│              GET USER DATA                              │
│  _secureStorage.getUserData()                          │
│  └─> Gets saved user data                              │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 5. Parse user data
                     ▼
┌─────────────────────────────────────────────────────────┐
│              CREATE USER ENTITY                         │
│  User.fromJson(userData)                                │
│  └─> Converts stored JSON to User entity               │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 6. Emit state
                     ▼
┌─────────────────────────────────────────────────────────┐
│              BLoC EMITS STATE                           │
│  emit(AuthAuthenticated(user))                          │
│  └─> User is authenticated!                            │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 7. Router checks state
                     ▼
┌─────────────────────────────────────────────────────────┐
│              ROUTER REDIRECT                            │
│  GoRouter redirect logic                                │
│  └─> Sees AuthAuthenticated state                      │
│  └─> Redirects to /home                                │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 8. Show home page
                     ▼
┌─────────────────────────────────────────────────────────┐
│              HOME PAGE DISPLAYED                        │
│  User sees home page automatically! ✨                  │
└─────────────────────────────────────────────────────────┘
```

---

## 📝 Code Walkthrough

### 1. App Startup (main.dart)

```dart
BlocProvider(
  create: (context) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
  //                                    ↑
  // This immediately dispatches AuthCheckRequested when AuthBloc is created
)
```

**What happens:**
- App starts
- `AuthBloc` is created
- `AuthCheckRequested` event is immediately dispatched
- This triggers the auth check

---

### 2. BLoC Handler (auth_bloc.dart)

```dart
Future<void> _onAuthCheckRequested(
  AuthCheckRequested event,
  Emitter<AuthBlocState> emit,
) async {
  try {
    Logger.info('Checking authentication status');
    
    // Step 1: Check if user is logged in
    final isLoggedIn = await _secureStorage.isLoggedIn();

    if (isLoggedIn) {
      // Step 2: Get user data from storage
      final userData = await _secureStorage.getUserData();
      
      if (userData != null && userData.isNotEmpty) {
        try {
          // Step 3: Convert stored JSON to User entity
          final user = User.fromJson(userData);
          
          // Step 4: Validate user data
          if (user.email.isNotEmpty && user.id.isNotEmpty) {
            Logger.info('User found in secure storage: ${user.email}');
            
            // Step 5: Emit authenticated state
            emit(AuthAuthenticated(user));
          } else {
            emit(AuthUnauthenticated());
          }
        } catch (e) {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } else {
      // No user logged in
      emit(AuthUnauthenticated());
    }
  } catch (e) {
    emit(AuthUnauthenticated());
  }
}
```

**What this does:**
1. Checks secure storage for login status
2. Gets user data if logged in
3. Converts JSON to User entity
4. Validates user data
5. Emits `AuthAuthenticated` if valid
6. Emits `AuthUnauthenticated` if not

---

### 3. Secure Storage Check

**File:** `lib/core/storage/secure_storage_service.dart`

```dart
Future<bool> isLoggedIn() async {
  try {
    final isLoggedIn = await _storage.read(key: _keyIsLoggedIn);
    return isLoggedIn == 'true';  // Returns true if logged in
  } catch (e) {
    return false;
  }
}

Future<Map<String, dynamic>?> getUserData() async {
  try {
    final userDataJson = await _storage.read(key: _keyUserData);
    if (userDataJson != null) {
      return json.decode(userDataJson) as Map<String, dynamic>;
    }
    return null;
  } catch (e) {
    return null;
  }
}
```

**What this does:**
- `isLoggedIn()` - Checks if login flag exists
- `getUserData()` - Gets saved user data as JSON

---

### 4. Router Redirect Logic

**File:** `lib/core/router/app_router.dart`

```dart
redirect: (context, state) {
  final authBloc = context.read<AuthBloc>();
  final isAuthenticated = authBloc.state is AuthAuthenticated;
  final isLoginPage = state.matchedLocation == '/login';
  final isSignupPage = state.matchedLocation == '/signup';
  final isHomePage = state.matchedLocation == '/home';

  // If authenticated and on login/signup page → redirect to home
  if (isAuthenticated && (isLoginPage || isSignupPage)) {
    return '/home';
  }

  // If not authenticated and on home page → redirect to login
  if (!isAuthenticated && isHomePage) {
    return '/login';
  }
  
  return null; // No redirect needed
}
```

**What this does:**
- Checks AuthBloc state
- If authenticated + on login page → redirect to `/home`
- If not authenticated + on home page → redirect to `/login`
- This happens automatically when state changes!

---

## 🎯 Key Points

### 1. When Auth Check Happens

**On app startup:**
```dart
// main.dart
AuthBloc()..add(AuthCheckRequested())
//         ↑ Immediately dispatched when BLoC is created
```

**Timing:**
- App starts
- AuthBloc created
- AuthCheckRequested dispatched
- Handler runs
- State emitted
- Router redirects

---

### 2. How It Knows You're Logged In

**When you login successfully:**
```dart
// auth_repository_impl.dart (login method)
await _secureStorage.saveToken(token);        // Saves token
await _secureStorage.saveUserData(user.toJson()); // Saves user data
```

**When app restarts:**
```dart
// auth_bloc.dart (_onAuthCheckRequested)
final isLoggedIn = await _secureStorage.isLoggedIn(); // Checks flag
final userData = await _secureStorage.getUserData();   // Gets data
```

**The data persists:**
- Token saved → `isLoggedIn()` returns true
- User data saved → `getUserData()` returns user JSON
- Even after app is killed, data remains in secure storage!

---

### 3. How Router Redirects

**Router checks state:**
```dart
final isAuthenticated = authBloc.state is AuthAuthenticated;
```

**If authenticated:**
- On `/login` → Redirects to `/home`
- On `/signup` → Redirects to `/home`
- On `/home` → Stays on `/home`

**If not authenticated:**
- On `/home` → Redirects to `/login`
- On `/login` → Stays on `/login`

---

## 📊 Visual Flow Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    APP RESTARTS                         │
│  User opens app after killing it                        │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 1. main() runs
                     ▼
┌─────────────────────────────────────────────────────────┐
│              MAIN.DART                                  │
│  BlocProvider(                                           │
│    create: (context) =>                                  │
│      di.sl<AuthBloc>()..add(AuthCheckRequested())       │
│  )                                                       │
│  ↑ Immediately dispatches event                          │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 2. Event dispatched
                     ▼
┌─────────────────────────────────────────────────────────┐
│              AUTH BLOC                                   │
│  _onAuthCheckRequested()                                │
│  └─> await _secureStorage.isLoggedIn()                 │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 3. Check storage
                     ▼
┌─────────────────────────────────────────────────────────┐
│              SECURE STORAGE                              │
│  isLoggedIn() → true (if token exists)                   │
│  getUserData() → { id, email, name, ... }               │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 4. Data found
                     ▼
┌─────────────────────────────────────────────────────────┐
│              CREATE USER                                │
│  User.fromJson(userData)                                │
│  └─> User(id: "123", email: "test@test.com", ...)       │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 5. Emit state
                     ▼
┌─────────────────────────────────────────────────────────┐
│              BLOC EMITS                                 │
│  emit(AuthAuthenticated(user))                          │
│  └─> State changed to authenticated                     │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 6. Router detects state change
                     ▼
┌─────────────────────────────────────────────────────────┐
│              ROUTER REDIRECT                            │
│  redirect: (context, state) {                           │
│    if (isAuthenticated && isLoginPage)                  │
│      return '/home';  ← Redirects here!                  │
│  }                                                      │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 7. Navigate
                     ▼
┌─────────────────────────────────────────────────────────┐
│              HOME PAGE                                  │
│  User sees home page automatically! ✨                  │
│  No login required!                                      │
└─────────────────────────────────────────────────────────┘
```

---

## 🔑 Key Files and Methods

### 1. main.dart
**Line:** ~24
```dart
AuthBloc()..add(AuthCheckRequested())
```
**Purpose:** Triggers auth check on app start

---

### 2. auth_bloc.dart
**Method:** `_onAuthCheckRequested`
**Lines:** ~94-131
**Purpose:** Checks storage and emits state

---

### 3. secure_storage_service.dart
**Methods:**
- `isLoggedIn()` - Checks if logged in
- `getUserData()` - Gets user data
**Purpose:** Provides storage access

---

### 4. app_router.dart
**Method:** `redirect`
**Purpose:** Redirects based on auth state

---

## 💡 How Data Persists

### When You Login:

```dart
// 1. Token saved
await _secureStorage.saveToken(token);
// Storage: { "auth_token": "abc123..." }

// 2. User data saved
await _secureStorage.saveUserData(user.toJson());
// Storage: { "user_data": "{ id: '123', email: '...' }" }

// 3. Login flag set
await _storage.write(key: _keyIsLoggedIn, value: 'true');
// Storage: { "is_logged_in": "true" }
```

### When App Restarts:

```dart
// 1. Check flag
isLoggedIn() → Returns true (flag exists)

// 2. Get user data
getUserData() → Returns { id, email, name, ... }

// 3. Create user entity
User.fromJson(userData) → User object

// 4. Emit authenticated
emit(AuthAuthenticated(user)) → State changed
```

**The data survives:**
- App kill
- Phone restart
- Until you logout

---

## ✅ Summary

### How Auto-Login Works:

1. **App Starts** → `main.dart` creates AuthBloc and dispatches `AuthCheckRequested`
2. **BLoC Handler** → `_onAuthCheckRequested` checks secure storage
3. **Storage Check** → `isLoggedIn()` and `getUserData()` retrieve saved data
4. **User Created** → `User.fromJson()` converts stored data to entity
5. **State Emitted** → `AuthAuthenticated(user)` state is emitted
6. **Router Redirects** → Router sees authenticated state and redirects to `/home`
7. **Home Shown** → User sees home page automatically!

### Key Files:

- `main.dart` - Triggers check on startup
- `auth_bloc.dart` - Handles the check
- `secure_storage_service.dart` - Provides storage
- `app_router.dart` - Redirects based on state

**The magic is:** Secure storage persists data, and router automatically redirects based on BLoC state! 🎯

