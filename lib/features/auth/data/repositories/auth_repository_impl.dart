import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/login_response_dto.dart';
import '../mappers/user_mapper.dart';

/// Auth Repository Implementation
/// Implements the AuthRepository interface
/// Handles authentication data operations
/// Follows Clean Architecture - Data Layer
class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;
  final SecureStorageService _secureStorage;

  AuthRepositoryImpl({
    required ApiService apiService,
    required SecureStorageService secureStorage,
  })  : _apiService = apiService,
        _secureStorage = secureStorage;

  @override
  Future<User> login(String email, String password) async {
    try {
      Logger.info('Attempting login for email: $email');

      // Make API call to login endpoint
      final response = await _apiService.post(
        '/auth/login',
        {
          'email': email,
          'password': password,
        },
      );

      // Parse response using DTO (Data Transfer Object)
      final loginResponseDto = LoginResponseDto.fromJson(response);

      // Validate response
      if (loginResponseDto.data == null) {
        throw AuthFailure(
          loginResponseDto.message ?? 'Login failed: No user data received',
        );
      }

      // Convert DTO to Domain Entity using mapper
      final user = UserMapper.toEntity(loginResponseDto.data!);

      // Save access token if present
      final token = loginResponseDto.data!.accessToken;
      if (token != null && token.isNotEmpty) {
        await _secureStorage.saveToken(token);
        Logger.info('Access token saved successfully');
      }

      // Save user data to secure storage
      await _secureStorage.saveUserData(user.toJson());
      Logger.info('User data saved successfully');

      Logger.info('Login successful for user: ${user.email}');
      return user;
    } on AuthFailure {
      Logger.error('Authentication failed');
      rethrow;
    } on NetworkFailure catch (e) {
      Logger.error('Network error during login', e);
      throw NetworkFailure('Network error: ${e.message}');
    } on ServerFailure catch (e) {
      Logger.error('Server error during login', e);
      throw ServerFailure('Server error: ${e.message}');
    } catch (e) {
      Logger.error('Unexpected error during login', e);
      throw AuthFailure('Login failed: $e');
    }
  }
}
