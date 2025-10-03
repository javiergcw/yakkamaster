import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/constants.dart';
import '../../../../../features/logic/builder/use_case/auth_profile_use_case.dart';
import '../../../../../features/logic/builder/models/receive/dto_receive_auth_profile_response.dart';
import '../../presentation/pages/builder_home_screen.dart';
import '../../presentation/pages/map_screen.dart';
import '../../presentation/pages/messages_screen.dart' as builder_messages;
import '../../presentation/pages/edit_personal_details_screen.dart';

class ProfileScreenController extends GetxController {
  final RxInt selectedIndex = 3.obs; // Profile tab selected
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  
  // Caso de uso para auth profile
  final AuthProfileUseCase _authProfileUseCase = AuthProfileUseCase();
  
  // Estados reactivos para el perfil
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final Rx<DtoReceiveAuthProfileResponse?> _authProfile = Rx<DtoReceiveAuthProfileResponse?>(null);
  
  // Getters
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  DtoReceiveAuthProfileResponse? get authProfile => _authProfile.value;
  
  // Getters para datos del perfil
  String get userFullName => _authProfile.value != null 
      ? _authProfileUseCase.getUserFullName(_authProfile.value!) 
      : 'Usuario';
  
  // Display name del builder (prioridad sobre user full name)
  String get builderDisplayName => _authProfile.value != null 
      ? _authProfileUseCase.getBuilderDisplayName(_authProfile.value!) 
      : 'Usuario';
  
  String get userEmail => _authProfile.value != null 
      ? _authProfileUseCase.getUserEmail(_authProfile.value!) 
      : '';
  
  String get userId => _authProfile.value != null 
      ? _authProfileUseCase.getUserId(_authProfile.value!).length > 5 
          ? _authProfileUseCase.getUserId(_authProfile.value!).substring(0, 5)
          : _authProfileUseCase.getUserId(_authProfile.value!)
      : '';
  
  // ID del builder profile (recortado a 5 caracteres)
  String get builderProfileId => _authProfile.value != null 
      ? _authProfileUseCase.getBuilderProfileId(_authProfile.value!).length > 5 
          ? _authProfileUseCase.getBuilderProfileId(_authProfile.value!).substring(0, 5)
          : _authProfileUseCase.getBuilderProfileId(_authProfile.value!)
      : '';
  
  String get currentRole => _authProfile.value != null 
      ? _authProfileUseCase.getCurrentRole(_authProfile.value!) 
      : '';
  
  String get builderCompanyName => _authProfile.value != null 
      ? _authProfileUseCase.getBuilderCompanyName(_authProfile.value!) 
      : 'Sin perfil de builder';
  
  bool get hasBuilderProfile => _authProfile.value != null 
      ? _authProfileUseCase.hasBuilderProfile(_authProfile.value!) 
      : false;
  
  bool get hasLabourProfile => _authProfile.value != null 
      ? _authProfileUseCase.hasLabourProfile(_authProfile.value!) 
      : false;
  
  bool get isBuilderProfileComplete => _authProfile.value != null 
      ? _authProfileUseCase.getBuilderProfileInfo(_authProfile.value!)['isComplete'] as bool
      : false;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
    // Cargar perfil automáticamente
    loadAuthProfile();
  }

  /// Carga el perfil de autenticación del usuario
  Future<void> loadAuthProfile() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      
      print('ProfileScreenController.loadAuthProfile - Iniciando carga de perfil...');
      
      final result = await _authProfileUseCase.getAuthProfile();
      
      if (result.isSuccess && result.data != null) {
        _authProfile.value = result.data!;
        print('ProfileScreenController.loadAuthProfile - Perfil cargado exitosamente:');
        print('  - Usuario: ${userFullName}');
        print('  - Email: ${userEmail}');
        print('  - Rol: ${currentRole}');
        print('  - Tiene perfil builder: $hasBuilderProfile');
        print('  - Empresa: $builderCompanyName');
      } else {
        _errorMessage.value = result.message ?? 'Error loading profile';
        print('ProfileScreenController.loadAuthProfile - Error: ${result.message}');
      }
    } catch (e) {
      _errorMessage.value = 'Error loading profile: $e';
      print('ProfileScreenController.loadAuthProfile - Excepción: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Recarga el perfil de autenticación
  Future<void> refreshProfile() async {
    print('ProfileScreenController.refreshProfile - Refrescando perfil...');
    await loadAuthProfile();
  }

  /// Obtiene estadísticas del perfil
  Map<String, dynamic> getProfileStats() {
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

  void handleHelp() async {
    // Crear URL de WhatsApp usando las constantes generales
    final String whatsappUrl = 'https://wa.me/${AppConstants.whatsappSupportNumber}?text=${Uri.encodeComponent(AppConstants.whatsappSupportMessage)}';

    try {
      // Intentar abrir WhatsApp
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(
          Uri.parse(whatsappUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Si no se puede abrir WhatsApp, mostrar mensaje
        Get.snackbar(
          'Error',
          'No se pudo abrir WhatsApp. Asegúrate de tener la aplicación instalada.',
          backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Manejar errores
      Get.snackbar(
        'Error',
        'Error al abrir WhatsApp: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void handleTermsAndConditions() async {
    try {
      print('Intentando abrir URL: ${AppConstants.termsAndConditionsUrl}');
      
      // Intentar abrir la URL directamente
      final bool launched = await launchUrl(
        Uri.parse(AppConstants.termsAndConditionsUrl),
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched) {
        Get.snackbar(
          'Error',
          'No se pudo abrir los términos y condiciones.',
          backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error al abrir términos y condiciones: $e');
      Get.snackbar(
        'Error',
        'Error al abrir términos y condiciones: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void handleDeleteAccount() async {
    try {
      print('Intentando abrir URL de eliminación de cuenta: ${AppConstants.deleteAccountUrl}');
      
      // Intentar abrir la URL directamente
      final bool launched = await launchUrl(
        Uri.parse(AppConstants.deleteAccountUrl),
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched) {
        Get.snackbar(
          'Error',
          'No se pudo abrir el formulario de eliminación de cuenta.',
          backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error al abrir formulario de eliminación de cuenta: $e');
      Get.snackbar(
        'Error',
        'Error al abrir formulario de eliminación de cuenta: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void onItemTapped(int index) {
    selectedIndex.value = index;

    if (index == 0) {
      // Home
      Get.offAllNamed(BuilderHomeScreen.id, arguments: {'flavor': currentFlavor.value});
    } else if (index == 1) {
      // Map
      Get.offAllNamed(MapScreen.id, arguments: {'flavor': currentFlavor.value});
    } else if (index == 2) {
      // Messages
      Get.offAllNamed(builder_messages.MessagesScreen.id, arguments: {'flavor': currentFlavor.value});
    }
    // Profile (index == 3) - already on this screen
  }

  void navigateToEditPersonalDetails() {
    Get.toNamed(EditPersonalDetailsScreen.id, arguments: {'flavor': currentFlavor.value});
  }
}
