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
      } else if (fromJsonList != null && response.jsonListBody != null) {
        final data = fromJsonList(response.jsonListBody!);
        return ApiResult<T>.success(data);
      } else {
        return ApiResult<T>.success(response.body as T);
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
