import 'http_client.dart';
import 'header_manager.dart';

/// Servicio global para operaciones CRUD
class CrudService {
  static final CrudService _instance = CrudService._internal();
  factory CrudService() => _instance;
  CrudService._internal();

  final HttpClient _httpClient = HttpClient();

  /// Configura la URL base del servicio
  void configure(String baseUrl) {
    _httpClient.setBaseUrl(baseUrl);
  }

  /// Configura el timeout de las peticiones
  void setTimeout(Duration timeout) {
    _httpClient.setTimeout(timeout);
  }

  /// Obtiene el gestor de headers
  HeaderManager get headerManager => _httpClient.headerManager;

  /// Crea un nuevo recurso
  Future<HttpResponse> create(String endpoint, Map<String, dynamic> data) async {
    return await _httpClient.post(endpoint, body: data);
  }

  /// Obtiene un recurso por ID
  Future<HttpResponse> getById(String endpoint, String id) async {
    return await _httpClient.get('$endpoint/$id');
  }

  /// Obtiene todos los recursos con filtros opcionales
  Future<HttpResponse> getAll(String endpoint, {Map<String, String>? filters}) async {
    return await _httpClient.get(endpoint, queryParams: filters);
  }

  /// Actualiza un recurso completo
  Future<HttpResponse> update(String endpoint, String id, Map<String, dynamic> data) async {
    return await _httpClient.put('$endpoint/$id', body: data);
  }

  /// Actualiza parcialmente un recurso
  Future<HttpResponse> updatePartial(String endpoint, String id, Map<String, dynamic> data) async {
    return await _httpClient.patch('$endpoint/$id', body: data);
  }

  /// Elimina un recurso
  Future<HttpResponse> delete(String endpoint, String id) async {
    return await _httpClient.delete('$endpoint/$id');
  }

  /// Busca recursos con parámetros de consulta
  Future<HttpResponse> search(String endpoint, Map<String, String> searchParams) async {
    return await _httpClient.get(endpoint, queryParams: searchParams);
  }

  /// Obtiene recursos con paginación
  Future<HttpResponse> getPaginated(
    String endpoint, {
    int page = 1,
    int limit = 10,
    Map<String, String>? filters,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
      ...?filters,
    };
    return await _httpClient.get(endpoint, queryParams: queryParams);
  }

  /// Sube un archivo
  Future<HttpResponse> uploadFile(String endpoint, String filePath, {String? fieldName}) async {
    // Implementación específica para subida de archivos
    // Esta sería una implementación básica, podrías necesitar usar multipart
    return await _httpClient.post(endpoint, body: {'file_path': filePath, 'field_name': fieldName});
  }

  /// Descarga un archivo
  Future<HttpResponse> downloadFile(String endpoint, String fileId) async {
    return await _httpClient.get('$endpoint/download/$fileId');
  }

  /// Realiza una petición personalizada
  Future<HttpResponse> customRequest(
    String method,
    String endpoint, {
    dynamic body,
    Map<String, String>? queryParams,
  }) async {
    switch (method.toUpperCase()) {
      case 'GET':
        return await _httpClient.get(endpoint, queryParams: queryParams);
      case 'POST':
        return await _httpClient.post(endpoint, body: body, queryParams: queryParams);
      case 'PUT':
        return await _httpClient.put(endpoint, body: body, queryParams: queryParams);
      case 'PATCH':
        return await _httpClient.patch(endpoint, body: body, queryParams: queryParams);
      case 'DELETE':
        return await _httpClient.delete(endpoint, queryParams: queryParams);
      default:
        throw ArgumentError('Método HTTP no soportado: $method');
    }
  }
}
