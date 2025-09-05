import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'dart:io';
import '../../../../../config/app_flavor.dart';
import '../../presentation/pages/create_profile_step2_screen.dart';
import '../../presentation/pages/skills_experience_screen.dart';
import '../../presentation/pages/location_screen.dart';
import '../../presentation/pages/profile_photo_screen.dart';
import '../../presentation/pages/license_screen.dart';
import '../../presentation/pages/documents_screen.dart';
import '../../presentation/pages/respect_screen.dart';
import '../../presentation/pages/lets_be_clear_screen.dart';
import '../../presentation/pages/profile_created_screen.dart';
import '../../../home/presentation/pages/home_screen.dart';

class CreateProfileController extends GetxController {
  // ===== STEP 1: BASIC INFO =====
  // Controllers para los campos de texto
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController(text: '0412345678');
  final TextEditingController emailController = TextEditingController(text: 'testing22@gmail.com');
  final TextEditingController birthCountryController = TextEditingController();
  
  // Variables para la imagen de perfil
  final Rx<File?> profileImage = Rx<File?>(null);
  final ImagePicker picker = ImagePicker();
  
  // ===== STEP 2: SKILLS & EXPERIENCE =====
  // Controller para el campo de búsqueda
  final TextEditingController searchController = TextEditingController();
  
  // Lista de habilidades disponibles
  final List<String> allSkills = [
    'General Labourer',
    'Paver Operator',
    'Carpenter',
    'Truck LR Driver',
    'Asbestos Remover',
    'Elevator operator',
    'Foreman',
    'Tow Truck Driver',
    'Lawn mower',
    'Construction Foreman',
    'Bulldozer Operator',
    'Plumber',
    'Heavy Rigid Truck Driver',
    'Traffic Controller',
    'Excavator Operator',
    'Bartender',
    'Gardener',
    'Truck HC Driver',
    'Waitress / Waiter',
    'Truck Driver',
    'Crane Operator - Mobile',
  ];
  
  // Lista de habilidades filtradas
  final RxList<String> filteredSkills = <String>[].obs;
  
  // Habilidades seleccionadas
  final RxSet<String> selectedSkills = <String>{}.obs;
  
  // Experiencia por habilidad
  final RxMap<String, int> skillExperience = <String, int>{}.obs;
  
  // Referencias por habilidad
  final RxMap<String, Map<String, dynamic>?> skillReferences = <String, Map<String, dynamic>?>{}.obs;
  
  // ===== STEP 3: LOCATION =====
  // Controllers para los campos de ubicación
  final TextEditingController addressController = TextEditingController();
  final TextEditingController suburbController = TextEditingController();
  
  // Variables reactivas para las opciones de ubicación
  final RxBool willingToRelocate = true.obs;
  final RxBool hasCar = true.obs;
  
  // ===== STEP 4: PROFILE PHOTO =====
  final ImagePicker _photoPicker = ImagePicker();
  final Rx<File?> profilePhoto = Rx<File?>(null);
  
  // ===== STEP 5: LICENSES =====
  // Variables para licencias
  final RxList<Map<String, dynamic>> licenses = <Map<String, dynamic>>[].obs;
  final RxString? selectedLicenseType = RxString('');
  final RxList<String> licenseTypes = <String>[
    'Driver License',
    'Forklift License',
    'White Card',
    'First Aid Certificate',
    'Working at Heights',
    'Confined Spaces',
    'Other'
  ].obs;
  
  // ===== STEP 6: PREVIOUS EMPLOYER =====
  // Controllers para empleador anterior
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController referenceNameController = TextEditingController();
  final TextEditingController referencePhoneController = TextEditingController();
  final TextEditingController referenceEmailController = TextEditingController();
  
  // Variables reactivas para empleador anterior
  final RxBool hasPreviousEmployer = false.obs;
  final RxBool canContactReference = false.obs;
  final Rx<Map<String, dynamic>?> firstSupervisor = Rx<Map<String, dynamic>?>(null);
  final Rx<Map<String, dynamic>?> secondSupervisor = Rx<Map<String, dynamic>?>(null);
  
