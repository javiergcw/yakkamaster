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
        print('AuthProfileUseCase.getAuthProfile - Perfil obtenido exitosamente:');
        print('  - Usuario: ${result.data!.user.email}');
        print('  - Rol actual: ${result.data!.currentRole}');
        print('  - Tiene perfil builder: ${result.data!.hasBuilderProfile}');
        print('  - Tiene perfil labour: ${result.data!.hasLabourProfile}');
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

  /// Obtiene el nombre completo del usuario
  String getUserFullName(DtoReceiveAuthProfileResponse profile) {
    return profile.user.fullName.isNotEmpty ? profile.user.fullName : 'Usuario';
  }

  /// Obtiene el email del usuario
  String getUserEmail(DtoReceiveAuthProfileResponse profile) {
    return profile.user.email;
  }

  /// Obtiene el ID del usuario
  String getUserId(DtoReceiveAuthProfileResponse profile) {
    return profile.user.id;
  }

  /// Obtiene el rol actual del usuario
  String getCurrentRole(DtoReceiveAuthProfileResponse profile) {
    return profile.currentRole;
  }

  /// Verifica si el usuario tiene perfil de builder
  bool hasBuilderProfile(DtoReceiveAuthProfileResponse profile) {
    return profile.hasBuilderProfile;
  }

  /// Verifica si el usuario tiene perfil de labour
  bool hasLabourProfile(DtoReceiveAuthProfileResponse profile) {
    return profile.hasLabourProfile;
  }

  /// Obtiene el nombre de la empresa del builder (si existe)
  String getBuilderCompanyName(DtoReceiveAuthProfileResponse profile) {
    if (profile.hasBuilderProfile && profile.builderProfile != null) {
      return profile.builderProfile!.companyName?.isNotEmpty == true 
          ? profile.builderProfile!.companyName! 
          : 'Sin empresa registrada';
    }
    return 'Sin perfil de builder';
  }

  /// Obtiene el display name del builder (si existe)
  String getBuilderDisplayName(DtoReceiveAuthProfileResponse profile) {
    if (profile.hasBuilderProfile && profile.builderProfile != null) {
      return profile.builderProfile!.displayName?.isNotEmpty == true 
          ? profile.builderProfile!.displayName! 
          : 'Sin nombre de display';
    }
    return 'Sin perfil de builder';
  }

  /// Obtiene el ID del builder profile
  String getBuilderProfileId(DtoReceiveAuthProfileResponse profile) {
    if (profile.hasBuilderProfile && profile.builderProfile != null) {
      return profile.builderProfile!.id;
    }
    return '';
  }

  /// Obtiene información del perfil de builder
  Map<String, dynamic> getBuilderProfileInfo(DtoReceiveAuthProfileResponse profile) {
    if (profile.hasBuilderProfile && profile.builderProfile != null) {
      return {
        'companyName': profile.builderProfile!.companyName ?? '',
        'profileId': profile.builderProfile!.id,
        'isComplete': profile.builderProfile!.isComplete,
      };
    }
    return {
      'companyName': '',
      'profileId': '',
      'isComplete': false,
    };
  }

  /// Obtiene información del perfil de labour
  Map<String, dynamic> getLabourProfileInfo(DtoReceiveAuthProfileResponse profile) {
    if (profile.hasLabourProfile && profile.labourProfile != null) {
      return {
        'profileId': profile.labourProfile!.id,
        'isComplete': profile.labourProfile!.hasBasicInfo,
      };
    }
    return {
      'profileId': '',
      'isComplete': false,
    };
  }

  /// Obtiene estadísticas del perfil
  Map<String, dynamic> getProfileStats(DtoReceiveAuthProfileResponse profile) {
    return {
      'hasBuilderProfile': profile.hasBuilderProfile,
      'hasLabourProfile': profile.hasLabourProfile,
      'currentRole': profile.currentRole,
      'builderProfileComplete': profile.hasBuilderProfile && profile.builderProfile?.isComplete == true,
      'labourProfileComplete': profile.hasLabourProfile && profile.labourProfile?.hasBasicInfo == true,
    };
  }
}