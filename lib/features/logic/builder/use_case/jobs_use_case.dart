import '../models/receive/dto_receive_job.dart';
import '../models/send/dto_send_job.dart';
import '../services/service_jobs.dart';
import '../../../../utils/response_handler.dart';

/// Caso de uso para operaciones de jobs
class JobsUseCase {
  final ServiceJobs _serviceJobs = ServiceJobs();

  /// Crea un nuevo job
  Future<ApiResult<DtoReceiveJob>> createJob(DtoSendJob jobData) async {
    try {
      // Validar datos antes de enviar
      if (!jobData.isValid) {
        return ApiResult<DtoReceiveJob>.error(
          message: 'Invalid job data. Missing fields: ${jobData.missingFields.join(', ')}',
        );
      }

      // Llamar al servicio para crear el job
      final result = await _serviceJobs.createJob(jobData);
      
      if (result.isSuccess && result.data != null) {
        print('Job created successfully: ${result.data!.id}');
      } else {
        print('Error creating job: ${result.message}');
      }

      return result;
    } catch (e) {
      return ApiResult<DtoReceiveJob>.error(
        message: 'Error in createJob use case: $e',
        error: e,
      );
    }
  }

  /// Obtiene todos los jobs del builder
  Future<ApiResult<List<DtoReceiveJob>>> getJobs() async {
    try {
      final result = await _serviceJobs.getJobs();
      
      if (result.isSuccess && result.data != null) {
        print('Jobs retrieved successfully: ${result.data!.length} jobs');
      } else {
        print('Error getting jobs: ${result.message}');
      }

      return result;
    } catch (e) {
      return ApiResult<List<DtoReceiveJob>>.error(
        message: 'Error in getJobs use case: $e',
        error: e,
      );
    }
  }

  /// Obtiene un job por ID
  Future<ApiResult<DtoReceiveJob>> getJobById(String id) async {
    try {
      print('JobsUseCase.getJobById - Starting with id: $id');
      
      if (id.trim().isEmpty) {
        print('JobsUseCase.getJobById - Empty ID provided');
        return ApiResult<DtoReceiveJob>.error(
          message: 'Job ID cannot be empty',
        );
      }

      print('JobsUseCase.getJobById - Calling service...');
      final result = await _serviceJobs.getJobById(id);
      
      print('JobsUseCase.getJobById - Service result isSuccess: ${result.isSuccess}');
      print('JobsUseCase.getJobById - Service result data: ${result.data?.id}');
      print('JobsUseCase.getJobById - Service result message: ${result.message}');
      
      if (result.isSuccess && result.data != null) {
        print('JobsUseCase.getJobById - Job retrieved successfully: ${result.data!.id}');
      } else {
        print('JobsUseCase.getJobById - Error getting job by ID: ${result.message}');
      }

      return result;
    } catch (e) {
      print('JobsUseCase.getJobById - Exception: $e');
      return ApiResult<DtoReceiveJob>.error(
        message: 'Error in getJobById use case: $e',
        error: e,
      );
    }
  }

  /// Actualiza un job existente
  Future<ApiResult<DtoReceiveJob>> updateJob(String id, DtoSendJob jobData) async {
    try {
      if (id.trim().isEmpty) {
        return ApiResult<DtoReceiveJob>.error(
          message: 'Job ID cannot be empty',
        );
      }

      // Validar datos antes de enviar
      if (!jobData.isValid) {
        return ApiResult<DtoReceiveJob>.error(
          message: 'Invalid job data. Missing fields: ${jobData.missingFields.join(', ')}',
        );
      }

      final result = await _serviceJobs.updateJob(id, jobData);
      
      if (result.isSuccess && result.data != null) {
        print('Job updated successfully: ${result.data!.id}');
      } else {
        print('Error updating job: ${result.message}');
      }

      return result;
    } catch (e) {
      return ApiResult<DtoReceiveJob>.error(
        message: 'Error in updateJob use case: $e',
        error: e,
      );
    }
  }

  /// Elimina un job
  Future<ApiResult<bool>> deleteJob(String id) async {
    try {
      if (id.trim().isEmpty) {
        return ApiResult<bool>.error(
          message: 'Job ID cannot be empty',
        );
      }

      final result = await _serviceJobs.deleteJob(id);
      
      if (result.isSuccess && result.data == true) {
        print('Job deleted successfully: $id');
      } else {
        print('Error deleting job: ${result.message}');
      }

      return result;
    } catch (e) {
      return ApiResult<bool>.error(
        message: 'Error in deleteJob use case: $e',
        error: e,
      );
    }
  }

  /// Obtiene jobs por jobsite ID
  Future<ApiResult<List<DtoReceiveJob>>> getJobsByJobsiteId(String jobsiteId) async {
    try {
      if (jobsiteId.trim().isEmpty) {
        return ApiResult<List<DtoReceiveJob>>.error(
          message: 'Jobsite ID cannot be empty',
        );
      }

      final result = await _serviceJobs.getJobsByJobsiteId(jobsiteId);
      
      if (result.isSuccess && result.data != null) {
        print('Jobs by jobsite retrieved successfully: ${result.data!.length} jobs for jobsite $jobsiteId');
      } else {
        print('Error getting jobs by jobsite ID: ${result.message}');
      }

      return result;
    } catch (e) {
      return ApiResult<List<DtoReceiveJob>>.error(
        message: 'Error in getJobsByJobsiteId use case: $e',
        error: e,
      );
    }
  }

  /// Valida los datos de un job antes de enviar
  bool validateJobData(DtoSendJob jobData) {
    return jobData.isValid;
  }

  /// Obtiene los campos faltantes de un job
  List<String> getMissingJobFields(DtoSendJob jobData) {
    return jobData.missingFields;
  }

  /// Crea un DtoSendJob con valores por defecto
  DtoSendJob createDefaultJob({
    required String jobsiteId,
    required String jobTypeId,
    String description = '',
    int manyLabours = 1,
    bool ongoingWork = false,
    double wageSiteAllowance = 0.0,
    double wageLeadingHandAllowance = 0.0,
    double wageProductivityAllowance = 0.0,
    double extrasOvertimeRate = 1.5,
    String startDateWork = '',
    String endDateWork = '',
    bool workSaturday = false,
    bool workSunday = false,
    String startTime = '08:00:00',
    String endTime = '17:00:00',
    int paymentDay = 15,
    bool requiresSupervisorSignature = false,
    String supervisorName = '',
    String visibility = 'PUBLIC',
    String paymentType = 'WEEKLY',
    List<String> licenseIds = const [],
    List<String> skillCategoryIds = const [],
    List<String> skillSubcategoryIds = const [],
  }) {
    return DtoSendJob.create(
      jobsiteId: jobsiteId,
      jobTypeId: jobTypeId,
      manyLabours: manyLabours,
      ongoingWork: ongoingWork,
      wageSiteAllowance: wageSiteAllowance,
      wageLeadingHandAllowance: wageLeadingHandAllowance,
      wageProductivityAllowance: wageProductivityAllowance,
      extrasOvertimeRate: extrasOvertimeRate,
      startDateWork: startDateWork,
      endDateWork: endDateWork,
      workSaturday: workSaturday,
      workSunday: workSunday,
      startTime: startTime,
      endTime: endTime,
      description: description,
      paymentDay: paymentDay,
      requiresSupervisorSignature: requiresSupervisorSignature,
      supervisorName: supervisorName,
      visibility: visibility,
      paymentType: paymentType,
      licenseIds: licenseIds,
      skillCategoryIds: skillCategoryIds,
      skillSubcategoryIds: skillSubcategoryIds,
    );
  }
}
