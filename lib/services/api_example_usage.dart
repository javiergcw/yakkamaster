import 'api_service.dart';
import 'api_errors.dart';

/// Ejemplo de uso del servicio de API
class ApiExampleUsage {
  final ApiService _apiService = ApiService.instance;
  
  /// Ejemplo de petición GET
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      return await _apiService.get<Map<String, dynamic>>(
        '/api/users/$userId',
        requireAuth: true,
      );
    } on ApiError catch (e) {
      print('Error al obtener perfil de usuario: ${e.message}');
      rethrow;
    }
  }
  
  /// Ejemplo de petición POST
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    try {
      return await _apiService.post<Map<String, dynamic>>(
        '/api/users',
        body: userData,
        requireAuth: true,
      );
    } on ApiError catch (e) {
      print('Error al crear usuario: ${e.message}');
      rethrow;
    }
  }
  
  /// Ejemplo de petición PUT
  Future<Map<String, dynamic>> updateUser(
    String userId,
    Map<String, dynamic> userData,
  ) async {
    try {
      return await _apiService.put<Map<String, dynamic>>(
        '/api/users/$userId',
        body: userData,
        requireAuth: true,
      );
    } on ApiError catch (e) {
      print('Error al actualizar usuario: ${e.message}');
      rethrow;
    }
  }
  
  /// Ejemplo de petición PATCH
  Future<Map<String, dynamic>> updateUserField(
    String userId,
    String field,
    dynamic value,
  ) async {
    try {
      return await _apiService.patch<Map<String, dynamic>>(
        '/api/users/$userId',
        body: {field: value},
        requireAuth: true,
      );
    } on ApiError catch (e) {
      print('Error al actualizar campo de usuario: ${e.message}');
      rethrow;
    }
  }
  
  /// Ejemplo de petición DELETE
  Future<void> deleteUser(String userId) async {
    try {
      await _apiService.delete<Map<String, dynamic>>(
        '/api/users/$userId',
        requireAuth: true,
      );
    } on ApiError catch (e) {
      print('Error al eliminar usuario: ${e.message}');
      rethrow;
    }
  }
  
  /// Ejemplo de petición a endpoint público
  Future<List<Map<String, dynamic>>> getMasterData(String type) async {
    try {
      return await _apiService.get<List<Map<String, dynamic>>>(
        '/api/master/$type',
        requireAuth: false, // Endpoint público
      );
    } on ApiError catch (e) {
      print('Error al obtener datos maestros: ${e.message}');
      rethrow;
    }
  }
  
  /// Ejemplo de petición con query parameters
  Future<Map<String, dynamic>> searchUsers({
    String? name,
    String? email,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (name != null) queryParams['name'] = name;
      if (email != null) queryParams['email'] = email;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      
      return await _apiService.get<Map<String, dynamic>>(
        '/api/users/search',
        queryParams: queryParams,
        requireAuth: true,
      );
    } on ApiError catch (e) {
      print('Error al buscar usuarios: ${e.message}');
      rethrow;
    }
  }
  
  /// Ejemplo de petición con timeout personalizado
  Future<Map<String, dynamic>> uploadFile(
    String filePath,
    Map<String, dynamic> metadata,
  ) async {
    try {
      return await _apiService.post<Map<String, dynamic>>(
        '/api/files/upload',
        body: {
          'file_path': filePath,
          'metadata': metadata,
        },
        timeout: const Duration(minutes: 5), // Timeout más largo para uploads
        requireAuth: true,
      );
    } on ApiError catch (e) {
      print('Error al subir archivo: ${e.message}');
      rethrow;
    }
  }
}
