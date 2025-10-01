import '../models/receive/dto_receive_auth_profile_response.dart';
import '../services/service_auth_profile.dart';
import '../../../../utils/response_handler.dart';

/// Caso de uso para operaciones de perfil de autenticación
class AuthProfileUseCase {
  final ServiceAuthProfile _serviceAuthProfile = ServiceAuthProfile();

  /// Obtiene el perfil de autenticación del usuario
  Future<ApiResult<DtoReceiveAuthProfileResponse>> getAuthProfile() async {
    try {
      print('AuthProfileUseCase.getAuthProfile - Iniciando obtención de perfil...');
      
      final result = await _serviceAuthProfile.getAuthProfile();
      
      if (result.isSuccess && result.data != null) {
        final profile = result.data!;
        print('AuthProfileUseCase.getAuthProfile - Perfil obtenido exitosamente:');
        print('  - Usuario: ${profile.user.email}');
        print('  - Nombre: ${profile.displayName}');
        print('  - Rol actual: ${profile.currentRoleWithEmoji}');
        print('  - Estado: ${profile.user.status}');
        print('  - Tiene perfil builder: ${profile.hasBuilderProfile}');
        print('  - Tiene perfil labour: ${profile.hasLabourProfile}');
        print('  - Perfil completo: ${profile.isProfileComplete}');
      } else {
        print('AuthProfileUseCase.getAuthProfile - Error obteniendo perfil: ${result.message}');
      }

      return result;
    } catch (e) {
      print('AuthProfileUseCase.getAuthProfile - Excepción: $e');
      return ApiResult<DtoReceiveAuthProfileResponse>.error(
        message: 'Error in getAuthProfile use case: $e',
        error: e,
      );
    }
  }

  /// Obtiene información básica del usuario
  Map<String, dynamic> getUserBasicInfo(DtoReceiveAuthProfileResponse profile) {
    return {
      'id': profile.user.id,
      'email': profile.user.email,
      'fullName': profile.user.fullName,
      'displayName': profile.displayName,
      'avatarUrl': profile.avatarUrl,
      'currentRole': profile.currentRole,
      'status': profile.user.status,
    };
  }

  /// Obtiene información de contacto
  Map<String, String> getContactInfo(DtoReceiveAuthProfileResponse profile) {
    return profile.contactInfo;
  }

  /// Obtiene estadísticas del perfil
  Map<String, dynamic> getProfileStats(DtoReceiveAuthProfileResponse profile) {
    return profile.profileStats;
  }

  /// Verifica si el usuario es un builder
  bool isBuilder(DtoReceiveAuthProfileResponse profile) {
    return profile.currentRole == 'builder';
  }

  /// Verifica si el usuario es un labour
  bool isLabour(DtoReceiveAuthProfileResponse profile) {
    return profile.currentRole == 'labour';
  }

  /// Verifica si el usuario tiene perfil completo
  bool hasCompleteProfile(DtoReceiveAuthProfileResponse profile) {
    return profile.isProfileComplete;
  }

  /// Obtiene el tiempo desde el último login
  Duration? getTimeSinceLastLogin(DtoReceiveAuthProfileResponse profile) {
    return profile.user.timeSinceLastLogin;
  }

  /// Obtiene el tiempo desde el cambio de rol
  Duration? getTimeSinceRoleChange(DtoReceiveAuthProfileResponse profile) {
    return profile.user.timeSinceRoleChange;
  }

  /// Obtiene información del perfil builder
  Map<String, dynamic>? getBuilderProfileInfo(DtoReceiveAuthProfileResponse profile) {
    if (profile.builderProfile == null) return null;
    
    return {
      'id': profile.builderProfile!.id,
      'companyName': profile.builderProfile!.companyName,
      'displayName': profile.builderProfile!.displayName,
      'location': profile.builderProfile!.location,
      'bio': profile.builderProfile!.bio,
      'isComplete': profile.builderProfile!.isComplete,
      'shortBio': profile.builderProfile!.shortBio,
    };
  }

  /// Obtiene información del perfil labour
  Map<String, dynamic>? getLabourProfileInfo(DtoReceiveAuthProfileResponse profile) {
    if (profile.labourProfile == null) return null;
    
    return {
      'id': profile.labourProfile!.id,
      'location': profile.labourProfile!.location,
      'bio': profile.labourProfile!.bio,
      'isEmpty': profile.labourProfile!.isEmpty,
      'hasBasicInfo': profile.labourProfile!.hasBasicInfo,
      'shortBio': profile.labourProfile!.shortBio,
    };
  }

  /// Obtiene un resumen completo del perfil
  Map<String, dynamic> getProfileSummary(DtoReceiveAuthProfileResponse profile) {
    return {
      'user': getUserBasicInfo(profile),
      'contact': getContactInfo(profile),
      'stats': getProfileStats(profile),
      'builderProfile': getBuilderProfileInfo(profile),
      'labourProfile': getLabourProfileInfo(profile),
      'isBuilder': isBuilder(profile),
      'isLabour': isLabour(profile),
      'hasCompleteProfile': hasCompleteProfile(profile),
      'timeSinceLastLogin': getTimeSinceLastLogin(profile)?.inHours,
      'timeSinceRoleChange': getTimeSinceRoleChange(profile)?.inHours,
    };
  }
}
