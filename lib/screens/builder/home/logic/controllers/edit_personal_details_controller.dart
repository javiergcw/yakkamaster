import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/logic/builder/use_case/builder_use_case.dart';
import '../../../../../features/logic/builder/use_case/auth_profile_use_case.dart';
import '../../../../../features/logic/builder/models/receive/dto_receive_auth_profile_response.dart';
import '../../../../../features/logic/masters/use_case/master_use_case.dart';
import '../../../../../features/logic/masters/models/receive/dto_receive_company.dart';
import '../../presentation/pages/builder_home_screen.dart';
import '../../presentation/pages/camera_with_overlay_screen.dart';

class EditPersonalDetailsController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  
  // Use cases
  final BuilderUseCase _builderUseCase = BuilderUseCase();
  final AuthProfileUseCase _authProfileUseCase = AuthProfileUseCase();
  final MasterUseCase _masterUseCase = MasterUseCase();
  
  // Estados reactivos para el perfil
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final Rx<DtoReceiveAuthProfileResponse?> _authProfile = Rx<DtoReceiveAuthProfileResponse?>(null);
  
  // Variables para manejar empresas
  final RxList<DtoReceiveCompany> availableCompanies = <DtoReceiveCompany>[].obs;
  final RxString selectedCompanyId = ''.obs;
  
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

  // Controllers para los campos de texto - precargados con datos actuales
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  
  // Variable reactiva para el nombre de empresa
  final RxString selectedCompanyName = 'Test company by Yakka'.obs;
  
  // Variables para la imagen de perfil
  final Rx<File?> profileImage = Rx<File?>(null);
  final ImagePicker picker = ImagePicker();
  
  // Lista de empresas creadas por el usuario
  final RxList<String> userCreatedCompanies = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    print('EditPersonalDetailsController initialized');
    print('Initial profileImage.value: ${profileImage.value?.path}');
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
      
      print('EditPersonalDetailsController.loadAuthProfile - Iniciando carga de perfil...');
      
      final result = await _authProfileUseCase.getAuthProfile();
      
      if (result.isSuccess && result.data != null) {
        _authProfile.value = result.data!;
        print('EditPersonalDetailsController.loadAuthProfile - Perfil cargado exitosamente:');
        print('  - Usuario: $userFullName');
        print('  - Email: $userEmail');
        print('  - Rol: $currentRole');
        print('  - Tiene perfil builder: $hasBuilderProfile');
        print('  - Empresa: $builderCompanyName');
        
        // Precargar los campos con los datos del perfil
        _loadProfileData();
      } else {
        _errorMessage.value = result.message ?? 'Error loading profile';
        print('EditPersonalDetailsController.loadAuthProfile - Error: ${result.message}');
      }
    } catch (e) {
      _errorMessage.value = 'Error loading profile: $e';
      print('EditPersonalDetailsController.loadAuthProfile - Excepción: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Precarga los datos del perfil en los campos de texto
  void _loadProfileData() {
    try {
      // Precargar datos del usuario desde el auth profile
      if (_authProfile.value != null) {
        final user = _authProfile.value!.user;
        
        // Mapear datos del usuario
        firstNameController.text = user.firstName ?? '';
        lastNameController.text = user.lastName ?? '';
        emailController.text = user.email;
        phoneController.text = user.phone ?? '';
        
        print('User data loaded:');
        print('  - First name: ${user.firstName}');
        print('  - Last name: ${user.lastName}');
        print('  - Email: ${user.email}');
        print('  - Phone: ${user.phone}');
        
        // Precargar datos del builder si existe
        if (hasBuilderProfile && _authProfile.value!.builderProfile != null) {
          final builderProfile = _authProfile.value!.builderProfile!;
          companyNameController.text = builderProfile.companyName ?? '';
          selectedCompanyName.value = builderProfile.companyName ?? '';
          
          print('Builder profile data loaded:');
          print('  - Company name: ${builderProfile.companyName}');
          print('  - Display name: ${builderProfile.displayName}');
        }
      }
      
      print('Profile data loaded successfully');
    } catch (e) {
      print('Error loading profile data: $e');
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    companyNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }

  // Función para mostrar opciones de selección de imagen
  void showImageSourceDialog() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Select image',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Camera'),
              subtitle: const Text('Take a new photo'),
              onTap: () {
                Get.back();
                _openCameraWithOverlay();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text('Gallery'),
              subtitle: const Text('Select from gallery'),
              onTap: () {
                Get.back();
                pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Función para abrir la cámara con overlay
  Future<void> _openCameraWithOverlay() async {
    try {
      // Verificar permisos de cámara
      PermissionStatus status = await Permission.camera.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        Get.dialog(
          AlertDialog(
            title: const Text('Camera Permission'),
            content: const Text('This app needs camera access to take photos. Please grant permission in settings.'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  openAppSettings();
                },
                child: const Text('Settings'),
              ),
            ],
          ),
        );
        return;
      }

      if (!status.isGranted) {
        return;
      }

      // Navegar a la pantalla de cámara con overlay
      final File? capturedImage = await Get.to<File>(
        CameraWithOverlayScreen(
          flavor: currentFlavor.value,
          onImageCaptured: (File image) {
            // Este callback se ejecutará cuando se capture la imagen
            print('Image captured callback executed: ${image.path}');
          },
        ),
      );

      // Si se capturó una imagen, actualizarla
      if (capturedImage != null) {
        print('Image received from camera: ${capturedImage.path}');
        print('Before updating profileImage.value: ${profileImage.value?.path}');
        profileImage.value = capturedImage;
        print('After updating profileImage.value: ${profileImage.value?.path}');
        
        // Mostrar mensaje de éxito
        Get.snackbar(
          'Success',
          'Image updated successfully',
          backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        print('No image captured');
      }
    } catch (e) {
      print('Error opening camera with overlay: $e');
      Get.snackbar(
        'Error',
        'Error opening camera: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Función para verificar y solicitar permisos
  Future<bool> requestPermissions(ImageSource source) async {
    if (source == ImageSource.camera) {
      // Solicitar permiso de cámara
      PermissionStatus status = await Permission.camera.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        Get.dialog(
          AlertDialog(
            title: const Text('Camera Permission'),
            content: const Text('This app needs camera access to take photos. Please grant permission in settings.'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  openAppSettings();
                },
                child: const Text('Settings'),
              ),
            ],
          ),
        );
        return false;
      }
      return status.isGranted;
    } else {
      // Para galería, verificar permisos de almacenamiento
      PermissionStatus status = await Permission.photos.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        // Intentar con permisos de almacenamiento como fallback
        status = await Permission.storage.request();
      }
      return status.isGranted;
    }
  }

  // Función para seleccionar imagen
  Future<void> pickImage(ImageSource source) async {
    try {
      // Verificar permisos primero
      bool hasPermission = await requestPermissions(source);
      if (!hasPermission) {
        return;
      }

      // Mostrar indicador de carga
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      // Intentar seleccionar imagen con configuración más simple
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      // Cerrar indicador de carga
      if (Get.isDialogOpen!) {
        Get.back();
      }
      
      if (image != null) {
        profileImage.value = File(image.path);
        
        // Mostrar mensaje de éxito
        Get.snackbar(
          'Success',
          'Image updated successfully',
          backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      // Cerrar indicador de carga si está abierto
      if (Get.isDialogOpen!) {
        Get.back();
      }
      
      // Manejo específico de errores
      String errorMessage = 'Error selecting image';
      
      if (e.toString().contains('channel-error')) {
        errorMessage = 'Communication error. Try:\n1. Restart the app\n2. Check camera permissions\n3. Use gallery instead of camera';
      } else if (e.toString().contains('permission')) {
        errorMessage = 'Permissions not granted. Go to:\nSettings > Apps > Yakka Sports > Permissions';
      } else if (e.toString().contains('camera')) {
        errorMessage = 'Error accessing camera. Try using gallery.';
      } else if (e.toString().contains('pigeon')) {
        errorMessage = 'Plugin internal error. Try:\n1. Restart the app\n2. Use gallery instead of camera';
      }
      
      // Mostrar diálogo de error más informativo
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                // Si es error de cámara, sugerir usar galería
                if (source == ImageSource.camera && 
                    (e.toString().contains('channel-error') || 
                     e.toString().contains('camera') ||
                     e.toString().contains('pigeon'))) {
                  pickImage(ImageSource.gallery);
                }
              },
              child: const Text('Try with gallery'),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
      
      // Log del error para debugging
      print('Error al seleccionar imagen: $e');
    }
  }

  void handleSave() async {
    print('=== handleSave called ===');
    print('First name: "${firstNameController.text}"');
    print('Last name: "${lastNameController.text}"');
    print('Company name: "${selectedCompanyName.value}"');
    print('Email: "${emailController.text}"');
    print('Selected company ID: "${selectedCompanyId.value}"');
    
    // Solo validar que se haya seleccionado una empresa válida
    if (selectedCompanyId.value.isEmpty) {
      print('Validation failed - no company selected');
      Get.snackbar(
        'Error',
        'Please select a company',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }
    
    print('Validation passed - saving changes');
    
    // Mostrar indicador de carga
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    
    try {
      // Asignar la empresa al builder usando el use case
      final result = await _builderUseCase.assignCompanyWithValidation(selectedCompanyId.value);
      
      // Cerrar el loading
      if (Get.isDialogOpen!) {
        Get.back();
      }
      
      if (result.isSuccess && result.data != null) {
        print('Company assigned successfully: ${result.data!.builderProfile.displayName}');
        
        // Mostrar mensaje de éxito
        Get.snackbar(
          'Success',
          'Company assigned successfully! Personal details updated.',
          backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        
        // Navegar al BuilderHomeScreen
        print('Navigating to BuilderHomeScreen');
        Get.offAllNamed(BuilderHomeScreen.id);
        
      } else {
        print('Error assigning company: ${result.message}');
        Get.snackbar(
          'Error',
          result.message ?? 'Error assigning company',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
      
    } catch (e) {
      // Cerrar el loading si está abierto
      if (Get.isDialogOpen!) {
        Get.back();
      }
      
      print('Exception in handleSave: $e');
      Get.snackbar(
        'Error',
        'Unexpected error: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void navigateBack() {
    Get.back();
  }

  void addUserCompany(String company) {
    print('Adding user company to EditPersonalDetailsController: $company');
    if (!userCreatedCompanies.contains(company)) {
      userCreatedCompanies.add(company);
      print('Company added to list. Total companies: ${userCreatedCompanies.length}');
    } else {
      print('Company already exists in list');
    }
    
    // Actualizar tanto el controller como la variable reactiva
    try {
      companyNameController.text = company;
      selectedCompanyName.value = company;
      print('Updated companyNameController and selectedCompanyName with: $company');
    } catch (e) {
      print('Warning: Could not update companyNameController, it may be disposed: $e');
    }
  }

  /// Selecciona una empresa y actualiza el companyId
  void selectCompany(String companyName, String companyId) {
    print('Selecting company: $companyName with ID: $companyId');
    selectedCompanyName.value = companyName;
    selectedCompanyId.value = companyId;
    companyNameController.text = companyName;
  }

  /// Carga las empresas disponibles del API
  Future<void> loadAvailableCompanies() async {
    try {
      print('Loading available companies...');
      final result = await _masterUseCase.getCompaniesList();
      
      if (result.isSuccess && result.data != null) {
        availableCompanies.value = result.data!;
        print('Loaded ${availableCompanies.length} companies');
      } else {
        print('Error loading companies: ${result.message}');
      }
    } catch (e) {
      print('Exception loading companies: $e');
    }
  }

  /// Obtiene el ID de una empresa por su nombre
  String? getCompanyIdByName(String companyName) {
    try {
      final company = availableCompanies.firstWhere(
        (company) => company.name == companyName,
      );
      return company.id;
    } catch (e) {
      print('Company not found: $companyName');
      return null;
    }
  }
}
