import '../../../../utils/crud_service.dart';
import '../../../../utils/http_client.dart';
import '../../../../utils/response_handler.dart';
import '../api_labour_constants.dart';
import '../models/send/dto_send_labour_profile.dart';
import '../models/receive/dto_receive_create_labour_profile.dart';

/// Servicio para operaciones de labour del API
class ServiceLabour {
  static final ServiceLabour _instance = ServiceLabour._internal();
  factory ServiceLabour() => _instance;
  ServiceLabour._internal();

  final CrudService _crudService = CrudService();

  /// Verifica el estado de autenticación
  Future<bool> isAuthenticated() async {
    await _crudService.headerManager.loadBearerToken();
    return await _crudService.headerManager.hasBearerToken();
  }

  /// Crea o actualiza el perfil de trabajador
  Future<ApiResult<DtoReceiveCreateLabourProfile>> createLabourProfile(DtoSendLabourProfile profileData) async {
    try {
      // Cargar solo el Bearer token (sin licencias)
      await _crudService.headerManager.loadBearerToken();
      
      // Verificar que el Bearer token esté disponible
      final hasToken = await _crudService.headerManager.hasBearerToken();
      if (!hasToken) {
        return ApiResult<DtoReceiveCreateLabourProfile>.error(
          message: 'No se encontró token de autenticación. Por favor, inicie sesión nuevamente.',
          error: 'Missing Bearer token',
        );
      }
      
      // Realizar petición POST al endpoint /api/v1/profiles/labour
      final response = await _crudService.create(
        ApiLabourConstants.labourProfile,
        profileData.toJson(),
      );
      
      // Verificar si la respuesta es exitosa
      if (!response.isSuccess) {
        return ApiResult<DtoReceiveCreateLabourProfile>.error(
          message: _getErrorMessage(response),
          statusCode: response.statusCode,
          error: response.error,
        );
      }
      
      // Procesar la respuesta JSON
      try {
        final jsonBody = response.jsonBody;
        if (jsonBody == null) {
          return ApiResult<DtoReceiveCreateLabourProfile>.error(
            message: 'Respuesta vacía del servidor',
            statusCode: response.statusCode,
            error: 'Empty response',
          );
        }
        
        // Crear el DTO desde el JSON
        final profileResponse = DtoReceiveCreateLabourProfile.fromJson(jsonBody);
        return ApiResult<DtoReceiveCreateLabourProfile>.success(profileResponse);
        
      } catch (parseError) {
        return ApiResult<DtoReceiveCreateLabourProfile>.error(
          message: 'Error al procesar la respuesta del servidor: $parseError',
          statusCode: response.statusCode,
          error: parseError,
        );
      }
      
    } catch (e) {
      return ApiResult<DtoReceiveCreateLabourProfile>.error(
        message: 'Error al crear/actualizar el perfil de trabajador: $e',
        error: e,
      );
    }
  }
  
  /// Obtiene un mensaje de error descriptivo
  String _getErrorMessage(HttpResponse response) {
    switch (response.statusCode) {
      case 400:
        return 'Solicitud incorrecta';
      case 401:
        return 'No autorizado';
      case 403:
        return 'Acceso denegado';
      case 404:
        return 'Recurso no encontrado';
      case 409:
        return 'Conflicto de datos';
      case 422:
        return 'Datos de entrada inválidos';
      case 429:
        return 'Demasiadas solicitudes';
      case 500:
        return 'Error interno del servidor';
      case 502:
        return 'Servidor no disponible';
      case 503:
        return 'Servicio temporalmente no disponible';
      case 0:
        return response.body.isNotEmpty ? response.body : 'Error de conexión';
      default:
        return 'Error HTTP ${response.statusCode}';
    }
  }

}
