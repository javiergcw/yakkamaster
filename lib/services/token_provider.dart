/// Interfaz para proveer tokens de autenticación
abstract class TokenProvider {
  /// Obtiene el token JWT actual
  Future<String?> getToken();
  
  /// Obtiene la license key actual
  Future<String?> getLicenseKey();
  
  /// Refresca el token si es necesario
  Future<String?> refreshToken();
  
  /// Limpia los tokens almacenados
  Future<void> clearTokens();
  
  /// Verifica si el token actual es válido
  Future<bool> isTokenValid();
}

/// Implementación básica de TokenProvider usando SharedPreferences
class DefaultTokenProvider implements TokenProvider {
  
  @override
  Future<String?> getToken() async {
    // Implementación básica - en un proyecto real usarías SharedPreferences
    // o el sistema de almacenamiento que prefieras
    return null;
  }
  
  @override
  Future<String?> getLicenseKey() async {
    // Implementación básica - en un proyecto real usarías SharedPreferences
    // o el sistema de almacenamiento que prefieras
    return null;
  }
  
  @override
  Future<String?> refreshToken() async {
    // Implementación básica - aquí implementarías la lógica de refresh
    return null;
  }
  
  @override
  Future<void> clearTokens() async {
    // Implementación básica - aquí limpiarías los tokens almacenados
  }
  
  @override
  Future<bool> isTokenValid() async {
    // Implementación básica - aquí verificarías si el token es válido
    return false;
  }
}
