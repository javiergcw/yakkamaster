import '../../../../utils/response_handler.dart';
import '../services/service_auth.dart';
import '../models/send/dto_send_login.dart';
import '../models/send/dto_send_register.dart';
import '../models/receive/dto_receive_login.dart';
import '../models/receive/dto_receive_register.dart';

/// Caso de uso para operaciones de autenticación
class AuthUseCase {
  static final AuthUseCase _instance = AuthUseCase._internal();
  factory AuthUseCase() => _instance;
  AuthUseCase._internal();

  final ServiceAuth _serviceAuth = ServiceAuth();

  /// Realiza el login del usuario
  /// 
  /// [email] - Email del usuario
  /// [password] - Contraseña del usuario
  /// Retorna un [ApiResult] con los datos del usuario y tokens
  /// o un error si la operación falla
  Future<ApiResult<DtoReceiveLogin>> login(String email, String password) async {
    try {
      // Crear el DTO de login
      final loginData = DtoSendLogin(
        email: email,
        password: password,
      );

      // Llamar al servicio para realizar el login
      final result = await _serviceAuth.login(loginData);
      
      return result;
    } catch (e) {
      return ApiResult<DtoReceiveLogin>.error(
        message: 'Error en el caso de uso al realizar login: $e',
        error: e,
      );
    }
  }

  /// Registra un nuevo usuario
  /// 
  /// [email] - Email del usuario
  /// [password] - Contraseña del usuario
  /// [autoVerify] - Si el usuario debe ser verificado automáticamente
  /// Retorna un [ApiResult] con los datos del usuario registrado
  /// o un error si la operación falla
  Future<ApiResult<DtoReceiveRegister>> register(String email, String password, {bool autoVerify = true}) async {
    try {
      // Crear el DTO de registro
      final registerData = DtoSendRegister(
        email: email,
        password: password,
        autoVerify: autoVerify,
      );

      // Llamar al servicio para realizar el registro
      final result = await _serviceAuth.register(registerData);
      
      return result;
    } catch (e) {
      return ApiResult<DtoReceiveRegister>.error(
        message: 'Error en el caso de uso al registrar usuario: $e',
        error: e,
      );
    }
  }
}
