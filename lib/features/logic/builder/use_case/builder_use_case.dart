import '../../../../utils/response_handler.dart';
import '../services/service_builder.dart';
import '../models/send/dto_send_builder_profile.dart';

/// Caso de uso para operaciones de builder
class BuilderUseCase {
  static final BuilderUseCase _instance = BuilderUseCase._internal();
  factory BuilderUseCase() => _instance;
  BuilderUseCase._internal();

  final ServiceBuilder _serviceBuilder = ServiceBuilder();

  /// Crea o actualiza el perfil de constructor
  /// 
  /// [companyName] - Nombre de la empresa
  /// [displayName] - Nombre para mostrar
  /// [location] - Ubicación de la empresa
  /// [bio] - Biografía/descripción de la empresa
  /// [avatarUrl] - URL del avatar/logo de la empresa
  /// [phone] - Teléfono de contacto
  /// [licenses] - Lista de licencias del constructor
  /// Retorna un [ApiResult] con la respuesta del servidor
  /// o un error si la operación falla
  Future<ApiResult<Map<String, dynamic>>> createBuilderProfile({
    required String companyName,
    required String displayName,
    required String location,
    required String bio,
    required String avatarUrl,
    required String phone,
    required List<DtoSendBuilderLicense> licenses,
  }) async {
    try {
      // Crear el DTO del perfil de constructor
      final profileData = DtoSendBuilderProfile(
        companyName: companyName,
        displayName: displayName,
        location: location,
        bio: bio,
        avatarUrl: avatarUrl,
        phone: phone,
        licenses: licenses,
      );

      // Llamar al servicio para crear/actualizar el perfil
      final result = await _serviceBuilder.createBuilderProfile(profileData);
      
      return result;
    } catch (e) {
      return ApiResult<Map<String, dynamic>>.error(
        message: 'Error en el caso de uso al crear perfil de constructor: $e',
        error: e,
      );
    }
  }
}
