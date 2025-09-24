import 'storage/auth_storage.dart';
import 'storage/license_storage.dart';

/// Gestor de headers para peticiones HTTP
class HeaderManager {
  static final HeaderManager _instance = HeaderManager._internal();
  factory HeaderManager() => _instance;
  HeaderManager._internal();

  final AuthStorage _authStorage = AuthStorage();
  final LicenseStorage _licenseStorage = LicenseStorage();
  
  String? _bearerToken;
  String? _licenseKey;
  Map<String, String> _customHeaders = {};

  /// Establece el Bearer token
  Future<void> setBearerToken(String token) async {
    _bearerToken = token;
    await _authStorage.setBearerToken(token);
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

    if (_bearerToken != null) {
      headers['Authorization'] = 'Bearer $_bearerToken';
    }

    if (_licenseKey != null) {
      headers['X-License-Key'] = _licenseKey!;
    }

    headers.addAll(_customHeaders);
    return headers;
  }

  /// Limpia el Bearer token
  Future<void> clearBearerToken() async {
    _bearerToken = null;
    await _authStorage.removeBearerToken();
  }

  /// Limpia la clave de licencia
  Future<void> clearLicenseKey() async {
    _licenseKey = null;
    await _licenseStorage.removeLicenseKey();
  }

  /// Limpia todos los headers
  Future<void> clearAll() async {
    _bearerToken = null;
    _licenseKey = null;
    _customHeaders.clear();
    await _authStorage.clearAllTokens();
    await _licenseStorage.clearAllKeys();
  }

  /// Carga los valores almacenados desde el storage
  Future<void> loadStoredValues() async {
    _bearerToken = await _authStorage.getBearerToken();
    _licenseKey = await _licenseStorage.getLicenseKey();
  }

  /// Carga solo el Bearer token desde el storage
  Future<void> loadBearerToken() async {
    _bearerToken = await _authStorage.getBearerToken();
  }

  /// Carga solo la licencia desde el storage
  Future<void> loadLicenseKey() async {
    _licenseKey = await _licenseStorage.getLicenseKey();
  }

  /// Verifica si existe un Bearer token almacenado
  Future<bool> hasBearerToken() async {
    if (_bearerToken != null) return true;
    return await _authStorage.hasBearerToken();
  }

  /// Verifica si existe una licencia almacenada
  Future<bool> hasLicenseKey() async {
    if (_licenseKey != null) return true;
    return await _licenseStorage.hasLicenseKey();
  }
}
