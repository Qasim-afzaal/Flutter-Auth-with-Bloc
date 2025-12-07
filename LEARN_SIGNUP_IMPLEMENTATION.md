# Learn Signup Implementation - Step by Step Guide

## 🎓 Learning Goals

By implementing signup yourself, you'll learn:
1. **BLoC Pattern** - How events, states, and handlers work
2. **Clean Architecture** - How data flows through layers
3. **Repository Pattern** - Contract vs Implementation
4. **DTO Pattern** - API structure vs Business logic

---

## 📋 Step-by-Step Implementation

### Step 1: Domain Layer - Add Signup to Contract

**File:** `lib/features/auth/domain/repositories/auth_repository.dart`

**What to do:**
Add the `register` method to the `AuthRepository` interface.

**Why this first?**
- Domain layer defines **what** you can do (contract)
- Business logic depends on this contract
- Follows Clean Architecture (start with domain)

**Code to add:**
```dart
abstract class AuthRepository {
  Future<User> login(String email, String password);
  
  // Add this method:
  Future<User> register(String email, String password, String name);
}
```

**What you're learning:**
- **Contract** = Promise of what methods exist
- **Interface** = Defines structure, not implementation
- **Domain Layer** = Business logic, no API details

---

### Step 2: Data Layer - Create Signup DTO (if needed)

**File:** `lib/features/auth/data/models/register_response_dto.dart` (NEW FILE)

**What to do:**
Create a DTO for the signup API response.

**Why?**
- DTO matches API structure exactly
- Separates API from business logic
- If signup response is same as login, you can reuse `LoginResponseDto`

**Check first:**
- Look at your API documentation
- If signup returns same structure as login → Reuse `LoginResponseDto`
- If different → Create `RegisterResponseDto`

**If you need to create it:**
```dart
import 'user_data_dto.dart';

class RegisterResponseDto {
  bool? success;
  String? message;
  UserDataDto? data;

  RegisterResponseDto({this.success, this.message, this.data});

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) {
    return RegisterResponseDto(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null 
          ? UserDataDto.fromJson(json['data']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}
```

**What you're learning:**
- **DTO** = Data Transfer Object (matches API)
- **fromJson** = Parse API response
- **toJson** = Convert to API format

---

### Step 3: Data Layer - Implement Signup in Repository

**File:** `lib/features/auth/data/repositories/auth_repository_impl.dart`

**What to do:**
Implement the `register` method in `AuthRepositoryImpl`.

**Why?**
- This is the **implementation** of the contract
- Contains **how** you actually do signup
- Handles API calls, parsing, storage

**Steps to follow:**
1. Call API service with signup endpoint
2. Parse response to DTO
3. Validate response
4. Convert DTO to Entity using mapper
5. Save token and user data
6. Return User entity

**Code structure:**
```dart
@override
Future<User> register(String email, String password, String name) async {
  try {
    // 1. Call API
    final response = await _apiService.post(
      '/auth/register',  // Signup endpoint
      {
        'email': email,
        'password': password,
        'name': name,
      },
    );

    // 2. Parse to DTO
    final registerResponseDto = RegisterResponseDto.fromJson(response);

    // 3. Validate
    if (registerResponseDto.data == null) {
      throw AuthFailure('Registration failed: No user data');
    }

    // 4. Convert DTO to Entity
    final user = UserMapper.toEntity(registerResponseDto.data!);

    // 5. Save token
    final token = registerResponseDto.data!.accessToken;
    if (token != null && token.isNotEmpty) {
      await _secureStorage.saveToken(token);
    }

    // 6. Save user data
    await _secureStorage.saveUserData(user.toJson());

    // 7. Return entity
    return user;
  } catch (e) {
    // Handle errors
    throw AuthFailure('Registration failed: $e');
  }
}
```

**What you're learning:**
- **Implementation** = Actual code that does the work
- **Repository Pattern** = Implements contract from domain
- **Data Layer** = Handles external concerns (API, storage)

---

### Step 4: Presentation Layer - Add Signup Event

**File:** `lib/features/auth/presentation/bloc/auth_event.dart`

**What to do:**
Add `RegisterRequested` event class.

