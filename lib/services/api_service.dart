import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../config/api_config.dart';
import 'api_errors.dart';
import 'token_provider.dart';

/// Configuración para endpoints públicos
class PublicEndpoint {
  final String pattern;
  final bool isPublic;
  
  const PublicEndpoint({
    required this.pattern,
    this.isPublic = true,
  });
}

/// Servicio global de API con manejo de headers, tokens y endpoints públicos
class ApiService extends GetxService {
  static ApiService get instance => Get.find<ApiService>();
  
  late final http.Client _client;
  late final TokenProvider _tokenProvider;
  late final List<PublicEndpoint> _publicEndpoints;
  
  // Configuración
  final Duration _defaultTimeout = const Duration(seconds: 30);
  final String _baseUrl = ApiConfig.currentBaseUrl;
  
  // Callback para manejar errores 401
  void Function()? _onUnauthorized;
  
  @override
  void onInit() {
    super.onInit();
    _client = http.Client();
    _tokenProvider = DefaultTokenProvider();
    _setupPublicEndpoints();
  }
  
  @override
  void onClose() {
    _client.close();
    super.onClose();
  }
  
  /// Configura el TokenProvider personalizado
  void setTokenProvider(TokenProvider tokenProvider) {
    _tokenProvider = tokenProvider;
  }
  
  /// Configura el callback para errores 401
  void setOnUnauthorized(void Function() callback) {
    _onUnauthorized = callback;
  }
  
  /// Configura los endpoints públicos
  void _setupPublicEndpoints() {
    _publicEndpoints = [
      // Endpoints de autenticación
      const PublicEndpoint(pattern: r'/api/auth/login'),
      const PublicEndpoint(pattern: r'/api/auth/register'),
      const PublicEndpoint(pattern: r'/api/auth/forgot-password'),
      const PublicEndpoint(pattern: r'/api/auth/refresh'),
      
      // Listas maestras
      const PublicEndpoint(pattern: r'/api/master/.*'),
      const PublicEndpoint(pattern: r'/api/public/.*'),
      
      // Endpoints de configuración pública
      const PublicEndpoint(pattern: r'/api/config/.*'),
      
      // Endpoints de documentación
      const PublicEndpoint(pattern: r'/api/docs/.*'),
    ];
  }
  
  /// Verifica si un endpoint es público
  bool _isPublicEndpoint(String endpoint) {
    return _publicEndpoints.any((publicEndpoint) {
      final regex = RegExp(publicEndpoint.pattern);
      return regex.hasMatch(endpoint);
    });
  }
  
