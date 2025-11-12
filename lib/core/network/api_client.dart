import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../errors/failures.dart';

/// API Client for making HTTP requests
/// Handles GET and POST requests with proper error handling
/// All requests include timeout protection and consistent error handling
class ApiClient {
  final http.Client _client;
  
  ApiClient({http.Client? client}) : _client = client ?? http.Client();
  
  /// Performs a GET request to the specified endpoint
  /// 
  /// Throws [NetworkFailure] if network error occurs or timeout is exceeded
  /// Throws [AuthFailure] if response is 401 Unauthorized
  /// Throws [ServerFailure] if response status code indicates server error
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await _client
          .get(
            Uri.parse('${AppConstants.baseUrl}/${AppConstants.apiVersion}$endpoint'),
            headers: _getHeaders(),
          )
          .timeout(const Duration(milliseconds: AppConstants.connectionTimeout));
      
      return _handleResponse(response);
    } on TimeoutException {
      throw NetworkFailure('Request timeout: Connection timed out');
    } catch (e) {
      throw NetworkFailure('Network error: $e');
    }
  }
  
  /// Performs a POST request to the specified endpoint with JSON body
  /// 
  /// Throws [NetworkFailure] if network error occurs or timeout is exceeded
  /// Throws [AuthFailure] if response is 401 Unauthorized
  /// Throws [ServerFailure] if response status code indicates server error
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _client
          .post(
            Uri.parse('${AppConstants.baseUrl}/${AppConstants.apiVersion}$endpoint'),
            headers: _getHeaders(),
            body: json.encode(body),
          )
          .timeout(const Duration(milliseconds: AppConstants.connectionTimeout));
      
      return _handleResponse(response);
    } on TimeoutException {
      throw NetworkFailure('Request timeout: Connection timed out');
    } catch (e) {
      throw NetworkFailure('Network error: $e');
    }
  }
  
  /// Performs a PUT request to the specified endpoint with JSON body
  /// 
  /// Throws [NetworkFailure] if network error occurs or timeout is exceeded
  /// Throws [AuthFailure] if response is 401 Unauthorized
  /// Throws [ServerFailure] if response status code indicates server error
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _client
          .put(
            Uri.parse('${AppConstants.baseUrl}/${AppConstants.apiVersion}$endpoint'),
            headers: _getHeaders(),
            body: json.encode(body),
          )
          .timeout(const Duration(milliseconds: AppConstants.connectionTimeout));
      
      return _handleResponse(response);
    } on TimeoutException {
      throw NetworkFailure('Request timeout: Connection timed out');
    } catch (e) {
      throw NetworkFailure('Network error: $e');
    }
  }
  
  /// Performs a DELETE request to the specified endpoint
  /// 
  /// Throws [NetworkFailure] if network error occurs or timeout is exceeded
  /// Throws [AuthFailure] if response is 401 Unauthorized
  /// Throws [ServerFailure] if response status code indicates server error
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await _client
          .delete(
            Uri.parse('${AppConstants.baseUrl}/${AppConstants.apiVersion}$endpoint'),
            headers: _getHeaders(),
          )
          .timeout(const Duration(milliseconds: AppConstants.connectionTimeout));
      
      return _handleResponse(response);
    } on TimeoutException {
      throw NetworkFailure('Request timeout: Connection timed out');
    } catch (e) {
      throw NetworkFailure('Network error: $e');
    }
  }
  
  /// Returns default HTTP headers for all requests
  /// Includes Content-Type and Accept headers for JSON communication
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }
  
  /// Handles HTTP response and converts to appropriate result or error
  /// 
  /// Returns decoded JSON for successful responses (2xx status codes)
  /// Throws [AuthFailure] for 401 Unauthorized responses
  /// Throws [ServerFailure] for all other error status codes
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw const AuthFailure('Unauthorized');
    } else {
      throw ServerFailure('Server error: ${response.statusCode}');
    }
  }
}
