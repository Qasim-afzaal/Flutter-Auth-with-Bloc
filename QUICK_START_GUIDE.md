# Quick Start Guide - Clean Architecture Concepts

## 🎯 The 4 Things You Need to Know

### 1. Entity = What Things Are

**Simple Answer:** A business object that represents something in your app.

**In Your Code:**
```dart
// domain/entities/user.dart
class User {
  final String id;
  final String email;
  final String name;
}
```

**Think:** "A User IS a person with id, email, and name"

---

### 2. Contract = What You Can Do (Promise)

**Simple Answer:** A promise that says "I will have these methods"

**In Your Code:**
```dart
// domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<User> login(String email, String password);
  // Promise: "I will have a login method"
}
```

**Think:** "I PROMISE to have a login method" (but don't say how)

---

### 3. Implementation = How You Do It

**Simple Answer:** The actual code that fulfills the promise

**In Your Code:**
```dart
// data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<User> login(String email, String password) async {
    // HERE'S HOW: Call API, parse response, save token
    final response = await _apiService.post('/auth/login', {...});
    // ... actual code ...
    return user;
  }
}
```

**Think:** "HERE'S HOW I actually login" (the real work)

---

### 4. Use Case = Business Action (Optional)

**Simple Answer:** A single business action with rules

**In Your Code:**
```dart
// domain/usecases/login_usecase.dart
class LoginUseCase {
  Future<User> call(String email, String password) async {
    // Business Rule 1: Validate email
    if (!isValidEmail(email)) throw Error('Invalid email');
    
    // Business Rule 2: Validate password
    if (password.length < 8) throw Error('Password too short');
    
    // Business Rule 3: Execute login
    return await repository.login(email, password);
  }
}
```

**Think:** "HOW to login: validate first, then login"

---

## 🔄 The Flow (Super Simple)

```
1. UI: User taps "Login"
   ↓
2. BLoC: Receives event
   ↓
3. Use Case (optional): Validates email/password
   ↓
4. Contract: "I need login method"
   ↓
5. Implementation: Actually calls API
   ↓
6. Entity: Returns User object
   ↓
7. Back to UI: Shows user info
```

## 📁 Where Everything Lives

```
domain/
  ├── entities/        ← Entity (User)
  ├── repositories/     ← Contract (AuthRepository)
  └── usecases/        ← Use Case (LoginUseCase)

data/
  └── repositories/    ← Implementation (AuthRepositoryImpl)
```

## 🎓 Real-World Example

**Restaurant Analogy:**

- **Entity** = Pizza (what it IS)
- **Contract** = Menu (what's available)
- **Implementation** = Kitchen (how it's made)
- **Use Case** = Recipe (step-by-step)

**In Your App:**

- **Entity** = User (what a user IS)
- **Contract** = AuthRepository (what you can do)
- **Implementation** = AuthRepositoryImpl (how you do it)
- **Use Case** = LoginUseCase (how to login)

## ✅ Quick Check

| Question | Answer |
|----------|--------|
| What is an Entity? | Business object (User) |
| What is a Contract? | Promise/Interface (AuthRepository) |
| What is Implementation? | Actual code (AuthRepositoryImpl) |
| What is Use Case? | Business action (LoginUseCase) |

## 📚 Learn More

- **CLEAN_ARCHITECTURE_FOR_BEGINNERS.md** - Detailed explanation
- **CONCEPTS_EXPLAINED.md** - Simple examples
- **CLEAN_ARCHITECTURE_VISUAL.md** - Visual diagrams

## 🎯 Remember

1. **Entity** = What things ARE
2. **Contract** = What you CAN DO
3. **Implementation** = HOW you do it
4. **Use Case** = Business action with rules

**You already have all of these in your code!** 🎉

