import '../../../../utils/crud_service.dart';
import '../../../../utils/response_handler.dart';
import '../api_builder_constants.dart';
import '../models/receive/dto_receive_job.dart';
import '../models/receive/dto_receive_job_visibility_update.dart';
import '../models/send/dto_send_job.dart';
import '../models/send/dto_send_job_visibility.dart';

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
      
      // Debug: imprimir la respuesta
      print('ServiceJobs.getJobs - Response body: ${response.body}');
      print('ServiceJobs.getJobs - Response jsonBody: ${response.jsonBody}');
      print('ServiceJobs.getJobs - Response jsonListBody: ${response.jsonListBody}');
      
      // Procesar la respuesta y convertir a List<DtoReceiveJob>
      // Usar fromJsonList para manejar arrays automáticamente
      final result = await _responseHandler.handleResponse<List<DtoReceiveJob>>(
        response,
        fromJsonList: (jsonList) {
          print('ServiceJobs.getJobs - fromJsonList called with ${jsonList.length} items');
          return jsonList.map((item) => DtoReceiveJob.fromJson(item as Map<String, dynamic>)).toList();
        },
      );

      return result;
    } catch (e) {
      print('ServiceJobs.getJobs - Error: $e');
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
      
      // Debug: imprimir la respuesta
      print('ServiceJobs.getJobById - Response status: ${response.statusCode}');
      print('ServiceJobs.getJobById - Response body: ${response.body}');
      print('ServiceJobs.getJobById - Response jsonBody: ${response.jsonBody}');
      print('ServiceJobs.getJobById - Response headers: ${response.headers}');
      
      // Procesar la respuesta y convertir a DtoReceiveJob
      // La respuesta tiene estructura: {"job": {...}, "message": "..."}
      print('ServiceJobs.getJobById - About to process response with ResponseHandler');
      final result = await _responseHandler.handleResponse<DtoReceiveJob>(
        response,
        fromJson: (json) {
          print('ServiceJobs.getJobById - fromJson called with keys: ${json.keys.toList()}');
          print('ServiceJobs.getJobById - fromJson called with full json: $json');
          
          // Extraer el objeto 'job' de la respuesta
          if (json.containsKey('job') && json['job'] != null) {
            print('ServiceJobs.getJobById - Found job key, parsing...');
            final jobData = json['job'] as Map<String, dynamic>;
            print('ServiceJobs.getJobById - Job data keys: ${jobData.keys.toList()}');
            print('ServiceJobs.getJobById - Job data id: ${jobData['id']}');
            print('ServiceJobs.getJobById - Job data description: ${jobData['description']}');
            print('ServiceJobs.getJobById - Job data many_labours: ${jobData['many_labours']}');
            print('ServiceJobs.getJobById - Job data total_wage: ${jobData['total_wage']}');
            
            try {
              final parsedJob = DtoReceiveJob.fromJson(jobData);
              print('ServiceJobs.getJobById - Successfully parsed job: ${parsedJob.id}');
              return parsedJob;
            } catch (parseError) {
              print('ServiceJobs.getJobById - Error parsing job data: $parseError');
              throw Exception('Error parsing job data: $parseError');
            }
          }
          print('ServiceJobs.getJobById - Job data not found in response');
          print('ServiceJobs.getJobById - Available keys: ${json.keys.toList()}');
          throw Exception('Job data not found in response');
        },
      );
      
      print('ServiceJobs.getJobById - ResponseHandler result isSuccess: ${result.isSuccess}');
      print('ServiceJobs.getJobById - ResponseHandler result data: ${result.data?.id}');
      print('ServiceJobs.getJobById - ResponseHandler result message: ${result.message}');

      return result;
    } catch (e) {
      print('ServiceJobs.getJobById - Error: $e');
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
      // La nueva estructura es: {"jobs": [...], "message": "..."}
      final result = await _responseHandler.handleResponse<List<DtoReceiveJob>>(
        response,
        fromJson: (json) {
          // Extraer el array 'jobs' de la respuesta
          if (json.containsKey('jobs') && json['jobs'] != null) {
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

  /// Actualiza la visibilidad de un job
  Future<ApiResult<DtoReceiveJobVisibilityUpdate>> updateJobVisibility(String jobId, DtoSendJobVisibility visibilityData) async {
    try {
      // Asegurar que el header de JWT esté configurado
      await _crudService.headerManager.loadBearerToken();
      
      // Construir la URL completa
      final url = ApiBuilderConstants.jobVisibility(jobId);
      print('🔍 ServiceJobs.updateJobVisibility - URL: $url');
      print('🔍 ServiceJobs.updateJobVisibility - Body: ${visibilityData.toJson()}');
      
      // Usar el método personalizado para endpoint completo
      final response = await _crudService.updateWithFullEndpoint(
        url,
        visibilityData.toJson(),
      );
      
      // Procesar la respuesta y convertir a DtoReceiveJobVisibilityUpdate
      final result = await _responseHandler.handleResponse<DtoReceiveJobVisibilityUpdate>(
        response,
        fromJson: (json) {
          // La respuesta tiene estructura: {"job": {...}, "message": "..."}
          return DtoReceiveJobVisibilityUpdate.fromJson(json);
        },
      );

      return result;
    } catch (e) {
      return ApiResult<DtoReceiveJobVisibilityUpdate>.error(
        message: 'Error updating job visibility: $e',
        error: e,
      );
    }
  }
}
