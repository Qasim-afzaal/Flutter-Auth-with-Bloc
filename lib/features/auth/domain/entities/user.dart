import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final DateTime createdAt;
  
  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    required this.createdAt,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    DateTime parseCreatedAt(dynamic dateValue) {
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
      avatar: json['avatar']?.toString(),
      createdAt: parseCreatedAt(
        json['created_at'] ?? json['createdAt'] ?? json['created'],
      ),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'created_at': createdAt.toIso8601String(),
    };
  }
  
  @override
  List<Object?> get props => [id, email, name, avatar, createdAt];
}
