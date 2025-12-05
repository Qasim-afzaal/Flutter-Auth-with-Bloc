# Clean Architecture - Visual Guide

## 🎯 The 4 Key Concepts

### 1. Entity (What Things Are)

```
┌─────────────────────────┐
│       ENTITY            │
│                         │
│  class User {           │
│    String id;           │  ← Business object
│    String email;        │  ← Represents a user
│    String name;         │  ← In your business
│  }                      │
└─────────────────────────┘

Location: domain/entities/user.dart
Purpose: Represents WHAT a user IS
```

**Real Example:**
```dart
User user = User(
  id: "123",
  email: "test@test.com",
  name: "John"
);
// This IS a user in your business logic
```

### 2. Contract (What You Can Do)

```
┌─────────────────────────┐
│      CONTRACT           │
│  (Interface/Promise)    │
│                         │
│  abstract class         │
│    AuthRepository {     │
│                         │
│    Future<User>         │  ← Promise: "I will
│      login(...);        │     have this method"
│  }                      │
└─────────────────────────┘

Location: domain/repositories/auth_repository.dart
Purpose: Defines WHAT you can do (not how)
```

**Real Example:**
```dart
abstract class AuthRepository {
  // This is a PROMISE/CONTRACT
  // It says "I will have a login method"
  Future<User> login(String email, String password);
}
```

### 3. Implementation (How You Do It)

```
┌─────────────────────────┐
│   IMPLEMENTATION        │
│  (Actual Code)         │
│                         │
│  class AuthRepository  │
│    Impl implements      │
│    AuthRepository {     │
│                         │
│    login(...) {         │  ← Actually does:
│      // Call API        │     the work
│      // Parse response  │
│      // Save token      │
│      return user;       │
│    }                    │
│  }                      │
└─────────────────────────┘

Location: data/repositories/auth_repository_impl.dart
Purpose: Defines HOW you do it (actual code)
```

**Real Example:**
```dart
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<User> login(String email, String password) async {
    // HERE'S HOW we actually login:
    final response = await _apiService.post('/auth/login', {...});
    final dto = LoginResponseDto.fromJson(response);
    final user = UserMapper.toEntity(dto.data!);
    await _secureStorage.saveToken(token);
    return user;
  }
}
```

### 4. Use Case (Business Action)

```
┌─────────────────────────┐
│      USE CASE           │
│  (Business Action)      │
│                         │
│  class LoginUseCase {  │
│                         │
│    call(...) {          │  ← Business action:
│      // Validate        │     "Login user"
│      // Rules           │
│      return repository     │
│        .login(...);     │
│    }                    │
│  }                      │
└─────────────────────────┘

Location: domain/usecases/login_usecase.dart
Purpose: Single business action with rules
```

**Real Example:**
```dart
class LoginUseCase {
  final AuthRepository _repository;
  
  Future<User> call(String email, String password) async {
    // Business Rule 1: Validate email
    if (!ValidationUtils.isValidEmail(email)) {
      throw ValidationFailure('Invalid email');
    }
    
    // Business Rule 2: Validate password
    if (password.length < 8) {
      throw ValidationFailure('Password too short');
    }
    
    // Business Rule 3: Execute login
    return await _repository.login(email, password);
  }
}
```

## 🔄 How They Work Together

### Complete Flow Diagram:

```
┌─────────────────────────────────────────────────────────┐
│                    USER INTERACTION                      │
│  User enters email/password → Taps "Login"             │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 1. Dispatch Event
                     ▼
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                    │
│  LoginPage → AuthBloc                                   │
│                                                          │
│  AuthBloc receives LoginRequested event                 │
│  └─> Option 1: Direct to Repository (current)           │
│  └─> Option 2: Through Use Case (recommended)          │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 2. Call Use Case (optional)
                     ▼
┌─────────────────────────────────────────────────────────┐
│                    DOMAIN LAYER                          │
│                                                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │  LoginUseCase (Business Action)                  │  │
│  │  - Validates email format                        │  │
│  │  - Validates password length                     │  │
│  │  - Calls repository                              │  │
│  └──────────────────┬───────────────────────────────┘  │
│                     │                                    │
│                     │ 3. Uses Contract                   │
│                     ▼                                    │
│  ┌──────────────────────────────────────────────────┐  │
│  │  AuthRepository (CONTRACT)                       │  │
│  │  abstract class AuthRepository {                 │  │
│  │    Future<User> login(...);  ← Promise           │  │
│  │  }                                                │  │
│  └──────────────────┬───────────────────────────────┘  │
│                     │                                    │
│                     │ 4. Implemented by                 │
│                     ▼                                    │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 5. Implementation
                     ▼
┌─────────────────────────────────────────────────────────┐
│                     DATA LAYER                          │
│                                                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │  AuthRepositoryImpl (IMPLEMENTATION)             │  │
│  │  - Calls API Service                             │  │
│  │  - Parses DTO                                     │  │
│  │  - Converts to Entity                            │  │
│  │  - Saves to Storage                               │  │
│  └──────────────────┬───────────────────────────────┘  │
│                     │                                    │
│                     │ 6. Returns Entity                  │
│                     ▼                                    │
│  ┌──────────────────────────────────────────────────┐  │
│  │  User (ENTITY)                                   │  │
│  │  - id, email, name, etc.                         │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

## 🎓 Simple Analogy: Restaurant

### Restaurant Analogy:

```
ENTITY = Food Item
┌─────────────┐
│   Pizza     │  ← What it IS
│ - Ingredients│
│ - Price     │
└─────────────┘

