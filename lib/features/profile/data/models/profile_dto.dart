/// Profile DTO (Data Transfer Object)
/// Represents the profile structure from API response
class ProfileDto {
  final String? id;
  final String? name;
  final String? email;
  final String? avatar;
  final String? bio;
  final String? createdAt;

  ProfileDto({
    this.id,
    this.name,
    this.email,
    this.avatar,
    this.bio,
    this.createdAt,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) {
    return ProfileDto(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      avatar: json['avatar']?.toString() ?? json['profile_image_url']?.toString(),
      bio: json['bio']?.toString(),
      createdAt: json['created_at']?.toString() ?? json['createdAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'bio': bio,
      'created_at': createdAt,
    };
  }
}

