import 'package:equatable/equatable.dart';

/// User Domain Entity
/// Represents a user in the domain layer
/// This is the business logic representation of a user
class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? authProvider;
  final String? gender;
  final String? age;
  
  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    required this.createdAt,
    this.updatedAt,
    this.authProvider,
    this.gender,
    this.age,
  });
  
  /// Creates User from JSON map (for backward compatibility)
  /// Note: Prefer using UserMapper.toEntity() from DTO
  factory User.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic dateValue) {
      if (dateValue == null) {
        return DateTime.now();
      }
      if (dateValue is String) {
        try {
          return DateTime.parse(dateValue);
        } catch (_) {
          return DateTime.now();
        }
      }
      if (dateValue is DateTime) {
        return dateValue;
      }
      return DateTime.now();
    }

    return User(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? json['username']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? json['profile_image_url']?.toString(),
      createdAt: parseDate(
        json['created_at'] ?? json['createdAt'] ?? json['created'],
      ),
      updatedAt: parseDate(
        json['updated_at'] ?? json['updatedAt'] ?? json['updated'],
      ),
      authProvider: json['auth_provider']?.toString() ?? json['authProvider']?.toString(),
      gender: json['gender']?.toString(),
      age: json['age']?.toString(),
    );
  }
  
  /// Converts User to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'profile_image_url': avatar,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'auth_provider': authProvider,
      'gender': gender,
      'age': age,
    };
  }
  
  @override
  List<Object?> get props => [
        id,
        email,
        name,
        avatar,
        createdAt,
        updatedAt,
        authProvider,
        gender,
        age,
      ];
}
