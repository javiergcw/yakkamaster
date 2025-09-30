import '../../../../utils/http_client.dart';
import '../../../../utils/response_handler.dart';
import '../models/send/dto_send_job_application.dart';
import '../models/receive/dto_receive_job_application_response.dart';
import '../api_labour_constants.dart';

/// Servicio para operaciones de aplicaciones de labour
class ServiceLabourApplications {
  static final ServiceLabourApplications _instance = ServiceLabourApplications._internal();
  factory ServiceLabourApplications() => _instance;
  ServiceLabourApplications._internal();

  final HttpClient _httpClient = HttpClient();

  /// Aplica a un trabajo
  /// 
  /// [application] - Datos de la aplicación
  /// Retorna un [ApiResult] con la respuesta de la aplicación
  Future<ApiResult<DtoReceiveJobApplicationResponse>> applyToJob(DtoSendJobApplication application) async {
    try {
      print('ServiceLabourApplications.applyToJob - Applying to job: ${application.jobId}');
      print('ServiceLabourApplications.applyToJob - Application data: ${application.toJson()}');

      final response = await _httpClient.post(
        ApiLabourConstants.applicants,
        body: application.toJson(),
      );

      print('ServiceLabourApplications.applyToJob - Response status: ${response.statusCode}');
      print('ServiceLabourApplications.applyToJob - Response data: ${response.jsonBody}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final applicationResponse = DtoReceiveJobApplicationResponse.fromJson(response.jsonBody!);
        
        return ApiResult<DtoReceiveJobApplicationResponse>.success(
          applicationResponse,
        );
      } else {
        return ApiResult<DtoReceiveJobApplicationResponse>.error(
          message: 'Failed to submit application: HTTP ${response.statusCode}',
          error: 'HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      print('ServiceLabourApplications.applyToJob - Error: $e');
      return ApiResult<DtoReceiveJobApplicationResponse>.error(
        message: 'Error submitting application: $e',
        error: e,
      );
    }
  }
}
