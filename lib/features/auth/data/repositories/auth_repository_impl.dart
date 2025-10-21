import 'package:auth_bloc/core/errors/failures.dart';
import 'package:auth_bloc/core/network/api_client.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';


class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  
  AuthRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;
  
  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await _apiClient.post('/auth/login', {
        'email': email,
        'password': password,
      });
      
      return User.fromJson(response['user']);
    } catch (e) {
      throw AuthFailure('Login failed: $e');
    }
  }
  
  @override
  Future<User> register(String email, String password, String name) async {
    try {
      final response = await _apiClient.post('/auth/register', {
        'email': email,
        'password': password,
        'name': name,
      });
      
      return User.fromJson(response['user']);
    } catch (e) {
      throw AuthFailure('Registration failed: $e');
    }
  }
  
  @override
  Future<void> logout() async {
    // Implement logout logic (clear tokens, etc.)
    await Future.delayed(const Duration(milliseconds: 500));
  }
  
  @override
  Future<User?> getCurrentUser() async {
    // Implement get current user logic
    return null;
  }
  
  @override
  Future<bool> isLoggedIn() async {
    // Implement check if logged in logic
    return false;
  }
}
