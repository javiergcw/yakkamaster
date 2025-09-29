import 'storage_manager.dart';

/// Gestor de almacenamiento para autenticación (JWT, tokens, etc.)
class AuthStorage {
  static final AuthStorage _instance = AuthStorage._internal();
  factory AuthStorage() => _instance;
  AuthStorage._internal();

  static const String _bearerTokenKey = 'bearer_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userTokenKey = 'user_token';
  static const String _sessionTokenKey = 'session_token';
  static const String _userEmailKey = 'user_email';

  final StorageManager _storage = StorageManager();

  /// Guarda el Bearer token
  Future<bool> setBearerToken(String token) async {
    return await _storage.setString(_bearerTokenKey, token);
  }

  /// Obtiene el Bearer token
  Future<String?> getBearerToken() async {
    return await _storage.getString(_bearerTokenKey);
  }

  /// Guarda el refresh token
  Future<bool> setRefreshToken(String token) async {
    return await _storage.setString(_refreshTokenKey, token);
  }

  /// Obtiene el refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.getString(_refreshTokenKey);
  }

  /// Guarda el token de usuario
  Future<bool> setUserToken(String token) async {
    return await _storage.setString(_userTokenKey, token);
  }

  /// Obtiene el token de usuario
  Future<String?> getUserToken() async {
    return await _storage.getString(_userTokenKey);
  }

  /// Guarda el token de sesión
  Future<bool> setSessionToken(String token) async {
    return await _storage.setString(_sessionTokenKey, token);
  }

  /// Obtiene el token de sesión
  Future<String?> getSessionToken() async {
    return await _storage.getString(_sessionTokenKey);
  }

  /// Verifica si existe un Bearer token
  Future<bool> hasBearerToken() async {
    return await _storage.containsKey(_bearerTokenKey);
  }

  /// Verifica si existe un refresh token
  Future<bool> hasRefreshToken() async {
    return await _storage.containsKey(_refreshTokenKey);
  }

  /// Verifica si existe un token de usuario
  Future<bool> hasUserToken() async {
    return await _storage.containsKey(_userTokenKey);
  }

  /// Verifica si existe un token de sesión
  Future<bool> hasSessionToken() async {
    return await _storage.containsKey(_sessionTokenKey);
  }

  /// Elimina el Bearer token
  Future<bool> removeBearerToken() async {
    return await _storage.remove(_bearerTokenKey);
  }

  /// Elimina el refresh token
  Future<bool> removeRefreshToken() async {
    return await _storage.remove(_refreshTokenKey);
  }

  /// Elimina el token de usuario
  Future<bool> removeUserToken() async {
    return await _storage.remove(_userTokenKey);
  }

  /// Elimina el token de sesión
  Future<bool> removeSessionToken() async {
    return await _storage.remove(_sessionTokenKey);
  }

  /// Guarda el email del usuario
  Future<bool> setUserEmail(String email) async {
    return await _storage.setString(_userEmailKey, email);
  }

  /// Obtiene el email del usuario
  Future<String?> getUserEmail() async {
    return await _storage.getString(_userEmailKey);
  }

  /// Verifica si existe un email guardado
  Future<bool> hasUserEmail() async {
    return await _storage.containsKey(_userEmailKey);
  }

  /// Elimina el email del usuario
  Future<bool> removeUserEmail() async {
    return await _storage.remove(_userEmailKey);
  }

  /// Elimina todos los tokens de autenticación
  Future<void> clearAllTokens() async {
    await _storage.removeMultiple([
      _bearerTokenKey,
      _refreshTokenKey,
      _userTokenKey,
      _sessionTokenKey,
      _userEmailKey,
    ]);
  }

  /// Obtiene todos los tokens disponibles
  Future<Map<String, String?>> getAllTokens() async {
    return {
      'bearer': await getBearerToken(),
      'refresh': await getRefreshToken(),
      'user': await getUserToken(),
      'session': await getSessionToken(),
      'email': await getUserEmail(),
    };
  }
}
