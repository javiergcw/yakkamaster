import '../../../../utils/response_handler.dart';
import '../services/service_labour.dart';
import '../models/send/dto_send_labour_profile.dart';

/// Caso de uso para operaciones de labour
class LabourUseCase {
  static final LabourUseCase _instance = LabourUseCase._internal();
  factory LabourUseCase() => _instance;
  LabourUseCase._internal();

  final ServiceLabour _serviceLabour = ServiceLabour();

  /// Crea o actualiza el perfil de trabajador
  /// 
  /// [firstName] - Nombre del trabajador
  /// [lastName] - Apellido del trabajador
  /// [location] - Ubicación del trabajador
  /// [bio] - Biografía/descripción del trabajador
  /// [avatarUrl] - URL del avatar del trabajador
  /// [phone] - Teléfono de contacto
  /// [skills] - Lista de habilidades del trabajador
  /// [licenses] - Lista de licencias del trabajador
  /// Retorna un [ApiResult] con la respuesta del servidor
  /// o un error si la operación falla
  Future<ApiResult<Map<String, dynamic>>> createLabourProfile({
    required String firstName,
    required String lastName,
    required String location,
    required String bio,
    required String avatarUrl,
    required String phone,
    required List<DtoSendLabourSkill> skills,
    required List<DtoSendLabourLicense> licenses,
  }) async {
    try {
      // Crear el DTO del perfil de trabajador
      final profileData = DtoSendLabourProfile(
        firstName: firstName,
        lastName: lastName,
        location: location,
        bio: bio,
        avatarUrl: avatarUrl,
        phone: phone,
        skills: skills,
        licenses: licenses,
      );

      // Llamar al servicio para crear/actualizar el perfil
      final result = await _serviceLabour.createLabourProfile(profileData);
      
      return result;
    } catch (e) {
      return ApiResult<Map<String, dynamic>>.error(
        message: 'Error en el caso de uso al crear perfil de trabajador: $e',
        error: e,
      );
    }
  }
}
