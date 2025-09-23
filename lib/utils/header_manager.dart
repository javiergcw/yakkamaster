import 'storage/auth_storage.dart';
import 'storage/license_storage.dart';

/// Gestor de headers para peticiones HTTP
class HeaderManager {
  static final HeaderManager _instance = HeaderManager._internal();
  factory HeaderManager() => _instance;
  HeaderManager._internal();

  final AuthStorage _authStorage = AuthStorage();
  final LicenseStorage _licenseStorage = LicenseStorage();
  
  String? _jwtToken;
  String? _licenseKey;
  Map<String, String> _customHeaders = {};

  /// Establece el token JWT
  Future<void> setJwtToken(String token) async {
    _jwtToken = token;
    await _authStorage.setJwtToken(token);
  }

  /// Establece la clave de licencia
  Future<void> setLicenseKey(String key) async {
    _licenseKey = key;
    await _licenseStorage.setLicenseKey(key);
  }

  /// Añade un header personalizado
  void addCustomHeader(String key, String value) {
    _customHeaders[key] = value;
  }

  /// Elimina un header personalizado
  void removeCustomHeader(String key) {
    _customHeaders.remove(key);
  }

  /// Limpia todos los headers personalizados
  void clearCustomHeaders() {
    _customHeaders.clear();
  }

  /// Obtiene todos los headers configurados
  Map<String, String> getHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_jwtToken != null) {
      headers['Authorization'] = 'Bearer $_jwtToken';
    }

    if (_licenseKey != null) {
      headers['X-License-Key'] = _licenseKey!;
    }

    headers.addAll(_customHeaders);
    return headers;
  }

  /// Limpia el token JWT
  Future<void> clearJwtToken() async {
    _jwtToken = null;
    await _authStorage.removeJwtToken();
  }

  /// Limpia la clave de licencia
  Future<void> clearLicenseKey() async {
    _licenseKey = null;
    await _licenseStorage.removeLicenseKey();
  }

  /// Limpia todos los headers
  Future<void> clearAll() async {
    _jwtToken = null;
    _licenseKey = null;
    _customHeaders.clear();
    await _authStorage.clearAllTokens();
    await _licenseStorage.clearAllKeys();
  }

  /// Carga los valores almacenados desde el storage
  Future<void> loadStoredValues() async {
    _jwtToken = await _authStorage.getJwtToken();
    _licenseKey = await _licenseStorage.getLicenseKey();
  }

  /// Carga solo el JWT token desde el storage
  Future<void> loadJwtToken() async {
    _jwtToken = await _authStorage.getJwtToken();
  }

  /// Carga solo la licencia desde el storage
  Future<void> loadLicenseKey() async {
    _licenseKey = await _licenseStorage.getLicenseKey();
  }

  /// Verifica si existe un token JWT almacenado
  Future<bool> hasJwtToken() async {
    if (_jwtToken != null) return true;
    return await _authStorage.hasJwtToken();
  }

  /// Verifica si existe una licencia almacenada
  Future<bool> hasLicenseKey() async {
    if (_licenseKey != null) return true;
    return await _licenseStorage.hasLicenseKey();
  }
}
