# Clean Architecture for Beginners

## 🎓 What is Clean Architecture?

Clean Architecture is a way to organize your code so that:
- Business logic doesn't depend on UI or database
- Code is easy to test
- Code is easy to maintain
- You can change UI or database without breaking business logic

Think of it like an **onion** with layers:

```
┌─────────────────────────────────────┐
│      OUTER LAYER (UI, Database)     │  ← Changes often
│                                     │
│  ┌───────────────────────────────┐  │
│  │   MIDDLE LAYER (Use Cases)    │  │  ← Business rules
│  │                                │  │
│  │  ┌─────────────────────────┐  │  │
│  │  │  INNER LAYER (Entities) │  │  │  ← Core, never changes
│  │  │                         │  │  │
│  │  └─────────────────────────┘  │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

## 📚 Key Concepts Explained

### 1. Entity (Domain Layer)

**What is it?**
- A **business object** that represents something important in your app
- Contains **business rules** and **data**
- **Never changes** based on UI or database

**Example from your code:**
```dart
// lib/features/auth/domain/entities/user.dart
class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final DateTime createdAt;
  
  // This is a business entity - represents a USER in your business logic
}
```

**Why it's important:**
- Represents **what** a user is in your business
- Doesn't care about UI or database
- Can be used anywhere in your app

**Real-world analogy:**
Think of a **Person** in real life:
- A person has: name, age, address (these are properties)
- These properties don't change based on how you display them (UI)
- These properties don't change based on where you store them (database)

### 2. Repository Contract/Interface (Domain Layer)

**What is it?**
- A **contract** (promise) that says "I will provide these methods"
- Defines **what** you can do, not **how** you do it
- Like a **menu** at a restaurant - tells you what's available, not how it's cooked

**Example from your code:**
```dart
// lib/features/auth/domain/repositories/auth_repository.dart
abstract class AuthRepository {
  // This is a CONTRACT - it says "I promise to have a login method"
  Future<User> login(String email, String password);
}
```

**Why it's important:**
- Business logic depends on the **contract**, not the implementation
- You can change how login works without changing business logic
- Easy to test (you can create a fake implementation)

**Real-world analogy:**
Think of a **Bank Account Contract**:
- Contract says: "You can deposit money, withdraw money, check balance"
- It doesn't say HOW the bank does it (database, API, etc.)
- You can change the bank's system without changing the contract

### 3. Repository Implementation (Data Layer)

**What is it?**
- The **actual implementation** of the contract
- Does the **real work** (calls API, saves to database)
- Implements the contract from domain layer

**Example from your code:**
```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  // This IMPLEMENTS the contract
  // It says "I will fulfill the promise to have a login method"
  
  @override
  Future<User> login(String email, String password) async {
    // Here's HOW we actually do login:
    // 1. Call API
    final response = await _apiService.post('/auth/login', {...});
    // 2. Parse response
    final dto = LoginResponseDto.fromJson(response);
    // 3. Convert to entity
    final user = UserMapper.toEntity(dto.data!);
    // 4. Save to storage
    await _secureStorage.saveToken(dto.data!.accessToken!);
    // 5. Return entity
    return user;
  }
}
```

**Why it's important:**
- Contains the **how** (implementation details)
- Can be changed without affecting business logic
- Handles API calls, database, etc.

**Real-world analogy:**
Think of a **Restaurant**:
- Contract (Menu): "We serve pizza"
- Implementation: The chef actually makes the pizza
- You can change the recipe without changing the menu

### 4. Use Case (Domain Layer) - Optional but Recommended

**What is it?**
- A **single business action** (like "Login User", "Get User Profile")
- Contains **business rules** for that action
- Uses repository to get data

**Example (not in your code yet, but recommended):**
```dart
// lib/features/auth/domain/usecases/login_usecase.dart
class LoginUseCase {
  final AuthRepository _repository;
  
  LoginUseCase(this._repository);
  
  // This is a USE CASE - a single business action
  Future<User> call(String email, String password) async {
    // Business rules:
    // 1. Validate email format
    if (!ValidationUtils.isValidEmail(email)) {
      throw ValidationFailure('Invalid email');
    }
    
    // 2. Validate password
    if (password.length < 8) {
      throw ValidationFailure('Password too short');
    }
    
    // 3. Call repository
    return await _repository.login(email, password);
  }
}
```

**Why it's important:**
- **Single Responsibility**: One use case = one action
- **Reusable**: Can be used in multiple places
- **Testable**: Easy to test business rules
- **Clear**: Makes code intention clear

**Real-world analogy:**
Think of a **Recipe**:
- Use Case = Recipe (step-by-step instructions)
- Entity = Ingredients (what you're working with)
- Repository = Where you get ingredients (store, garden, etc.)

## 🏗️ How They Work Together

### Simple Flow:

```
1. UI (Login Page)
   └─> "User wants to login"
   
2. Use Case (LoginUseCase) - Optional
   └─> "Validate email/password, then login"
   
3. Repository Contract (AuthRepository)
   └─> "I need a login method"
   
4. Repository Implementation (AuthRepositoryImpl)
   └─> "Here's how I login: call API, save token"
   
5. Entity (User)
   └─> "Here's the user data"
   
6. Back to UI
   └─> "Show user on screen"
```

### With Your Current Code:

```
1. UI: LoginPage
   └─> Dispatches LoginRequested event
   
2. BLoC: AuthBloc
   └─> Calls _authRepository.login()
   
