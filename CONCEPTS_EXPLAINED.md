# Clean Architecture Concepts - Simple Explanation

## 🎯 What You Asked About

You wanted to understand:
1. **Contract** (Repository Interface)
2. **Use Case**
3. **Entity**
4. How they all work together

## 📖 Concept 1: Entity

### What is an Entity?

An **Entity** is a business object that represents something important in your app.

**Think of it like this:**
- In real life: A **Person** has name, age, address
- In your app: A **User** has id, email, name

**In your code:**
```dart
// lib/features/auth/domain/entities/user.dart
class User {
  final String id;        // User's unique ID
  final String email;     // User's email
  final String name;      // User's name
  final DateTime createdAt; // When user was created
}
```

**Key Points:**
- ✅ Represents **what** a user IS
- ✅ Contains **business data**
- ✅ Doesn't care about UI or database
- ✅ Used everywhere in your app

**Real Example:**
```dart
// This is a User entity - represents a user in your business
User user = User(
  id: "123",
  email: "test@test.com",
  name: "John Doe",
  createdAt: DateTime.now(),
);
```

## 📖 Concept 2: Contract (Repository Interface)

### What is a Contract?

A **Contract** (also called Interface) is a **promise** that says "I will provide these methods."

**Think of it like this:**
- Restaurant **Menu** = Contract (tells you what's available)
- Restaurant **Kitchen** = Implementation (actually makes the food)

**In your code:**
```dart
// lib/features/auth/domain/repositories/auth_repository.dart
abstract class AuthRepository {
  // This is a CONTRACT - it promises to have a login method
  Future<User> login(String email, String password);
}
```

**Key Points:**
- ✅ Defines **what** you can do (not how)
- ✅ Uses `abstract class` (no implementation)
- ✅ Business logic depends on this (not implementation)
- ✅ Easy to test (can create fake implementation)

**Why it's important:**
```dart
// Business logic uses the CONTRACT
class AuthBloc {
  final AuthRepository _repository; // Uses contract
  
  void login() {
    _repository.login(email, password); // Uses contract, not implementation
  }
}

// You can change the implementation without changing business logic!
```

## 📖 Concept 3: Implementation (Repository Implementation)

### What is an Implementation?

An **Implementation** is the **actual code** that fulfills the contract.

**In your code:**
```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  // This IMPLEMENTS the contract
  // It says "I will actually do the login"
  
  @override
  Future<User> login(String email, String password) async {
    // HERE'S HOW we actually login:
    // 1. Call API
    final response = await _apiService.post('/auth/login', {...});
    // 2. Parse response
    final dto = LoginResponseDto.fromJson(response);
    // 3. Convert to entity
    final user = UserMapper.toEntity(dto.data!);
    // 4. Save token
    await _secureStorage.saveToken(dto.data!.accessToken!);
    // 5. Return user
    return user;
  }
}
```

**Key Points:**
- ✅ Implements the contract (`implements AuthRepository`)
- ✅ Contains **how** you do it (actual code)
- ✅ Can be changed without affecting business logic
- ✅ Handles API calls, database, etc.

## 📖 Concept 4: Use Case (Optional but Recommended)

### What is a Use Case?

A **Use Case** is a **single business action** with business rules.

**Think of it like this:**
- Use Case = Recipe (step-by-step instructions for one dish)
- Entity = Ingredients (what you're working with)
- Repository = Where you get ingredients

**Example (I created this for you):**
```dart
// lib/features/auth/domain/usecases/login_usecase.dart
class LoginUseCase {
  final AuthRepository _repository;
  
  LoginUseCase(this._repository);
  
  // This is a USE CASE - a single business action
  Future<User> call(String email, String password) async {
    // Business Rule 1: Validate email
    if (email.isEmpty) {
      throw ValidationFailure('Email is required');
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

**Key Points:**
- ✅ Represents **one business action** (Login)
- ✅ Contains **business rules** (validation)
- ✅ Uses repository to get data
- ✅ Reusable and testable

**Why it's useful:**
```dart
// Without Use Case (current):
// Business rules are in BLoC or Repository (mixed concerns)

// With Use Case (better):
// Business rules are in Use Case (clear separation)
class AuthBloc {
  final LoginUseCase _loginUseCase;
  
  void login() {
    _loginUseCase(email, password); // Use case handles all rules
  }
}
```

## 🔄 How They Work Together

### Complete Flow:

```
1. UI (Login Page)
   └─> User enters email/password
   
2. BLoC (AuthBloc)
   └─> Receives LoginRequested event
   
3. Use Case (LoginUseCase) - Optional
   └─> Validates email/password (business rules)
   └─> Calls repository
   
4. Repository Contract (AuthRepository)
   └─> Defines: "I have a login method"
   
5. Repository Implementation (AuthRepositoryImpl)
   └─> Actually does: API call → Parse → Save → Return
   
6. Entity (User)
   └─> Returns to BLoC
   
7. BLoC
   └─> Emits AuthAuthenticated(user)
   
8. UI
   └─> Shows home page
```

### Visual Representation:

```
┌─────────────────────────────────────────┐
│           PRESENTATION LAYER             │
│  UI → BLoC → Use Case (optional)        │
└──────────────────┬──────────────────────┘
                   │
                   │ Uses
                   ▼
┌─────────────────────────────────────────┐
│            DOMAIN LAYER                  │
│  Entity (User)                          │
│  Contract (AuthRepository)              │
│  Use Case (LoginUseCase)                │
└──────────────────┬──────────────────────┘
                   │
                   │ Implemented by
                   ▼
┌─────────────────────────────────────────┐
│             DATA LAYER                   │
│  Implementation (AuthRepositoryImpl)  │
│  DTOs (UserDataDto)                     │
│  Mapper (UserMapper)                    │
└─────────────────────────────────────────┘
```

## 🎓 Real-World Analogy

### Restaurant Analogy:

1. **Entity** = Food Item
   - "Pizza" is a food item (has ingredients, price, etc.)

2. **Contract** = Menu
   - Menu says "We serve Pizza" (what's available)

3. **Implementation** = Kitchen
   - Kitchen actually makes the pizza (how it's done)

4. **Use Case** = Recipe
   - Recipe says "How to make pizza" (step-by-step)

### In Your App:

1. **Entity** = User
   - "User" has id, email, name

2. **Contract** = AuthRepository
   - "I have a login method"

3. **Implementation** = AuthRepositoryImpl
   - "Here's how I login: call API, save token"

4. **Use Case** = LoginUseCase
   - "How to login: validate, then call repository"

## 📋 Quick Comparison Table

| Concept | What It Is | Where | Example |
|---------|-----------|-------|---------|
| **Entity** | Business object | `domain/entities/` | `User` |
| **Contract** | Promise/Interface | `domain/repositories/` | `AuthRepository` |
| **Implementation** | Actual code | `data/repositories/` | `AuthRepositoryImpl` |
| **Use Case** | Business action | `domain/usecases/` | `LoginUseCase` |

## 💡 Key Takeaways

1. **Entity** = What things ARE (User, Product)
2. **Contract** = What you CAN DO (AuthRepository interface)
3. **Implementation** = HOW you do it (AuthRepositoryImpl)
4. **Use Case** = Business action with rules (LoginUseCase)

**Remember:**
- Contract defines **what**
- Implementation defines **how**
- Entity defines **what things are**
- Use Case defines **business actions**

## 🚀 Your Current Code

You already have:
- ✅ **Entity**: `User` in `domain/entities/user.dart`
- ✅ **Contract**: `AuthRepository` in `domain/repositories/auth_repository.dart`
- ✅ **Implementation**: `AuthRepositoryImpl` in `data/repositories/auth_repository_impl.dart`
- 💡 **Use Case**: I created `LoginUseCase` as an example (optional)

You're already following Clean Architecture! 🎉

## 📚 Next Steps

1. Read the code examples above
2. Understand the flow
3. Try creating a new use case (like `LogoutUseCase`)
4. Practice with the concepts

The key is: **Contract = What, Implementation = How, Entity = What things are**

