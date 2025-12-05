# User Entity Explanation

## What is the User Entity?

The `User` entity in `lib/features/auth/domain/entities/user.dart` is a **Domain Entity** - it represents a user in your business logic.

## Why Do We Need It?

### 1. **Business Logic Representation**

```dart
class User {
  final String id;           // User's unique identifier
  final String email;        // User's email address
  final String name;         // User's name
  final String? avatar;      // User's profile image URL
  final DateTime createdAt;  // When user was created
  // ... more fields
}
```

This is how your **business logic** thinks about a user - not as JSON, but as a structured object with proper types.

### 2. **Separation from API**

- **DTO (UserDataDto)**: Matches API response exactly (nullable strings, API field names)
- **User Entity**: Matches business logic needs (proper types, required fields)

### 3. **Type Safety**

```dart
// DTO (from API) - nullable, strings
UserDataDto dto = UserDataDto.fromJson(apiResponse);
String? email = dto.email;  // Can be null
String? createdAt = dto.createdAt;  // String, not DateTime

// Entity (business logic) - validated, proper types
User user = UserMapper.toEntity(dto);
String email = user.email;  // Always non-null (validated)
DateTime createdAt = user.createdAt;  // Proper DateTime type
```

## How It's Used

### Flow:

```
1. API Response (JSON)
   ↓
2. UserDataDto.fromJson()  ← Parse API response
   ↓
3. UserMapper.toEntity()   ← Convert to business entity
   ↓
4. User Entity              ← Used in business logic
   ↓
5. BLoC uses User           ← State management
   ↓
6. UI displays User         ← Show user info
```

### Example Usage:

```dart
// In Repository
final user = UserMapper.toEntity(loginResponseDto.data!);
return user;  // Return domain entity

// In BLoC
emit(AuthAuthenticated(user));  // Use domain entity

// In UI
Text(user.name)  // Display user name
Text(user.email) // Display user email
```

## Why User.fromJson() Exists

The `User.fromJson()` method is kept for **backward compatibility** and is used when:

1. **Loading from Secure Storage**: When app restarts, we load user data from storage
2. **Legacy Code**: If any old code still uses it
3. **Fallback**: If DTO parsing fails, we can fall back to this

```dart
// In AuthBloc - loading from secure storage
final userData = await _secureStorage.getUserData();
final user = User.fromJson(userData);  // Used here!
```

## Key Points

1. ✅ **User Entity** = Business logic representation
2. ✅ **UserDataDto** = API response representation
3. ✅ **UserMapper** = Converts between them
4. ✅ **User.fromJson()** = Used for secure storage loading

## Summary

- **User Entity** is essential - it's your business logic representation
- It's different from DTO (which matches API)
- Mapper converts DTO → Entity
- Entity is used throughout the app (BLoC, UI, etc.)

