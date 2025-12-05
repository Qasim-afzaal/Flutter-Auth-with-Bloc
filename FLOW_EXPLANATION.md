# Authentication Flow Explanation

This document explains how the authentication flow works in this app, from UI interaction to API calls and back.

## Architecture Overview

```
┌─────────────┐
│     UI      │  (Login Page, Home Page, etc.)
└──────┬──────┘
       │
       │ 1. User Action (e.g., taps Login button)
       │ 2. Dispatch Event (LoginRequested)
       │
       ▼
┌─────────────┐
│    BLoC     │  (AuthBloc - State Management)
└──────┬──────┘
       │
       │ 3. Handle Event
       │ 4. Call Repository Method
       │
       ▼
┌─────────────┐
│ Repository  │  (AuthRepositoryImpl - Data Layer)
└──────┬──────┘
       │
       │ 5. Call API Service
       │ 6. Save to Secure Storage
       │
       ▼
┌─────────────┐
│ API Service │  (ApiService - Network Layer)
└──────┬──────┘
       │
       │ 7. Make HTTP Request
       │
       ▼
┌─────────────┐
│   Backend   │  (Your API Server)
└─────────────┘
```

## Complete Flow: Login Example

Let's trace a complete login flow step by step:

### Step 1: User Interaction (UI Layer)

**File:** `lib/features/auth/presentation/pages/login_page.dart`

```dart
// User fills email and password, then taps Login button
void _handleLogin() {
  if (_formKey.currentState!.validate()) {
    // Dispatch LoginRequested event to BLoC
    context.read<AuthBloc>().add(
      LoginRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }
}
```

**What happens:**
- User enters credentials
- Form validation runs
- `LoginRequested` event is dispatched to `AuthBloc`

---

### Step 2: BLoC Receives Event (Presentation Layer)

**File:** `lib/features/auth/presentation/bloc/auth_bloc.dart`

```dart
class AuthBloc extends Bloc<AuthEvent, AuthBlocState> {
  final AuthRepository _authRepository;
  final SecureStorageService _secureStorage;

  // Event handler for LoginRequested
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthBlocState> emit,
  ) async {
    // 1. Emit loading state (UI shows loading indicator)
    emit(AuthLoading());

    try {
      // 2. Call repository to perform login
      final user = await _authRepository.login(
        event.email,
        event.password,
      );
      
      // 3. If successful, emit authenticated state
      emit(AuthAuthenticated(user));
    } catch (e) {
      // 4. If failed, emit error state
      emit(AuthError(e.toString()));
    }
  }
}
```

**What happens:**
1. BLoC receives `LoginRequested` event
2. Emits `AuthLoading` state → UI shows loading spinner
3. Calls `_authRepository.login()` method
4. Waits for response
5. On success: Emits `AuthAuthenticated(user)` → UI navigates to home
6. On error: Emits `AuthError(message)` → UI shows error message

---

### Step 3: Repository Implementation (Data Layer)

**File:** `lib/features/auth/data/repositories/auth_repository_impl.dart`

```dart
class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;
  final SecureStorageService _secureStorage;

  @override
  Future<User> login(String email, String password) async {
    try {
      Logger.info('Attempting login for email: $email');

      // 1. Make API call using ApiService
      final response = await _apiService.post(
        '/auth/login',
        {
          'email': email,
          'password': password,
        },
      );

      // 2. Parse user data from response
      final userData = response['data'] as Map<String, dynamic>? ??
          response['user'] as Map<String, dynamic>? ??
          response;

      final user = User.fromJson(userData);

      // 3. Save token if present
      final token = response['token'] as String? ?? 
                   response['access_token'] as String?;
      if (token != null) {
        await _secureStorage.saveToken(token);
      }

      // 4. Save user data to secure storage
      await _secureStorage.saveUserData(user.toJson());

      // 5. Return user object
      return user;
    } catch (e) {
      // Handle errors and rethrow as appropriate Failure
      if (e is AuthFailure) rethrow;
      if (e is NetworkFailure) rethrow;
      if (e is ServerFailure) rethrow;
      throw AuthFailure('Login failed: $e');
    }
  }
}
```

**What happens:**
1. Repository receives email and password
2. Calls `_apiService.post()` → Makes HTTP request
3. Waits for API response
4. Parses response to create `User` object
5. Saves authentication token to secure storage
6. Saves user data to secure storage
7. Returns `User` object to BLoC

---

### Step 4: API Service (Network Layer)

**File:** `lib/core/network/api_service.dart`

```dart
class ApiService {
  final http.Client _client;
  final String _baseUrl;

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    // Uses generic _makeRequest method
    return _makeRequest(
      method: HttpMethod.post,
      endpoint: endpoint,
      body: body,
      headers: headers,
    );
  }

  Future<Map<String, dynamic>> _makeRequest({
    required HttpMethod method,
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    // 1. Build URL
    final normalizedEndpoint = endpoint.startsWith('/') 
        ? endpoint 
        : '/$endpoint';
    final uri = Uri.parse('$_baseUrl$normalizedEndpoint');
    
    // 2. Build headers
    final requestHeaders = _buildHeaders(headers);
    
    // 3. Execute HTTP request
    final response = await _executeRequest(
      method: method,
      uri: uri,
      headers: requestHeaders,
      body: body,
    ).timeout(Duration(milliseconds: AppConstants.connectionTimeout));
    
    // 4. Handle response
    return _handleResponse(response);
  }
}
```

**What happens:**
1. Receives endpoint and body from repository
2. Builds complete URL: `http://3.92.114.189:3005/api/auth/login`
3. Sets headers (Content-Type: application/json)
4. Makes HTTP POST request to backend
5. Handles timeout (30 seconds)
6. Parses response JSON
7. Returns `Map<String, dynamic>` to repository
8. Throws appropriate errors (NetworkFailure, AuthFailure, ServerFailure)

