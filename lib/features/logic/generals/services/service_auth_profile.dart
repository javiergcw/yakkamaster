import '../../../../utils/crud_service.dart';
import '../../../../utils/response_handler.dart';
import '../../builder/api_builder_constants.dart';
import '../models/receive/dto_receive_auth_profile_response.dart';

/// Servicio para operaciones de perfil de autenticación
class ServiceAuthProfile {
  static final ServiceAuthProfile _instance = ServiceAuthProfile._internal();
  factory ServiceAuthProfile() => _instance;
  ServiceAuthProfile._internal();

  final CrudService _crudService = CrudService();
  final ResponseHandler _responseHandler = ResponseHandler();

  /// Obtiene el perfil de autenticación del usuario
  Future<ApiResult<DtoReceiveAuthProfileResponse>> getAuthProfile() async {
    try {
      // Asegurar que el header de JWT esté configurado
      await _crudService.headerManager.loadBearerToken();
      
      // Realizar petición GET al endpoint /api/v1/auth/profile
      final response = await _crudService.getAll(ApiBuilderConstants.authProfile);
      
      // Debug: imprimir la respuesta
      print('ServiceAuthProfile.getAuthProfile - Response body: ${response.body}');
      print('ServiceAuthProfile.getAuthProfile - Response jsonBody: ${response.jsonBody}');
      
      // Procesar la respuesta y convertir a DtoReceiveAuthProfileResponse
      final result = await _responseHandler.handleResponse<DtoReceiveAuthProfileResponse>(
        response,
        fromJson: (json) {
          print('ServiceAuthProfile.getAuthProfile - fromJson called with keys: ${json.keys.toList()}');
          return DtoReceiveAuthProfileResponse.fromJson(json);
        },
      );

      if (result.isSuccess && result.data != null) {
        print('ServiceAuthProfile.getAuthProfile - Perfil obtenido exitosamente:');
        print('  - Usuario: ${result.data!.user.email}');
        print('  - Rol actual: ${result.data!.currentRole}');
        print('  - Tiene perfil builder: ${result.data!.hasBuilderProfile}');
        print('  - Tiene perfil labour: ${result.data!.hasLabourProfile}');
      }

      return result;
    } catch (e) {
      print('ServiceAuthProfile.getAuthProfile - Error: $e');
      return ApiResult<DtoReceiveAuthProfileResponse>.error(
        message: 'Error getting auth profile: $e',
        error: e,
      );
    }
  }
}
