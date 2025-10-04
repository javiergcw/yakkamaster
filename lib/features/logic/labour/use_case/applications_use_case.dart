import '../../../../utils/response_handler.dart';
import '../services/service_labour_applications.dart';
import '../models/send/dto_send_job_application.dart';
import '../models/receive/dto_receive_job_application_response.dart';
import '../models/receive/dto_receive_applications_response.dart';
import '../models/receive/dto_receive_job_application.dart';

/// Caso de uso para operaciones de aplicaciones de labour
class ApplicationsUseCase {
  static final ApplicationsUseCase _instance = ApplicationsUseCase._internal();
  factory ApplicationsUseCase() => _instance;
  ApplicationsUseCase._internal();

  final ServiceLabourApplications _serviceLabourApplications = ServiceLabourApplications();

  /// Aplica a un trabajo
  /// 
  /// [jobId] - ID del trabajo al que se aplica
  /// [coverLetter] - Carta de presentación (opcional)
  /// [resumeUrl] - URL del CV (opcional)
  /// Retorna un [ApiResult] con la respuesta de la aplicación
  Future<ApiResult<DtoReceiveJobApplicationResponse>> applyToJob({
    required String jobId,
    String? coverLetter,
    String? resumeUrl,
  }) async {
    try {
      print('ApplicationsUseCase.applyToJob - Applying to job: $jobId');
      print('ApplicationsUseCase.applyToJob - Cover letter: ${coverLetter != null ? 'provided' : 'null'}');
      print('ApplicationsUseCase.applyToJob - Resume URL: ${resumeUrl != null ? 'provided' : 'null'}');

      // Crear el DTO de aplicación
      final application = DtoSendJobApplication.create(
        jobId: jobId,
        coverLetter: coverLetter,
        resumeUrl: resumeUrl,
      );

      // Llamar al servicio
      final result = await _serviceLabourApplications.applyToJob(application);
      
      if (result.isSuccess) {
        print('ApplicationsUseCase.applyToJob - Application successful: ${result.data?.applicationId}');
      } else {
        print('ApplicationsUseCase.applyToJob - Application failed: ${result.message}');
      }
      
      return result;
    } catch (e) {
      print('ApplicationsUseCase.applyToJob - Error: $e');
      return ApiResult<DtoReceiveJobApplicationResponse>.error(
        message: 'Error in use case applying to job: $e',
        error: e,
      );
    }
  }

  /// Obtiene las aplicaciones del usuario
  /// 
  /// Retorna un [ApiResult] con la lista de aplicaciones
  Future<ApiResult<DtoReceiveApplicationsResponse>> getApplications() async {
    try {
      print('ApplicationsUseCase.getApplications - Getting applications...');

      // Llamar al servicio
      final result = await _serviceLabourApplications.getApplications();
      
      if (result.isSuccess) {
        print('ApplicationsUseCase.getApplications - Applications retrieved successfully: ${result.data?.applicationsCount} applications');
      } else {
        print('ApplicationsUseCase.getApplications - Failed to get applications: ${result.message}');
      }
      
      return result;
    } catch (e) {
      print('ApplicationsUseCase.getApplications - Error: $e');
      return ApiResult<DtoReceiveApplicationsResponse>.error(
        message: 'Error in use case getting applications: $e',
        error: e,
      );
    }
  }

  /// Obtiene solo las aplicaciones (lista filtrada)
  /// 
  /// Retorna un [ApiResult] con la lista de aplicaciones o lista vacía si no hay aplicaciones
  Future<ApiResult<List<DtoReceiveJobApplication>>> getApplicationsList() async {
    try {
      print('ApplicationsUseCase.getApplicationsList - Getting applications list...');

      final result = await getApplications();
      
      if (result.isSuccess && result.data != null) {
        if (result.data!.hasApplications) {
          print('ApplicationsUseCase.getApplicationsList - Found ${result.data!.applicationsCount} applications');
          return ApiResult<List<DtoReceiveJobApplication>>.success(result.data!.applications!);
        } else {
          // Caso cuando applications es null o está vacío - no es un error, solo no hay aplicaciones
          print('ApplicationsUseCase.getApplicationsList - No applications found (applications is null or empty)');
          return ApiResult<List<DtoReceiveJobApplication>>.success([]);
        }
      }
      
      print('ApplicationsUseCase.getApplicationsList - Error getting applications: ${result.message}');
      return ApiResult<List<DtoReceiveJobApplication>>.error(
        message: result.message ?? 'Error loading applications',
        error: result.error,
      );
    } catch (e) {
      print('ApplicationsUseCase.getApplicationsList - Error: $e');
      return ApiResult<List<DtoReceiveJobApplication>>.error(
        message: 'Error getting applications list: $e',
        error: e,
      );
    }
  }

  /// Obtiene aplicaciones por estado
  /// 
  /// [status] - Estado de las aplicaciones a filtrar (APPLIED, ACCEPTED, REJECTED)
  /// Retorna un [ApiResult] con la lista filtrada de aplicaciones
  Future<ApiResult<List<DtoReceiveJobApplication>>> getApplicationsByStatus(String status) async {
    try {
      print('ApplicationsUseCase.getApplicationsByStatus - Getting applications with status: $status');

      final result = await getApplications();
      
      if (result.isSuccess && result.data != null) {
        final filteredApplications = result.data!.getApplicationsByStatus(status);
        print('ApplicationsUseCase.getApplicationsByStatus - Found ${filteredApplications.length} applications with status: $status');
        
        return ApiResult<List<DtoReceiveJobApplication>>.success(filteredApplications);
      }
      
      print('ApplicationsUseCase.getApplicationsByStatus - No applications found for status: $status');
      return ApiResult<List<DtoReceiveJobApplication>>.error(
        message: result.message ?? 'No applications found for status: $status',
        error: result.error,
      );
    } catch (e) {
      print('ApplicationsUseCase.getApplicationsByStatus - Error: $e');
      return ApiResult<List<DtoReceiveJobApplication>>.error(
        message: 'Error getting applications by status: $e',
        error: e,
      );
    }
  }
}
