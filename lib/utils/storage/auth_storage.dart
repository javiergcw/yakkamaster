import 'storage_manager.dart';

/// Gestor de almacenamiento para autenticación (JWT, tokens, etc.)
class AuthStorage {
  static final AuthStorage _instance = AuthStorage._internal();
  factory AuthStorage() => _instance;
  AuthStorage._internal();

  static const String _jwtTokenKey = 'jwt_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userTokenKey = 'user_token';
  static const String _sessionTokenKey = 'session_token';

  final StorageManager _storage = StorageManager();

  /// Guarda el token JWT
  Future<bool> setJwtToken(String token) async {
    return await _storage.setString(_jwtTokenKey, token);
  }

  /// Obtiene el token JWT
  Future<String?> getJwtToken() async {
    return await _storage.getString(_jwtTokenKey);
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

  /// Verifica si existe un token JWT
  Future<bool> hasJwtToken() async {
    return await _storage.containsKey(_jwtTokenKey);
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

  /// Elimina el token JWT
  Future<bool> removeJwtToken() async {
    return await _storage.remove(_jwtTokenKey);
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

  /// Elimina todos los tokens de autenticación
  Future<void> clearAllTokens() async {
    await _storage.removeMultiple([
      _jwtTokenKey,
      _refreshTokenKey,
      _userTokenKey,
      _sessionTokenKey,
    ]);
  }

  /// Obtiene todos los tokens disponibles
  Future<Map<String, String?>> getAllTokens() async {
    return {
      'jwt': await getJwtToken(),
      'refresh': await getRefreshToken(),
      'user': await getUserToken(),
      'session': await getSessionToken(),
    };
  }
}
