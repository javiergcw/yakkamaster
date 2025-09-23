import '../services/service_general.dart';
import '../models/receive/dto_receive_health.dart';
import '../../../../utils/response_handler.dart';

/// Caso de uso para obtener el estado de salud del servidor
class GetHealthUseCase {
  final ServiceGeneral _serviceGeneral;

  GetHealthUseCase({ServiceGeneral? serviceGeneral})
      : _serviceGeneral = serviceGeneral ?? ServiceGeneral();

  /// Ejecuta el caso de uso para obtener el estado de salud
  /// 
  /// Retorna un [ApiResult<DtoReceiveHealth>] que contiene:
  /// - Los datos de salud del servidor si la operación es exitosa
  /// - Un error con mensaje descriptivo si la operación falla
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
  /// } else {
  ///   print('Error: ${result.message}');
  /// }
  /// ```
  Future<ApiResult<DtoReceiveHealth>> execute() async {
    try {
      // Llamar al servicio para obtener el estado de salud
      final result = await _serviceGeneral.getHealth();
      
      // El servicio ya maneja los errores internamente,
      // por lo que simplemente retornamos el resultado
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
}
