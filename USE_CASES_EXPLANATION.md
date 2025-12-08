# What Are Use Cases?

## 🤔 Simple Explanation

**Use Case** = A single business action or operation

Think of it like this:
- **Repository** = "How to get data" (data access)
- **Use Case** = "What to do with data" (business rules)

---

## 📝 Real-World Analogy

### Without Use Case (What You Have Now):

**Like ordering food directly from kitchen:**
```
You → Kitchen (Repository)
"Give me food!"
Kitchen gives you raw ingredients
You cook it yourself
```

### With Use Case:

**Like ordering from a restaurant:**
```
You → Waiter (Use Case) → Kitchen (Repository)
"Order a pizza"
Waiter validates order, checks menu, then asks kitchen
Kitchen prepares food
Waiter brings it to you
```

**The waiter (Use Case) adds business rules:**
- Is the item on the menu? (validation)
- Do you have enough money? (business rule)
- Is the restaurant open? (business rule)

---

## 🎯 What Use Cases Do

### 1. Contain Business Rules

**Example: Login Use Case**

```dart
class LoginUseCase {
  final AuthRepository _repository;
  
  LoginUseCase(this._repository);
  
  Future<User> call(String email, String password) async {
    // Business Rule 1: Validate email format
    if (!isValidEmail(email)) {
      throw ValidationFailure('Invalid email');
    }
    
    // Business Rule 2: Validate password strength
    if (password.length < 8) {
      throw ValidationFailure('Password too short');
    }
    
    // Business Rule 3: Check if account is locked
    if (await _isAccountLocked(email)) {
      throw AccountLockedFailure('Account is locked');
    }
    
    // Business Rule 4: Execute login
    return await _repository.login(email, password);
  }
}
```

**What it does:**
- Validates input (business rules)
- Checks business conditions
- Then calls repository

---

## 🏗️ Clean Architecture Layers

### Without Use Case (Your Current Structure):

```
Presentation (BLoC)
    ↓
Repository (Data Access)
    ↓
API/Database
```

**Flow:**
```
BLoC → Repository → API
```

### With Use Case:

```
Presentation (BLoC)
    ↓
Use Case (Business Rules)
    ↓
Repository (Data Access)
    ↓
API/Database
```

**Flow:**
```
BLoC → Use Case → Repository → API
```

---

## 📊 Comparison

### Current Approach (BLoC → Repository):

```dart
// In AuthBloc
Future<void> _onLoginRequested(...) async {
  emit(AuthLoading());
  
  // Validation in BLoC (not ideal)
  if (email.isEmpty) {
    emit(AuthError('Email required'));
    return;
  }
  
  // Business logic in BLoC (not ideal)
  final user = await _repository.login(email, password);
  emit(AuthAuthenticated(user));
}
```

**Problems:**
- Business rules in BLoC (presentation layer)
- Hard to test business logic separately
- BLoC does too much

### With Use Case:

```dart
// In AuthBloc
Future<void> _onLoginRequested(...) async {
  emit(AuthLoading());
  
  try {
    // Use Case handles all business rules
    final user = await _loginUseCase(email, password);
    emit(AuthAuthenticated(user));
  } catch (e) {
    emit(AuthError(e.toString()));
  }
}

// In LoginUseCase (Domain Layer)
Future<User> call(String email, String password) async {
  // All business rules here
  if (!isValidEmail(email)) throw ValidationFailure(...);
  if (password.length < 8) throw ValidationFailure(...);
  
  return await _repository.login(email, password);
}
```

**Benefits:**
- Business rules in domain layer (correct place)
- Easy to test business logic
- BLoC only handles UI state

---

## 🎯 When to Use Use Cases

### Use Use Cases When:

1. **Complex Business Logic**
   - Multiple validation rules
   - Business conditions to check
   - Example: Login with account lockout, password reset

