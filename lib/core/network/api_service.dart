import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../errors/failures.dart';
import '../utils/logger.dart';

/// HTTP Method enum for type-safe method specification
enum HttpMethod {
  get,
  post,
  put,
  patch,
  delete,
}

/// API Service class for making HTTP requests
/// Implements all HTTP methods (GET, POST, PUT, DELETE, PATCH)
/// Uses a generic request method to reduce code duplication
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
    return _makeRequest(
      method: HttpMethod.get,
      endpoint: endpoint,
      headers: headers,
    );
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
    return _makeRequest(
      method: HttpMethod.post,
      endpoint: endpoint,
      body: body,
      headers: headers,
    );
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
    return _makeRequest(
      method: HttpMethod.put,
      endpoint: endpoint,
      body: body,
      headers: headers,
    );
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
    return _makeRequest(
      method: HttpMethod.patch,
      endpoint: endpoint,
      body: body,
      headers: headers,
    );
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
    return _makeRequest(
      method: HttpMethod.delete,
      endpoint: endpoint,
      headers: headers,
    );
  }

  /// Generic request method that handles all HTTP methods
  /// This method centralizes all common logic (error handling, logging, etc.)
  /// 
  /// [method] - The HTTP method to use (GET, POST, PUT, PATCH, DELETE)
  /// [endpoint] - The API endpoint
  /// [body] - Optional request body (required for POST, PUT, PATCH)
  /// [headers] - Optional custom headers
  /// 
  /// Returns [Map<String, dynamic>] containing the response data
  /// Throws [NetworkFailure] if network error occurs
  /// Throws [ServerFailure] if server returns error status code
  /// Throws [AuthFailure] if response is 401 Unauthorized
  Future<Map<String, dynamic>> _makeRequest({
    required HttpMethod method,
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final methodName = method.name.toUpperCase();
    
    try {
      Logger.info('$methodName Request: $_baseUrl$endpoint');
      
      if (body != null) {
        Logger.debug('$methodName Body: ${json.encode(body)}');
      }

      // Ensure endpoint starts with /
      final normalizedEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
      final uri = Uri.parse('$_baseUrl$normalizedEndpoint');
      final requestHeaders = _buildHeaders(headers);

      // Execute the appropriate HTTP method
      final response = await _executeRequest(
        method: method,
        uri: uri,
        headers: requestHeaders,
        body: body,
      ).timeout(
        Duration(milliseconds: AppConstants.connectionTimeout),
        onTimeout: () {
          throw TimeoutException('Request timeout');
        },
      );

      Logger.info('$methodName Response Status: ${response.statusCode}');
      return _handleResponse(response);
    } on TimeoutException catch (e) {
      Logger.error('$methodName Request Timeout', e);
      throw NetworkFailure('Request timeout: ${e.message}');
    } on http.ClientException catch (e) {
      Logger.error('$methodName Network Error', e);
      throw NetworkFailure('Network error: ${e.message}');
    } on AuthFailure {
      rethrow; // Re-throw auth failures as-is
    } on ServerFailure {
      rethrow; // Re-throw server failures as-is
    } on NetworkFailure {
      rethrow; // Re-throw network failures as-is
    } catch (e) {
      Logger.error('$methodName Unexpected Error', e);
      throw NetworkFailure('Unexpected error: $e');
    }
  }

  /// Executes the HTTP request based on the method type
  /// 
  /// [method] - The HTTP method to execute
  /// [uri] - The complete URI for the request
  /// [headers] - Request headers
  /// [body] - Optional request body
  /// 
  /// Returns [http.Response] from the HTTP client
  Future<http.Response> _executeRequest({
    required HttpMethod method,
    required Uri uri,
    required Map<String, String> headers,
    Map<String, dynamic>? body,
  }) async {
    final bodyString = body != null ? json.encode(body) : null;

    switch (method) {
      case HttpMethod.get:
        return await _client.get(uri, headers: headers);
      case HttpMethod.post:
        return await _client.post(uri, headers: headers, body: bodyString);
      case HttpMethod.put:
        return await _client.put(uri, headers: headers, body: bodyString);
      case HttpMethod.patch:
        return await _client.patch(uri, headers: headers, body: bodyString);
      case HttpMethod.delete:
        return await _client.delete(uri, headers: headers);
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
