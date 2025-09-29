import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../../../../config/app_flavor.dart';
import '../../presentation/widgets/company_selection_dialog.dart';
import '../../presentation/pages/register_new_company_screen.dart';
import '../../../../builder/home/presentation/pages/builder_home_screen.dart';
import '../../../../builder/home/presentation/pages/camera_with_overlay_screen.dart';
import '../../../../builder/home/presentation/pages/camera_simple_screen.dart';
import '../../../../../features/logic/builder/use_case/builder_use_case.dart';
import '../../../../../features/logic/builder/models/send/dto_send_builder_profile.dart';
import '../../../../../features/logic/masters/use_case/master_use_case.dart';
import '../../../../../features/logic/masters/models/receive/dto_receive_license.dart';

class CreateProfileBuilderController extends GetxController {
  // ===== CASOS DE USO =====
  final BuilderUseCase _builderUseCase = BuilderUseCase();
  final MasterUseCase _masterUseCase = MasterUseCase();
  
  // Controllers para los campos de texto
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  
  // Variables para la imagen de perfil
  final Rx<File?> profileImage = Rx<File?>(null);
  final ImagePicker picker = ImagePicker();
  
  // Lista de empresas creadas por el usuario
  final RxList<String> userCreatedCompanies = <String>[].obs;
  
  // Variables para licencias
  final RxList<Map<String, dynamic>> licenses = <Map<String, dynamic>>[].obs;
  final RxString? selectedCredential = RxString('');
  
  // Variables para datos dinámicos de la API
  final RxList<DtoReceiveLicense> licensesFromApi = <DtoReceiveLicense>[].obs;
  final RxBool isLoadingLicenses = false.obs;
  
  
  // Flavor actual
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  
  // Estado de carga
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
    
