import '../services/service_general.dart';
import '../models/receive/dto_receive_health.dart';
import '../../../../utils/response_handler.dart';
import '../../../../utils/storage/license_storage.dart';

/// Caso de uso para obtener el estado de salud del servidor
class GetHealthUseCase {
  final ServiceGeneral _serviceGeneral;
  final LicenseStorage _licenseStorage;

  GetHealthUseCase({
    ServiceGeneral? serviceGeneral,
    LicenseStorage? licenseStorage,
  }) : _serviceGeneral = serviceGeneral ?? ServiceGeneral(),
       _licenseStorage = licenseStorage ?? LicenseStorage();

  /// Ejecuta el caso de uso para obtener el estado de salud
  /// 
  /// Retorna un [ApiResult<DtoReceiveHealth>] que contiene:
  /// - Los datos de salud del servidor si la operación es exitosa
  /// - Un error con mensaje descriptivo si la operación falla
  /// 
  /// Automáticamente guarda la licencia en el storage local si la operación es exitosa.
  /// 
  /// Ejemplo de uso:
  /// ```dart
  /// final useCase = GetHealthUseCase();
  /// final result = await useCase.execute();
  /// 
  /// if (result.isSuccess) {
  ///   final healthData = result.data!;
  ///   print('Estado del servidor: ${healthData.status}');
  ///   print('Versión: ${healthData.version}');
  ///   print('Licencia guardada: ${healthData.data.license}');
  /// } else {
  ///   print('Error: ${result.message}');
  /// }
  /// ```
  Future<ApiResult<DtoReceiveHealth>> execute() async {
    try {
      // Llamar al servicio para obtener el estado de salud
      final result = await _serviceGeneral.getHealth();
      
      // Si la operación fue exitosa, guardar la licencia en el storage
      if (result.isSuccess && result.data != null) {
        final healthData = result.data!;
        final license = healthData.data.license;
        
        if (license.isNotEmpty) {
          await _licenseStorage.setLicenseKey(license);
          print('Licencia guardada en storage: $license');
        }
      }
      
      return result;
    } catch (e) {
      // Manejo adicional de errores si es necesario
      return ApiResult<DtoReceiveHealth>.error(
        message: 'Error inesperado al obtener el estado de salud: $e',
        error: e,
      );
    }
  }

  /// Verifica si el servidor está saludable de manera rápida
  /// 
  /// Este método es útil para verificaciones rápidas sin necesidad
  /// de procesar toda la información de salud.
  /// 
  /// Retorna `true` si el servidor está saludable, `false` en caso contrario.
  Future<bool> isServerHealthy() async {
    try {
      final result = await execute();
      
      if (result.isSuccess && result.data != null) {
        return result.data!.isHealthy;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Obtiene información básica del servidor
  /// 
  /// Retorna un mapa con información básica del servidor:
  /// - 'isHealthy': bool - si el servidor está saludable
  /// - 'version': String - versión del servidor
  /// - 'timestamp': String - timestamp de la respuesta
  /// - 'uptime': String - tiempo de actividad del servidor
  Future<Map<String, dynamic>> getBasicServerInfo() async {
    try {
      final result = await execute();
      
      if (result.isSuccess && result.data != null) {
        final health = result.data!;
        return {
          'isHealthy': health.isHealthy,
          'version': health.version,
          'timestamp': health.timestamp,
          'uptime': health.data.uptime,
          'license': health.data.license,
        };
      }
      
      return {
        'isHealthy': false,
        'version': 'unknown',
        'timestamp': DateTime.now().toIso8601String(),
        'uptime': 'unknown',
        'license': 'unknown',
      };
    } catch (e) {
      return {
        'isHealthy': false,
        'version': 'error',
        'timestamp': DateTime.now().toIso8601String(),
        'uptime': 'error',
        'license': 'error',
      };
    }
  }

  /// Inicializa la aplicación obteniendo el estado de salud y guardando la licencia
  /// 
  /// Este método debe ser llamado al iniciar la aplicación para:
  /// - Verificar que el servidor esté funcionando
  /// - Obtener y guardar la licencia automáticamente
  /// - Configurar el estado inicial de la aplicación
  /// 
  /// Retorna un [ApiResult<Map<String, dynamic>>] con información del estado de inicialización
  Future<ApiResult<Map<String, dynamic>>> initializeApp() async {
    try {
      print('Iniciando aplicación - Verificando estado del servidor...');
      
      // Ejecutar el caso de uso para obtener el estado de salud
      final result = await execute();
      
      if (result.isSuccess && result.data != null) {
        final healthData = result.data!;
        final license = healthData.data.license;
        
        // Verificar si la licencia se guardó correctamente
        final storedLicense = await _licenseStorage.getLicenseKey();
        final licenseSaved = storedLicense == license;
        
        print('Aplicación inicializada exitosamente');
        print('Servidor saludable: ${healthData.isHealthy}');
        print('Versión: ${healthData.version}');
        print('Licencia obtenida: ${license.isNotEmpty ? "Sí" : "No"}');
        print('Licencia guardada: ${licenseSaved ? "Sí" : "No"}');
        
        return ApiResult<Map<String, dynamic>>.success({
          'isHealthy': healthData.isHealthy,
          'version': healthData.version,
          'timestamp': healthData.timestamp,
          'uptime': healthData.data.uptime,
          'license': license,
          'licenseSaved': licenseSaved,
          'serverStatus': healthData.status,
          'initializationTime': DateTime.now().toIso8601String(),
        });
      } else {
        print('Error al inicializar aplicación: ${result.message}');
        
        return ApiResult<Map<String, dynamic>>.error(
          message: 'Error al inicializar la aplicación: ${result.message}',
          error: result.error,
        );
      }
    } catch (e) {
      print('Error inesperado al inicializar aplicación: $e');
      
      return ApiResult<Map<String, dynamic>>.error(
        message: 'Error inesperado al inicializar la aplicación: $e',
        error: e,
      );
    }
  }

  /// Verifica si la aplicación ya tiene una licencia guardada
  /// 
  /// Retorna `true` si existe una licencia guardada, `false` en caso contrario
  Future<bool> hasStoredLicense() async {
    return await _licenseStorage.hasLicenseKey();
  }

  /// Obtiene la licencia guardada
  /// 
  /// Retorna la licencia guardada o `null` si no existe
  Future<String?> getStoredLicense() async {
    return await _licenseStorage.getLicenseKey();
  }
}
