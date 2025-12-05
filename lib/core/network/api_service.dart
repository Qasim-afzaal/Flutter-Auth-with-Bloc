import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../errors/failures.dart';
import '../utils/logger.dart';

/// API Service class for making HTTP requests
/// Implements all HTTP methods (GET, POST, PUT, DELETE, PATCH)
/// Handles all network errors, timeouts, and response parsing
/// Follows SOLID principles and Clean Architecture
class ApiService {
  final http.Client _client;
  final String _baseUrl;

  ApiService({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? AppConstants.baseUrl;

  /// Performs a GET request to the specified endpoint
  /// 
  /// [endpoint] - The API endpoint (e.g., '/users', '/auth/login')
  /// [headers] - Optional custom headers to include in the request
  /// 
  /// Returns [Map<String, dynamic>] containing the response data
  /// Throws [NetworkFailure] if network error occurs
  /// Throws [ServerFailure] if server returns error status code
  /// Throws [AuthFailure] if response is 401 Unauthorized
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      Logger.info('GET Request: $_baseUrl$endpoint');

      // Ensure endpoint starts with /
      final normalizedEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
      final uri = Uri.parse('$_baseUrl$normalizedEndpoint');
      final requestHeaders = _buildHeaders(headers);

      final response = await _client
          .get(uri, headers: requestHeaders)
          .timeout(
            Duration(milliseconds: AppConstants.connectionTimeout),
            onTimeout: () {
              throw TimeoutException('Request timeout');
            },
          );

      Logger.info('GET Response Status: ${response.statusCode}');
      return _handleResponse(response);
    } on TimeoutException catch (e) {
      Logger.error('GET Request Timeout', e);
      throw NetworkFailure('Request timeout: ${e.message}');
    } on http.ClientException catch (e) {
      Logger.error('GET Network Error', e);
      throw NetworkFailure('Network error: ${e.message}');
    } catch (e) {
      Logger.error('GET Unexpected Error', e);
      throw NetworkFailure('Unexpected error: $e');
    }
  }

