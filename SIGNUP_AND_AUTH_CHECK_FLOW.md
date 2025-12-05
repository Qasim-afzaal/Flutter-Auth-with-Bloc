# Signup and Auth Check Flow Guide

## 🎯 What You Want to Implement

1. **Signup Function** - Register a new user
2. **Check User Already Logged In** - Verify if user is authenticated

## 📋 Flow Guide (Step by Step)

### Part 1: Signup Function Flow

#### Step 1: Domain Layer - Add Signup to Contract

**File:** `lib/features/auth/domain/repositories/auth_repository.dart`

**What to do:**
- Add `register()` method to the `AuthRepository` interface
- Define the method signature (what parameters it needs, what it returns)

**Example signature:**
```dart
Future<User> register(String email, String password, String name);
```

**Why here first:**
- Contract defines WHAT you can do (not how)
- Business logic depends on this contract
- Follows Clean Architecture (domain layer first)

---

#### Step 2: Data Layer - Create Signup DTO

**File:** `lib/features/auth/data/models/register_response_dto.dart` (NEW FILE)

**What to do:**
- Create a DTO similar to `LoginResponseDto`
- Parse the signup API response structure
- Should match your API response format

**Structure:**
- Similar to `LoginResponseDto`
- Contains success, message, data fields
- Data field contains `UserDataDto`

**Why here:**
- DTOs match API structure exactly
- Separates API from business logic

---

#### Step 3: Data Layer - Implement Signup in Repository

**File:** `lib/features/auth/data/repositories/auth_repository_impl.dart`

**What to do:**
- Implement the `register()` method
- Follow the same pattern as `login()`:
  1. Call API service with signup endpoint
  2. Parse response to DTO
  3. Convert DTO to Entity using mapper
  4. Save token and user data to secure storage
  5. Return User entity

**Flow:**
```
1. Call _apiService.post('/auth/register', {...})
2. Parse to RegisterResponseDto
3. Validate response
4. Convert DTO to User entity (UserMapper.toEntity)
5. Save token to secure storage
6. Save user data to secure storage
7. Return User entity
```

**Why here:**
- This is the IMPLEMENTATION layer
- Contains HOW you actually do signup
- Handles API calls and data operations

---

#### Step 4: Domain Layer - Create Signup Use Case (Optional but Recommended)

**File:** `lib/features/auth/domain/usecases/register_usecase.dart` (NEW FILE)

**What to do:**
- Create a use case similar to `LoginUseCase`
- Add business rules:
  - Validate email format
  - Validate password (length, strength)
  - Validate name (not empty, minimum length)
- Call repository.register() after validation

**Flow:**
```
1. Validate email format
2. Validate password (min 8 chars, etc.)
3. Validate name (not empty, min 2 chars)
4. If all valid → call repository.register()
5. Return User entity
```

**Why here:**
- Contains business rules
- Single responsibility (just signup)
- Reusable and testable

---

#### Step 5: Presentation Layer - Add Signup Event

**File:** `lib/features/auth/presentation/bloc/auth_event.dart`

**What to do:**
- Add `RegisterRequested` event class
- Include email, password, and name as parameters
- Follow the same pattern as `LoginRequested`

**Structure:**
```dart
class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  
  // Constructor and props
}
```

**Why here:**
- Events are presentation layer concerns
- UI dispatches events to BLoC

---

#### Step 6: Presentation Layer - Handle Signup in BLoC

**File:** `lib/features/auth/presentation/bloc/auth_bloc.dart`

**What to do:**
- Add event handler: `on<RegisterRequested>(_onRegisterRequested)`
- Create `_onRegisterRequested` method
- Follow the same pattern as `_onLoginRequested`:
  1. Emit `AuthLoading` state
  2. Call repository (or use case) to register
  3. On success: Emit `AuthAuthenticated(user)`
  4. On error: Emit `AuthError(message)`

**Flow:**
```
1. Receive RegisterRequested event
2. Emit AuthLoading (show spinner)
3. Try: Call repository.register() or useCase()
4. Success → Emit AuthAuthenticated(user)
5. Error → Emit AuthError(message)
```

