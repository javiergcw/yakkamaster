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
          
          // Buscar posibles claves que contengan arrays
          if (jsonBody.containsKey('data') && jsonBody['data'] is List) {
            jsonList = jsonBody['data'] as List<dynamic>;
          } else if (jsonBody.containsKey('results') && jsonBody['results'] is List) {
            jsonList = jsonBody['results'] as List<dynamic>;
          } else if (jsonBody.containsKey('items') && jsonBody['items'] is List) {
            jsonList = jsonBody['items'] as List<dynamic>;
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
            message: 'No se encontró un array válido en la respuesta JSON',
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
            message: 'Respuesta no es un JSON válido: ${response.body}',
            statusCode: response.statusCode,
            error: 'Invalid JSON response',
          );
        }
      }
    } catch (e) {
      return ApiResult<T>.error(
        message: 'Error al procesar la respuesta: $e',
        statusCode: response.statusCode,
        error: e,
      );
    }
  }

  /// Obtiene un mensaje de error descriptivo
  String _getErrorMessage(HttpResponse response) {
    switch (response.statusCode) {
      case 400:
        return 'Solicitud incorrecta';
      case 401:
        return 'No autorizado';
      case 403:
        return 'Acceso denegado';
      case 404:
        return 'Recurso no encontrado';
      case 409:
        return 'Conflicto de datos';
      case 422:
        return 'Datos de entrada inválidos';
      case 429:
        return 'Demasiadas solicitudes';
      case 500:
        return 'Error interno del servidor';
      case 502:
        return 'Servidor no disponible';
      case 503:
        return 'Servicio temporalmente no disponible';
      case 0:
        return response.body.isNotEmpty ? response.body : 'Error de conexión';
      default:
        return 'Error HTTP ${response.statusCode}';
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
  String get errorMessage => message ?? 'Error desconocido';
}
