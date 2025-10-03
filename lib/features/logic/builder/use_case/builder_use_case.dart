import '../../../../utils/response_handler.dart';
import '../services/service_builder.dart';
import '../models/send/dto_send_builder_profile.dart';
import '../models/send/dto_send_builder_company.dart';
import '../models/receive/dto_receive_builder_company_response.dart';

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
        displayName: displayName,
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

  /// Asigna una empresa a un builder
  /// 
  /// [companyId] - ID de la empresa a asignar
  /// Retorna un [ApiResult] con la respuesta de asignación
  /// o un error si la operación falla
  Future<ApiResult<DtoReceiveBuilderCompanyResponse>> assignCompany(String companyId) async {
    try {
      // Crear el objeto de datos de asignación de empresa
      final companyData = DtoSendBuilderCompany(
        companyId: companyId,
      );

      // Llamar al servicio para asignar la empresa
      final result = await _serviceBuilder.assignCompany(companyData);
      
      return result;
    } catch (e) {
      return ApiResult<DtoReceiveBuilderCompanyResponse>.error(
        message: 'Error en el caso de uso al asignar empresa: $e',
        error: e,
      );
    }
  }

  /// Asigna una empresa a un builder con validación adicional
  /// 
  /// [companyId] - ID de la empresa a asignar
  /// Retorna un [ApiResult] con la respuesta de asignación
  /// o un error si la operación falla
  Future<ApiResult<DtoReceiveBuilderCompanyResponse>> assignCompanyWithValidation(String companyId) async {
    try {
      // Validar que el companyId no esté vacío
      if (companyId.trim().isEmpty) {
        return ApiResult<DtoReceiveBuilderCompanyResponse>.error(
          message: 'El ID de la empresa no puede estar vacío',
        );
      }

      // Crear el objeto de datos de asignación de empresa
      final companyData = DtoSendBuilderCompany(
        companyId: companyId.trim(),
      );

      // Validar datos antes de enviar
      if (!companyData.isValid) {
        return ApiResult<DtoReceiveBuilderCompanyResponse>.error(
          message: 'Los datos de la empresa no son válidos',
        );
      }

      if (!companyData.hasValidCompanyId) {
        return ApiResult<DtoReceiveBuilderCompanyResponse>.error(
          message: 'El ID de la empresa no tiene un formato válido',
        );
      }

      // Llamar al método principal de asignación
      return await assignCompany(companyId);
    } catch (e) {
      return ApiResult<DtoReceiveBuilderCompanyResponse>.error(
        message: 'Error al asignar empresa con validación: $e',
        error: e,
      );
    }
  }
}
