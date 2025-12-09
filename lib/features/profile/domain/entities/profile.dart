import 'package:equatable/equatable.dart';

/// Profile Entity
/// Represents user profile information
/// Domain layer entity - pure business logic
class Profile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String? bio;
  final DateTime createdAt;

  const Profile({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.bio,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, email, avatar, bio, createdAt];
}