**Why?**
- Events represent user actions
- BLoC receives events and handles them
- Follows BLoC pattern

**Code to add:**
```dart
class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const RegisterRequested({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];

  @override
  String toString() => 'RegisterRequested(email: $email)';
}
```

**What you're learning:**
- **Event** = User action (what user wants to do)
- **Extends AuthEvent** = All events extend base class
- **props** = For equality comparison (Equatable)
- **toString** = For debugging

---

### Step 5: Presentation Layer - Handle Signup in BLoC

**File:** `lib/features/auth/presentation/bloc/auth_bloc.dart`

**What to do:**
1. Register the event handler
2. Create the handler method

**Why?**
- BLoC handles business logic coordination
- Receives events, calls repository, emits states
- This is where BLoC pattern shines!

**Step 5a: Register Event Handler**

In the constructor, add:
```dart
AuthBloc({
  required AuthRepository authRepository,
  required SecureStorageService secureStorage,
})  : _authRepository = authRepository,
      _secureStorage = secureStorage,
      super(AuthInitial()) {
  on<LoginRequested>(_onLoginRequested);
  on<LogoutRequested>(_onLogoutRequested);
  on<AuthCheckRequested>(_onAuthCheckRequested);
  
  // Add this:
  on<RegisterRequested>(_onRegisterRequested);
}
```

**Step 5b: Create Handler Method**

Add this method (look at `_onLoginRequested` as reference):
```dart
Future<void> _onRegisterRequested(
  RegisterRequested event,
  Emitter<AuthBlocState> emit,
) async {
  // 1. Emit loading state (show spinner)
  emit(AuthLoading());

  try {
    // 2. Call repository to register
    final user = await _authRepository.register(
      event.email,
      event.password,
      event.name,
    );

    // 3. On success, emit authenticated state
    emit(AuthAuthenticated(user));
  } catch (e) {
    // 4. On error, emit error state
    emit(AuthError(e.toString()));
  }
}
```

**What you're learning:**
- **BLoC Handler** = Processes events
- **emit()** = Emits new state (triggers UI rebuild)
- **States** = AuthLoading, AuthAuthenticated, AuthError
- **Event** = Contains data (email, password, name)

---

### Step 6: Presentation Layer - Update Signup Page UI

**File:** `lib/features/auth/presentation/pages/signup_page.dart`

**What to do:**
1. Add form fields (name, email, password)
2. Add validation
3. Dispatch `RegisterRequested` event
4. Listen to state changes

**Why?**
- UI handles user interaction
- Dispatches events to BLoC
- Listens to states from BLoC
- Reacts to state changes

**Step 6a: Add Form Fields**

```dart
final _formKey = GlobalKey<FormState>();
final _nameController = TextEditingController();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
```

**Step 6b: Add Form Validation**

```dart
String? _validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Name is required';
  }
  if (value.length < 2) {
    return 'Name must be at least 2 characters';
  }
  return null;
}

String? _validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  if (!value.contains('@')) {
    return 'Invalid email';
  }
  return null;
}

String? _validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  if (value.length < 8) {
    return 'Password must be at least 8 characters';
  }
  return null;
}
```

**Step 6c: Dispatch Event on Submit**

```dart
void _handleSignup() {
  if (_formKey.currentState!.validate()) {
    // Dispatch RegisterRequested event
    context.read<AuthBloc>().add(
      RegisterRequested(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
      ),
    );
  }
}
```

**Step 6d: Listen to State Changes**

```dart
BlocListener<AuthBloc, AuthBlocState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      // Navigate to home on success
      context.go('/home');
    } else if (state is AuthError) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: BlocBuilder<AuthBloc, AuthBlocState>(
    builder: (context, state) {
      // Show loading spinner when loading
      if (state is AuthLoading) {
        return const CircularProgressIndicator();
      }

      // Show form
      return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              validator: _validateName,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _emailController,
              validator: _validateEmail,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _passwordController,
              validator: _validatePassword,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            ElevatedButton(
              onPressed: _handleSignup,
              child: Text('Sign Up'),
            ),
          ],
        ),
      );
    },
  ),
)
```

