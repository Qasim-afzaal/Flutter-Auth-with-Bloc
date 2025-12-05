import 'user_data_dto.dart';

/// Login Response DTO (Data Transfer Object)
/// Represents the complete login API response structure
/// This is the data layer model that matches the API response format
class LoginResponseDto {
  final bool? success;
  final String? message;
  final UserDataDto? data;

  LoginResponseDto({
    this.success,
    this.message,
    this.data,
  });

  /// Creates LoginResponseDto from JSON map
  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      success: json['success'] as bool?,
      message: json['message']?.toString(),
      data: json['data'] != null
          ? UserDataDto.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Converts LoginResponseDto to JSON map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }

  /// Creates a copy of LoginResponseDto with updated fields
  LoginResponseDto copyWith({
    bool? success,
    String? message,
    UserDataDto? data,
  }) {
    return LoginResponseDto(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}

