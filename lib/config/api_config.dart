class ApiConfig {
  // URLs base para diferentes entornos
  static const String devBaseUrl = 'https://dev-api.yakkasports.com';
  static const String stagingBaseUrl = 'https://staging-api.yakkasports.com';
  static const String productionBaseUrl = 'https://api.yakkasports.com';
  
  // URL actual (cambiar según el entorno)
  static const String currentBaseUrl = devBaseUrl;
  
  // Endpoints para documentos
  static const String uploadDocumentEndpoint = '/api/documents/upload';
  static const String deleteDocumentEndpoint = '/api/documents';
  static const String getUserDocumentsEndpoint = '/api/documents';
  
  // Timeouts
  static const int connectionTimeout = 30; // segundos
  static const int receiveTimeout = 30; // segundos
  
  // Headers por defecto
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Headers para subida de archivos
  static Map<String, String> get uploadHeaders => {
    'Accept': 'application/json',
  };
}
