# Visual Flow Diagrams

## 1. Login Flow - Complete Sequence

```
┌─────────────────────────────────────────────────────────────────┐
│                         USER INTERACTION                        │
│  User enters email/password → Taps "Login" button              │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │ 1. Dispatch LoginRequested Event
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                            UI LAYER                              │
│  login_page.dart                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ context.read<AuthBloc>().add(                             │   │
│  │   LoginRequested(email: "...", password: "...")          │   │
│  │ );                                                         │   │
│  └──────────────────────────────────────────────────────────┘   │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │ 2. Event flows to BLoC
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                         PRESENTATION LAYER                       │
│  auth_bloc.dart                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ _onLoginRequested(event, emit) {                          │   │
│  │   emit(AuthLoading());              // Show spinner      │   │
│  │   final user = await _authRepository.login(...);         │   │
│  │   emit(AuthAuthenticated(user));    // Success           │   │
│  │ }                                                          │   │
│  └──────────────────────────────────────────────────────────┘   │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │ 3. Call Repository
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                           DATA LAYER                             │
│  auth_repository_impl.dart                                       │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ login(email, password) {                                  │   │
│  │   // Make API call                                        │   │
│  │   final response = await _apiService.post(...);          │   │
│  │   // Parse response                                       │   │
│  │   final user = User.fromJson(response['data']);          │   │
│  │   // Save to storage                                      │   │
│  │   await _secureStorage.saveToken(token);                │   │
│  │   await _secureStorage.saveUserData(user.toJson());     │   │
│  │   return user;                                            │   │
│  │ }                                                          │   │
│  └──────────────────────────────────────────────────────────┘   │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │ 4. Call API Service
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                         NETWORK LAYER                            │
│  api_service.dart                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ post(endpoint, body) {                                     │   │
│  │   // Build URL                                            │   │
│  │   final uri = Uri.parse('$_baseUrl$endpoint');          │   │
│  │   // Make HTTP request                                    │   │
│  │   final response = await _client.post(uri, ...);         │   │
│  │   // Handle response                                      │   │
│  │   return _handleResponse(response);                       │   │
│  │ }                                                          │   │
│  └──────────────────────────────────────────────────────────┘   │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │ 5. HTTP POST Request
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                          BACKEND API                             │
│  http://3.92.114.189:3005/api/auth/login                         │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ POST /auth/login                                          │   │
│  │ Body: { "email": "...", "password": "..." }             │   │
│  │                                                           │   │
│  │ Response: {                                              │   │
│  │   "data": { "id": "...", "email": "...", ... },         │   │
│  │   "token": "eyJhbGciOiJIUzI1NiIs..."                     │   │
│  │ }                                                         │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                             │
                             │ 6. Response flows back
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    RESPONSE FLOW (BACKWARDS)                     │
│                                                                   │
│  Backend Response (JSON)                                         │
│       ↓                                                          │
│  API Service (parses JSON → Map<String, dynamic>)               │
│       ↓                                                          │
│  Repository (creates User object, saves to storage)              │
│       ↓                                                          │
│  BLoC (emits AuthAuthenticated state)                            │
│       ↓                                                          │
│  UI (listens to state, navigates to /home)                       │
└─────────────────────────────────────────────────────────────────┘
```

## 2. State Management Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    STATE FLOW DIAGRAM                        │
└─────────────────────────────────────────────────────────────┘

Initial State
    │
    │ AuthInitial
    │ (App starts)
    │
    ├─► AuthCheckRequested
    │       │
    │       ├─ User found in storage ──► AuthAuthenticated ──► Show Home
    │       │
    │       └─ No user ────────────────► AuthUnauthenticated ─► Show Login
    │
    │
    ├─► LoginRequested
    │       │
    │       ├─ AuthLoading (shows spinner)
    │       │
    │       ├─ Success ──► AuthAuthenticated ──► Navigate to /home
    │       │
    │       └─ Error ────► AuthError ─────────► Show error message
    │
    │
    └─► LogoutRequested
            │
            ├─ AuthLoading
            │
            └─ AuthUnauthenticated ──► Navigate to /login
```

## 3. Dependency Injection Flow

```
┌─────────────────────────────────────────────────────────────┐
│              DEPENDENCY INJECTION CHAIN                      │
└─────────────────────────────────────────────────────────────┘

main.dart
    │
    │ await di.init()
    │
    ▼
injection_container.dart
    │
    ├─► Register ApiService (Singleton)
    │       └─ Used by: AuthRepositoryImpl
    │
    ├─► Register SecureStorageService (Singleton)
    │       └─ Used by: AuthRepositoryImpl, AuthBloc
    │
    ├─► Register AuthRepository (Singleton)
    │       └─ Implementation: AuthRepositoryImpl
    │       └─ Dependencies: ApiService, SecureStorageService
    │
    └─► Register AuthBloc (Factory)
            └─ Dependencies: AuthRepository, SecureStorageService
            └─ Created per widget tree