  /// Construye los headers para la petición
  Future<Map<String, String>> _buildHeaders({
    Map<String, String>? customHeaders,
    bool requireAuth = true,
  }) async {
    final headers = <String, String>{
      ...ApiConfig.defaultHeaders,
      ...?customHeaders,
    };
    
    // Agregar license key si está disponible
    final licenseKey = await _tokenProvider.getLicenseKey();
    if (licenseKey != null) {
      headers['X-License-Key'] = licenseKey;
    }
    
    // Agregar token JWT si es requerido y está disponible
    if (requireAuth) {
      final token = await _tokenProvider.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    
    return headers;
  }
  
  /// Serializa query parameters
  String _serializeQueryParams(Map<String, dynamic>? queryParams) {
    if (queryParams == null || queryParams.isEmpty) return '';
    
    final uri = Uri(queryParameters: queryParams.map(
      (key, value) => MapEntry(key, value.toString()),
    ));
    
    return uri.query;
  }
  
  /// Serializa el body a JSON
  String? _serializeBody(dynamic body) {
    if (body == null) return null;
    if (body is String) return body;
    if (body is Map || body is List) return jsonEncode(body);
    return body.toString();
  }
  
  /// Maneja errores de respuesta HTTP
  void _handleHttpError(http.Response response, String endpoint) {
    switch (response.statusCode) {
      case 401:
        _onUnauthorized?.call();
        throw const ApiUnauthorizedError(endpoint: '');
      case 403:
        throw ApiForbiddenError(endpoint: endpoint);
      case 404:
        throw ApiNotFoundError(endpoint: endpoint);
      case >= 500:
        throw ApiServerError(
          endpoint: endpoint,
          statusCode: response.statusCode,
        );
      default:
        throw ApiError(
          message: 'HTTP ${response.statusCode}: ${response.reasonPhrase}',
          statusCode: response.statusCode,
          endpoint: endpoint,
        );
    }
  }
  
  /// Método principal para realizar peticiones HTTP
  Future<http.Response> request({
    required String method,
    required String endpoint,
    Map<String, dynamic>? queryParams,
    dynamic body,
    Map<String, String>? headers,
    Duration? timeout,
    bool requireAuth = true,
  }) async {
    try {
      // Construir URL completa
      final queryString = _serializeQueryParams(queryParams);
      final url = Uri.parse('$_baseUrl$endpoint${queryString.isNotEmpty ? '?$queryString' : ''}');
      
      // Determinar si el endpoint es público
      final isPublic = _isPublicEndpoint(endpoint);
      final shouldRequireAuth = requireAuth && !isPublic;
      
      // Construir headers
      final requestHeaders = await _buildHeaders(
        customHeaders: headers,
        requireAuth: shouldRequireAuth,
      );
      
      // Serializar body
      final bodyString = _serializeBody(body);
      
      // Realizar petición con timeout
      http.Response response;
      switch (method.toUpperCase()) {
        case 'GET':
          response = await _client
              .get(url, headers: requestHeaders)
              .timeout(timeout ?? _defaultTimeout);
          break;
        case 'POST':
          response = await _client
              .post(url, headers: requestHeaders, body: bodyString)
              .timeout(timeout ?? _defaultTimeout);
          break;
        case 'PUT':
          response = await _client
              .put(url, headers: requestHeaders, body: bodyString)
              .timeout(timeout ?? _defaultTimeout);
          break;
        case 'PATCH':
          response = await _client
              .patch(url, headers: requestHeaders, body: bodyString)
              .timeout(timeout ?? _defaultTimeout);
          break;
        case 'DELETE':
          response = await _client
              .delete(url, headers: requestHeaders)
              .timeout(timeout ?? _defaultTimeout);
          break;
        default:
          throw ApiError(
            message: 'Método HTTP no soportado: $method',
            endpoint: endpoint,
          );
      }
      
      // Manejar errores HTTP
      if (response.statusCode >= 400) {
        _handleHttpError(response, endpoint);
      }
      
      return response;
      
    } on SocketException catch (e) {
      throw ApiNetworkError(
        message: e.message,
        endpoint: endpoint,
      );
    } on HttpException catch (e) {
      throw ApiNetworkError(
        message: e.message,
        endpoint: endpoint,
      );
    } on FormatException catch (e) {
      throw ApiSerializationError(
        message: e.message,
        endpoint: endpoint,
      );
    } on TimeoutException {
      throw ApiTimeoutError(
        endpoint: endpoint,
        timeout: timeout ?? _defaultTimeout,
      );
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiError(
        message: e.toString(),
        endpoint: endpoint,
        originalError: e,
      );
    }
  }
  
  // Métodos de conveniencia para diferentes tipos de peticiones HTTP
  
  /// Realiza una petición GET
  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    Duration? timeout,
    bool requireAuth = true,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final response = await request(
      method: 'GET',
      endpoint: endpoint,
      queryParams: queryParams,
      headers: headers,
      timeout: timeout,
      requireAuth: requireAuth,
    );
    
    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    
    if (fromJson != null) {
      return fromJson(jsonData);
    }
    
    return jsonData as T;
  }
  
  /// Realiza una petición POST
  Future<T> post<T>(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    Duration? timeout,
    bool requireAuth = true,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final response = await request(
      method: 'POST',
      endpoint: endpoint,
      queryParams: queryParams,
      body: body,
      headers: headers,
      timeout: timeout,
      requireAuth: requireAuth,
    );
    
    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    
    if (fromJson != null) {
      return fromJson(jsonData);
    }
    
    return jsonData as T;
  }
  
  /// Realiza una petición PUT
  Future<T> put<T>(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    Duration? timeout,
    bool requireAuth = true,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final response = await request(
      method: 'PUT',
      endpoint: endpoint,
      queryParams: queryParams,
      body: body,
      headers: headers,
      timeout: timeout,
      requireAuth: requireAuth,
    );
    
    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    
    if (fromJson != null) {
      return fromJson(jsonData);
    }
    
    return jsonData as T;
  }
  
  /// Realiza una petición PATCH
  Future<T> patch<T>(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    Duration? timeout,
    bool requireAuth = true,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final response = await request(
      method: 'PATCH',
      endpoint: endpoint,
      queryParams: queryParams,
      body: body,
      headers: headers,
      timeout: timeout,
      requireAuth: requireAuth,
    );
    
    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    
    if (fromJson != null) {
      return fromJson(jsonData);
    }
    
    return jsonData as T;
  }
  
  /// Realiza una petición DELETE
  Future<T> delete<T>(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    Duration? timeout,
    bool requireAuth = true,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final response = await request(
      method: 'DELETE',
      endpoint: endpoint,
      queryParams: queryParams,
      headers: headers,
      timeout: timeout,
      requireAuth: requireAuth,
    );
    
    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    
    if (fromJson != null) {
      return fromJson(jsonData);
    }
    
    return jsonData as T;
  }
}
