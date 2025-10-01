import '../../../../utils/http_client.dart';
import '../../../../utils/response_handler.dart';
import '../models/receive/dto_receive_builder_applicants_response.dart';
import '../api_builder_constants.dart';

/// Servicio para operaciones de aplicantes del builder
class ServiceBuilderApplicants {
  static final ServiceBuilderApplicants _instance = ServiceBuilderApplicants._internal();
  factory ServiceBuilderApplicants() => _instance;
  ServiceBuilderApplicants._internal();

  final HttpClient _httpClient = HttpClient();

  /// Obtiene los aplicantes de los trabajos del builder
  /// 
  /// Retorna un [ApiResult] con la lista de trabajos y sus aplicantes
  Future<ApiResult<DtoReceiveBuilderApplicantsResponse>> getApplicants() async {
    try {
      print('ServiceBuilderApplicants.getApplicants - Getting applicants');

      final response = await _httpClient.get(
        ApiBuilderConstants.applicants,
      );

      print('ServiceBuilderApplicants.getApplicants - Response status: ${response.statusCode}');
      print('ServiceBuilderApplicants.getApplicants - Response data: ${response.jsonBody}');

      if (response.statusCode == 200) {
        final applicantsResponse = DtoReceiveBuilderApplicantsResponse.fromJson(response.jsonBody!);
        
        return ApiResult<DtoReceiveBuilderApplicantsResponse>.success(
          applicantsResponse,
        );
      } else {
        return ApiResult<DtoReceiveBuilderApplicantsResponse>.error(
          message: 'Failed to get applicants: HTTP ${response.statusCode}',
          error: 'HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      print('ServiceBuilderApplicants.getApplicants - Error: $e');
      return ApiResult<DtoReceiveBuilderApplicantsResponse>.error(
        message: 'Error getting applicants: $e',
        error: e,
      );
    }
  }
}