3. Repository Contract: AuthRepository (interface)
   └─> Defines: Future<User> login(String, String)
   
4. Repository Implementation: AuthRepositoryImpl
   └─> Actually does: API call → Parse DTO → Convert to Entity → Save
   
5. Entity: User
   └─> Returns to BLoC
   
6. BLoC: Emits AuthAuthenticated(user)
   
7. UI: Shows home page with user info
```

## 📁 File Structure Explained

```
lib/features/auth/
│
├── domain/                    # BUSINESS LOGIC (Inner Layer)
│   ├── entities/             # What things ARE
│   │   └── user.dart        # User entity (business object)
│   │
│   ├── repositories/         # CONTRACTS (What you can do)
│   │   └── auth_repository.dart  # Contract: "I have login()"
│   │
│   └── usecases/            # BUSINESS ACTIONS (Optional)
│       └── login_usecase.dart  # "How to login" (business rules)
│
└── data/                     # IMPLEMENTATION (Outer Layer)
    └── repositories/        # ACTUAL IMPLEMENTATION
        └── auth_repository_impl.dart  # How login() actually works
```

## 🎯 Key Differences

### Entity vs DTO

| Entity (Domain) | DTO (Data) |
|----------------|------------|
| Business logic | API structure |
| Proper types (DateTime) | Strings, nullable |
| Required fields | All nullable |
| Never changes | Changes with API |

### Contract vs Implementation

| Contract (Interface) | Implementation |
|---------------------|----------------|
| **What** you can do | **How** you do it |
| In domain layer | In data layer |
| `abstract class` | `class implements` |
| No actual code | Actual code |

### Use Case vs Repository

| Use Case | Repository |
|----------|-----------|
| Business action | Data access |
| Contains rules | Gets/saves data |
| "Login user" | "Get user from API" |
| Optional but recommended | Required |

## 💡 Simple Examples

### Example 1: Entity

```dart
// This is WHAT a user IS in your business
class User {
  final String id;        // Required - every user has an ID
  final String email;     // Required - every user has email
  final DateTime createdAt; // Proper type, not String
}
```

### Example 2: Contract

```dart
// This is WHAT you can DO (promise)
abstract class AuthRepository {
  Future<User> login(String email, String password);
  // Promise: "I will have a login method"
}
```

### Example 3: Implementation

```dart
// This is HOW you do it (actual work)
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<User> login(String email, String password) async {
    // Actually call API, parse response, etc.
    final response = await apiService.post('/login', {...});
    return User.fromJson(response);
  }
}
```

### Example 4: Use Case (Recommended)

```dart
// This is the BUSINESS ACTION with rules
class LoginUseCase {
  final AuthRepository repository;
  
  Future<User> call(String email, String password) async {
    // Business rules first
    if (email.isEmpty) throw Error('Email required');
    if (password.length < 8) throw Error('Password too short');
    
    // Then do the action
    return await repository.login(email, password);
  }
}
```

## 🔄 Dependency Rule

**The Golden Rule of Clean Architecture:**

```
Inner layers can NEVER depend on outer layers
Outer layers CAN depend on inner layers
```

```
Domain Layer (Inner)
    ↑
    │ Domain depends on NOTHING
    │
Data Layer (Middle)
    ↑
    │ Data depends on Domain
    │
Presentation Layer (Outer)
    ↑
    │ Presentation depends on Domain + Data
```

**In your code:**
- ✅ Domain (User, AuthRepository) - depends on nothing
- ✅ Data (AuthRepositoryImpl) - depends on Domain
- ✅ Presentation (BLoC, UI) - depends on Domain

## 🎓 Learning Path

### Step 1: Understand Entities
- Entities = Business objects (User, Product, Order)
- They represent **what things are**

### Step 2: Understand Contracts
- Contracts = Interfaces (AuthRepository)
- They define **what you can do**

### Step 3: Understand Implementation
- Implementation = Actual code (AuthRepositoryImpl)
- They define **how you do it**

### Step 4: Understand Use Cases (Optional)
- Use Cases = Business actions (LoginUseCase)
- They contain **business rules**

## 📝 Quick Reference

| Concept | What It Is | Where It Lives | Example |
|---------|-----------|----------------|---------|
| **Entity** | Business object | `domain/entities/` | `User` |
| **Contract** | Interface/Promise | `domain/repositories/` | `AuthRepository` |
| **Implementation** | Actual code | `data/repositories/` | `AuthRepositoryImpl` |
| **Use Case** | Business action | `domain/usecases/` | `LoginUseCase` |
| **DTO** | API structure | `data/models/` | `UserDataDto` |
| **Mapper** | Converter | `data/mappers/` | `UserMapper` |

## ✅ Summary

1. **Entity** = What things ARE (User, Product)
2. **Contract** = What you CAN DO (AuthRepository interface)
3. **Implementation** = HOW you do it (AuthRepositoryImpl)
4. **Use Case** = Business action with rules (LoginUseCase) - Optional but recommended
5. **DTO** = API structure (UserDataDto)
6. **Mapper** = Converts DTO → Entity

**Remember:**
- Inner layers (Domain) don't depend on outer layers
- Outer layers (Data, Presentation) depend on inner layers
- Contracts define what, implementations define how

## 🚀 Next Steps

1. ✅ You already have: Entity, Contract, Implementation
2. 💡 Consider adding: Use Cases (for business rules)
3. 📚 Read the code: See how they work together
4. 🧪 Practice: Try creating a new feature following this pattern

You're already following Clean Architecture! You just need to understand the concepts. 🎉

