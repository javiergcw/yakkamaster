import '../../../../utils/crud_service.dart';
import '../../../../utils/response_handler.dart';
import '../api_builder_constants.dart';
import '../models/receive/dto_receive_job.dart';
import '../models/send/dto_send_job.dart';

/// Servicio para operaciones de jobs del API
class ServiceJobs {
  static final ServiceJobs _instance = ServiceJobs._internal();
  factory ServiceJobs() => _instance;
  ServiceJobs._internal();

  final CrudService _crudService = CrudService();
  final ResponseHandler _responseHandler = ResponseHandler();

  /// Crea un nuevo job
  Future<ApiResult<DtoReceiveJob>> createJob(DtoSendJob jobData) async {
    try {
      // Asegurar que el header de JWT esté configurado
      await _crudService.headerManager.loadBearerToken();
      
      // Realizar petición POST al endpoint /api/v1/builder/jobs
      final response = await _crudService.create(
        ApiBuilderConstants.jobs,
        jobData.toJson(),
      );
      
      // Procesar la respuesta y convertir a DtoReceiveJob
      // La respuesta tiene estructura: {"job": {...}, "message": "..."}
      final result = await _responseHandler.handleResponse<DtoReceiveJob>(
        response,
        fromJson: (json) {
          // Extraer el objeto 'job' de la respuesta
          if (json.containsKey('job') && json['job'] != null) {
            return DtoReceiveJob.fromJson(json['job'] as Map<String, dynamic>);
          }
          throw Exception('Job data not found in response');
        },
      );

      return result;
    } catch (e) {
      return ApiResult<DtoReceiveJob>.error(
        message: 'Error creating job: $e',
        error: e,
      );
    }
  }

  /// Obtiene los jobs del builder
  Future<ApiResult<List<DtoReceiveJob>>> getJobs() async {
    try {
      // Asegurar que el header de JWT esté configurado
      await _crudService.headerManager.loadBearerToken();
      
      // Realizar petición GET al endpoint /api/v1/builder/jobs
      final response = await _crudService.getAll(ApiBuilderConstants.jobs);
      
      // Procesar la respuesta y convertir a List<DtoReceiveJob>
      final result = await _responseHandler.handleResponse<List<DtoReceiveJob>>(
        response,
        fromJson: (json) {
          // La respuesta tiene estructura: {"jobs": [...], "message": "..."}
          if (json.containsKey('jobs') && json['jobs'] is List) {
            final jobsList = json['jobs'] as List;
            return jobsList.map((item) => DtoReceiveJob.fromJson(item as Map<String, dynamic>)).toList();
          }
          throw Exception('Jobs array not found in response');
        },
      );

      return result;
    } catch (e) {
      return ApiResult<List<DtoReceiveJob>>.error(
        message: 'Error getting jobs: $e',
        error: e,
      );
    }
  }

  /// Obtiene un job por ID
  Future<ApiResult<DtoReceiveJob>> getJobById(String id) async {
    try {
      // Asegurar que el header de JWT esté configurado
      await _crudService.headerManager.loadBearerToken();
      
      // Realizar petición GET al endpoint /api/v1/builder/jobs/:id
      final response = await _crudService.getById(ApiBuilderConstants.jobs, id);
      
      // Procesar la respuesta y convertir a DtoReceiveJob
      final result = await _responseHandler.handleResponse<DtoReceiveJob>(
        response,
        fromJson: DtoReceiveJob.fromJson,
      );

      return result;
    } catch (e) {
      return ApiResult<DtoReceiveJob>.error(
        message: 'Error getting job by ID: $e',
        error: e,
      );
    }
  }

  /// Actualiza un job existente
  Future<ApiResult<DtoReceiveJob>> updateJob(String id, DtoSendJob jobData) async {
    try {
      // Asegurar que el header de JWT esté configurado
      await _crudService.headerManager.loadBearerToken();
      
      // Realizar petición PUT al endpoint /api/v1/builder/jobs/:id
      final response = await _crudService.update(
        ApiBuilderConstants.jobs,
        id,
        jobData.toJson(),
      );
      
      // Procesar la respuesta y convertir a DtoReceiveJob
      final result = await _responseHandler.handleResponse<DtoReceiveJob>(
        response,
        fromJson: DtoReceiveJob.fromJson,
      );

      return result;
    } catch (e) {
      return ApiResult<DtoReceiveJob>.error(
        message: 'Error updating job: $e',
        error: e,
      );
    }
  }

  /// Elimina un job
  Future<ApiResult<bool>> deleteJob(String id) async {
    try {
      // Asegurar que el header de JWT esté configurado
      await _crudService.headerManager.loadBearerToken();
      
      // Realizar petición DELETE al endpoint /api/v1/builder/jobs/:id
      final response = await _crudService.delete(ApiBuilderConstants.jobs, id);
      
      // Procesar la respuesta
      final result = await _responseHandler.handleResponse<bool>(
        response,
        fromJson: (json) => true, // Si la respuesta es exitosa, consideramos que se eliminó
      );

      return result;
    } catch (e) {
      return ApiResult<bool>.error(
        message: 'Error deleting job: $e',
        error: e,
      );
    }
  }

  /// Obtiene jobs por jobsite ID
  Future<ApiResult<List<DtoReceiveJob>>> getJobsByJobsiteId(String jobsiteId) async {
    try {
      // Asegurar que el header de JWT esté configurado
      await _crudService.headerManager.loadBearerToken();
      
      // Realizar petición GET al endpoint /api/v1/builder/jobs?jobsite_id=:id
      final response = await _crudService.getAll(ApiBuilderConstants.jobs);
      
      // Procesar la respuesta y convertir a List<DtoReceiveJob>
      final result = await _responseHandler.handleResponse<List<DtoReceiveJob>>(
        response,
        fromJson: (json) {
          // La respuesta tiene estructura: {"jobs": [...], "message": "..."}
          if (json.containsKey('jobs') && json['jobs'] is List) {
            final jobsList = json['jobs'] as List;
            return jobsList.map((item) => DtoReceiveJob.fromJson(item as Map<String, dynamic>)).toList();
          }
          throw Exception('Jobs array not found in response');
        },
      );

      return result;
    } catch (e) {
      return ApiResult<List<DtoReceiveJob>>.error(
        message: 'Error getting jobs by jobsite ID: $e',
        error: e,
      );
    }
  }
}