**Why here:**
- BLoC handles state management
- Coordinates between UI and repository

---

#### Step 7: Presentation Layer - Update Signup Page UI

**File:** `lib/features/auth/presentation/pages/signup_page.dart`

**What to do:**
- Add form fields: name, email, password
- Add form validation
- Add submit button
- Dispatch `RegisterRequested` event when form is valid
- Listen to BLoC state changes:
  - On `AuthAuthenticated` → Navigate to home
  - On `AuthError` → Show error message
  - On `AuthLoading` → Show loading spinner

**Flow:**
```
1. User fills form (name, email, password)
2. User taps "Sign Up" button
3. Validate form fields
4. If valid → Dispatch RegisterRequested event
5. Listen to state:
   - Loading → Show spinner
   - Authenticated → Navigate to /home
   - Error → Show error message
```

**Why here:**
- UI handles user interaction
- Dispatches events to BLoC
- Reacts to state changes

---

#### Step 8: Dependency Injection - Register Use Case (if created)

**File:** `lib/injection/injection_container.dart`

**What to do:**
- If you created `RegisterUseCase`, register it:
  ```dart
  sl.registerFactory(() => RegisterUseCase(authRepository: sl()));
  ```

**Why here:**
- Dependency injection setup
- Makes use case available throughout app

---

### Part 2: Check User Already Logged In Flow

#### Step 1: Already Implemented! ✅

**File:** `lib/features/auth/presentation/bloc/auth_bloc.dart`

**What's already there:**
- `AuthCheckRequested` event (already exists)
- `_onAuthCheckRequested` handler (already implemented)
- Uses `SecureStorageService` to check if user is logged in

**Current flow:**
```
1. App starts → main.dart dispatches AuthCheckRequested
2. BLoC receives event
3. Checks secure storage: isLoggedIn()
4. If logged in → Gets user data from storage
5. Parses user data to User entity
6. Emits AuthAuthenticated(user)
7. If not logged in → Emits AuthUnauthenticated
```

**This is already working!** ✅

---

#### Step 2: How It Works (Understanding)

**When app starts:**
```dart
// main.dart
BlocProvider(
  create: (context) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
  // ↑ This dispatches AuthCheckRequested when app starts
)
```

**In BLoC:**
```dart
// auth_bloc.dart
Future<void> _onAuthCheckRequested(...) async {
  // 1. Check secure storage
  final isLoggedIn = await _secureStorage.isLoggedIn();
  
  // 2. If logged in, get user data
  if (isLoggedIn) {
    final userData = await _secureStorage.getUserData();
    final user = User.fromJson(userData);
    emit(AuthAuthenticated(user));
  } else {
    emit(AuthUnauthenticated());
  }
}
```

**In Router:**
```dart
// app_router.dart
redirect: (context, state) {
  final isAuthenticated = authBloc.state is AuthAuthenticated;
  
  // If authenticated and on login page → redirect to home
  if (isAuthenticated && isLoginPage) return '/home';
  
  // If not authenticated and on home page → redirect to login
  if (!isAuthenticated && isHomePage) return '/login';
}
```

---

## 📊 Complete Signup Flow Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    USER INTERACTION                      │
│  User fills signup form → Taps "Sign Up"               │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 1. Dispatch RegisterRequested Event
                     ▼
┌─────────────────────────────────────────────────────────┐
│                 PRESENTATION LAYER                       │
│  SignupPage → AuthBloc                                  │
│                                                          │
│  AuthBloc receives RegisterRequested                    │
│  └─> Emits AuthLoading                                  │
│  └─> Calls RegisterUseCase (optional) or Repository    │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 2. Use Case (optional)
                     ▼
┌─────────────────────────────────────────────────────────┐
│                  DOMAIN LAYER                            │
│                                                          │
│  RegisterUseCase (optional)                              │
│  └─> Validates email, password, name                    │
│  └─> Calls Repository                                   │
│                                                          │
│  AuthRepository (Contract)                              │
│  └─> Defines: Future<User> register(...)                │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 3. Implementation
                     ▼
