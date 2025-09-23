/// Clases de error personalizadas para el servicio de API
class ApiError implements Exception {
  final String message;
  final int? statusCode;
  final String? endpoint;
  final dynamic originalError;

  const ApiError({
    required this.message,
    this.statusCode,
    this.endpoint,
    this.originalError,
  });

  @override
  String toString() {
    return 'ApiError: $message${statusCode != null ? ' (Status: $statusCode)' : ''}${endpoint != null ? ' at $endpoint' : ''}';
  }
}

/// Error específico para timeout
class ApiTimeoutError extends ApiError {
  ApiTimeoutError({
    required String endpoint,
    required Duration timeout,
  }) : super(
          message: 'Request timeout after ${timeout.inSeconds}s',
          endpoint: endpoint,
        );
}

/// Error específico para respuestas 401 (No autorizado)
class ApiUnauthorizedError extends ApiError {
  const ApiUnauthorizedError({
    required String endpoint,
  }) : super(
          message: 'Unauthorized access',
          statusCode: 401,
          endpoint: endpoint,
        );
}

/// Error específico para respuestas 403 (Prohibido)
class ApiForbiddenError extends ApiError {
  const ApiForbiddenError({
    required String endpoint,
  }) : super(
          message: 'Forbidden access',
          statusCode: 403,
          endpoint: endpoint,
        );
}

/// Error específico para respuestas 404 (No encontrado)
class ApiNotFoundError extends ApiError {
  const ApiNotFoundError({
    required String endpoint,
  }) : super(
          message: 'Resource not found',
          statusCode: 404,
          endpoint: endpoint,
        );
}

/// Error específico para respuestas 500+ (Error del servidor)
class ApiServerError extends ApiError {
  const ApiServerError({
    required String endpoint,
    required int statusCode,
  }) : super(
          message: 'Server error',
          statusCode: statusCode,
          endpoint: endpoint,
        );
}

/// Error específico para problemas de red
class ApiNetworkError extends ApiError {
  const ApiNetworkError({
    required String message,
    required String endpoint,
  }) : super(
          message: 'Network error: $message',
          endpoint: endpoint,
        );
}

/// Error específico para problemas de serialización
class ApiSerializationError extends ApiError {
  const ApiSerializationError({
    required String message,
    required String endpoint,
  }) : super(
          message: 'Serialization error: $message',
          endpoint: endpoint,
        );
}
