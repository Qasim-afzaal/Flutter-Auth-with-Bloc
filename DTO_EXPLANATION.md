# DTO (Data Transfer Object) Pattern Explanation

## What is DTO?

DTO stands for **Data Transfer Object**. It's a design pattern used to transfer data between different layers of an application, especially between the API and your application.

## Why Use DTOs?

1. **Separation of Concerns**: API response structure is separate from domain entities
2. **Type Safety**: Strong typing for API responses
3. **Flexibility**: API can change without affecting domain logic
4. **Clean Architecture**: Follows Clean Architecture principles
5. **Maintainability**: Easier to maintain and test

## Architecture with DTOs

```
API Response (JSON)
       ↓
   DTO Layer (Data Transfer Objects)
       ↓
   Mapper (Converts DTO → Entity)
       ↓
   Domain Entity (Business Logic)
       ↓
   Repository (Returns Entity)
       ↓
   BLoC (Uses Entity)
       ↓
   UI (Displays Entity)
```

## Our Implementation

### 1. DTO Models (Data Layer)

**File:** `lib/features/auth/data/models/login_response_dto.dart`

```dart
class LoginResponseDto {
  final bool? success;
  final String? message;
  final UserDataDto? data;
  
  // fromJson, toJson methods
}
```

**File:** `lib/features/auth/data/models/user_data_dto.dart`

```dart
class UserDataDto {
  final String? id;
  final String? name;
  final String? email;
  final String? authProvider;
  final String? gender;
  final String? age;
  final String? profileImageUrl;
  final String? createdAt;
  final String? updatedAt;
  final String? accessToken;
  
  // fromJson, toJson methods
}
```

**Purpose:**
- Matches exactly with API response structure
- Handles nullable fields from API
- Provides type-safe parsing

### 2. Domain Entity (Domain Layer)

**File:** `lib/features/auth/domain/entities/user.dart`

```dart
class User {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? authProvider;
  final String? gender;
  final String? age;
  
  // Business logic representation
}
```

**Purpose:**
- Represents user in business logic
- Uses proper types (DateTime instead of String)
- Contains domain-specific logic

### 3. Mapper (Data Layer)

**File:** `lib/features/auth/data/mappers/user_mapper.dart`

```dart
class UserMapper {
  // Convert DTO → Entity
  static User toEntity(UserDataDto dto) {
    return User(
      id: dto.id ?? '',
      email: dto.email ?? '',
      // ... converts and validates
    );
  }
  
  // Convert Entity → DTO (if needed)
  static UserDataDto toDto(User entity) {
    // ...
  }
}
```

**Purpose:**
- Converts between DTO and Entity
- Handles type conversions (String → DateTime)
- Validates and transforms data

## Complete Flow with DTOs

### Step 1: API Response

```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "id": "123",
    "name": "John Doe",
    "email": "john@example.com",
    "auth_provider": "email",
    "gender": "male",
    "age": "25",
    "profile_image_url": "https://...",
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-02T00:00:00Z",
    "access_token": "eyJhbGciOiJIUzI1NiIs..."
  }
}
```

### Step 2: Parse to DTO

```dart
// In Repository
final response = await _apiService.post('/auth/login', {...});

// Parse JSON to DTO
final loginResponseDto = LoginResponseDto.fromJson(response);
// loginResponseDto.data is UserDataDto
```

### Step 3: Convert DTO to Entity

```dart
// Use mapper to convert DTO to Domain Entity
final user = UserMapper.toEntity(loginResponseDto.data!);
// Now we have a User entity with proper types
```

### Step 4: Use Entity in Business Logic

```dart
// Repository returns User entity
return user;

// BLoC receives User entity
emit(AuthAuthenticated(user));

// UI displays User entity
Text(user.name)
```

## Benefits of This Approach

### 1. **Type Safety**

```dart
// DTO handles nullable API fields
UserDataDto dto = UserDataDto.fromJson(json);
String? email = dto.email; // Can be null

// Entity ensures required fields
User user = UserMapper.toEntity(dto);
String email = user.email; // Always non-null (validated in mapper)
```

### 2. **Separation of Concerns**

- **DTO**: Matches API structure exactly
- **Entity**: Matches business logic needs
- **Mapper**: Handles conversion between them

### 3. **Easy Testing**

```dart
// Test DTO parsing
test('LoginResponseDto parses correctly', () {
  final json = {'success': true, 'data': {...}};
  final dto = LoginResponseDto.fromJson(json);
  expect(dto.success, true);
});

// Test mapper
test('UserMapper converts DTO to Entity', () {
  final dto = UserDataDto(id: '123', email: 'test@test.com', ...);
  final user = UserMapper.toEntity(dto);
  expect(user.id, '123');
});
```

### 4. **API Changes Don't Break Domain Logic**

If API changes:
- Update DTO only
- Update mapper if needed
- Domain entity stays the same
- Business logic unaffected

## File Structure

```
lib/features/auth/
├── data/
│   ├── models/              # DTOs (Data Transfer Objects)
│   │   ├── login_response_dto.dart
│   │   └── user_data_dto.dart
│   ├── mappers/             # Converters
│   │   └── user_mapper.dart
│   └── repositories/
│       └── auth_repository_impl.dart
│
└── domain/
    └── entities/            # Domain Entities
        └── user.dart
```

## Usage Example

### In Repository

```dart
Future<User> login(String email, String password) async {
  // 1. Make API call
  final response = await _apiService.post('/auth/login', {...});
  
  // 2. Parse to DTO
  final loginResponseDto = LoginResponseDto.fromJson(response);
  
  // 3. Validate
  if (loginResponseDto.data == null) {
    throw AuthFailure('No user data received');
  }
  
  // 4. Convert DTO to Entity
  final user = UserMapper.toEntity(loginResponseDto.data!);
  
  // 5. Save token
  if (loginResponseDto.data!.accessToken != null) {
    await _secureStorage.saveToken(loginResponseDto.data!.accessToken!);
  }
  
  // 6. Return Entity
  return user;
}
```

## Key Points

1. **DTOs are in the Data Layer**: They represent API structure
2. **Entities are in the Domain Layer**: They represent business logic
3. **Mappers convert between them**: Handles type conversions and validation
4. **Repository uses DTOs**: Parses API response, converts to Entity
5. **BLoC uses Entities**: Business logic works with domain entities
6. **UI uses Entities**: Displays domain entities

## Best Practices

1. ✅ **DTOs match API exactly**: Field names, types, structure
2. ✅ **Entities use proper types**: DateTime instead of String
3. ✅ **Mappers handle validation**: Ensure required fields exist
4. ✅ **Null safety**: Handle nullable API fields properly
5. ✅ **Type conversion**: Convert String dates to DateTime in mapper
6. ✅ **Error handling**: Validate DTO data before converting

## Summary

DTOs provide a clean way to:
- Parse API responses type-safely
- Separate API structure from business logic
- Handle API changes without breaking domain logic
- Maintain clean architecture principles

The flow is: **API → DTO → Mapper → Entity → BLoC → UI**