---

### Step 5: Backend API

**Backend receives:**
```json
POST http://3.92.114.189:3005/api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

**Backend responds:**
```json
{
  "success": true,
  "data": {
    "id": "123",
    "email": "user@example.com",
    "name": "John Doe",
    "avatar": null,
    "created_at": "2024-01-01T00:00:00Z"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

### Step 6: Response Flow Back to UI

The response flows back through the layers:

1. **API Service** → Returns `Map<String, dynamic>` to Repository
2. **Repository** → Parses to `User`, saves to storage, returns `User` to BLoC
3. **BLoC** → Emits `AuthAuthenticated(user)` state
4. **UI** → Listens to state changes and updates

**File:** `lib/features/auth/presentation/pages/login_page.dart`

```dart
BlocListener<AuthBloc, AuthBlocState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      // Navigate to home page on successful login
      context.go('/home');
    } else if (state is AuthError) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  },
  child: // ... UI widgets
)
```

---

## State Flow Diagram

```
Initial State: AuthInitial
       │
       │ User taps Login
       ▼
   AuthLoading (shows spinner)
       │
       ├─ Success ──► AuthAuthenticated ──► Navigate to /home
       │
       └─ Error ────► AuthError ──────────► Show error message
```

---

## Dependency Injection Flow

**File:** `lib/injection/injection_container.dart`

```dart
// 1. Register API Service (Singleton - one instance for entire app)
sl.registerLazySingleton<ApiService>(() => ApiService());

// 2. Register Secure Storage (Singleton)
sl.registerLazySingleton<SecureStorageService>(
  () => SecureStorageService()
);

// 3. Register Repository (Singleton - uses ApiService and SecureStorage)
sl.registerLazySingleton<AuthRepository>(
  () => AuthRepositoryImpl(
    apiService: sl(),        // Injects ApiService
    secureStorage: sl(),     // Injects SecureStorageService
  ),
);

// 4. Register BLoC (Factory - new instance per widget tree)
sl.registerFactory(
  () => AuthBloc(
    authRepository: sl(),    // Injects AuthRepository
    secureStorage: sl(),      // Injects SecureStorageService
  ),
);
```

**Dependency Chain:**
```
AuthBloc
  ├─ AuthRepository (interface)
  │   └─ AuthRepositoryImpl
  │       ├─ ApiService
  │       └─ SecureStorageService
  └─ SecureStorageService
```

---

## Complete Example: Login Flow

### 1. User Action
```dart
// User enters email: "test@example.com"
// User enters password: "password123"
// User taps "Login" button
```

### 2. UI Dispatches Event
```dart
context.read<AuthBloc>().add(
  LoginRequested(
    email: "test@example.com",
    password: "password123",
  ),
);
```

### 3. BLoC Handles Event
```dart
// AuthBloc receives LoginRequested event
emit(AuthLoading());  // UI shows loading spinner

final user = await _authRepository.login(
  "test@example.com",
  "password123",
);

emit(AuthAuthenticated(user));  // UI navigates to home
```

### 4. Repository Makes API Call
```dart
// AuthRepositoryImpl.login() called
final response = await _apiService.post(
  '/auth/login',
  {
    'email': 'test@example.com',
    'password': 'password123',
  },
);
// Response: { "data": {...}, "token": "..." }

// Save to secure storage
await _secureStorage.saveToken(response['token']);
await _secureStorage.saveUserData(user.toJson());

return user;  // Return to BLoC
```

### 5. API Service Makes HTTP Request
```dart
// ApiService.post() called
// URL: http://3.92.114.189:3005/api/auth/login
// Method: POST
// Body: {"email":"test@example.com","password":"password123"}
// Headers: {"Content-Type": "application/json"}

// HTTP Request sent to backend
// Response received and parsed
return responseMap;  // Return to Repository
```

### 6. Backend Processes Request
```
Backend validates credentials
Backend generates JWT token
Backend returns user data + token
```

### 7. Response Flows Back
```
Backend Response
    ↓
API Service (parses JSON)
    ↓
Repository (creates User object, saves to storage)
    ↓
BLoC (emits AuthAuthenticated state)
    ↓
UI (listens to state, navigates to home)
```

---

## Key Concepts

### 1. **Separation of Concerns**
- **UI**: Only handles user interaction and display
- **BLoC**: Manages state and business logic flow
- **Repository**: Handles data operations (API + Storage)
- **API Service**: Handles network communication

### 2. **Dependency Injection**
- All dependencies are injected, not created directly
- Makes code testable and maintainable
- Follows Dependency Inversion Principle

### 3. **Error Handling**
- Errors are caught at each layer
- Converted to appropriate Failure types
- Propagated up to BLoC
- BLoC emits error state
- UI displays error to user

### 4. **State Management**
- BLoC manages all state changes
- UI listens to state changes
- State changes trigger UI updates automatically

---

## Testing the Flow

To see the flow in action:

1. **Run the app**: `flutter run`
2. **Open login page**: App starts at `/login`
3. **Enter credentials**: Fill email and password
4. **Tap Login**: Watch the flow:
   - Loading spinner appears (AuthLoading)
   - API call is made (check logs)
   - On success: Navigate to home
   - On error: Show error message

---

## Next Steps: Implementing Signup

When you implement signup, follow the same pattern:

1. **UI**: Create signup form, dispatch `RegisterRequested` event
2. **BLoC**: Add `_onRegisterRequested` handler
3. **Repository**: Add `register()` method (you'll write this)
4. **API Service**: Use existing `post()` method
5. **Flow**: Same as login flow!

This architecture makes it easy to add new features following the same pattern.

