import 'http_client.dart';

/// Manejador de respuestas y errores HTTP
class ResponseHandler {
  static final ResponseHandler _instance = ResponseHandler._internal();
  factory ResponseHandler() => _instance;
  ResponseHandler._internal();

  /// Procesa una respuesta HTTP y maneja errores comunes
  Future<ApiResult<T>> handleResponse<T>(
    HttpResponse response, {
    T Function(Map<String, dynamic>)? fromJson,
    T Function(List<dynamic>)? fromJsonList,
  }) async {
    if (!response.isSuccess) {
      return ApiResult<T>.error(
        message: _getErrorMessage(response),
        statusCode: response.statusCode,
        error: response.error,
      );
    }

    try {
      if (fromJson != null && response.jsonBody != null) {
        final data = fromJson(response.jsonBody!);
        return ApiResult<T>.success(data);
      } else if (fromJsonList != null) {
        // Intentar obtener la lista desde diferentes estructuras posibles
        List<dynamic>? jsonList;
        
              if (response.jsonListBody != null) {
                // Si la respuesta es directamente un array
                jsonList = response.jsonListBody;
              } else if (response.jsonBody != null) {
                // Si la respuesta es un objeto que contiene un array
                final jsonBody = response.jsonBody!;
                
                // Debug: imprimir las claves disponibles
                print('ResponseHandler - Available keys: ${jsonBody.keys.toList()}');
                
                // Buscar posibles claves que contengan arrays
                if (jsonBody.containsKey('data') && jsonBody['data'] is List) {
                  jsonList = jsonBody['data'] as List<dynamic>;
                } else if (jsonBody.containsKey('results') && jsonBody['results'] is List) {
                  jsonList = jsonBody['results'] as List<dynamic>;
                } else if (jsonBody.containsKey('items') && jsonBody['items'] is List) {
                  jsonList = jsonBody['items'] as List<dynamic>;
        } else if (jsonBody.containsKey('jobs')) {
          if (jsonBody['jobs'] is List) {
            print('ResponseHandler - Found jobs key with ${(jsonBody['jobs'] as List).length} items');
            jsonList = jsonBody['jobs'] as List<dynamic>;
          } else if (jsonBody['jobs'] == null) {
            print('ResponseHandler - Found jobs key but it is null, returning empty list');
            jsonList = <dynamic>[]; // Devolver lista vacía cuando jobs es null
          }
        } else if (jsonBody.containsKey('jobsites') && jsonBody['jobsites'] is List) {
            jsonList = jsonBody['jobsites'] as List<dynamic>;
          } else if (jsonBody.containsKey('skills') && jsonBody['skills'] is List) {
            jsonList = jsonBody['skills'] as List<dynamic>;
          } else if (jsonBody.containsKey('experience_levels') && jsonBody['experience_levels'] is List) {
            jsonList = jsonBody['experience_levels'] as List<dynamic>;
          }
        }
        
        if (jsonList != null) {
          final data = fromJsonList(jsonList);
          return ApiResult<T>.success(data);
        } else {
          return ApiResult<T>.error(
            message: 'No valid array found in JSON response',
            statusCode: response.statusCode,
            error: 'No array found in JSON response',
          );
        }
      } else {
        // Si no hay parsers específicos, intentar parsear como JSON primero
        if (response.jsonBody != null) {
          return ApiResult<T>.success(response.jsonBody as T);
        } else if (response.jsonListBody != null) {
          return ApiResult<T>.success(response.jsonListBody as T);
        } else {
          // Si no es JSON válido, devolver error
          return ApiResult<T>.error(
            message: 'Response is not valid JSON: ${response.body}',
            statusCode: response.statusCode,
            error: 'Invalid JSON response',
          );
        }
      }
    } catch (e) {
      print('ResponseHandler Error: $e');
      print('Response body: ${response.body}');
      print('Response jsonBody: ${response.jsonBody}');
      return ApiResult<T>.error(
        message: 'Error processing response: $e',
        statusCode: response.statusCode,
        error: e,
      );
    }
  }

  /// Obtiene un mensaje de error descriptivo
  String _getErrorMessage(HttpResponse response) {
    switch (response.statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Access denied';
      case 404:
        return 'Resource not found';
      case 409:
        return 'Data conflict';
      case 422:
        return 'Invalid input data';
      case 429:
        return 'Too many requests';
      case 500:
        return 'Internal server error';
      case 502:
        return 'Server unavailable';
      case 503:
        return 'Service temporarily unavailable';
      case 0:
        return response.body.isNotEmpty ? response.body : 'Connection error';
      default:
        return 'HTTP error ${response.statusCode}';
    }
  }

  /// Valida si una respuesta es exitosa
  bool isSuccess(HttpResponse response) {
    return response.isSuccess;
  }

  /// Obtiene el código de estado de una respuesta
  int getStatusCode(HttpResponse response) {
    return response.statusCode;
  }

  /// Obtiene el cuerpo de la respuesta como JSON
  Map<String, dynamic>? getJsonBody(HttpResponse response) {
    return response.jsonBody;
  }

  /// Obtiene el cuerpo de la respuesta como lista JSON
  List<dynamic>? getJsonListBody(HttpResponse response) {
    return response.jsonListBody;
  }
}

/// Clase para representar el resultado de una operación API
class ApiResult<T> {
  final bool isSuccess;
  final T? data;
  final String? message;
  final int? statusCode;
  final dynamic error;

  ApiResult._({
    required this.isSuccess,
    this.data,
    this.message,
    this.statusCode,
    this.error,
  });

  /// Constructor para resultado exitoso
  factory ApiResult.success(T data) {
    return ApiResult._(
      isSuccess: true,
      data: data,
    );
  }

  /// Constructor para resultado con error
  factory ApiResult.error({
    required String message,
    int? statusCode,
    dynamic error,
  }) {
    return ApiResult._(
      isSuccess: false,
      message: message,
      statusCode: statusCode,
      error: error,
    );
  }

  /// Verifica si la operación fue exitosa
  bool get isError => !isSuccess;

  /// Obtiene el mensaje de error si existe
  String get errorMessage => message ?? 'Unknown error';
}
