import '../../../../core/errors/failures.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_dto.dart';
import '../mappers/profile_mapper.dart';

/// Profile Repository Implementation
/// Implements the ProfileRepository interface
class ProfileRepositoryImpl implements ProfileRepository {
  final SecureStorageService _secureStorage;

  ProfileRepositoryImpl({
    required SecureStorageService secureStorage,
  }) : _secureStorage = secureStorage;

  @override
  Future<Profile> getProfile() async {
    try {
      Logger.info('Fetching user profile');

      // Get user data from secure storage
      final userData = await _secureStorage.getUserData();
      
      if (userData == null || userData.isEmpty) {
        throw AuthFailure('No user data found');
      }

      // Convert to DTO then to Entity
      final dto = ProfileDto.fromJson(userData);
      final profile = ProfileMapper.toEntity(dto);

      Logger.info('Profile fetched successfully: ${profile.email}');
      return profile;
    } catch (e) {
      Logger.error('Error fetching profile', e);
      throw ServerFailure('Failed to fetch profile: $e');
    }
  }
}