┌─────────────────────────────────────────────────────────────┐
│                    DEPENDENCY TREE                            │
└─────────────────────────────────────────────────────────────┘

AuthBloc
    ├─ AuthRepository (interface)
    │   └─ AuthRepositoryImpl
    │       ├─ ApiService
    │       │   └─ http.Client
    │       └─ SecureStorageService
    │           └─ FlutterSecureStorage
    └─ SecureStorageService
        └─ FlutterSecureStorage
```

## 4. Error Handling Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    ERROR HANDLING FLOW                       │
└─────────────────────────────────────────────────────────────┘

API Service
    │
    ├─ Network Error (no internet, timeout)
    │   └─► Throws NetworkFailure
    │
    ├─ 401 Unauthorized
    │   └─► Throws AuthFailure
    │
    ├─ 400-499 Client Error
    │   └─► Throws ServerFailure
    │
    └─ 500-599 Server Error
        └─► Throws ServerFailure
            │
            ▼
Repository
    │
    ├─ Catches Failure
    │   └─► Re-throws (preserves error type)
    │
    └─ Catches Exception
        └─► Wraps in AuthFailure
            │
            ▼
BLoC
    │
    ├─ Catches Failure/Exception
    │   └─► Emits AuthError(state.message)
    │
    └─ UI displays error message
```

## 5. Data Flow: Login Success

```
┌─────────────────────────────────────────────────────────────┐
│              LOGIN SUCCESS - DATA FLOW                         │
└─────────────────────────────────────────────────────────────┘

1. User Input
   email: "test@example.com"
   password: "password123"
   
2. API Request
   POST http://3.92.114.189:3005/api/auth/login
   {
     "email": "test@example.com",
     "password": "password123"
   }
   
3. API Response
   {
     "success": true,
     "data": {
       "id": "123",
       "email": "test@example.com",
       "name": "John Doe",
       "avatar": null,
       "created_at": "2024-01-01T00:00:00Z"
     },
     "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
   }
   
4. Secure Storage
   Token saved: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
   User data saved: { "id": "123", "email": "...", ... }
   
5. BLoC State
   AuthAuthenticated(user: User(id: "123", ...))
   
6. UI Update
   Navigate to /home
   Display user information
```

## 6. Navigation Flow with GoRouter

```
┌─────────────────────────────────────────────────────────────┐
│              NAVIGATION FLOW (GoRouter)                      │
└─────────────────────────────────────────────────────────────┘

App Start
    │
    ├─► Check Auth Status (AuthCheckRequested)
    │       │
    │       ├─ User logged in ──► /home
    │       │
    │       └─ User not logged in ──► /login
    │
    │
    ├─► Login Success ──► context.go('/home')
    │
    ├─► Logout ──► context.go('/login')
    │
    ├─► Signup Page ──► context.go('/signup')
    │
    └─► Route Guards
            │
            ├─ Authenticated user tries /login ──► Redirect to /home
            │
            └─ Unauthenticated user tries /home ──► Redirect to /login
```

## 7. File Structure & Responsibilities

```
lib/
├── main.dart                    # App entry point, sets up BlocProvider
│
├── injection/
│   └── injection_container.dart # Dependency injection setup
│
├── core/
│   ├── network/
│   │   └── api_service.dart    # HTTP requests (GET, POST, etc.)
│   ├── storage/
│   │   └── secure_storage_service.dart  # Secure data storage
│   ├── router/
│   │   └── app_router.dart     # Navigation configuration
│   └── errors/
│       └── failures.dart        # Error types
│
└── features/
    └── auth/
        ├── domain/              # Business logic (interfaces)
        │   ├── entities/
        │   │   └── user.dart
        │   └── repositories/
        │       └── auth_repository.dart
        │
        ├── data/                # Data layer (implementations)
        │   └── repositories/
        │       └── auth_repository_impl.dart
        │
        └── presentation/        # UI layer
            ├── bloc/
            │   ├── auth_bloc.dart
            │   ├── auth_event.dart
            │   └── auth_bloc_state.dart
            └── pages/
                ├── login_page.dart
                ├── signup_page.dart
                └── home_page.dart
```

## Key Takeaways

1. **Unidirectional Data Flow**: Data flows in one direction (UI → BLoC → Repository → API)
2. **State Management**: BLoC manages all state, UI reacts to state changes
3. **Separation of Concerns**: Each layer has a specific responsibility
4. **Dependency Injection**: All dependencies are injected, making code testable
5. **Error Handling**: Errors are handled at each layer and propagated appropriately
6. **Type Safety**: Using interfaces and types ensures compile-time safety

