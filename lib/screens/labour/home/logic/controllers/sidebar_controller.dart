import 'package:get/get.dart';
import '../../../../../features/logic/generals/use_case/auth_profile_use_case.dart';
import '../../../../../features/logic/generals/models/receive/dto_receive_auth_profile_response.dart';

/// Controlador para el sidebar de labour
class SidebarController extends GetxController {
  final AuthProfileUseCase _authProfileUseCase = AuthProfileUseCase();
  
  // Estados observables
  final RxBool _isLoading = false.obs;
  final Rx<DtoReceiveAuthProfileResponse?> _authProfile = Rx<DtoReceiveAuthProfileResponse?>(null);
  final RxString _errorMessage = ''.obs;
  
  // Getters
  bool get isLoading => _isLoading.value;
  DtoReceiveAuthProfileResponse? get authProfile => _authProfile.value;
  String get errorMessage => _errorMessage.value;
  
  // Información del usuario
  String get userFullName {
    if (_authProfile.value != null) {
      return _authProfileUseCase.getUserFullName(_authProfile.value!);
    }
    return 'Usuario';
  }
  
  String get userEmail {
    if (_authProfile.value != null) {
      return _authProfileUseCase.getUserEmail(_authProfile.value!);
    }
    return 'usuario@ejemplo.com';
  }
  
  String get userId {
    if (_authProfile.value != null) {
      return _authProfileUseCase.getUserId(_authProfile.value!);
    }
    return '';
  }
  
  // Información específica del perfil de labour
  String get labourProfileId {
    if (_authProfile.value != null) {
      final labourInfo = _authProfileUseCase.getLabourProfileInfo(_authProfile.value!);
      return labourInfo['profileId'] ?? '';
    }
    return '';
  }
  
  bool get hasLabourProfile {
    if (_authProfile.value != null) {
      return _authProfileUseCase.hasLabourProfile(_authProfile.value!);
    }
    return false;
  }
  
  bool get isLabourProfileComplete {
    if (_authProfile.value != null) {
      final labourInfo = _authProfileUseCase.getLabourProfileInfo(_authProfile.value!);
      return labourInfo['isComplete'] ?? false;
    }
    return false;
  }
  
  // Información del perfil de builder (si existe)
  String get builderCompanyName {
    if (_authProfile.value != null) {
      return _authProfileUseCase.getBuilderCompanyName(_authProfile.value!);
    }
    return 'Sin perfil de builder';
  }
  
  bool get hasBuilderProfile {
    if (_authProfile.value != null) {
      return _authProfileUseCase.hasBuilderProfile(_authProfile.value!);
    }
    return false;
  }
  
  // Estadísticas del perfil
  Map<String, dynamic> get profileStats {
    if (_authProfile.value != null) {
      return _authProfileUseCase.getProfileStats(_authProfile.value!);
    }
    return {
      'hasBuilderProfile': false,
      'hasLabourProfile': false,
      'currentRole': '',
      'builderProfileComplete': false,
      'labourProfileComplete': false,
    };
  }
  
  @override
  void onInit() {
    super.onInit();
    loadAuthProfile();
  }
  
  /// Carga el perfil de autenticación del usuario
  Future<void> loadAuthProfile() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      
      print('SidebarController.loadAuthProfile - Cargando perfil de autenticación...');
      
      final result = await _authProfileUseCase.getAuthProfile();
      
      if (result.isSuccess && result.data != null) {
        _authProfile.value = result.data!;
        print('SidebarController.loadAuthProfile - Perfil cargado exitosamente');
        print('  - Usuario: ${userFullName}');
        print('  - Email: ${userEmail}');
        print('  - Tiene perfil labour: $hasLabourProfile');
        print('  - Perfil labour completo: $isLabourProfileComplete');
        print('  - Tiene perfil builder: $hasBuilderProfile');
      } else {
        _errorMessage.value = result.message ?? 'Error cargando perfil';
        print('SidebarController.loadAuthProfile - Error: ${_errorMessage.value}');
      }
    } catch (e) {
      _errorMessage.value = 'Error inesperado: $e';
      print('SidebarController.loadAuthProfile - Excepción: $e');
    } finally {
      _isLoading.value = false;
    }
  }
  
  /// Refresca el perfil de autenticación
  Future<void> refreshProfile() async {
    await loadAuthProfile();
  }
  
  /// Verifica si el usuario puede acceder a funcionalidades de builder
  bool canAccessBuilderFeatures() {
    return hasBuilderProfile;
  }
  
  /// Verifica si el usuario puede acceder a funcionalidades de labour
  bool canAccessLabourFeatures() {
    return hasLabourProfile;
  }
  
  /// Obtiene el rol actual del usuario
  String getCurrentRole() {
    if (_authProfile.value != null) {
      return _authProfileUseCase.getCurrentRole(_authProfile.value!);
    }
    return '';
  }
  
  /// Obtiene información completa del perfil para debugging
  Map<String, dynamic> getDebugInfo() {
    return {
      'isLoading': isLoading,
      'hasError': _errorMessage.value.isNotEmpty,
      'errorMessage': _errorMessage.value,
      'userFullName': userFullName,
      'userEmail': userEmail,
      'userId': userId,
      'currentRole': getCurrentRole(),
      'hasBuilderProfile': hasBuilderProfile,
      'hasLabourProfile': hasLabourProfile,
      'isLabourProfileComplete': isLabourProfileComplete,
      'labourProfileId': labourProfileId,
      'builderCompanyName': builderCompanyName,
      'profileStats': profileStats,
    };
  }
}
