import 'package:equatable/equatable.dart';

/// Home Item Entity
/// Represents an item displayed on the home page
/// Domain layer entity - pure business logic
class HomeItem extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final DateTime createdAt;

  const HomeItem({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, description, imageUrl, createdAt];
}