2. **Multiple Business Rules**
   - Validation
   - Authorization
   - Business conditions
   - Example: E-commerce checkout

3. **Reusable Business Logic**
   - Same logic used in multiple places
   - Example: User validation used in login and signup

4. **Large Projects**
   - Need clear separation
   - Multiple developers
   - Example: Enterprise apps

### Don't Need Use Cases When:

1. **Simple Operations**
   - Just get data, no business rules
   - Example: Simple CRUD operations

2. **Small Projects**
   - Over-engineering
   - Example: Your current auth app

3. **No Business Rules**
   - Just data access
   - Example: Simple data fetching

---

## 📝 Example: When You Would Need Use Cases

### Scenario: Complex Login with Business Rules

**Without Use Case (Current):**
```dart
// All logic in BLoC (bad)
Future<void> _onLoginRequested(...) async {
  // Validation
  if (!isValidEmail(email)) { ... }
  
  // Check account lockout
  if (await _isAccountLocked(email)) { ... }
  
  // Check password attempts
  if (await _getFailedAttempts(email) > 5) { ... }
  
  // Rate limiting
  if (await _isRateLimited(email)) { ... }
  
  // Finally login
  final user = await _repository.login(...);
}
```

**With Use Case (Better):**
```dart
// BLoC (simple)
Future<void> _onLoginRequested(...) async {
  emit(AuthLoading());
  try {
    final user = await _loginUseCase(email, password);
    emit(AuthAuthenticated(user));
  } catch (e) {
    emit(AuthError(e.toString()));
  }
}

// Use Case (all business rules)
class LoginUseCase {
  Future<User> call(String email, String password) async {
    // All business rules here
    _validateEmail(email);
    _checkAccountLockout(email);
    _checkFailedAttempts(email);
    _checkRateLimit(email);
    
    return await _repository.login(email, password);
  }
}
```

---

## 🎓 Your Current Project

### Do You Need Use Cases?

**Answer: No, not yet!**

**Why:**
- Your login/signup is simple
- No complex business rules
- BLoC → Repository is fine for now
- Adding use cases would be over-engineering

**When to Add:**
- If you add complex business rules
- If you need to reuse business logic
- If project grows larger

---

## 📊 Use Case Structure

### If You Add Use Cases Later:

```
lib/features/auth/domain/
├── entities/
│   └── user.dart
├── repositories/
│   └── auth_repository.dart
└── usecases/                    ← Add this when needed
    ├── login_usecase.dart
    └── register_usecase.dart
```

### Use Case Template:

```dart
class LoginUseCase {
  final AuthRepository _repository;
  
  LoginUseCase(this._repository);
  
  /// Executes login with business rules
  Future<User> call(String email, String password) async {
    // Business Rule 1: Validate
    if (!isValidEmail(email)) {
      throw ValidationFailure('Invalid email');
    }
    
    // Business Rule 2: Check conditions
    // ... more business rules
    
    // Business Rule 3: Execute
    return await _repository.login(email, password);
  }
}
```

---

## 🔑 Key Takeaways

### Use Cases Are:

1. **Business Logic Layer**
   - Contains business rules
   - Validates input
   - Checks conditions

2. **Between BLoC and Repository**
   - BLoC → Use Case → Repository
   - Use Case adds business rules

3. **Optional for Simple Projects**
   - Not always needed
   - Add when complexity grows

4. **Domain Layer**
   - Part of Clean Architecture
   - Independent of UI and data

---

## ✅ Summary

**What Use Cases Are:**
- Business logic layer
- Contains business rules
- Between presentation and data layers

**When to Use:**
- Complex business logic
- Multiple business rules
- Large projects

**Your Project:**
- Don't need them yet
- Current structure is fine
- Add later if needed

**Remember:**
- **Repository** = How to get data
- **Use Case** = What to do with data (business rules)
- **BLoC** = UI state management

You're doing great without use cases for now! Add them when your project grows more complex! 🎯

