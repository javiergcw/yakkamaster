import '../../../../utils/response_handler.dart';
import '../services/service_labour_applications.dart';
import '../models/send/dto_send_job_application.dart';
import '../models/receive/dto_receive_job_application_response.dart';

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
}