  // ===== STEP 7: DOCUMENTS =====
  // Variables para documentos
  final RxString? selectedCredential = RxString('');
  final RxList<String> credentials = <String>[
    'Driver License',
    'Forklift License',
    'White Card',
    'First Aid Certificate',
    'Working at Heights',
    'Confined Spaces',
    'Other'
  ].obs;
  
  final RxList<Map<String, dynamic>> documents = <Map<String, dynamic>>[
    {'type': 'Resume', 'file': null, 'uploaded': false, 'path': null, 'size': null},
    {'type': 'Cover letter', 'file': null, 'uploaded': false, 'path': null, 'size': null},
    {'type': 'Police check', 'file': null, 'uploaded': false, 'path': null, 'size': null},
    {'type': 'Other', 'file': null, 'uploaded': false, 'path': null, 'size': null},
  ].obs;
  
  // ===== GENERAL =====
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  @override
  void onInit() {
    super.onInit();
    // Si se pasa un flavor específico, usarlo
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
    
    // Inicializar habilidades filtradas
    filteredSkills.value = List.from(allSkills);
    
    // Agregar listener para búsqueda
    searchController.addListener(() {
      filterSkills(searchController.text);
    });
  }

  @override
  void onClose() {
    // Dispose de todos los controllers
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    birthCountryController.dispose();
    searchController.dispose();
    addressController.dispose();
    suburbController.dispose();
    companyNameController.dispose();
    positionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    referenceNameController.dispose();
    referencePhoneController.dispose();
    referenceEmailController.dispose();
    super.onClose();
  }

  // ===== NAVIGATION METHODS =====
  
  // Industry Selection → Create Profile
  void handleConstructionSelection() {
    Get.toNamed('/create-profile', arguments: {'flavor': currentFlavor.value});
  }

  void handleHospitalitySelection() {
    Get.toNamed('/create-profile', arguments: {'flavor': currentFlavor.value});
  }

  void handleBothSelection() {
    Get.toNamed('/create-profile', arguments: {'flavor': currentFlavor.value});
  }