CONTRACT = Menu
┌─────────────┐
│   Menu      │  ← What's AVAILABLE
│ - Pizza    │  ← Promise: "We serve pizza"
│ - Pasta    │
└─────────────┘

IMPLEMENTATION = Kitchen
┌─────────────┐
│   Kitchen   │  ← HOW it's made
│ - Recipe    │  ← Actually makes pizza
│ - Cooks     │
└─────────────┘

USE CASE = Recipe
┌─────────────┐
│   Recipe    │  ← HOW to make it
│ - Steps     │  ← Step-by-step instructions
│ - Rules     │
└─────────────┘
```

## 📁 File Structure with Examples

```
lib/features/auth/
│
├── domain/                          # BUSINESS LOGIC
│   │
│   ├── entities/                    # WHAT things ARE
│   │   └── user.dart               # User entity
│   │       class User {            # ← ENTITY
│   │         String id;
│   │         String email;
│   │       }
│   │
│   ├── repositories/               # CONTRACTS (Promises)
│   │   └── auth_repository.dart   # Contract
│   │       abstract class         # ← CONTRACT
│   │         AuthRepository {
│   │         Future<User> login(...);
│   │       }
│   │
│   └── usecases/                  # BUSINESS ACTIONS
│       └── login_usecase.dart     # Use Case
│           class LoginUseCase {   # ← USE CASE
│             Future<User> call(...) {
│               // Business rules
│               return repository.login(...);
│             }
│           }
│
└── data/                           # IMPLEMENTATION
    └── repositories/
        └── auth_repository_impl.dart  # Implementation
            class AuthRepositoryImpl   # ← IMPLEMENTATION
              implements AuthRepository {
              Future<User> login(...) {
                // Actual code: API call, etc.
              }
            }
```

## 🔑 Key Differences

### Entity vs DTO

```
ENTITY (Domain)              DTO (Data)
┌──────────────┐            ┌──────────────┐
│   User       │            │ UserDataDto  │
│              │            │              │
│ id: String   │            │ id: String?  │
│ email: String│            │ email: String?│
│ createdAt:   │            │ createdAt:   │
│   DateTime   │            │   String?    │
└──────────────┘            └──────────────┘
Business logic              API structure
```

### Contract vs Implementation

```
CONTRACT                    IMPLEMENTATION
┌──────────────┐            ┌──────────────┐
│ AuthRepository│           │AuthRepository│
│ (abstract)   │            │Impl          │
│              │            │              │
│ login() {    │            │ login() {    │
│   // Empty   │            │   // Actual  │
│ }            │            │   // code    │
└──────────────┘            └──────────────┘
What you can do            How you do it
```

## 💡 Quick Reference Card

```
┌─────────────────────────────────────────┐
│     CLEAN ARCHITECTURE QUICK REF        │
├─────────────────────────────────────────┤
│                                         │
│  ENTITY = What things ARE               │
│  Location: domain/entities/             │
│  Example: User                          │
│                                         │
│  CONTRACT = What you CAN DO             │
│  Location: domain/repositories/         │
│  Example: AuthRepository (abstract)     │
│                                         │
│  IMPLEMENTATION = HOW you do it         │
│  Location: data/repositories/           │
│  Example: AuthRepositoryImpl            │
│                                         │
│  USE CASE = Business action            │
│  Location: domain/usecases/             │
│  Example: LoginUseCase                  │
│                                         │
└─────────────────────────────────────────┘
```

## 🎯 Remember This

1. **Entity** = Business object (User)
2. **Contract** = Promise/Interface (AuthRepository)
3. **Implementation** = Actual code (AuthRepositoryImpl)
4. **Use Case** = Business action (LoginUseCase)

**The Flow:**
```
UI → Use Case → Contract → Implementation → Entity → Back to UI
```

**Dependency Rule:**
```
Inner layers (Domain) don't depend on outer layers
Outer layers (Data, Presentation) depend on inner layers
```

## ✅ You Already Have It!

Your code already follows Clean Architecture:
- ✅ Entity: `User` in `domain/entities/user.dart`
- ✅ Contract: `AuthRepository` in `domain/repositories/auth_repository.dart`
- ✅ Implementation: `AuthRepositoryImpl` in `data/repositories/auth_repository_impl.dart`
- 💡 Use Case: `LoginUseCase` example created (optional)

You're doing it right! 🎉

