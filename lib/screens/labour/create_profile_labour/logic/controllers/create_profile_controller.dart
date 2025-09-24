import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'dart:io';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/logic/masters/use_case/master_use_case.dart';
import '../../../../../features/logic/masters/models/receive/dto_receive_skill.dart';
import '../../../../../features/logic/masters/models/receive/dto_receive_experience_level.dart';
import '../../../../../features/logic/masters/models/receive/dto_receive_license.dart';
import '../../../../../features/logic/labour/use_case/labour_use_case.dart';
import '../../../../../features/logic/labour/models/send/dto_send_labour_profile.dart';
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
import '../../../../builder/home/presentation/pages/camera_with_overlay_screen.dart';

class CreateProfileController extends GetxController {
  // ===== GENERAL CONFIGURATION =====
  final String controllerId = DateTime.now().millisecondsSinceEpoch.toString();
  static bool _isInitialized = false;
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  
  // Instancias de los casos de uso
  final MasterUseCase _masterUseCase = MasterUseCase();
  final LabourUseCase _labourUseCase = LabourUseCase();
  
  // Variables estáticas para preservar datos entre navegaciones
  static String? _preservedFirstName;
  static String? _preservedLastName;
  static String? _preservedPhone;
  static String? _preservedEmail;
  static String? _preservedAddress;
  static String? _preservedSuburb;
  static List<String> _preservedSelectedSkills = [];
  static List<Map<String, dynamic>> _preservedLicenses = [];
  static String? _preservedProfileImagePath;
  
  // ===== STEP 1: BASIC INFO =====
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController(text: '0412345678');
  final TextEditingController emailController = TextEditingController(text: 'testing22@gmail.com');
  final TextEditingController birthCountryController = TextEditingController();
  
  // ===== STEP 2: SKILLS & EXPERIENCE =====
  final TextEditingController searchController = TextEditingController();
  
  // Variables para datos dinámicos de la API
  final RxList<DtoReceiveSkill> allSkillsFromApi = <DtoReceiveSkill>[].obs;
  final RxList<DtoReceiveExperienceLevel> experienceLevelsFromApi = <DtoReceiveExperienceLevel>[].obs;
  final RxList<DtoReceiveLicense> licensesFromApi = <DtoReceiveLicense>[].obs;
  final RxBool isLoadingSkills = false.obs;
  final RxBool isLoadingExperienceLevels = false.obs;
  final RxBool isLoadingLicenses = false.obs;
  
  // Lista de habilidades filtradas
  final RxList<String> filteredSkills = <String>[].obs;
  
  // Habilidades seleccionadas (usando ID único: "categoryId_subcategoryId")
  final RxSet<String> selectedSkills = <String>{}.obs;
  
  // Categorías expandidas
  final RxSet<String> expandedCategories = <String>{}.obs;
  
  // Mapa de categorías y sus subcategorías
  final RxMap<String, List<String>> categorySubcategories = <String, List<String>>{}.obs;
  
  // Experiencia por habilidad
  final RxMap<String, int> skillExperience = <String, int>{}.obs;
  
  // Referencias por habilidad
  final RxMap<String, Map<String, dynamic>?> skillReferences = <String, Map<String, dynamic>?>{}.obs;
  
  // ===== STEP 3: LOCATION =====
  final TextEditingController addressController = TextEditingController();
  final TextEditingController suburbController = TextEditingController();
  
  // Variables reactivas para las opciones de ubicación
  final RxBool willingToRelocate = true.obs;
  final RxBool hasCar = true.obs;
  
  // ===== STEP 4: PROFILE PHOTO =====
  final ImagePicker picker = ImagePicker();
  final ImagePicker _photoPicker = ImagePicker();
  final Rx<File?> profileImage = Rx<File?>(null);
  final Rx<File?> profilePhoto = Rx<File?>(null);
  
  // ===== STEP 5: LICENSES =====
  final RxList<Map<String, dynamic>> licenses = <Map<String, dynamic>>[].obs;
  final RxString? selectedLicenseType = RxString('');
  final RxList<String> licenseTypes = <String>[].obs;
  
  // ===== STEP 6: PREVIOUS EMPLOYER =====
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
  final RxString? selectedCredential = RxString('');
  final RxList<String> credentials = <String>[].obs;
  
