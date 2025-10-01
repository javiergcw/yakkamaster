import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/constants.dart';
import '../../../../../screens/labour/home/presentation/pages/edit_personal_details_screen.dart' as labour_edit_personal;
import '../../../../../screens/labour/home/presentation/pages/edit_documents_screen.dart';
import '../../../../../screens/labour/home/presentation/pages/edit_bank_details_screen.dart';
import '../../../../../features/logic/generals/use_case/auth_profile_use_case.dart';
import '../../../../../features/logic/generals/models/receive/dto_receive_auth_profile_response.dart';

class ProfileScreenController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final ImagePicker picker = ImagePicker();
  final Rx<XFile?> selectedImage = Rx<XFile?>(null);
  final RxDouble userRating = 5.0.obs;
  final RxInt jobsCount = 0.obs;
  
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
  
  String get userEmail => _authProfile.value != null 
      ? _authProfileUseCase.getUserEmail(_authProfile.value!) 
      : '';
  
  String get userId => _authProfile.value != null 
      ? _authProfileUseCase.getUserId(_authProfile.value!).length > 5 
          ? _authProfileUseCase.getUserId(_authProfile.value!).substring(0, 5)
          : _authProfileUseCase.getUserId(_authProfile.value!)
      : '';
  
  String get currentRole => _authProfile.value != null 
      ? _authProfileUseCase.getCurrentRole(_authProfile.value!) 
      : '';
  
  bool get hasBuilderProfile => _authProfile.value != null 
      ? _authProfileUseCase.hasBuilderProfile(_authProfile.value!) 
      : false;
  
  bool get hasLabourProfile => _authProfile.value != null 
      ? _authProfileUseCase.hasLabourProfile(_authProfile.value!) 
      : false;
  
  bool get isLabourProfileComplete => _authProfile.value != null 
      ? _authProfileUseCase.getLabourProfileInfo(_authProfile.value!)['isComplete'] as bool
      : false;

  @override
  void onInit() {
    super.onInit();
    // Establecer flavor si se proporciona en los argumentos
    final arguments = Get.arguments;
    if (arguments != null && arguments['flavor'] != null) {
      currentFlavor.value = arguments['flavor'];
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
        print('  - Tiene perfil labour: $hasLabourProfile');
        print('  - Perfil labour completo: $isLabourProfileComplete');
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

  void handleEditPersonalDetails() {
    // Navegar a la pantalla de edición de detalles personales
    Get.toNamed(labour_edit_personal.EditPersonalDetailsScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void handleEditDocuments() {
    // Navegar a la pantalla de edición de documentos
    Get.toNamed(EditDocumentsScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void handleEditBankDetails() {
    // Navegar a la pantalla de edición de detalles bancarios
    Get.toNamed(EditBankDetailsScreen.id, arguments: {'flavor': currentFlavor.value});
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

  void handleLogOut() {
    // TODO: Implementar logout
    print('Log out pressed');
    Get.snackbar(
      'Info',
      'Logout functionality not implemented yet',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void handleEditProfileImage() {
    showImageSourceDialog();
  }

  void showImageSourceDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        title: Text(
          'Seleccionar imagen',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value))),
              title: Text(
                'Cámara',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value))),
              title: Text(
                'Galería',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Get.back();
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      // Solicitar permisos
      if (source == ImageSource.camera) {
        final status = await Permission.camera.request();
        if (!status.isGranted) {
          showPermissionDeniedDialog('cámara');
          return;
        }
      } else {
        final status = await Permission.photos.request();
        if (!status.isGranted) {
          showPermissionDeniedDialog('galería');
          return;
        }
      }

      // Seleccionar imagen
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImage.value = image;
        print('Imagen seleccionada: ${image.path}');
      }
    } catch (e) {
      print('Error al seleccionar imagen: $e');
      showErrorDialog('Error al seleccionar la imagen');
    }
  }

  void showPermissionDeniedDialog(String permission) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        title: Text(
          'Permiso requerido',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Se necesita permiso para acceder a la $permission. Por favor, habilita el permiso en la configuración de la aplicación.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: Text(
              'Configuración',
              style: TextStyle(
                color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        title: Text(
          'Error',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'OK',
              style: TextStyle(
                color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
