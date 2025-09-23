import '../../../../utils/crud_service.dart';
import '../../../../utils/response_handler.dart';
import '../api_auth_constants.dart';
import '../models/send/dto_send_login.dart';
import '../models/send/dto_send_register.dart';
import '../models/receive/dto_receive_login.dart';
import '../models/receive/dto_receive_register.dart';

/// Servicio para operaciones de autenticación del API
class ServiceAuth {
  static final ServiceAuth _instance = ServiceAuth._internal();
  factory ServiceAuth() => _instance;
  ServiceAuth._internal();

  final CrudService _crudService = CrudService();
  final ResponseHandler _responseHandler = ResponseHandler();

  /// Realiza el login del usuario
  Future<ApiResult<DtoReceiveLogin>> login(DtoSendLogin loginData) async {
    try {
      // Realizar petición POST al endpoint /api/v1/auth/login
      final response = await _crudService.create(
        ApiAuthConstants.login,
        loginData.toJson(),
      );
      
      // Procesar la respuesta y convertir a DtoReceiveLogin
      final result = await _responseHandler.handleResponse<DtoReceiveLogin>(
        response,
        fromJson: DtoReceiveLogin.fromJson,
      );

      return result;
    } catch (e) {
      return ApiResult<DtoReceiveLogin>.error(
        message: 'Error al realizar el login: $e',
        error: e,
      );
    }
  }

  /// Registra un nuevo usuario
  Future<ApiResult<DtoReceiveRegister>> register(DtoSendRegister registerData) async {
    try {
      // Realizar petición POST al endpoint /api/v1/auth/register
      final response = await _crudService.create(
        ApiAuthConstants.register,
        registerData.toJson(),
      );
      
      // Procesar la respuesta y convertir a DtoReceiveRegister
      final result = await _responseHandler.handleResponse<DtoReceiveRegister>(
        response,
        fromJson: DtoReceiveRegister.fromJson,
      );

      return result;
    } catch (e) {
      return ApiResult<DtoReceiveRegister>.error(
        message: 'Error al registrar el usuario: $e',
        error: e,
      );
    }
  }
}
