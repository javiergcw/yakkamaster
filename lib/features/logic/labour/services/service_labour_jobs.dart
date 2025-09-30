import '../../../../utils/crud_service.dart';
import '../../../../utils/response_handler.dart';
import '../api_labour_constants.dart';
import '../models/receive/dto_receive_labour_jobs.dart';
import '../models/receive/dto_receive_job_detail.dart';
import '../models/receive/dto_receive_job_detail_response.dart';

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

  /// Obtiene los detalles de un job específico por ID
  Future<ApiResult<DtoReceiveJobDetail>> getJobById(String jobId) async {
    try {
      // Asegurar que el header de JWT esté configurado
      await _crudService.headerManager.loadBearerToken();
      
      // Realizar petición GET al endpoint /api/v1/labour/jobs/{jobId}
      final response = await _crudService.getById(ApiLabourConstants.jobs, jobId);
      
      // Procesar la respuesta y convertir a DtoReceiveJobDetail
      final result = await _responseHandler.handleResponse<DtoReceiveJobDetail>(
        response,
        fromJson: DtoReceiveJobDetail.fromJson,
      );

      return result;
    } catch (e) {
      return ApiResult<DtoReceiveJobDetail>.error(
        message: 'Error getting job by ID: $e',
        error: e,
      );
    }
  }

  /// Obtiene los detalles completos de un job con información de aplicación
  Future<ApiResult<DtoReceiveJobDetailResponse>> getJobDetailWithApplication(String jobId) async {
    try {
      // Asegurar que el header de JWT esté configurado
      await _crudService.headerManager.loadBearerToken();
      
      // Realizar petición GET al endpoint /api/v1/labour/jobs/{jobId}
      final response = await _crudService.getById(ApiLabourConstants.jobs, jobId);
      
      // Procesar la respuesta y convertir a DtoReceiveJobDetailResponse
      final result = await _responseHandler.handleResponse<DtoReceiveJobDetailResponse>(
        response,
        fromJson: DtoReceiveJobDetailResponse.fromJson,
      );

      return result;
    } catch (e) {
      return ApiResult<DtoReceiveJobDetailResponse>.error(
        message: 'Error getting job detail with application: $e',
        error: e,
      );
    }
  }
}
