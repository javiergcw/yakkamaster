import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'header_manager.dart';
import 'const_api.dart';

/// Cliente HTTP base con configuración centralizada
class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  factory HttpClient() => _instance;
  HttpClient._internal();

  final HeaderManager _headerManager = HeaderManager();
  String? _baseUrl;
  Duration _timeout = const Duration(seconds: 30);

  /// Configura la URL base
  void setBaseUrl(String url) {
    _baseUrl = url;
  }

  /// Configura el timeout de las peticiones
  void setTimeout(Duration timeout) {
    _timeout = timeout;
  }

  /// Realiza una petición GET
  Future<HttpResponse> get(String endpoint, {Map<String, String>? queryParams}) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final response = await http.get(
        uri,
        headers: _headerManager.getHeaders(),
      ).timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Realiza una petición POST
  Future<HttpResponse> post(String endpoint, {dynamic body, Map<String, String>? queryParams}) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final response = await http.post(
        uri,
        headers: _headerManager.getHeaders(),
        body: body != null ? jsonEncode(body) : null,
      ).timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Realiza una petición PUT
  Future<HttpResponse> put(String endpoint, {dynamic body, Map<String, String>? queryParams}) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final response = await http.put(
        uri,
        headers: _headerManager.getHeaders(),
        body: body != null ? jsonEncode(body) : null,
      ).timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Realiza una petición PATCH
  Future<HttpResponse> patch(String endpoint, {dynamic body, Map<String, String>? queryParams}) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final response = await http.patch(
        uri,
        headers: _headerManager.getHeaders(),
        body: body != null ? jsonEncode(body) : null,
      ).timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Realiza una petición DELETE
  Future<HttpResponse> delete(String endpoint, {Map<String, String>? queryParams}) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final response = await http.delete(
        uri,
        headers: _headerManager.getHeaders(),
      ).timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Construye la URI completa
  Uri _buildUri(String endpoint, Map<String, String>? queryParams) {
    // Usar la URL base configurada o la URL por defecto de ConstApi
    final baseUrl = _baseUrl ?? ConstApi.devBaseUrl;
    
    final uri = Uri.parse('$baseUrl$endpoint');
    
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams);
    }
    
    return uri;
  }

  /// Maneja la respuesta HTTP
  HttpResponse _handleResponse(http.Response response) {
    return HttpResponse(
      statusCode: response.statusCode,
      body: response.body,
      headers: response.headers,
      isSuccess: response.statusCode >= 200 && response.statusCode < 300,
    );
  }

  /// Maneja errores de conexión
  HttpResponse _handleError(dynamic error) {
    if (error is SocketException) {
      return HttpResponse(
        statusCode: 0,
        body: 'Error de conexión: ${error.message}',
        headers: {},
        isSuccess: false,
        error: error,
      );
    } else if (error is HttpException) {
      return HttpResponse(
        statusCode: 0,
        body: 'Error HTTP: ${error.message}',
        headers: {},
        isSuccess: false,
        error: error,
      );
    } else {
      return HttpResponse(
        statusCode: 0,
        body: 'Error inesperado: $error',
        headers: {},
        isSuccess: false,
        error: error,
      );
    }
  }

  /// Obtiene el gestor de headers
  HeaderManager get headerManager => _headerManager;
}

/// Clase para representar respuestas HTTP
class HttpResponse {
  final int statusCode;
  final String body;
  final Map<String, String> headers;
  final bool isSuccess;
  final dynamic error;

  HttpResponse({
    required this.statusCode,
    required this.body,
    required this.headers,
    required this.isSuccess,
    this.error,
  });

  /// Obtiene el cuerpo de la respuesta como JSON
  Map<String, dynamic>? get jsonBody {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Obtiene el cuerpo de la respuesta como lista JSON
  List<dynamic>? get jsonListBody {
    try {
      return jsonDecode(body) as List<dynamic>;
    } catch (e) {
      return null;
    }
  }
}