  final RxList<Map<String, dynamic>> documents = <Map<String, dynamic>>[
    {'type': 'Resume', 'file': null, 'uploaded': false, 'path': null, 'size': null},
    {'type': 'Cover letter', 'file': null, 'uploaded': false, 'path': null, 'size': null},
    {'type': 'Police check', 'file': null, 'uploaded': false, 'path': null, 'size': null},
    {'type': 'Other', 'file': null, 'uploaded': false, 'path': null, 'size': null},
  ].obs;

  @override
  void onInit() {
    super.onInit();
    
    // Si se pasa un flavor específico, usarlo
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
    
    // Solo inicializar la primera vez
    if (!_isInitialized) {
      _isInitialized = true;
      
      // Cargar datos desde la API
      loadSkillsFromApi(showSnackbar: true);
      loadExperienceLevelsFromApi(showSnackbar: true);
      loadLicensesFromApi(showSnackbar: true);
    
    // Agregar listener para búsqueda
    searchController.addListener(() {
      filterSkills(searchController.text);
    });
    }
    
    // Restaurar datos preservados si existen
    restoreControllerData();
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

  



  // ===== STEP 1: BASIC INFO METHODS =====

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

  // ===== STEP 2: SKILLS & EXPERIENCE METHODS =====

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
    
    // Navegar a la pantalla de ubicación (step 3)
    Get.toNamed(LocationScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  // ===== STEP 3: LOCATION METHODS =====

  // Location → Profile Photo
  void handleLocationContinue() {
    // Navegar a la pantalla de foto de perfil (step 4)
    Get.toNamed(ProfilePhotoScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void toggleWillingToRelocate() {
    willingToRelocate.value = !willingToRelocate.value;
  }

  void toggleHasCar() {
    hasCar.value = !hasCar.value;
  }

  // ===== STEP 4: PROFILE PHOTO METHODS =====

  // Profile Photo → License
  void handleProfilePhotoContinue() {
    // Navegar a la pantalla de licencias (step 5)
    Get.toNamed(LicenseScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  // ===== STEP 5: LICENSES METHODS =====
  
  // License → Respect
  void handleLicenseContinue() {
    // Navegar a la pantalla de respeto (step 6)
    Get.toNamed(RespectScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  // ===== STEP 6: RESPECT METHODS =====

  // Respect → Let's Be Clear
  void handleRespectCommit() {
    // Preservar datos antes de navegar
    preserveControllerData();
    
    // Navegar a la pantalla "Let's Be Clear" (step 7)
    Get.offAndToNamed(LetsBeClearScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  // ===== STEP 7: LET'S BE CLEAR METHODS =====

  // Let's Be Clear → Profile Created
  void handleLetsBeClearAccept() async {
    // Crear el perfil de trabajador antes de navegar
    bool profileCreated = await createLabourProfile();
    
    // Solo navegar si el perfil se creó exitosamente
    if (profileCreated) {
      Get.offAndToNamed(ProfileCreatedScreen.id, arguments: {'flavor': currentFlavor.value});
    }
  }

  // ===== STEP 8: PROFILE CREATED METHODS =====

  // Profile Created → Home
  void handleStartUsingYakka() {
    // Limpiar el controlador después de completar el flujo
    resetController();
    
    // Navegar a la pantalla home de YAKKA
    Get.offAllNamed(HomeScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  // ===== STEP 9: DOCUMENTS METHODS =====

  void handleUploadResume() {
    // Navegar a la pantalla de documentos
    Get.toNamed(DocumentsScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  // Documents → Home
  void handleDocumentsContinue() {
    // Navegar al home screen
    Get.offAllNamed(HomeScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  
  /// Carga las habilidades desde la API
  Future<void> loadSkillsFromApi({bool showSnackbar = true}) async {
    try {
      isLoadingSkills.value = true;
      
      final result = await _masterUseCase.getSkills();
      
      if (result.isSuccess && result.data != null) {
        allSkillsFromApi.value = result.data!;
        filteredSkills.value = result.data!.map((skill) => skill.name).toList();
        
        if (showSnackbar) {
          Get.snackbar(
            'Success',
            'Skills loaded successfully (${result.data!.length} skills)',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      } else {
        if (showSnackbar) {
          Get.snackbar(
            'Error',
            'Failed to load skills: ${result.message ?? 'Unknown error'}',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      }
    } catch (e) {
      if (showSnackbar) {
        Get.snackbar(
          'Error',
          'Failed to load skills: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      isLoadingSkills.value = false;
    }
  }
  
  /// Carga los niveles de experiencia desde la API
  Future<void> loadExperienceLevelsFromApi({bool showSnackbar = true}) async {
    try {
      isLoadingExperienceLevels.value = true;
      
      final result = await _masterUseCase.getActiveExperienceLevels();
      
      if (result.isSuccess && result.data != null) {
        experienceLevelsFromApi.value = result.data!;
        
        if (showSnackbar) {
          Get.snackbar(
            'Success',
            'Experience levels loaded successfully (${result.data!.length} levels)',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      } else {
        if (showSnackbar) {
          Get.snackbar(
            'Error',
            'Failed to load experience levels: ${result.message ?? 'Unknown error'}',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      }
    } catch (e) {
      if (showSnackbar) {
        Get.snackbar(
          'Error',
          'Failed to load experience levels: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      isLoadingExperienceLevels.value = false;
    }
  }

  /// Carga las licencias desde la API
  Future<void> loadLicensesFromApi({bool showSnackbar = true}) async {
    try {
      isLoadingLicenses.value = true;
      final result = await _masterUseCase.getLicenses();
      
      if (result.isSuccess && result.data != null) {
        licensesFromApi.value = result.data!;
        credentials.value = result.data!.map((license) => license.name).toList();
        licenseTypes.value = result.data!.map((license) => license.name).toList();
        
        if (showSnackbar) {
          Get.snackbar(
            'Success', 
            'Licenses loaded successfully (${result.data!.length} licenses)', 
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 2),
          );
        }
      } else {
        if (showSnackbar) {
          Get.snackbar(
            'Error', 
            'Failed to load licenses: ${result.message ?? 'Unknown error'}', 
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );
        }
      }
    } catch (e) {
      if (showSnackbar) {
        Get.snackbar(
          'Error', 
          'Failed to load licenses: $e', 
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
    } finally {
      isLoadingLicenses.value = false;
    }
  }

  /// Método para resetear el controlador (usar solo cuando sea necesario)
  static void resetController() {
    _isInitialized = false;
  }

  /// Preserva los datos del controlador antes de navegación
  void preserveControllerData() {
    _preservedFirstName = firstNameController.text;
    _preservedLastName = lastNameController.text;
    _preservedPhone = phoneController.text;
    _preservedEmail = emailController.text;
    _preservedAddress = addressController.text;
    _preservedSuburb = suburbController.text;
    _preservedSelectedSkills = List.from(selectedSkills);
    _preservedLicenses = List.from(licenses);
    _preservedProfileImagePath = profileImage.value?.path;
  }

  /// Restaura los datos preservados en el controlador
  void restoreControllerData() {
    if (_preservedFirstName != null) {
      firstNameController.text = _preservedFirstName!;
    }
    if (_preservedLastName != null) {
      lastNameController.text = _preservedLastName!;
    }
    if (_preservedPhone != null) {
      phoneController.text = _preservedPhone!;
    }
    if (_preservedEmail != null) {
      emailController.text = _preservedEmail!;
    }
    if (_preservedAddress != null) {
      addressController.text = _preservedAddress!;
    }
    if (_preservedSuburb != null) {
      suburbController.text = _preservedSuburb!;
    }
    if (_preservedSelectedSkills.isNotEmpty) {
      selectedSkills.assignAll(_preservedSelectedSkills);
    }
    if (_preservedLicenses.isNotEmpty) {
      licenses.value = List.from(_preservedLicenses);
    }
    if (_preservedProfileImagePath != null) {
      profileImage.value = File(_preservedProfileImagePath!);
    }
  }

  /// Recopila todos los datos del stepper y crea el perfil de trabajador
  Future<bool> createLabourProfile() async {
    try {
      // ===== STEP 1: BASIC INFO =====
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();
      final phone = phoneController.text.trim();
      
      if (firstName.isEmpty || lastName.isEmpty) {
        Get.snackbar(
          'Error',
          'First name and last name are required',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        return false;
      }
      
      // ===== STEP 3: LOCATION =====
      final location = '${addressController.text.trim()}, ${suburbController.text.trim()}';
      final bio = 'Experienced worker with ${selectedSkills.length} skills';
      
      // ===== STEP 4: PROFILE PHOTO =====
      String avatarFileName = '';
      if (profileImage.value != null) {
        avatarFileName = profileImage.value!.path.split('/').last;
      }
      
      // ===== STEP 2: SKILLS & EXPERIENCE =====
      List<DtoSendLabourSkill> skills = [];
      if (selectedSkills.isEmpty) {
        Get.snackbar(
          'Error',
          'At least one skill is required',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        return false;
      }
      
      for (String uniqueId in selectedSkills) {
        // Extraer categoryId y subcategoryId del ID único
        List<String> parts = uniqueId.split('_');
        if (parts.length >= 2) {
          String categoryId = parts[0];
          String subcategoryId = parts[1];
          
          // Obtener experiencia
          int experienceValue = skillExperience[uniqueId] ?? 0;
          double yearsExperience = _convertExperienceToYears(experienceValue);
          String experienceLevelId = _getExperienceLevelId(experienceValue);
          
          print('DEBUG - Skill: $uniqueId');
          print('DEBUG - Experience Value: $experienceValue');
          print('DEBUG - Experience Level ID: $experienceLevelId');
          print('DEBUG - Years Experience: $yearsExperience');
          
          // Crear skill con IDs válidos de la API
          skills.add(DtoSendLabourSkill(
            categoryId: categoryId,
            subcategoryId: subcategoryId,
            experienceLevelId: experienceLevelId,
            yearsExperience: yearsExperience,
            isPrimary: skills.isEmpty,
          ));
        }
      }
      
      // ===== STEP 5: LICENSES =====
      List<DtoSendLabourLicense> labourLicenses = [];
      for (var license in this.licenses) {
        if (license['uploaded'] == true && license['file'] != null) {
          String fileName = license['file'].toString();
          String licenseId = license['id'] ?? license['type'] ?? 'unknown';
          
          print('DEBUG - License: ${license['type']}');
          print('DEBUG - License ID: $licenseId');
          print('DEBUG - File: $fileName');
          
          labourLicenses.add(DtoSendLabourLicense(
            licenseId: licenseId,
            photoUrl: fileName,
            issuedAt: DateTime.now().toIso8601String(),
            expiresAt: DateTime.now().add(Duration(days: 365)).toIso8601String(),
          ));
        }
      }
      
      print('DEBUG - Total licenses to send: ${labourLicenses.length}');
      
      // ===== CREAR PERFIL CON TODOS LOS DATOS =====
      final result = await _labourUseCase.createLabourProfile(
        firstName: firstName,
        lastName: lastName,
        location: location,
        bio: bio,
        avatarUrl: avatarFileName,
        phone: phone,
        skills: skills,
        licenses: labourLicenses,
      );
      
      if (result.isSuccess) {
        Get.snackbar(
          'Success',
          'Profile created successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to create profile: ${result.message ?? 'Unknown error'}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create profile: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      return false;
    }
  }

  /// Convierte el valor de experiencia a años
  double _convertExperienceToYears(int experienceValue) {
    switch (experienceValue) {
      case 0:
        return 0.5; // Menos de 6 meses
      case 1:
        return 0.75; // 6-12 meses
      case 2:
        return 1.5; // 1-2 años
      case 3:
        return 3.5; // 2-5 años
      case 5:
        return 6.0; // Más de 5 años
      default:
        return 1.0;
    }
  }

  /// Obtiene el ID del nivel de experiencia
  String _getExperienceLevelId(int experienceValue) {
    // Si tenemos datos de la API, usar el índice para obtener el ID
    if (experienceLevelsFromApi.isNotEmpty) {
      try {
        // Usar el índice como posición en la lista
        if (experienceValue >= 0 && experienceValue < experienceLevelsFromApi.length) {
          return experienceLevelsFromApi[experienceValue].id;
        } else {
          return experienceLevelsFromApi.first.id;
        }
      } catch (e) {
        return experienceLevelsFromApi.first.id;
      }
    }
    
    // Si no hay datos de API, retornar ID por defecto
    return 'f057645b-b107-42c5-b4e9-03921430bb25'; // ID de "Less than 6 months"
  }
  
  void filterSkills(String query) {
    if (query.isEmpty) {
      // Usar categorías de la API
      if (allSkillsFromApi.isNotEmpty) {
        filteredSkills.value = allSkillsFromApi.map((skill) => skill.name).toList();
      }
    } else {
      // Filtrar categorías según los datos de la API
      if (allSkillsFromApi.isNotEmpty) {
        List<String> categoriesToFilter = allSkillsFromApi.map((skill) => skill.name).toList();
        filteredSkills.value = categoriesToFilter
          .where((category) => category.toLowerCase().contains(query.toLowerCase()))
          .toList();
      }
    }
  }

  // Toggle para categorías (expandir/contraer) - permitir múltiples
  void toggleCategory(String category) {
    if (expandedCategories.contains(category)) {
      // Si ya está expandida, contraerla
      expandedCategories.remove(category);
    } else {
      // Si no está expandida, expandirla (mantener las otras expandidas)
      expandedCategories.add(category);
    }
  }

  // Toggle para subcategorías (seleccionar y abrir modal de experiencia)
  void toggleSubcategory(String subcategory) {
    // Crear ID único para la subcategoría
    String uniqueId = getUniqueSubcategoryId(subcategory);
    
    if (selectedSkills.contains(uniqueId)) {
      // Si ya está seleccionada, deseleccionarla
      selectedSkills.remove(uniqueId);
      // Limpiar experiencia y referencia cuando se deselecciona
      skillExperience.remove(uniqueId);
      skillReferences.remove(uniqueId);
    } else {
      // Si no está seleccionada, mostrar modal de experiencia
      showExperienceModal(subcategory);
    }
  }

  // Obtener ID único para una subcategoría
  String getUniqueSubcategoryId(String subcategoryName) {
    if (allSkillsFromApi.isNotEmpty) {
      // Buscar solo en las categorías expandidas
      for (var skill in allSkillsFromApi) {
        if (expandedCategories.contains(skill.name)) {
          for (var sub in skill.subcategories) {
            if (sub.name == subcategoryName) {
              return "${skill.id}_${sub.id}"; // ID único: categoryId_subcategoryId
            }
          }
        }
      }
    }
    return subcategoryName; // Fallback si no se encuentra
  }

  // Obtener nombre de skill desde ID único
  String getSkillNameFromUniqueId(String uniqueId) {
    List<String> parts = uniqueId.split('_');
    if (parts.length >= 2) {
      String categoryId = parts[0];
      String subcategoryId = parts[1];
      
      if (allSkillsFromApi.isNotEmpty) {
        for (var skill in allSkillsFromApi) {
          if (skill.id == categoryId) {
            for (var sub in skill.subcategories) {
              if (sub.id == subcategoryId) {
                return sub.name;
              }
            }
          }
        }
      }
    }
    return uniqueId; // Fallback si no se encuentra
  }

  // Contrae la categoría padre de una subcategoría seleccionada
  void _collapseParentCategory(String subcategory) {
    // Obtener el ID único de la subcategoría
    String uniqueId = getUniqueSubcategoryId(subcategory);
    List<String> parts = uniqueId.split('_');
    
    if (parts.length >= 2) {
      String categoryId = parts[0];
      
      // Buscar la categoría por ID y contraerla
      if (allSkillsFromApi.isNotEmpty) {
        for (var skill in allSkillsFromApi) {
          if (skill.id == categoryId) {
            expandedCategories.remove(skill.name);
            return;
          }
        }
      }
    }
  }

  // Obtener subcategorías para una categoría específica desde la API
  List<String> getSubcategoriesForCategory(String category) {
    // Buscar la categoría en los datos de la API
    if (allSkillsFromApi.isNotEmpty) {
      try {
        final skill = allSkillsFromApi.firstWhere((s) => s.name == category);
        return skill.subcategories.map((sub) => sub.name).toList();
      } catch (e) {
        // Si no se encuentra la categoría, retornar lista vacía
        return [];
      }
    }
    
    // Si no hay datos de API, retornar lista vacía
    return [];
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
    final modalHeight = screenHeight * 0.5;
    final modalPadding = screenWidth * 0.06;
    final titleFontSize = screenWidth * 0.048;
    final buttonFontSize = screenWidth * 0.032;
    
    // Variable reactiva para mantener la selección
    final RxString selectedExperienceLevel = ''.obs;

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
                    child: Column(
                      children: [
                        // Grid de opciones de experiencia dinámicas
                        Obx(() {
                          if (isLoadingExperienceLevels.value) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                              ),
                            );
                          }
                          
                          // Usar niveles de la API
                          List<String> experienceLevels = [];
                          if (experienceLevelsFromApi.isNotEmpty) {
                            experienceLevels = experienceLevelsFromApi.map((level) => level.name).toList();
                          }
                          
                          return Column(
                            children: _buildExperienceLevelsGridReactive(experienceLevels, selectedExperienceLevel, setModalState, buttonFontSize),
                          );
                        }),
                      
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
                      
                      // Spacer para empujar el botón hacia abajo
                      Spacer(),
                   
                      // Botón SAVE sin sombra
                      Obx(() => Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: selectedExperienceLevel.value.isNotEmpty
                              ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value))
                              : Colors.grey[400],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ElevatedButton(
                              onPressed: selectedExperienceLevel.value.isNotEmpty 
                              ? () {
                                  // Guardar la experiencia seleccionada usando ID único
                                  String uniqueId = getUniqueSubcategoryId(selectedSkill);
                                  selectedSkills.add(uniqueId);
                                  int experienceValue = _getExperienceValue(selectedExperienceLevel.value);
                                  skillExperience[uniqueId] = experienceValue;
                                  
                                  print('DEBUG - Saving experience for skill: $selectedSkill');
                                  print('DEBUG - Unique ID: $uniqueId');
                                  print('DEBUG - Selected Level: ${selectedExperienceLevel.value}');
                                  print('DEBUG - Experience Value: $experienceValue');
                                  
                                  // Contraer la categoría padre después de guardar
                                  _collapseParentCategory(selectedSkill);
                                  
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
                      )),
                      
                      SizedBox(height: modalPadding * 0.5),
                      ],
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

  /// Construye el grid de niveles de experiencia dinámicamente (método reactivo)
  List<Widget> _buildExperienceLevelsGridReactive(
    List<String> experienceLevels,
    RxString selectedExperienceLevel,
    StateSetter setModalState,
    double buttonFontSize,
  ) {
    List<Widget> widgets = [];
    
    // Dividir en filas de 2 elementos
    for (int i = 0; i < experienceLevels.length; i += 2) {
      if (i > 0) {
        widgets.add(SizedBox(height: 12));
      }
      
      List<String> rowLevels = experienceLevels.skip(i).take(2).toList();
      
      widgets.add(
        Row(
          children: rowLevels.map((level) {
            return Expanded(
              child: Obx(() => _buildExperienceButtonReactive(
                level,
                selectedExperienceLevel.value,
                () {
                  selectedExperienceLevel.value = level;
                },
                buttonFontSize,
              )),
            );
          }).toList()
            ..addAll(
              // Agregar espacios vacíos si la fila no está completa
              List.generate(2 - rowLevels.length, (index) => Expanded(child: SizedBox())),
            ),
        ),
      );
    }
    
    return widgets;
  }



  int _getExperienceValue(String level) {
    // Buscar el nivel de experiencia en los datos de la API
    if (experienceLevelsFromApi.isNotEmpty) {
      try {
        final experienceLevel = experienceLevelsFromApi.firstWhere(
          (levelData) => levelData.name == level,
          orElse: () => experienceLevelsFromApi.first,
        );
        
        // Usar el índice del nivel en la lista como valor
        int index = experienceLevelsFromApi.indexOf(experienceLevel);
        return index >= 0 ? index : 0;
      } catch (e) {
        return 0; // Default al primer nivel
      }
    }
    
    // Fallback si no hay datos de API
    return 0;
  }

  Widget _buildExperienceButtonReactive(
    String level,
    String selectedLevel,
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
    expandedCategories.clear();
    skillExperience.clear();
    skillReferences.clear();
  }

  void saveReference() {
    // Método mantenido para compatibilidad, pero ya no se usa
  }

  void clearReference() {
    // Método mantenido para compatibilidad, pero ya no se usa
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
        
        // Actualizar la licencia en la lista reactiva
        licenses[index] = {
          ...licenses[index],
          'uploaded': true,
          'file': file.name,
          'path': file.path,
          'size': file.size,
        };
        
        // Forzar la actualización de la UI
        licenses.refresh();
        
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