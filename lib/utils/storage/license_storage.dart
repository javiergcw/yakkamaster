import 'storage_manager.dart';

/// Gestor de almacenamiento para licencias y claves de API
class LicenseStorage {
  static final LicenseStorage _instance = LicenseStorage._internal();
  factory LicenseStorage() => _instance;
  LicenseStorage._internal();

  static const String _licenseKeyKey = 'license_key';
  static const String _apiKeyKey = 'api_key';
  static const String _secretKeyKey = 'secret_key';
  static const String _clientIdKey = 'client_id';
  static const String _clientSecretKey = 'client_secret';

  final StorageManager _storage = StorageManager();

  /// Guarda la clave de licencia
  Future<bool> setLicenseKey(String key) async {
    return await _storage.setString(_licenseKeyKey, key);
  }

  /// Obtiene la clave de licencia
  Future<String?> getLicenseKey() async {
    return await _storage.getString(_licenseKeyKey);
  }

  /// Guarda la clave de API
  Future<bool> setApiKey(String key) async {
    return await _storage.setString(_apiKeyKey, key);
  }

  /// Obtiene la clave de API
  Future<String?> getApiKey() async {
    return await _storage.getString(_apiKeyKey);
  }

  /// Guarda la clave secreta
  Future<bool> setSecretKey(String key) async {
    return await _storage.setString(_secretKeyKey, key);
  }

  /// Obtiene la clave secreta
  Future<String?> getSecretKey() async {
    return await _storage.getString(_secretKeyKey);
  }

  /// Guarda el ID de cliente
  Future<bool> setClientId(String id) async {
    return await _storage.setString(_clientIdKey, id);
  }

  /// Obtiene el ID de cliente
  Future<String?> getClientId() async {
    return await _storage.getString(_clientIdKey);
  }

  /// Guarda el secreto de cliente
  Future<bool> setClientSecret(String secret) async {
    return await _storage.setString(_clientSecretKey, secret);
  }

  /// Obtiene el secreto de cliente
  Future<String?> getClientSecret() async {
    return await _storage.getString(_clientSecretKey);
  }

  /// Verifica si existe una clave de licencia
  Future<bool> hasLicenseKey() async {
    return await _storage.containsKey(_licenseKeyKey);
  }

  /// Verifica si existe una clave de API
  Future<bool> hasApiKey() async {
    return await _storage.containsKey(_apiKeyKey);
  }

  /// Verifica si existe una clave secreta
  Future<bool> hasSecretKey() async {
    return await _storage.containsKey(_secretKeyKey);
  }

  /// Verifica si existe un ID de cliente
  Future<bool> hasClientId() async {
    return await _storage.containsKey(_clientIdKey);
  }

  /// Verifica si existe un secreto de cliente
  Future<bool> hasClientSecret() async {
    return await _storage.containsKey(_clientSecretKey);
  }

  /// Elimina la clave de licencia
  Future<bool> removeLicenseKey() async {
    return await _storage.remove(_licenseKeyKey);
  }

  /// Elimina la clave de API
  Future<bool> removeApiKey() async {
    return await _storage.remove(_apiKeyKey);
  }

  /// Elimina la clave secreta
  Future<bool> removeSecretKey() async {
    return await _storage.remove(_secretKeyKey);
  }

  /// Elimina el ID de cliente
  Future<bool> removeClientId() async {
    return await _storage.remove(_clientIdKey);
  }

  /// Elimina el secreto de cliente
  Future<bool> removeClientSecret() async {
    return await _storage.remove(_clientSecretKey);
  }

  /// Elimina todas las claves de licencia
  Future<void> clearAllKeys() async {
    await _storage.removeMultiple([
      _licenseKeyKey,
      _apiKeyKey,
      _secretKeyKey,
      _clientIdKey,
      _clientSecretKey,
    ]);
  }

  /// Obtiene todas las claves disponibles
  Future<Map<String, String?>> getAllKeys() async {
    return {
      'license': await getLicenseKey(),
      'api': await getApiKey(),
      'secret': await getSecretKey(),
      'client_id': await getClientId(),
      'client_secret': await getClientSecret(),
    };
  }
}
