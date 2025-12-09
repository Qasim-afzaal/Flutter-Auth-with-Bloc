/// Home Item DTO (Data Transfer Object)
/// Represents the home item structure from API response
/// This is the data layer model that matches the API response format
class HomeItemDto {
  final String? id;
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? createdAt;

  HomeItemDto({
    this.id,
    this.title,
    this.description,
    this.imageUrl,
    this.createdAt,
  });

  /// Creates HomeItemDto from JSON map
  factory HomeItemDto.fromJson(Map<String, dynamic> json) {
    return HomeItemDto(
      id: json['id']?.toString(),
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      imageUrl: json['image_url']?.toString() ?? json['imageUrl']?.toString(),
      createdAt: json['created_at']?.toString() ?? json['createdAt']?.toString(),
    );
  }

  /// Converts HomeItemDto to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'created_at': createdAt,
    };
  }
}

