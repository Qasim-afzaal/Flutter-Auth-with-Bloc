import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../errors/failures.dart';

class ApiClient {
  final http.Client _client;
  
  ApiClient({http.Client? client}) : _client = client ?? http.Client();
  
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await _client
          .get(
            Uri.parse('${AppConstants.baseUrl}/${AppConstants.apiVersion}$endpoint'),
            headers: _getHeaders(),
          )
          .timeout(const Duration(milliseconds: AppConstants.connectionTimeout));
      
      return _handleResponse(response);
    } catch (e) {
      throw NetworkFailure('Network error: $e');
    }
  }
  
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
    } catch (e) {
      throw NetworkFailure('Network error: $e');
    }
  }
  
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }
  
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return json.decode(response.body) as Map<String, dynamic>;
      } catch (e) {
        throw ServerFailure('Invalid JSON response: $e');
      }
    } else if (response.statusCode == 401) {
      throw const AuthFailure('Unauthorized - Invalid credentials');
    } else if (response.statusCode == 403) {
      throw const AuthFailure('Forbidden - Access denied');
    } else if (response.statusCode >= 500) {
      throw ServerFailure('Server error: ${response.statusCode} - Internal server error');
    } else {
      throw ServerFailure('Request failed with status ${response.statusCode}: ${response.body}');
    }
  }
}
