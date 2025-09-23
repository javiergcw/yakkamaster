import 'package:shared_preferences/shared_preferences.dart';

/// Gestor de almacenamiento local usando SharedPreferences
class StorageManager {
  static final StorageManager _instance = StorageManager._internal();
  factory StorageManager() => _instance;
  StorageManager._internal();

  SharedPreferences? _prefs;

  /// Inicializa el gestor de almacenamiento
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Obtiene una instancia de SharedPreferences
  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Guarda un string en el almacenamiento
  Future<bool> setString(String key, String value) async {
    final prefs = await this.prefs;
    return await prefs.setString(key, value);
  }

  /// Obtiene un string del almacenamiento
  Future<String?> getString(String key) async {
    final prefs = await this.prefs;
    return prefs.getString(key);
  }

  /// Guarda un entero en el almacenamiento
  Future<bool> setInt(String key, int value) async {
    final prefs = await this.prefs;
    return await prefs.setInt(key, value);
  }

  /// Obtiene un entero del almacenamiento
  Future<int?> getInt(String key) async {
    final prefs = await this.prefs;
    return prefs.getInt(key);
  }

  /// Guarda un booleano en el almacenamiento
  Future<bool> setBool(String key, bool value) async {
    final prefs = await this.prefs;
    return await prefs.setBool(key, value);
  }

  /// Obtiene un booleano del almacenamiento
  Future<bool?> getBool(String key) async {
    final prefs = await this.prefs;
    return prefs.getBool(key);
  }

  /// Guarda una lista de strings en el almacenamiento
  Future<bool> setStringList(String key, List<String> value) async {
    final prefs = await this.prefs;
    return await prefs.setStringList(key, value);
  }

  /// Obtiene una lista de strings del almacenamiento
  Future<List<String>?> getStringList(String key) async {
    final prefs = await this.prefs;
    return prefs.getStringList(key);
  }

  /// Elimina una clave del almacenamiento
  Future<bool> remove(String key) async {
    final prefs = await this.prefs;
    return await prefs.remove(key);
  }

  /// Verifica si existe una clave en el almacenamiento
  Future<bool> containsKey(String key) async {
    final prefs = await this.prefs;
    return prefs.containsKey(key);
  }

  /// Obtiene todas las claves del almacenamiento
  Future<Set<String>> getKeys() async {
    final prefs = await this.prefs;
    return prefs.getKeys();
  }

  /// Limpia todo el almacenamiento
  Future<bool> clear() async {
    final prefs = await this.prefs;
    return await prefs.clear();
  }

  /// Elimina múltiples claves del almacenamiento
  Future<void> removeMultiple(List<String> keys) async {
    final prefs = await this.prefs;
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}