  // Create Profile → Create Profile Step 2
  void handleNext() {
    // Validar campos requeridos
    if (firstNameController.text.isEmpty || lastNameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    
    // Navegar a la siguiente pantalla (step 2)
    Get.toNamed(CreateProfileStep2Screen.id, arguments: {'flavor': currentFlavor.value});
  }

  // Create Profile Step 2 → Skills Experience
  void handleNextStep2() {
    // Validar campo de email
    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    
    // Validar formato de email
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailController.text)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    
    // Validar campo de teléfono
    if (phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your phone number',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    
    // Navegar a la pantalla de habilidades (step 3)
    Get.toNamed(SkillsExperienceScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  // Skills Experience → Location
  void handleSkillsContinue() {
    // Validar que se hayan seleccionado habilidades
    if (selectedSkills.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select at least one skill',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    
    // Navegar al siguiente paso del stepper
    Get.toNamed(LocationScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  // Location → Profile Photo
  void handleLocationContinue() {
    // Navegar a la pantalla de foto de perfil
    Get.toNamed(ProfilePhotoScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  // Profile Photo → License
  void handleProfilePhotoContinue() {
    // Navegar a la pantalla de licencias
    Get.toNamed(LicenseScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  // License → Previous Employer
  void handleLicenseContinue() {
    // Navegar a la pantalla de respeto
    Get.toNamed(RespectScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  // Respect → Let's Be Clear
  void handleRespectCommit() {
    // Navegar a la pantalla "Let's Be Clear" después del compromiso
    Get.offAllNamed(LetsBeClearScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  // Let's Be Clear → Profile Created
  void handleLetsBeClearAccept() {
    // Navegar a la pantalla de perfil creado después de aceptar los términos
    Get.offAllNamed(ProfileCreatedScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  // Profile Created → Home
  void handleStartUsingYakka() {
    // Navegar a la pantalla home de YAKKA usando GetX
    Get.offAllNamed(HomeScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void handleUploadResume() {
    // Navegar a la pantalla de documentos
    Get.toNamed(DocumentsScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  // Documents → Home
  void handleDocumentsContinue() {
    // Navegar al home screen
    Get.offAllNamed(HomeScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  // ===== SKILLS & EXPERIENCE METHODS =====
  
  void filterSkills(String query) {
    if (query.isEmpty) {
      filteredSkills.value = List.from(allSkills);
    } else {
      filteredSkills.value = allSkills
          .where((skill) => skill.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void toggleSkill(String skill) {
    if (selectedSkills.contains(skill)) {
      selectedSkills.remove(skill);
      // Limpiar experiencia y referencia cuando se deselecciona
      skillExperience.remove(skill);
      skillReferences.remove(skill);
    } else {
      // No agregar a selectedSkills todavía, solo mostrar modal
      showExperienceModal(skill);
    }
  }

  void showExperienceModal(String selectedSkill) {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive para el modal
    final modalHeight = screenHeight * 0.6;
    final modalPadding = screenWidth * 0.06;
    final titleFontSize = screenWidth * 0.048;
    final buttonFontSize = screenWidth * 0.032;
    
    // Variable para mantener la selección
    String? selectedExperienceLevel;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: modalHeight,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Header del modal sin color
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: modalPadding,
                    vertical: modalPadding * 1.2,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Select Experience Level',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                
                // Contenido del modal con fondo blanco
                Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(modalPadding),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Grid de opciones de experiencia
                          Column(
                            children: [
                              // Primera fila: 2 opciones
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildExperienceButton(
                                      'Less than 6 months',
                                      selectedExperienceLevel,
                                      () => setModalState(() => selectedExperienceLevel = 'Less than 6 months'),
                                      buttonFontSize,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: _buildExperienceButton(
                                      '6-12 months',
                                      selectedExperienceLevel,
                                      () => setModalState(() => selectedExperienceLevel = '6-12 months'),
                                      buttonFontSize,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              // Segunda fila: 2 opciones
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildExperienceButton(
                                      '1-2 years',
                                      selectedExperienceLevel,
                                      () => setModalState(() => selectedExperienceLevel = '1-2 years'),
                                      buttonFontSize,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: _buildExperienceButton(
                                      '2-5 years',
                                      selectedExperienceLevel,
                                      () => setModalState(() => selectedExperienceLevel = '2-5 years'),
                                      buttonFontSize,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              // Tercera fila: 1 opción centrada
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: _buildExperienceButton(
                                      'More than 5 years',
                                      selectedExperienceLevel,
                                      () => setModalState(() => selectedExperienceLevel = 'More than 5 years'),
                                      buttonFontSize,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        
                        SizedBox(height: modalPadding),
                        
                        // Texto Add reference (optional) o referencia guardada
                        Obx(() {
                          final currentReference = skillReferences[selectedSkill];
                          if (currentReference != null) {
                            // Mostrar referencia guardada para esta habilidad
                            return Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.green[200]!),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reference Added:',
                                    style: TextStyle(
                                      fontSize: buttonFontSize * 0.9,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${currentReference['name']} - ${currentReference['company']}',
                                    style: TextStyle(
                                      fontSize: buttonFontSize * 0.85,
                                      color: Colors.green[600],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // Mostrar botón para agregar referencia
                            return GestureDetector(
                              onTap: () {
                                // Usar el modal de supervisor existente
                                showAddSupervisorModalForSkill(selectedSkill);
                              },
                              child: Center(
                                child: Text(
                                  '+add reference (optional)',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: buttonFontSize,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                        
                        SizedBox(height: modalPadding * 0.5),
                        
                        // Botón SAVE sin sombra
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ElevatedButton(
                            onPressed: selectedExperienceLevel != null 
                                ? () {
                                    // Agregar la skill a selectedSkills solo cuando se guarda exitosamente
                                    selectedSkills.add(selectedSkill);
                                    // Guardar la experiencia seleccionada
                                    skillExperience[selectedSkill] = _getExperienceValue(selectedExperienceLevel!);
                                    Get.back();
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'SAVE',
                              style: TextStyle(
                                fontSize: buttonFontSize * 1.1,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: modalPadding * 0.5),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  int _getExperienceValue(String level) {
    switch (level) {
      case 'Less than 6 months':
        return 0;
      case '6-12 months':
        return 1;
      case '1-2 years':
        return 2;
      case '2-5 years':
        return 3;
      case 'More than 5 years':
        return 5;
      default:
        return 0;
    }
  }

  Widget _buildExperienceButton(
    String level,
    String? selectedLevel,
    VoidCallback onTap,
    double buttonFontSize,
  ) {
    final isSelected = selectedLevel == level;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isSelected 
              ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value))
              : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value))
                : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected 
              ? [
                  BoxShadow(
                    color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)).withOpacity(0.4),
                    offset: const Offset(0, 6),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              level,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: buttonFontSize,
                color: isSelected 
                    ? Colors.black 
                    : const Color(0xFF374151),
                fontWeight: isSelected 
                    ? FontWeight.w600 
                    : FontWeight.w500,
                height: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void resetSelections() {
    selectedSkills.clear();
    skillExperience.clear();
    skillReferences.clear();
  }

  void saveReference() {
    // Método mantenido para compatibilidad, pero ya no se usa
  }

  void clearReference() {
    // Método mantenido para compatibilidad, pero ya no se usa
  }

  // ===== LOCATION METHODS =====
  
  void toggleWillingToRelocate() {
    willingToRelocate.value = !willingToRelocate.value;
  }

  void toggleHasCar() {
    hasCar.value = !hasCar.value;
  }

  // ===== IMAGE PICKER METHODS =====
  
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
                'Seleccionar imagen',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Cámara'),
              subtitle: const Text('Tomar una nueva foto'),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text('Galería'),
              subtitle: const Text('Seleccionar de la galería'),
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

  void showPhotoOptions() {
    pickImage(ImageSource.gallery);
  }

  Future<bool> requestPermissions(ImageSource source) async {
    if (source == ImageSource.camera) {
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
      PermissionStatus status = await Permission.photos.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        status = await Permission.storage.request();
      }
      return status.isGranted;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      bool hasPermission = await requestPermissions(source);
      if (!hasPermission) {
        return;
      }

      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      if (Get.isDialogOpen!) {
        Get.back();
      }
      
      if (image != null) {
        profileImage.value = File(image.path);
      }
    } catch (e) {
      if (Get.isDialogOpen!) {
        Get.back();
      }
      
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
      
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
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
      
      print('Error al seleccionar imagen: $e');
    }
  }

  Future<void> pickProfilePhoto(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        final cameraStatus = await Permission.camera.request();
        if (!cameraStatus.isGranted) {
      Get.snackbar(
            'Permisos requeridos',
            'Se necesita acceso a la cámara para tomar fotos',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
      } else {
        final photosStatus = await Permission.photos.request();
        if (!photosStatus.isGranted) {
      Get.snackbar(
            'Permisos requeridos',
            'Se necesita acceso a las fotos para seleccionar una imagen',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
      }

      final XFile? image = await _photoPicker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        profilePhoto.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al seleccionar imagen: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ===== LICENSE METHODS =====
  
  void showLicenseDropdown() {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final titleFontSize = screenWidth * 0.045;
    final itemFontSize = screenWidth * 0.035;

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Text(
                'Select License Type',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: licenseTypes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      licenseTypes[index],
                      style: TextStyle(
                        fontSize: itemFontSize,
                        color: Colors.black87,
                      ),
                    ),
                    onTap: () {
                      selectedLicenseType?.value = licenseTypes[index];
                      Get.back();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  void addLicense() {
    if (selectedCredential?.value != null && selectedCredential!.value.isNotEmpty) {
      licenses.add({
        'type': selectedCredential!.value,
        'number': '',
        'expiryDate': '',
        'uploaded': false,
        'file': null,
        'path': null,
        'size': null,
      });
      selectedCredential?.value = '';
    }
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
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        
        licenses[index]['uploaded'] = true;
        licenses[index]['file'] = file.name;
        licenses[index]['path'] = file.path;
        licenses[index]['size'] = file.size;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al subir archivo: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ===== PREVIOUS EMPLOYER METHODS =====
  
  void toggleHasPreviousEmployer() {
    hasPreviousEmployer.value = !hasPreviousEmployer.value;
  }

  void toggleCanContactReference() {
    canContactReference.value = !canContactReference.value;
  }

  void handlePreviousEmployerContinue() {
    // Navegar a la pantalla de Documents
    Get.toNamed(DocumentsScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void showAddSupervisorModalForSkill(String skillName) {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive para el modal
    final modalHeight = screenHeight * 0.75;
    final modalPadding = screenWidth * 0.06;
    final titleFontSize = screenWidth * 0.048;
    final labelFontSize = screenWidth * 0.038;
    final buttonFontSize = screenWidth * 0.035;
    final verticalSpacing = screenHeight * 0.02;

    // Controllers para el modal
    final nameController = TextEditingController();
    final companyController = TextEditingController();
    final phoneController = TextEditingController();
    
    // Variables para intl_phone_field
    String initialCountryCode = 'US';

    Get.bottomSheet(
      Container(
        height: modalHeight,
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2C), // Dark grey background
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Header del modal
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: modalPadding,
                vertical: modalPadding * 1.2,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF2C2C2C),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Text(
                'Add Reference for $skillName',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            
            // Contenido del modal
            Expanded(
              child: Container(
                color: const Color(0xFF2C2C2C),
                padding: EdgeInsets.all(modalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Campo Name
                    Text(
                      "Name",
                      style: TextStyle(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: verticalSpacing * 0.5),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Enter Name Contact",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 2),
                    
                    // Campo Company Type
                    Text(
                      "Company Type",
                      style: TextStyle(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: verticalSpacing * 0.5),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: companyController,
                        decoration: InputDecoration(
                          hintText: "Enter Company Name",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 2),
                    
                    // Campo Phone Number
                    Text(
                      "Phone Number",
                      style: TextStyle(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: verticalSpacing * 0.5),
                    IntlPhoneField(
                      controller: phoneController,
                      initialCountryCode: initialCountryCode,
                      decoration: InputDecoration(
                        hintText: "Enter Phone Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value))),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      style: TextStyle(
                        fontSize: labelFontSize,
                        color: Colors.black,
                      ),
                      dropdownTextStyle: TextStyle(
                        fontSize: labelFontSize,
                        color: Colors.black,
                      ),
                      onChanged: (phone) {
                        // El número completo se actualiza automáticamente
                      },
                    ),
                    
                    const Spacer(),
                    
                    // Botones EXIT y SAVE
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: ElevatedButton(
                              onPressed: () => Get.back(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'EXIT',
                                style: TextStyle(
                                  fontSize: buttonFontSize,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: modalPadding * 0.5),
                        Expanded(
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (nameController.text.trim().isNotEmpty &&
                                    companyController.text.trim().isNotEmpty &&
                                    phoneController.text.trim().isNotEmpty) {
                                  // Guardar referencia específica para esta habilidad
                                  skillReferences[skillName] = {
                                    'name': nameController.text.trim(),
                                    'company': companyController.text.trim(),
                                    'phone': phoneController.text.trim(),
                                  };
                                  Get.back();
                                } else {
                                  // No mostrar toast, solo no hacer nada
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'SAVE',
                                style: TextStyle(
                                  fontSize: buttonFontSize,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: verticalSpacing),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void showAddSupervisorModal(bool isFirstSupervisor) {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive para el modal
    final modalHeight = screenHeight * 0.75;
    final modalPadding = screenWidth * 0.06;
    final titleFontSize = screenWidth * 0.048;
    final labelFontSize = screenWidth * 0.038;
    final buttonFontSize = screenWidth * 0.035;
    final verticalSpacing = screenHeight * 0.02;

    // Controllers para el modal
    final nameController = TextEditingController();
    final companyController = TextEditingController();
    final phoneController = TextEditingController();
    
    // Variables para intl_phone_field
    String initialCountryCode = 'US';

    Get.bottomSheet(
      Container(
        height: modalHeight,
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2C), // Dark grey background
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Header del modal
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: modalPadding,
                vertical: modalPadding * 1.2,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF2C2C2C),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Text(
                'Add your Previous employer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            
            // Contenido del modal
            Expanded(
              child: Container(
                color: const Color(0xFF2C2C2C),
                padding: EdgeInsets.all(modalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Campo Name
                    Text(
                      "Name",
                      style: TextStyle(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: verticalSpacing * 0.5),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Enter Name Contact",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 2),
                    
                    // Campo Company Type
                    Text(
                      "Company Type",
                      style: TextStyle(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: verticalSpacing * 0.5),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: companyController,
                        decoration: InputDecoration(
                          hintText: "Enter Company Name",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 2),
                    
                    // Campo Phone Number
                    Text(
                      "Phone Number",
                      style: TextStyle(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: verticalSpacing * 0.5),
                    IntlPhoneField(
                      controller: phoneController,
                      initialCountryCode: initialCountryCode,
                      decoration: InputDecoration(
                        hintText: "Enter Phone Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value))),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      style: TextStyle(
                        fontSize: labelFontSize,
                        color: Colors.black,
                      ),
                      dropdownTextStyle: TextStyle(
                        fontSize: labelFontSize,
                        color: Colors.black,
                      ),
                      onChanged: (phone) {
                        // El número completo se actualiza automáticamente
                      },
                    ),
                    
                    const Spacer(),
                    
                    // Botones EXIT y SAVE
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: ElevatedButton(
                              onPressed: () => Get.back(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'EXIT',
                                style: TextStyle(
                                  fontSize: buttonFontSize,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: modalPadding * 0.5),
                        Expanded(
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (nameController.text.trim().isNotEmpty &&
                                    companyController.text.trim().isNotEmpty &&
                                    phoneController.text.trim().isNotEmpty) {
                                  if (isFirstSupervisor) {
                                    firstSupervisor.value = {
                                      'name': nameController.text.trim(),
                                      'company': companyController.text.trim(),
                                      'phone': phoneController.text.trim(),
                                    };
                                  } else {
                                    secondSupervisor.value = {
                                      'name': nameController.text.trim(),
                                      'company': companyController.text.trim(),
                                      'phone': phoneController.text.trim(),
                                    };
                                  }
                                  // Ya no se necesita savedReference global
                                  Get.back();
                                } else {
                                  // No mostrar toast, solo no hacer nada
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'SAVE',
                                style: TextStyle(
                                  fontSize: buttonFontSize,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: verticalSpacing),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void showEditSupervisorModal(bool isFirst) {
    // Implementar modal para editar supervisor
    Get.dialog(
      AlertDialog(
        title: Text('Edit Supervisor'),
        content: Text('Edit supervisor modal functionality'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void showDeleteConfirmationDialog(bool isFirst) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Supervisor'),
        content: Text('Are you sure you want to delete this supervisor?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (isFirst) {
                firstSupervisor.value = null;
              } else {
                secondSupervisor.value = null;
              }
              Get.back();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void handleSkip() {
    // Navegar a la pantalla de Documents
    Get.toNamed(DocumentsScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  // ===== DOCUMENTS METHODS =====
  
  void showCredentialDropdown() {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final titleFontSize = screenWidth * 0.045;
    final itemFontSize = screenWidth * 0.035;

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Text(
                'Select Credential',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: credentials.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      credentials[index],
                      style: TextStyle(
                        fontSize: itemFontSize,
                        color: Colors.black87,
                      ),
                    ),
                    onTap: () {
                      selectedCredential?.value = credentials[index];
                      Get.back();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  void addCredential() {
    // No mostrar toast, solo no hacer nada si no hay credencial seleccionada
  }

  Future<void> uploadDocument(int index) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        
        documents[index]['uploaded'] = true;
        documents[index]['file'] = file.name;
        documents[index]['path'] = file.path;
        documents[index]['size'] = file.size;
      }
    } catch (e) {
      // Error al seleccionar archivo
    }
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}