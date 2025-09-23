import '../../../../utils/crud_service.dart';
import '../../../../utils/response_handler.dart';
import '../api_labour_constants.dart';
import '../models/send/dto_send_labour_profile.dart';

/// Servicio para operaciones de labour del API
class ServiceLabour {
  static final ServiceLabour _instance = ServiceLabour._internal();
  factory ServiceLabour() => _instance;
  ServiceLabour._internal();

  final CrudService _crudService = CrudService();
  final ResponseHandler _responseHandler = ResponseHandler();

  /// Crea o actualiza el perfil de trabajador
  Future<ApiResult<Map<String, dynamic>>> createLabourProfile(DtoSendLabourProfile profileData) async {
    try {
      // Asegurar que el header de JWT esté configurado
      await _crudService.headerManager.loadJwtToken();
      
      // Realizar petición POST al endpoint /api/v1/profiles/labour
      final response = await _crudService.create(
        ApiLabourConstants.labourProfile,
        profileData.toJson(),
      );
      
      // Procesar la respuesta
      final result = await _responseHandler.handleResponse<Map<String, dynamic>>(
        response,
        fromJson: (json) => json,
      );

      return result;
    } catch (e) {
      return ApiResult<Map<String, dynamic>>.error(
        message: 'Error al crear/actualizar el perfil de trabajador: $e',
        error: e,
      );
    }
  }
}
