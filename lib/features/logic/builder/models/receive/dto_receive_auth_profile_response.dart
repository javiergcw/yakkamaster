import 'dto_receive_user.dart';
import 'dto_receive_builder_profile.dart';
import 'dto_receive_labour_profile.dart';

/// DTO para recibir la respuesta completa del perfil de autenticación
class DtoReceiveAuthProfileResponse {
  final DtoReceiveUser user;
  final DtoReceiveBuilderProfile? builderProfile;
  final DtoReceiveLabourProfile? labourProfile;
  final String currentRole;
  final bool hasBuilderProfile;
  final bool hasLabourProfile;

  DtoReceiveAuthProfileResponse({
    required this.user,
    this.builderProfile,
    this.labourProfile,
    required this.currentRole,
    required this.hasBuilderProfile,
    required this.hasLabourProfile,
  });

  /// Constructor desde JSON
  factory DtoReceiveAuthProfileResponse.fromJson(Map<String, dynamic> json) {
    return DtoReceiveAuthProfileResponse(
      user: DtoReceiveUser.fromJson(json['user'] ?? {}),
      builderProfile: json['builder_profile'] != null && 
          json['builder_profile']['id'] != null && 
          json['builder_profile']['id'].toString().isNotEmpty
          ? DtoReceiveBuilderProfile.fromJson(json['builder_profile'])
          : null,
      labourProfile: json['labour_profile'] != null && 
          json['labour_profile']['id'] != null && 
          json['labour_profile']['id'].toString().isNotEmpty
          ? DtoReceiveLabourProfile.fromJson(json['labour_profile'])
          : null,
      currentRole: json['current_role']?.toString() ?? '',
      hasBuilderProfile: json['has_builder_profile'] == true,
      hasLabourProfile: json['has_labour_profile'] == true,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'builder_profile': builderProfile?.toJson(),
      'labour_profile': labourProfile?.toJson(),
      'current_role': currentRole,
      'has_builder_profile': hasBuilderProfile,
      'has_labour_profile': hasLabourProfile,
    };
  }

  /// Obtiene el nombre para mostrar del usuario
  String get displayName {
    if (currentRole == 'builder' && builderProfile != null) {
      return builderProfile!.displayNameOrCompany;
    } else if (currentRole == 'labour' && labourProfile != null) {
      return user.fullName;
    }
    return user.fullName;
  }

  /// Obtiene el avatar del usuario
  String get avatarUrl {
    return user.avatarUrl;
  }

  /// Obtiene la biografía del usuario
  String get bio {
    if (currentRole == 'builder' && builderProfile != null) {
      return builderProfile!.bio ?? '';
    } else if (currentRole == 'labour' && labourProfile != null) {
      return labourProfile!.bio ?? '';
    }
    return '';
  }

  /// Obtiene la ubicación del usuario
  String get location {
    if (currentRole == 'builder' && builderProfile != null) {
      return builderProfile!.location ?? '';
    } else if (currentRole == 'labour' && labourProfile != null) {
      return labourProfile!.location ?? '';
    }
    return '';
  }

  /// Verifica si el perfil está completo
  bool get isProfileComplete {
    if (currentRole == 'builder') {
      return builderProfile != null && builderProfile!.isComplete;
    } else if (currentRole == 'labour') {
      return labourProfile != null && labourProfile!.hasBasicInfo;
    }
    return false;
  }

  /// Obtiene el rol actual con emoji
  String get currentRoleWithEmoji {
    switch (currentRole) {
      case 'builder':
        return '🏗️ Builder';
      case 'labour':
        return '👷 Labour';
      default:
        return '👤 User';
    }
  }

  /// Obtiene información de contacto
  Map<String, String> get contactInfo {
    return {
      'email': user.email,
      'phone': user.phone ?? 'No disponible',
      'address': user.address ?? 'No disponible',
    };
  }

  /// Obtiene estadísticas del perfil
  Map<String, dynamic> get profileStats {
    return {
      'hasBuilderProfile': hasBuilderProfile,
      'hasLabourProfile': hasLabourProfile,
      'isProfileComplete': isProfileComplete,
      'currentRole': currentRole,
      'userStatus': user.status,
      'lastLogin': user.lastLoginAt,
      'roleChangedAt': user.roleChangedAt,
    };
  }

  @override
  String toString() {
    return 'DtoReceiveAuthProfileResponse(user: ${user.email}, currentRole: $currentRole, hasBuilderProfile: $hasBuilderProfile)';
  }
}
