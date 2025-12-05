import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/logger.dart';

/// Secure Storage Service
/// Handles secure storage operations using flutter_secure_storage
/// Used for storing sensitive data like tokens and user credentials
/// Follows SOLID principles - Single Responsibility Principle
class SecureStorageService {
  final FlutterSecureStorage _storage;

  // Storage keys
  static const String _keyToken = 'auth_token';
  static const String _keyUserData = 'user_data';
  static const String _keyIsLoggedIn = 'is_logged_in';

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock_this_device,
          ),
        );

  /// Saves authentication token securely
  /// 
  /// [token] - The authentication token to save
  /// Returns true if successful, false otherwise
  Future<bool> saveToken(String token) async {
    try {
      await _storage.write(key: _keyToken, value: token);
      Logger.info('Token saved successfully');
      return true;
    } catch (e) {
      Logger.error('Failed to save token', e);
      return false;
    }
  }

  /// Retrieves the saved authentication token
  /// 
  /// Returns the token if exists, null otherwise
  Future<String?> getToken() async {
    try {
      final token = await _storage.read(key: _keyToken);
      if (token != null) {
        Logger.info('Token retrieved successfully');
      }
      return token;
    } catch (e) {
      Logger.error('Failed to retrieve token', e);
      return null;
    }
  }

  /// Saves user data securely as JSON string
  /// 
  /// [userData] - Map containing user data
  /// Returns true if successful, false otherwise
  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    try {
      final userDataJson = json.encode(userData);
      await _storage.write(key: _keyUserData, value: userDataJson);
      await _storage.write(key: _keyIsLoggedIn, value: 'true');
      Logger.info('User data saved successfully');
      return true;
    } catch (e) {
      Logger.error('Failed to save user data', e);
      return false;
    }
  }

  /// Retrieves saved user data
  /// 
  /// Returns Map containing user data if exists, null otherwise
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final userDataJson = await _storage.read(key: _keyUserData);
      if (userDataJson != null) {
        Logger.info('User data retrieved successfully');
        return json.decode(userDataJson) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      Logger.error('Failed to retrieve user data', e);
      return null;
    }
  }

  /// Checks if user is logged in
  /// 
  /// Returns true if user data exists, false otherwise
  Future<bool> isLoggedIn() async {
    try {
      final isLoggedIn = await _storage.read(key: _keyIsLoggedIn);
      return isLoggedIn == 'true';
    } catch (e) {
      Logger.error('Failed to check login status', e);
      return false;
    }
  }

  /// Clears all stored data (logout)
  /// 
  /// Returns true if successful, false otherwise
  Future<bool> clearAll() async {
    try {
      await _storage.deleteAll();
      Logger.info('All data cleared successfully');
      return true;
    } catch (e) {
      Logger.error('Failed to clear data', e);
      return false;
    }
  }

  /// Deletes a specific key
  /// 
  /// [key] - The key to delete
  /// Returns true if successful, false otherwise
  Future<bool> deleteKey(String key) async {
    try {
      await _storage.delete(key: key);
      Logger.info('Key deleted: $key');
      return true;
    } catch (e) {
      Logger.error('Failed to delete key: $key', e);
      return false;
    }
  }
}

