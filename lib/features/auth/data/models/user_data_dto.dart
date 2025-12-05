/// User Data DTO (Data Transfer Object)
/// Represents the user data structure from API response
/// This is the data layer model that matches the API response format
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

  UserDataDto({
    this.id,
    this.name,
    this.email,
    this.authProvider,
    this.gender,
    this.age,
    this.profileImageUrl,
    this.createdAt,
    this.updatedAt,
    this.accessToken,
  });

  /// Creates UserDataDto from JSON map
  factory UserDataDto.fromJson(Map<String, dynamic> json) {
    return UserDataDto(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      authProvider: json['auth_provider']?.toString(),
      gender: json['gender']?.toString(),
      age: json['age']?.toString(),
      profileImageUrl: json['profile_image_url']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      accessToken: json['access_token']?.toString(),
    );
  }

  /// Converts UserDataDto to JSON map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['auth_provider'] = authProvider;
    data['gender'] = gender;
    data['age'] = age;
    data['profile_image_url'] = profileImageUrl;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['access_token'] = accessToken;
    return data;
  }

  /// Creates a copy of UserDataDto with updated fields
  UserDataDto copyWith({
    String? id,
    String? name,
    String? email,
    String? authProvider,
    String? gender,
    String? age,
    String? profileImageUrl,
    String? createdAt,
    String? updatedAt,
    String? accessToken,
  }) {
    return UserDataDto(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      authProvider: authProvider ?? this.authProvider,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      accessToken: accessToken ?? this.accessToken,
    );
  }
}