    // Cargar licencias desde la API
    loadLicensesFromApi();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    companyNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.onClose();
  }

  // Función para mostrar opciones de selección de imagen
  void showImageSourceDialog() {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    
    // Calcular valores responsive
    final modalPadding = screenWidth * 0.06;
    final titleFontSize = screenWidth * 0.048;
    final itemFontSize = screenWidth * 0.038;
    final subtitleFontSize = screenWidth * 0.032;
    final iconSize = screenWidth * 0.08;
    
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, -4),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle del modal
            Container(
              width: 50,
              height: 5,
              margin: EdgeInsets.only(top: modalPadding * 0.5),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            
            // Título del modal
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: modalPadding,
                vertical: modalPadding * 1.2,
              ),
              child: Text(
                'Select image',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            
            // Opciones de selección
            Container(
              padding: EdgeInsets.symmetric(horizontal: modalPadding),
              child: Column(
                children: [
                  // Opción Camera
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: modalPadding * 0.8),
                    decoration: BoxDecoration(
                      color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          _openCameraWithOverlay();
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: EdgeInsets.all(modalPadding),
                          child: Row(
                            children: [
                              // Icono de cámara
                              Container(
                                width: iconSize,
                                height: iconSize,
                                decoration: BoxDecoration(
                                  color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: iconSize * 0.6,
                                ),
                              ),
                              
                              SizedBox(width: modalPadding),
                              
                              // Texto
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Camera',
                                      style: TextStyle(
                                        fontSize: itemFontSize,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Take a new photo',
                                      style: TextStyle(
                                        fontSize: subtitleFontSize,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Flecha
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey[400],
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Opción Gallery
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: modalPadding * 1.5),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          pickImage(ImageSource.gallery);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: EdgeInsets.all(modalPadding),
                          child: Row(
                            children: [
                              // Icono de galería
                              Container(
                                width: iconSize,
                                height: iconSize,
                                decoration: BoxDecoration(
                                  color: Colors.grey[600],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.photo_library,
                                  color: Colors.white,
                                  size: iconSize * 0.6,
                                ),
                              ),
                              
                              SizedBox(width: modalPadding),
                              
                              // Texto
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Gallery',
                                      style: TextStyle(
                                        fontSize: itemFontSize,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Select from gallery',
                                      style: TextStyle(
                                        fontSize: subtitleFontSize,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Flecha
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey[400],
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
        profileImage.value = capturedImage;
        
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
            title: const Text('Permiso de Cámara'),
            content: const Text('Esta aplicación necesita acceso a la cámara para tomar fotos. Por favor, concede el permiso en la configuración.'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  openAppSettings();
                },
                child: const Text('Configuración'),
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
          'Éxito',
          'Imagen seleccionada exitosamente',
          backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
          colorText: Colors.black,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      // Cerrar indicador de carga si está abierto
      if (Get.isDialogOpen!) {
        Get.back();
      }
      
      // Manejo específico de errores
      String errorMessage = 'Error al seleccionar imagen';
      
      if (e.toString().contains('channel-error')) {
        errorMessage = 'Error de comunicación. Intenta:\n1. Reiniciar la app\n2. Verificar permisos de cámara\n3. Usar galería en lugar de cámara';
      } else if (e.toString().contains('permission')) {
        errorMessage = 'Permisos no concedidos. Ve a:\nConfiguración > Aplicaciones > Yakka Sports > Permisos';
      } else if (e.toString().contains('camera')) {
        errorMessage = 'Error al acceder a la cámara. Intenta usar la galería.';
      } else if (e.toString().contains('pigeon')) {
        errorMessage = 'Error interno del plugin. Intenta:\n1. Reiniciar la app\n2. Usar galería en lugar de cámara';
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
              child: const Text('Intentar con galería'),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      );
      
      // Log del error para debugging
      print('Error al seleccionar imagen: $e');
    }
  }

  // Función para mostrar el diálogo de selección de empresa
  void showCompanySelectionDialog() {
    print('Opening company selection dialog...');
    try {
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: CompanySelectionDialog(
            flavor: currentFlavor.value,
            onCompanySelected: (String company) {
              print('Company selected: $company');
              companyNameController.text = company;
            },
            onRegisterNewCompany: () {
              print('Register new company tapped');
              Get.toNamed(RegisterNewCompanyScreen.id, arguments: {'flavor': currentFlavor.value});
            },
            additionalCompanies: userCreatedCompanies,
          ),
        ),
      );
      print('Dialog opened successfully');
    } catch (e) {
      print('Error opening dialog: $e');
      Get.snackbar(
        'Error',
        'Error opening company selection: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void handleNext() {
    // Validar campos requeridos
    if (firstNameController.text.isEmpty || 
        lastNameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    // Navegar al paso 2
    Get.toNamed('/create-profile-step2-builder', arguments: {'flavor': currentFlavor.value});
  }

  void handleNextStep2() {
    // Validar campos requeridos
    if (emailController.text.isEmpty || 
        phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    // Navegar directamente a la pantalla de foto de perfil (saltando location)
    Get.toNamed('/profile-photo-builder', arguments: {'flavor': currentFlavor.value});
  }


  void handleProfilePhotoContinue() {
    // Navegar a la pantalla de licencias
    Get.toNamed('/license-builder', arguments: {'flavor': currentFlavor.value});
  }

  void handleLicenseContinue() {
    // Navegar a la pantalla de respeto
    Get.toNamed('/builder/respect', arguments: {'flavor': currentFlavor.value});
  }

  // Métodos para la pantalla de respeto
  void handleRespectBackNavigation() {
    Get.back();
  }

  void handleRespectCommit() {
    // Navegar a la pantalla "Let's Be Clear"
    Get.toNamed('/builder/lets-be-clear', arguments: {'flavor': currentFlavor.value});
  }

  /// Maneja la aceptación en Let's Be Clear
  void handleAccept() async {
    try {
      // Mostrar indicador de carga
      isLoading.value = true;
      
      // Crear el perfil de builder antes de navegar
      bool profileCreated = await createBuilderProfile();
      
      // Solo navegar si el perfil se creó exitosamente
      if (profileCreated) {
        Get.offAllNamed('/builder/profile-created', arguments: {'flavor': currentFlavor.value});
      } else {
        // Si falló la creación, mostrar mensaje de error
        Get.snackbar(
          'Error',
          'Failed to create builder profile. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      // Manejar errores inesperados
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } finally {
      // Ocultar indicador de carga
      isLoading.value = false;
    }
  }

  // Métodos para la pantalla de perfil creado
  void handleStartUsingYakka() {
    // Navegar al BuilderHomeScreen usando GetX
    Get.offAllNamed(BuilderHomeScreen.id);
  }

  void handleLinkCompany() {
    // Mostrar el diálogo de selección de empresa
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: CompanySelectionDialog(
          flavor: currentFlavor.value,
          onCompanySelected: (String company) {
            // Actualizar el campo de nombre de empresa
            companyNameController.text = company;
            
            // Mostrar mensaje de éxito
            Get.snackbar(
              'Empresa seleccionada',
              'Has seleccionado: $company',
              backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
              colorText: Colors.black,
            );
            
            // Navegar al home después de seleccionar
            Get.offAllNamed(BuilderHomeScreen.id);
          },
          onRegisterNewCompany: () {
            // Navegar a la pantalla de registro de nueva empresa
            Get.toNamed('/register-new-company', arguments: {'flavor': currentFlavor.value});
          },
        ),
      ),
    );
  }

  void addUserCompany(String company) {
    print('Adding user company: $company');
    if (!userCreatedCompanies.contains(company)) {
      userCreatedCompanies.add(company);
      print('Company added to list. Total companies: ${userCreatedCompanies.length}');
    } else {
      print('Company already exists in list');
    }
    
    // Solo actualizar el controller si no está disposed
    try {
      companyNameController.text = company;
      print('Updated companyNameController with: $company');
    } catch (e) {
      print('Warning: Could not update companyNameController, it may be disposed: $e');
      // No es crítico si no se puede actualizar el controller
    }
  }


  // Métodos para manejar licencias
  void addLicense() {
    // Validar si hay una credencial seleccionada
    if (selectedCredential?.value == null || selectedCredential!.value.isEmpty) {
      Get.snackbar(
        'Warning',
        'Please select a credential first',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
      return;
    }

    // Mostrar modal bottom sheet para seleccionar foto o cámara
    _showImageSourceModal();
  }

  void _showImageSourceModal() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Image Source',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Opción de cámara
                GestureDetector(
                  onTap: () {
                    Get.back(); // Cerrar el modal
                    _captureImageFromCamera();
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Camera',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Opción de galería
                GestureDetector(
                  onTap: () {
                    Get.back(); // Cerrar el modal
                    _selectImageFromGallery();
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.photo_library,
                          size: 40,
                          color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Gallery',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _captureImageFromCamera() async {
    try {
      // Navegar a la pantalla de cámara simple (con switch)
      await Get.to(
        () => CameraSimpleScreen(
          flavor: currentFlavor.value,
          onImageCaptured: (File image) {
            // Este callback se ejecutará cuando se capture la imagen
            final xFile = XFile(image.path);
            _addLicenseToMapWithImage(xFile);
          },
        ),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error opening camera: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _selectImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        // Agregar la licencia con la imagen seleccionada
        _addLicenseToMapWithImage(image);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error selecting image: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _addLicenseToMapWithImage(XFile image) async {
    // Buscar el ID real de la licencia desde la API
    String licenseId = '';
    String licenseName = selectedCredential!.value;

    if (licensesFromApi.isNotEmpty) {
      try {
        final license = licensesFromApi.firstWhere(
          (l) => l.name == licenseName,
          orElse: () => licensesFromApi.first,
        );
        licenseId = license.id;
      } catch (e) {
        // Si no se encuentra, usar el primer ID disponible
        licenseId = licensesFromApi.first.id;
      }
    }

    // Obtener información del archivo
    final file = File(image.path);
    final fileName = image.path.split('/').last;
    final fileSize = await file.length();

    licenses.add({
      'id': licenseId,
      'type': licenseName,
      'number': '',
      'expiryDate': '',
      'uploaded': true,
      'file': fileName,
      'path': image.path,
      'size': fileSize,
    });
    selectedCredential?.value = '';
  }

  void _addLicenseToMap() {
    // Buscar el ID real de la licencia desde la API
    String licenseId = '';
    String licenseName = selectedCredential!.value;

    if (licensesFromApi.isNotEmpty) {
      try {
        final license = licensesFromApi.firstWhere(
          (l) => l.name == licenseName,
          orElse: () => licensesFromApi.first,
        );
        licenseId = license.id;
      } catch (e) {
        // Si no se encuentra, usar el primer ID disponible
        licenseId = licensesFromApi.first.id;
      }
    }

    licenses.add({
      'id': licenseId,
      'type': licenseName,
      'number': '',
      'expiryDate': '',
      'uploaded': false,
      'file': null,
      'path': null,
      'size': null,
    });
    selectedCredential?.value = '';
  }

  void removeLicense(int index) {
    if (index >= 0 && index < licenses.length) {
      licenses.removeAt(index);
    }
  }

  Future<void> uploadLicense(int index) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        licenses[index] = {
          ...licenses[index],
          'uploaded': true,
          'file': file.name,
          'path': file.path,
          'size': file.size,
        };
        licenses.refresh(); // Forzar la actualización de la UI
        
        Get.snackbar(
          'Success',
          'File uploaded successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error uploading file: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Carga las licencias desde la API
  Future<void> loadLicensesFromApi() async {
    try {
      isLoadingLicenses.value = true;
      final result = await _masterUseCase.getLicenses();
      
      if (result.isSuccess && result.data != null) {
        licensesFromApi.value = result.data!;
      }
    } catch (e) {
      // Error handling without snackbar
    } finally {
      isLoadingLicenses.value = false;
    }
  }


  void showCredentialDropdown() {
    // Usar licencias de la API en lugar de lista hardcodeada
    if (licensesFromApi.isEmpty) {
      Get.snackbar(
        'Error',
        'No credentials available. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.bottomSheet(
      Container(
        height: MediaQuery.of(Get.context!).size.height * 0.6, // Limitar altura al 60% de la pantalla
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
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
                'Select Credential',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: licensesFromApi.length,
                itemBuilder: (context, index) {
                  final license = licensesFromApi[index];
                  return ListTile(
                    title: Text(license.name),
                    onTap: () {
                      selectedCredential?.value = license.name;
                      Get.back();
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Crea el perfil de builder usando el BuilderUseCase
  Future<bool> createBuilderProfile() async {
    try {
      // Validar campos requeridos
      if (firstNameController.text.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'First name is required',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        return false;
      }
      
      
      // Preparar licencias
      List<DtoSendBuilderLicense> builderLicenses = [];
      for (var license in this.licenses) {
        if (license['uploaded'] == true && license['file'] != null) {
          String fileName = license['file'].toString();
          String licenseId = license['id'] ?? license['type'] ?? 'unknown';
          
          builderLicenses.add(DtoSendBuilderLicense(
            licenseId: licenseId,
            photoUrl: fileName,
            issuedAt: DateTime.now().toIso8601String(),
            expiresAt: DateTime.now().add(Duration(days: 365)).toIso8601String(),
          ));
        }
      }
      
      // Crear perfil usando el BuilderUseCase
      final result = await _builderUseCase.createBuilderProfile(
        companyName: '', // Enviar vacío como solicitado
        displayName: '${firstNameController.text.trim()} ${lastNameController.text.trim()}'.trim(),
        location: '', // Enviar vacío ya que no se requiere location
        bio: '', // Enviar vacío como solicitado
        avatarUrl: profileImage.value?.path ?? '',
        phone: phoneController.text.trim(),
        licenses: builderLicenses,
      );
      
      if (result.isSuccess) {
        Get.snackbar(
          'Success',
          'Builder profile created successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to create builder profile: ${result.message ?? 'Unknown error'}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create builder profile: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      return false;
    }
  }
}