  /// Performs a POST request to the specified endpoint with JSON body
  /// 
  /// [endpoint] - The API endpoint (e.g., '/auth/login', '/users')
  /// [body] - The request body as a Map
  /// [headers] - Optional custom headers to include in the request
  /// 
  /// Returns [Map<String, dynamic>] containing the response data
  /// Throws [NetworkFailure] if network error occurs
  /// Throws [ServerFailure] if server returns error status code
  /// Throws [AuthFailure] if response is 401 Unauthorized
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    try {
      Logger.info('POST Request: $_baseUrl$endpoint');
      Logger.debug('POST Body: ${json.encode(body)}');

      // Ensure endpoint starts with /
      final normalizedEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
      final uri = Uri.parse('$_baseUrl$normalizedEndpoint');
      final requestHeaders = _buildHeaders(headers);

      final response = await _client
          .post(
            uri,
            headers: requestHeaders,
            body: json.encode(body),
          )
          .timeout(
            Duration(milliseconds: AppConstants.connectionTimeout),
            onTimeout: () {
              throw TimeoutException('Request timeout');
            },
          );

      Logger.info('POST Response Status: ${response.statusCode}');
      return _handleResponse(response);
    } on TimeoutException catch (e) {
      Logger.error('POST Request Timeout', e);
      throw NetworkFailure('Request timeout: ${e.message}');
    } on http.ClientException catch (e) {
      Logger.error('POST Network Error', e);
      throw NetworkFailure('Network error: ${e.message}');
    } catch (e) {
      Logger.error('POST Unexpected Error', e);
      throw NetworkFailure('Unexpected error: $e');
    }
  }

  /// Performs a PUT request to the specified endpoint with JSON body
  /// 
  /// [endpoint] - The API endpoint
  /// [body] - The request body as a Map
  /// [headers] - Optional custom headers to include in the request
  /// 
  /// Returns [Map<String, dynamic>] containing the response data
  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    try {
      Logger.info('PUT Request: $_baseUrl$endpoint');

      // Ensure endpoint starts with /
      final normalizedEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
      final uri = Uri.parse('$_baseUrl$normalizedEndpoint');
      final requestHeaders = _buildHeaders(headers);

      final response = await _client
          .put(
            uri,
            headers: requestHeaders,
            body: json.encode(body),
          )
          .timeout(
            Duration(milliseconds: AppConstants.connectionTimeout),
            onTimeout: () {
              throw TimeoutException('Request timeout');
            },
          );

      Logger.info('PUT Response Status: ${response.statusCode}');
      return _handleResponse(response);
    } on TimeoutException catch (e) {
      Logger.error('PUT Request Timeout', e);
      throw NetworkFailure('Request timeout');
    } on http.ClientException catch (e) {
      Logger.error('PUT Network Error', e);
      throw NetworkFailure('Network error: ${e.message}');
    } catch (e) {
      Logger.error('PUT Unexpected Error', e);
      throw NetworkFailure('Unexpected error: $e');
    }
  }

  /// Performs a PATCH request to the specified endpoint with JSON body
  /// 
  /// [endpoint] - The API endpoint
  /// [body] - The request body as a Map
  /// [headers] - Optional custom headers to include in the request
  /// 
  /// Returns [Map<String, dynamic>] containing the response data
  Future<Map<String, dynamic>> patch(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    try {
      Logger.info('PATCH Request: $_baseUrl$endpoint');

      // Ensure endpoint starts with /
      final normalizedEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
      final uri = Uri.parse('$_baseUrl$normalizedEndpoint');
      final requestHeaders = _buildHeaders(headers);

      final response = await _client
          .patch(
            uri,
            headers: requestHeaders,
            body: json.encode(body),
          )
          .timeout(
            Duration(milliseconds: AppConstants.connectionTimeout),
            onTimeout: () {
              throw TimeoutException('Request timeout');
            },
          );

      Logger.info('PATCH Response Status: ${response.statusCode}');
      return _handleResponse(response);
    } on TimeoutException catch (e) {
      Logger.error('PATCH Request Timeout', e);
      throw NetworkFailure('Request timeout');
    } on http.ClientException catch (e) {
      Logger.error('PATCH Network Error', e);
      throw NetworkFailure('Network error: ${e.message}');
    } catch (e) {
      Logger.error('PATCH Unexpected Error', e);
      throw NetworkFailure('Unexpected error: $e');
    }
  }

  /// Performs a DELETE request to the specified endpoint
  /// 
  /// [endpoint] - The API endpoint
  /// [headers] - Optional custom headers to include in the request
  /// 
  /// Returns [Map<String, dynamic>] containing the response data
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      Logger.info('DELETE Request: $_baseUrl$endpoint');

      // Ensure endpoint starts with /
      final normalizedEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
      final uri = Uri.parse('$_baseUrl$normalizedEndpoint');
      final requestHeaders = _buildHeaders(headers);

      final response = await _client
          .delete(uri, headers: requestHeaders)
          .timeout(
            Duration(milliseconds: AppConstants.connectionTimeout),
            onTimeout: () {
              throw TimeoutException('Request timeout');
            },
          );

      Logger.info('DELETE Response Status: ${response.statusCode}');
      return _handleResponse(response);
    } on TimeoutException catch (e) {
      Logger.error('DELETE Request Timeout', e);
      throw NetworkFailure('Request timeout');
    } on http.ClientException catch (e) {
      Logger.error('DELETE Network Error', e);
      throw NetworkFailure('Network error: ${e.message}');
    } catch (e) {
      Logger.error('DELETE Unexpected Error', e);
      throw NetworkFailure('Unexpected error: $e');
    }
  }

  /// Builds headers for HTTP requests
  /// Merges default headers with custom headers
  Map<String, String> _buildHeaders(Map<String, String>? customHeaders) {
    final defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (customHeaders != null) {
      defaultHeaders.addAll(customHeaders);
    }

    return defaultHeaders;
  }

  /// Handles HTTP response and converts to appropriate result or error
  /// 
  /// Returns decoded JSON for successful responses (2xx status codes)
  /// Throws [AuthFailure] for 401 Unauthorized responses
  /// Throws [ServerFailure] for all other error status codes
  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    // Success responses (200-299)
    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      try {
        return json.decode(response.body) as Map<String, dynamic>;
      } catch (e) {
        Logger.error('Failed to parse response body', e);
        throw ServerFailure('Invalid response format');
      }
    }

    // Handle error responses
    String errorMessage = 'Server error: $statusCode';
    try {
      final errorBody = json.decode(response.body) as Map<String, dynamic>;
      errorMessage = errorBody['message'] as String? ??
          errorBody['error'] as String? ??
          errorMessage;
    } catch (_) {
      // If parsing fails, use default error message
    }

    // Specific error handling
    if (statusCode == 401) {
      throw AuthFailure(errorMessage);
    } else if (statusCode >= 400 && statusCode < 500) {
      throw ServerFailure(errorMessage);
    } else if (statusCode >= 500) {
      throw ServerFailure('Internal server error: $statusCode');
    }

    throw ServerFailure(errorMessage);
  }

  /// Closes the HTTP client and releases resources
  void dispose() {
    _client.close();
  }
}

