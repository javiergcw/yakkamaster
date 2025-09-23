import '../../../../utils/crud_service.dart';
import '../../../../utils/response_handler.dart';
import '../api_general_constants.dart';
import '../models/receive/dto_receive_health.dart';

/// Servicio para operaciones generales del API
class ServiceGeneral {
  static final ServiceGeneral _instance = ServiceGeneral._internal();
  factory ServiceGeneral() => _instance;
  ServiceGeneral._internal();

  final CrudService _crudService = CrudService();
  final ResponseHandler _responseHandler = ResponseHandler();

  /// Obtiene el estado de salud del servidor
  Future<ApiResult<DtoReceiveHealth>> getHealth() async {
    try {
      // Realizar petición GET al endpoint /health usando getAll
      final response = await _crudService.getAll(ApiGeneralConstants.health);
      
      // Procesar la respuesta y convertir a DtoReceiveHealth
      final result = await _responseHandler.handleResponse<DtoReceiveHealth>(
        response,
        fromJson: DtoReceiveHealth.fromJson,
      );

      return result;
    } catch (e) {
      return ApiResult<DtoReceiveHealth>.error(
        message: 'Error al obtener el estado de salud: $e',
        error: e,
      );
    }
  }
}