**What you're learning:**
- **BlocListener** = Listens to state changes (side effects like navigation)
- **BlocBuilder** = Rebuilds UI based on state
- **context.read<AuthBloc>()** = Gets BLoC instance
- **add()** = Dispatches event to BLoC

---

## 🔄 Complete Flow Explained

### How BLoC Works:

```
1. User Action (taps button)
   ↓
2. UI dispatches event (RegisterRequested)
   ↓
3. BLoC receives event
   ↓
4. BLoC emits loading state (AuthLoading)
   ↓
5. BLoC calls repository
   ↓
6. Repository calls API
   ↓
7. API returns response
   ↓
8. Repository converts to entity
   ↓
9. Repository returns entity to BLoC
   ↓
10. BLoC emits success state (AuthAuthenticated)
    ↓
11. UI listens to state change
    ↓
12. UI navigates to home
```

### BLoC Pattern Concepts:

**Event** = What user wants to do
- `RegisterRequested(email, password, name)`
- Represents user action

**State** = Current app state
- `AuthLoading` = Processing
- `AuthAuthenticated` = Success
- `AuthError` = Error

**Handler** = Processes event
- `_onRegisterRequested()` = Handles registration
- Calls repository, emits states

**emit()** = Emits new state
- Triggers UI rebuild
- All BlocBuilder widgets rebuild

---

## 🎯 Key Learning Points

### 1. BLoC Pattern

**Event → Handler → State**

```dart
// Event (user action)
RegisterRequested(email, password, name)

// Handler (processes event)
_onRegisterRequested(event, emit) {
  emit(AuthLoading());  // State 1
  // ... do work ...
  emit(AuthAuthenticated(user));  // State 2
}

// State (current state)
AuthLoading → AuthAuthenticated
```

### 2. Clean Architecture Flow

```
UI (Presentation)
  ↓ dispatches event
BLoC (Presentation)
  ↓ calls
Repository Contract (Domain)
  ↓ implemented by
Repository Implementation (Data)
  ↓ calls
API Service (Data)
  ↓ returns
DTO (Data)
  ↓ converted by
Mapper (Data)
  ↓ returns
Entity (Domain)
  ↓ back to
BLoC (Presentation)
  ↓ emits state
UI (Presentation)
```

### 3. Repository Pattern

**Contract (Domain):**
```dart
abstract class AuthRepository {
  Future<User> register(...);  // What you can do
}
```

**Implementation (Data):**
```dart
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<User> register(...) {
    // How you do it
  }
}
```

---

## ✅ Checklist

Follow these steps in order:

- [ ] **Step 1:** Add `register()` to `AuthRepository` contract
- [ ] **Step 2:** Create `RegisterResponseDto` (if needed)
- [ ] **Step 3:** Implement `register()` in `AuthRepositoryImpl`
- [ ] **Step 4:** Add `RegisterRequested` event
- [ ] **Step 5:** Add handler in `AuthBloc`
- [ ] **Step 6:** Update `SignupPage` UI

---

## 🎓 What You'll Learn

### BLoC Pattern:
1. ✅ Events represent user actions
2. ✅ States represent app state
3. ✅ Handlers process events and emit states
4. ✅ UI listens to states and dispatches events

### Clean Architecture:
1. ✅ Domain layer defines contracts
2. ✅ Data layer implements contracts
3. ✅ Presentation layer uses contracts
4. ✅ Layers are independent

### Repository Pattern:
1. ✅ Contract defines what you can do
2. ✅ Implementation defines how you do it
3. ✅ Business logic depends on contract, not implementation

---

## 💡 Tips

1. **Follow the login pattern** - Signup is similar to login
2. **Test each step** - Don't move to next step until current works
3. **Read error messages** - They tell you what's wrong
4. **Use existing code** - Look at login implementation as reference
5. **Ask questions** - If stuck, check the code examples

---

## 🚀 You're Ready!

Now you understand:
- How BLoC works (Events → Handlers → States)
- How Clean Architecture flows (Domain → Data → Presentation)
- How to implement a feature step by step

**Go ahead and implement signup!** Follow the steps above, and you'll learn by doing! 🎉

