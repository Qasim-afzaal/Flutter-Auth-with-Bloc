import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

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

      // Parse user data from response
      final userData = response['data'] as Map<String, dynamic>? ??
          response['user'] as Map<String, dynamic>? ??
          response;

      final user = User.fromJson(userData);

      // Save token if present in response
      final token = response['token'] as String? ?? response['access_token'] as String?;
      if (token != null) {
        await _secureStorage.saveToken(token);
        Logger.info('Token saved successfully');
      }

      // Save user data
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
