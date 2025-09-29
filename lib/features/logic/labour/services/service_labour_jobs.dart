import '../../../../utils/crud_service.dart';
import '../../../../utils/response_handler.dart';
import '../api_labour_constants.dart';
import '../models/receive/dto_receive_labour_jobs.dart';

/// Servicio para operaciones de jobs de labour
class ServiceLabourJobs {
  static final ServiceLabourJobs _instance = ServiceLabourJobs._internal();
  factory ServiceLabourJobs() => _instance;
  ServiceLabourJobs._internal();

  final CrudService _crudService = CrudService();
  final ResponseHandler _responseHandler = ResponseHandler();

  /// Obtiene los jobs disponibles para labour
  Future<ApiResult<DtoReceiveLabourJobs>> getJobs() async {
    try {
      // Asegurar que el header de JWT esté configurado
      await _crudService.headerManager.loadBearerToken();
      
      // Realizar petición GET al endpoint /api/v1/labour/jobs
      final response = await _crudService.getAll(ApiLabourConstants.jobs);
      
      // Procesar la respuesta y convertir a DtoReceiveLabourJobs
      final result = await _responseHandler.handleResponse<DtoReceiveLabourJobs>(
        response,
        fromJson: DtoReceiveLabourJobs.fromJson,
      );

      return result;
    } catch (e) {
      return ApiResult<DtoReceiveLabourJobs>.error(
        message: 'Error getting jobs: $e',
        error: e,
      );
    }
  }
}