┌─────────────────────────────────────────────────────────┐
│                   DATA LAYER                            │
│                                                          │
│  AuthRepositoryImpl                                     │
│  └─> Calls API: POST /auth/register                    │
│  └─> Parses to RegisterResponseDto                     │
│  └─> Converts DTO to User entity                       │
│  └─> Saves token and user data to secure storage        │
│  └─> Returns User entity                                │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 4. Response flows back
                     ▼
┌─────────────────────────────────────────────────────────┐
│                    RESPONSE FLOW                        │
│                                                          │
│  User Entity                                            │
│    ↓                                                    │
│  Repository returns User                                │
│    ↓                                                    │
│  BLoC emits AuthAuthenticated(user)                     │
│    ↓                                                    │
│  UI navigates to /home                                  │
└─────────────────────────────────────────────────────────┘
```

## 📁 Files You Need to Create/Modify

### New Files to Create:

1. ✅ `lib/features/auth/data/models/register_response_dto.dart`
   - Similar to `login_response_dto.dart`
   - Parses signup API response

2. ✅ `lib/features/auth/domain/usecases/register_usecase.dart` (Optional)
   - Similar to `login_usecase.dart`
   - Contains signup business rules

### Files to Modify:

1. ✅ `lib/features/auth/domain/repositories/auth_repository.dart`
   - Add `register()` method to contract

2. ✅ `lib/features/auth/data/repositories/auth_repository_impl.dart`
   - Implement `register()` method

3. ✅ `lib/features/auth/presentation/bloc/auth_event.dart`
   - Add `RegisterRequested` event

4. ✅ `lib/features/auth/presentation/bloc/auth_bloc.dart`
   - Add `_onRegisterRequested` handler
   - Register the event handler

5. ✅ `lib/features/auth/presentation/pages/signup_page.dart`
   - Add form fields and validation
   - Dispatch `RegisterRequested` event
   - Listen to state changes

6. ✅ `lib/injection/injection_container.dart` (if using use case)
   - Register `RegisterUseCase`

## 🎯 Step-by-Step Checklist

### For Signup:

- [ ] **Step 1**: Add `register()` to `AuthRepository` contract
- [ ] **Step 2**: Create `RegisterResponseDto` (if API response is different)
- [ ] **Step 3**: Implement `register()` in `AuthRepositoryImpl`
- [ ] **Step 4**: Create `RegisterUseCase` (optional but recommended)
- [ ] **Step 5**: Add `RegisterRequested` event
- [ ] **Step 6**: Add `_onRegisterRequested` handler in BLoC
- [ ] **Step 7**: Update SignupPage UI (form, validation, dispatch event)
- [ ] **Step 8**: Register use case in DI (if created)

### For Auth Check:

- [x] **Already Done!** ✅
  - `AuthCheckRequested` event exists
  - Handler implemented in BLoC
  - Called on app start in main.dart
  - Router handles redirects

## 🔑 Key Points to Remember

1. **Start with Domain Layer** (Contract first)
2. **Then Data Layer** (Implementation)
3. **Then Presentation Layer** (BLoC, UI)
4. **Follow the same pattern as Login**
5. **Use DTOs for API responses**
6. **Use Mapper to convert DTO → Entity**
7. **Save to secure storage after successful signup**
8. **Auth check is already implemented!**

## 💡 Tips

1. **Copy Login Pattern**: Signup follows the same pattern as login
2. **Use Existing Code**: Look at `login()` implementation as reference
3. **Test Each Step**: Test after each layer is complete
4. **Follow Clean Architecture**: Domain → Data → Presentation
5. **Use DTOs**: Don't parse API response directly in repository

## 🎓 Learning Path

1. **Understand Login Flow First** (you already have this)
2. **Follow Same Pattern for Signup**
3. **Add Business Rules in Use Case**
4. **Test Each Layer Separately**

## ✅ What's Already Working

- ✅ Auth check on app start
- ✅ Secure storage for user data
- ✅ Router redirects based on auth state
- ✅ Login flow (use as reference)

## 🚀 You're Ready!

Follow the flow above, and you'll have signup working in no time! Remember:
- Start with Domain (contract)
- Then Data (implementation)
- Then Presentation (BLoC, UI)

Good luck! 🎉

