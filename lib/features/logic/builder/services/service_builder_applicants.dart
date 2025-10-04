import '../../../../utils/crud_service.dart';
import '../../../../utils/response_handler.dart';
import '../api_builder_constants.dart';
import '../models/receive/dto_receive_builder_applicants_response.dart';
import '../models/send/dto_send_hire_decision.dart';
import '../models/receive/dto_receive_hire_response.dart';
import '../models/receive/dto_receive_decline_response.dart';

/// Servicio para operaciones de applicants del builder
class ServiceBuilderApplicants {
  static final ServiceBuilderApplicants _instance = ServiceBuilderApplicants._internal();
  factory ServiceBuilderApplicants() => _instance;
  ServiceBuilderApplicants._internal();

  final CrudService _crudService = CrudService();
  final ResponseHandler _responseHandler = ResponseHandler();

  /// Obtiene todos los applicants del builder
  Future<ApiResult<DtoReceiveBuilderApplicantsResponse>> getApplicants() async {
    try {
      // Asegurar que el header de JWT esté configurado
      await _crudService.headerManager.loadBearerToken();
      
      // Realizar petición GET al endpoint /api/v1/builder/applicants
      final response = await _crudService.getAll(ApiBuilderConstants.applicants);
      
      // Debug: imprimir la respuesta
      print('ServiceBuilderApplicants.getApplicants - Response body: ${response.body}');
      print('ServiceBuilderApplicants.getApplicants - Response jsonBody: ${response.jsonBody}');
      
      // Procesar la respuesta y convertir a DtoReceiveBuilderApplicantsResponse
      final result = await _responseHandler.handleResponse<DtoReceiveBuilderApplicantsResponse>(
        response,
        fromJson: (json) {
          print('ServiceBuilderApplicants.getApplicants - fromJson called with keys: ${json.keys.toList()}');
          return DtoReceiveBuilderApplicantsResponse.fromJson(json);
        },
      );

      return result;
    } catch (e) {
      print('ServiceBuilderApplicants.getApplicants - Error: $e');
      return ApiResult<DtoReceiveBuilderApplicantsResponse>.error(
        message: 'Error getting applicants: $e',
        error: e,
      );
    }
  }

  /// Contrata un applicant
  Future<ApiResult<DtoReceiveHireResponse>> hireApplicant(DtoSendHireDecision hireDecision) async {
    try {
      // Validar datos antes de enviar
      if (!hireDecision.isValid) {
        return ApiResult<DtoReceiveHireResponse>.error(
          message: 'Invalid hire decision data. Errors: ${hireDecision.validationErrors.join(', ')}',
        );
      }

      // Asegurar que el header de JWT esté configurado
      await _crudService.headerManager.loadBearerToken();
      
      // Usar el mismo endpoint para hire y decline
      print('ServiceBuilderApplicants.hireApplicant - URL: ${ApiBuilderConstants.applicants}');
      print('ServiceBuilderApplicants.hireApplicant - Body: ${hireDecision.toJson()}');
      
      // Realizar petición POST al endpoint
      final response = await _crudService.create(ApiBuilderConstants.applicants, hireDecision.toJson());
      
      // Debug: imprimir la respuesta
      print('ServiceBuilderApplicants.hireApplicant - Response body: ${response.body}');
      print('ServiceBuilderApplicants.hireApplicant - Response jsonBody: ${response.jsonBody}');
      
      // Procesar la respuesta y convertir a DtoReceiveHireResponse
      final result = await _responseHandler.handleResponse<DtoReceiveHireResponse>(
        response,
        fromJson: (json) {
          print('ServiceBuilderApplicants.hireApplicant - fromJson called with keys: ${json.keys.toList()}');
          return DtoReceiveHireResponse.fromJson(json);
        },
      );

      if (result.isSuccess && result.data != null) {
        print('ServiceBuilderApplicants.hireApplicant - Applicant hired successfully:');
        print('  - Application ID: ${result.data!.applicationId}');
        print('  - Hired: ${result.data!.hired}');
        print('  - Assignment ID: ${result.data!.assignmentId}');
        print('  - Message: ${result.data!.message}');
      }

      return result;
    } catch (e) {
      print('ServiceBuilderApplicants.hireApplicant - Error: $e');
      return ApiResult<DtoReceiveHireResponse>.error(
        message: 'Error hiring applicant: $e',
        error: e,
      );
    }
  }

  /// Rechaza un applicant
  Future<ApiResult<DtoReceiveDeclineResponse>> declineApplicant(DtoSendHireDecision declineDecision) async {
    try {
      // Validar datos antes de enviar
      if (!declineDecision.isValid) {
        return ApiResult<DtoReceiveDeclineResponse>.error(
          message: 'Invalid decline decision data. Errors: ${declineDecision.validationErrors.join(', ')}',
        );
      }

      // Asegurar que el header de JWT esté configurado
      await _crudService.headerManager.loadBearerToken();
      
      // Usar el mismo endpoint para hire y decline
      print('ServiceBuilderApplicants.declineApplicant - URL: ${ApiBuilderConstants.applicants}');
      print('ServiceBuilderApplicants.declineApplicant - Body: ${declineDecision.toJson()}');
      
      // Realizar petición POST al endpoint
      final response = await _crudService.create(ApiBuilderConstants.applicants, declineDecision.toJson());
      
      // Debug: imprimir la respuesta
      print('ServiceBuilderApplicants.declineApplicant - Response body: ${response.body}');
      print('ServiceBuilderApplicants.declineApplicant - Response jsonBody: ${response.jsonBody}');
      
      // Procesar la respuesta y convertir a DtoReceiveDeclineResponse
      final result = await _responseHandler.handleResponse<DtoReceiveDeclineResponse>(
        response,
        fromJson: (json) {
          print('ServiceBuilderApplicants.declineApplicant - fromJson called with keys: ${json.keys.toList()}');
          return DtoReceiveDeclineResponse.fromJson(json);
        },
      );

      if (result.isSuccess && result.data != null) {
        print('ServiceBuilderApplicants.declineApplicant - Applicant declined successfully:');
        print('  - Application ID: ${result.data!.applicationId}');
        print('  - Hired: ${result.data!.hired}');
        print('  - Message: ${result.data!.message}');
      }

      return result;
    } catch (e) {
      print('ServiceBuilderApplicants.declineApplicant - Error: $e');
      return ApiResult<DtoReceiveDeclineResponse>.error(
        message: 'Error declining applicant: $e',
        error: e,
      );
    }
  }
}
