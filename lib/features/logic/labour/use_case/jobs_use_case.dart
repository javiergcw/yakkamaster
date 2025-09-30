import '../../../../utils/response_handler.dart';
import '../services/service_labour_jobs.dart';
import '../models/receive/dto_receive_labour_jobs.dart';
import '../models/receive/dto_receive_labour_job.dart';
import '../models/receive/dto_receive_job_detail.dart';
import '../models/receive/dto_receive_job_detail_response.dart';

/// Caso de uso para operaciones de jobs de labour
class JobsUseCase {
  static final JobsUseCase _instance = JobsUseCase._internal();
  factory JobsUseCase() => _instance;
  JobsUseCase._internal();

  final ServiceLabourJobs _serviceLabourJobs = ServiceLabourJobs();

  /// Obtiene los jobs disponibles para labour
  /// 
  /// Retorna un [ApiResult] con la lista de jobs
  /// o un error si la operación falla
  Future<ApiResult<DtoReceiveLabourJobs>> getJobs() async {
    try {
      // Llamar al servicio para obtener los jobs
      final result = await _serviceLabourJobs.getJobs();
      
      return result;
    } catch (e) {
      return ApiResult<DtoReceiveLabourJobs>.error(
        message: 'Error in use case getting jobs: $e',
        error: e,
      );
    }
  }

  /// Obtiene los jobs por status
  /// 
  /// [status] - Status para filtrar los jobs (ACTIVE, INACTIVE, etc.)
  /// Retorna un [ApiResult] con los jobs filtrados por status
  Future<ApiResult<List<DtoReceiveLabourJob>>> getJobsByStatus(String status) async {
    try {
      // Obtener todos los jobs
      final result = await getJobs();
      
      if (result.isSuccess && result.data != null) {
        // Filtrar por status
        final filteredJobs = result.data!.getJobsByStatus(status);
        
        return ApiResult<List<DtoReceiveLabourJob>>.success(filteredJobs);
      }
      
      return ApiResult<List<DtoReceiveLabourJob>>.error(
        message: result.message ?? 'Unknown error getting jobs',
        error: result.error,
      );
    } catch (e) {
      return ApiResult<List<DtoReceiveLabourJob>>.error(
        message: 'Error getting jobs by status $status: $e',
        error: e,
      );
    }
  }

  /// Obtiene los jobs por tipo
  /// 
  /// [jobType] - Tipo de job para filtrar
  /// Retorna un [ApiResult] con los jobs filtrados por tipo
  Future<ApiResult<List<DtoReceiveLabourJob>>> getJobsByType(String jobType) async {
    try {
      // Obtener todos los jobs
      final result = await getJobs();
      
      if (result.isSuccess && result.data != null) {
        // Filtrar por tipo
        final filteredJobs = result.data!.getJobsByType(jobType);
        
        return ApiResult<List<DtoReceiveLabourJob>>.success(filteredJobs);
      }
      
      return ApiResult<List<DtoReceiveLabourJob>>.error(
        message: result.message ?? 'Unknown error getting jobs',
        error: result.error,
      );
    } catch (e) {
      return ApiResult<List<DtoReceiveLabourJob>>.error(
        message: 'Error getting jobs by type $jobType: $e',
        error: e,
      );
    }
  }

  /// Obtiene los jobs aplicados
  /// 
  /// Retorna un [ApiResult] con los jobs donde has_applied = true
  Future<ApiResult<List<DtoReceiveLabourJob>>> getAppliedJobs() async {
    try {
      // Obtener todos los jobs
      final result = await getJobs();
      
      if (result.isSuccess && result.data != null) {
        // Filtrar jobs aplicados
        final appliedJobs = result.data!.getAppliedJobs();
        
        return ApiResult<List<DtoReceiveLabourJob>>.success(appliedJobs);
      }
      
      return ApiResult<List<DtoReceiveLabourJob>>.error(
        message: result.message ?? 'Unknown error getting applied jobs',
        error: result.error,
      );
    } catch (e) {
      return ApiResult<List<DtoReceiveLabourJob>>.error(
        message: 'Error getting applied jobs: $e',
        error: e,
      );
    }
  }

  /// Obtiene los jobs no aplicados
  /// 
  /// Retorna un [ApiResult] con los jobs donde has_applied = false
  Future<ApiResult<List<DtoReceiveLabourJob>>> getNotAppliedJobs() async {
    try {
      // Obtener todos los jobs
      final result = await getJobs();
      
      if (result.isSuccess && result.data != null) {
        // Filtrar jobs no aplicados
        final notAppliedJobs = result.data!.getNotAppliedJobs();
        
        return ApiResult<List<DtoReceiveLabourJob>>.success(notAppliedJobs);
      }
      
      return ApiResult<List<DtoReceiveLabourJob>>.error(
        message: result.message ?? 'Unknown error getting not applied jobs',
        error: result.error,
      );
    } catch (e) {
      return ApiResult<List<DtoReceiveLabourJob>>.error(
        message: 'Error getting not applied jobs: $e',
        error: e,
      );
    }
  }

  /// Obtiene los jobs por nivel de experiencia
  /// 
  /// [experienceLevel] - Nivel de experiencia para filtrar (BEGINNER, INTERMEDIATE, ADVANCED)
  /// Retorna un [ApiResult] con los jobs filtrados por nivel de experiencia
  Future<ApiResult<List<DtoReceiveLabourJob>>> getJobsByExperienceLevel(String experienceLevel) async {
    try {
      // Obtener todos los jobs
      final result = await getJobs();
      
      if (result.isSuccess && result.data != null) {
        // Filtrar por nivel de experiencia
        final filteredJobs = result.data!.getJobsByExperienceLevel(experienceLevel);
        
        return ApiResult<List<DtoReceiveLabourJob>>.success(filteredJobs);
      }
      
      return ApiResult<List<DtoReceiveLabourJob>>.error(
        message: result.message ?? 'Unknown error getting jobs by experience level',
        error: result.error,
      );
    } catch (e) {
      return ApiResult<List<DtoReceiveLabourJob>>.error(
        message: 'Error getting jobs by experience level $experienceLevel: $e',
        error: e,
      );
    }
  }

  /// Obtiene un job específico por ID con detalles completos
  /// 
  /// [jobId] - ID del job a buscar
  /// Retorna un [ApiResult] con el job encontrado o null
  Future<ApiResult<DtoReceiveJobDetail?>> getJobById(String jobId) async {
    try {
      // Llamar al servicio para obtener los detalles del job
      final result = await _serviceLabourJobs.getJobById(jobId);
      
      return result;
    } catch (e) {
      return ApiResult<DtoReceiveJobDetail?>.error(
        message: 'Error in use case getting job by ID: $e',
        error: e,
      );
    }
  }

  /// Obtiene los detalles completos de un job con información de aplicación
  /// 
  /// [jobId] - ID del job a buscar
  /// Retorna un [ApiResult] con el job y su aplicación (si existe)
  Future<ApiResult<DtoReceiveJobDetailResponse?>> getJobDetailWithApplication(String jobId) async {
    try {
      // Llamar al servicio para obtener los detalles del job con aplicación
      final result = await _serviceLabourJobs.getJobDetailWithApplication(jobId);
      
      return result;
    } catch (e) {
      return ApiResult<DtoReceiveJobDetailResponse?>.error(
        message: 'Error in use case getting job detail with application: $e',
        error: e,
      );
    }
  }
}
