import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/logic/masters/use_case/master_use_case.dart';
import '../../../../../features/logic/masters/models/receive/dto_receive_license.dart';
import '../../../../../features/logic/masters/models/receive/dto_receive_skill.dart';
import '../../data/dto/post_job_dto.dart';
import '../../presentation/pages/post_job_stepper_screen.dart';
import '../../presentation/pages/post_job_stepper_step2_screen.dart';
import '../../presentation/pages/post_job_stepper_step3_screen.dart';
import '../../presentation/pages/post_job_stepper_step4_screen.dart';
import '../../presentation/pages/post_job_stepper_step5_screen.dart';
import '../../presentation/pages/post_job_stepper_step6_screen.dart';
import '../../presentation/pages/post_job_stepper_step7_screen.dart';
import '../../presentation/pages/post_job_stepper_step8_screen.dart';
import '../../presentation/pages/post_job_review_screen.dart';

class UnifiedPostJobController extends GetxController {
  // ===== CORE DATA =====
  final _postJobData = PostJobDto(
    requiresSupervisorSignature: false,
    supervisorName: null,
  ).obs;
  final _currentStep = 1.obs;
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  // ===== STEP 1 - SKILL SELECTION =====
  final TextEditingController searchController = TextEditingController();
  final RxList<String> filteredSkills = <String>[].obs;
  
  // Variables para datos dinámicos de la API
  final RxList<DtoReceiveSkill> allSkillsFromApi = <DtoReceiveSkill>[].obs;
  final RxBool isLoadingSkills = false.obs;
  
  // Habilidades seleccionadas (usando ID único: "categoryId_subcategoryId")
  final RxSet<String> selectedSkills = <String>{}.obs;
  
  // Categorías expandidas
  final RxSet<String> expandedCategories = <String>{}.obs;
  
  // Mapa de categorías y sus subcategorías
  final RxMap<String, List<String>> categorySubcategories = <String, List<String>>{}.obs;

  // ===== STEP 8 - SUPERVISOR SIGNATURE =====
  final RxString selectedOption = ''.obs;
  final RxString supervisorName = ''.obs;
  final TextEditingController supervisorNameController = TextEditingController();

  // ===== STEP 4 - DATE SELECTION =====
  final Rx<DateTime> focusedDay = DateTime.now().obs;
  final Rx<DateTime?> selectedStartDate = Rx<DateTime?>(null);
  final Rx<DateTime?> selectedEndDate = Rx<DateTime?>(null);
  final Rx<DateTimeRange?> selectedDateRange = Rx<DateTimeRange?>(null);

  // ===== STEP 5 - TIME & JOB TYPE =====
  final Rx<TimeOfDay?> selectedStartTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> selectedEndTime = Rx<TimeOfDay?>(null);
  final RxString selectedJobType = ''.obs;

  // Variables para datos dinámicos de la API
  final RxList<dynamic> jobTypesFromApi = <dynamic>[].obs;
  final RxBool isLoadingJobTypes = false.obs;

  // ===== STEP 6 - REQUIREMENTS =====
  final RxList<String> selectedRequirements = <String>[].obs;
  final RxString selectedCredential = ''.obs;
  final RxList<String> selectedCredentials = <String>[].obs;

  // Variables para datos dinámicos de la API
  final RxList<dynamic> jobRequirementsFromApi = <dynamic>[].obs;
  final RxBool isLoadingJobRequirements = false.obs;
  final RxString description = ''.obs;


  final MasterUseCase _masterUseCase = MasterUseCase();
  final RxList<DtoReceiveLicense> licensesFromApi = <DtoReceiveLicense>[].obs;
  final RxList<String> credentials = <String>[].obs;
  final RxBool isLoadingCredentials = false.obs;

  // ===== REVIEW SCREEN =====
  final RxBool isPublic = true.obs;

  // ===== GETTERS =====
  PostJobDto get postJobData => _postJobData.value;
  int get currentStep => _currentStep.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    print('🔄 UnifiedPostJobController onInit - Instance: ${this.hashCode}');
    initializeController();
  }

  void initializeController() {
    // Establecer flavor si viene en los argumentos
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
    
    // Inicializar estado de carga
    isLoadingSkills.value = true;
    
    // Cargar habilidades desde el backend
    loadSkillsFromApi();
    
    // Inicializar estado público/privado
    isPublic.value = _postJobData.value.isPublic ?? true;
    
    // Cargar credenciales desde el backend
    loadCredentialsFromApi();
    
    // Cargar tipos de trabajo desde el backend
    loadJobTypesFromApi();
    
    // Cargar requisitos de trabajo desde el backend
    loadJobRequirementsFromApi();
    
    // Inicializar datos existentes
    _initializeExistingData();
    
    // Configurar listeners
    _setupListeners();
  }

  void _initializeExistingData() {
    // Inicializar datos del step 4 (fechas)
    if (_postJobData.value.startDate != null) {
      selectedStartDate.value = _postJobData.value.startDate;
      focusedDay.value = selectedStartDate.value!;
    }
    if (_postJobData.value.endDate != null) {
      selectedEndDate.value = _postJobData.value.endDate;
    }
    if (selectedStartDate.value != null && selectedEndDate.value != null) {
      selectedDateRange.value = DateTimeRange(
        start: selectedStartDate.value!,
        end: selectedEndDate.value!,
      );
    }

    // Inicializar datos del step 5 (tiempos y tipo de trabajo)
    if (_postJobData.value.startTime != null) {
      selectedStartTime.value = _postJobData.value.startTime;
    }
    if (_postJobData.value.endTime != null) {
      selectedEndTime.value = _postJobData.value.endTime;
    }
    if (_postJobData.value.jobType != null) {
      selectedJobType.value = _postJobData.value.jobType!;
    }

    // Inicializar datos del step 8 (supervisor)
    if (_postJobData.value.requiresSupervisorSignature != null) {
      selectedOption.value = _postJobData.value.requiresSupervisorSignature! ? "yes" : "no";
    }
    if (_postJobData.value.supervisorName != null) {
      supervisorName.value = _postJobData.value.supervisorName!;
      supervisorNameController.text = _postJobData.value.supervisorName!;
    }
  }

  void _setupListeners() {
    // Listener para búsqueda de habilidades
    searchController.addListener(performSearch);
    
    // Listener para nombre del supervisor - Removido para evitar conflicto con onChanged
    // supervisorNameController.addListener(() {
    //   print('🔍 supervisorNameController listener triggered with: "${supervisorNameController.text}"');
    //   updateSupervisorName(supervisorNameController.text);
    // });
  }

  Future<void> loadCredentialsFromApi({bool showSnackbar = true}) async {
    try {
      isLoadingCredentials.value = true;
      
      final result = await _masterUseCase.getLicenses();
      
      if (result.isSuccess && result.data != null) {
        licensesFromApi.value = result.data!;
        credentials.value = result.data!.map((license) => license.name).toList();
      }
    } catch (e) {
      if (showSnackbar) {
        Get.snackbar(
          'Error',
          'Failed to load credentials: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoadingCredentials.value = false;
    }
  }

  Future<void> loadSkillsFromApi({bool showSnackbar = true}) async {
    try {
      print('🔄 Loading skills from API...');
      isLoadingSkills.value = true;
      
      final result = await _masterUseCase.getSkills();
      
      if (result.isSuccess && result.data != null) {
        print('✅ Skills loaded successfully: ${result.data!.length} items');
        allSkillsFromApi.value = result.data!;
        _processSkillsData();
        print('✅ Skills processed: ${filteredSkills.length} categories');
      } else {
        print('❌ Failed to load skills: ${result.message}');
      }
    } catch (e) {
      print('❌ Error loading skills: $e');
      if (showSnackbar) {
        Get.snackbar(
          'Error',
          'Failed to load skills: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoadingSkills.value = false;
      print('🔄 Skills loading completed');
    }
  }

  void _processSkillsData() {
    print('🔄 Processing skills data...');
    // Procesar datos de la API para crear categorías y subcategorías
    final Map<String, List<String>> categories = {};
    
    for (final skill in allSkillsFromApi) {
      final categoryName = skill.name;
      final subcategories = skill.subcategories.map((sub) => sub.name).toList();
      
      print('📁 Category: $categoryName with ${subcategories.length} subcategories');
      categories[categoryName] = subcategories;
    }
    
    categorySubcategories.value = categories;
    filteredSkills.value = categories.keys.toList();
    print('✅ Skills data processed: ${categories.length} categories');
  }

  void toggleCategory(String category) {
    if (expandedCategories.contains(category)) {
      expandedCategories.remove(category);
    } else {
      expandedCategories.add(category);
    }
  }

  void toggleSubcategory(String subcategory, String category) {
    final uniqueId = "${category}_$subcategory";
    if (selectedSkills.contains(uniqueId)) {
      selectedSkills.remove(uniqueId);
    } else {
      // Remover todas las subskills de esta categoría específica
      final subcategories = getSubcategoriesForCategory(category);
      for (final sub in subcategories) {
        final subId = "${category}_$sub";
        selectedSkills.remove(subId);
      }
      // Agregar la nueva subskill seleccionada
      selectedSkills.add(uniqueId);
      // Cerrar la sección de subcategorías
      expandedCategories.remove(category);
    }
  }

  String getUniqueSubcategoryId(String subcategory) {
    // Buscar la categoría padre de esta subcategoría
    for (final entry in categorySubcategories.entries) {
      if (entry.value.contains(subcategory)) {
        return "${entry.key}_$subcategory";
      }
    }
    return subcategory;
  }

  String getSkillNameFromUniqueId(String uniqueId) {
    final parts = uniqueId.split('_');
    if (parts.length >= 2) {
      return parts.sublist(1).join('_');
    }
    return uniqueId;
  }

  List<String> getSubcategoriesForCategory(String category) {
    return categorySubcategories[category] ?? [];
  }

  String? getCategoryFromSubcategory(String subcategory) {
    // Buscar la categoría padre de esta subcategoría
    for (final entry in categorySubcategories.entries) {
      if (entry.value.contains(subcategory)) {
        return entry.key;
      }
    }
    return null;
  }

  String? getCategoryFromUniqueId(String uniqueId) {
    // Extraer la categoría del ID único
    final parts = uniqueId.split('_');
    if (parts.length >= 2) {
      return parts[0];
    }
    return null;
  }

  void resetSelections() {
    selectedSkills.clear();
    expandedCategories.clear();
  }

  Future<void> loadJobTypesFromApi({bool showSnackbar = true}) async {
    try {
      print('🔄 Loading job types from API...');
      isLoadingJobTypes.value = true;
      
      final result = await _masterUseCase.getJobTypes();
      
      if (result.isSuccess && result.data != null) {
        print('✅ Job types loaded successfully: ${result.data!.types.length} items');
        // Mapear los tipos de trabajo a una lista simple de nombres
        jobTypesFromApi.value = result.data!.types.map((jobType) => jobType.name).toList();
        print('✅ Job types processed: ${jobTypesFromApi.length} types');
      } else {
        print('❌ Failed to load job types: ${result.message}');
      }
    } catch (e) {
      print('❌ Error loading job types: $e');
      if (showSnackbar) {
        Get.snackbar(
          'Error',
          'Failed to load job types: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoadingJobTypes.value = false;
      print('🔄 Job types loading completed');
    }
  }

  Future<void> loadJobRequirementsFromApi({bool showSnackbar = true}) async {
    try {
      print('🔄 Loading job requirements from API...');
      isLoadingJobRequirements.value = true;
      
      final result = await _masterUseCase.getJobRequirements();
      
      if (result.isSuccess && result.data != null) {
        print('✅ Job requirements loaded successfully: ${result.data!.requirements.length} items');
        // Mapear los requisitos de trabajo a una lista simple de nombres
        jobRequirementsFromApi.value = result.data!.requirements.map((requirement) => requirement.name).toList();
        print('✅ Job requirements processed: ${jobRequirementsFromApi.length} requirements');
      } else {
        print('❌ Failed to load job requirements: ${result.message}');
      }
    } catch (e) {
      print('❌ Error loading job requirements: $e');
      if (showSnackbar) {
        Get.snackbar(
          'Error',
          'Failed to load job requirements: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoadingJobRequirements.value = false;
      print('🔄 Job requirements loading completed');
    }
  }

  // ===== STEP MANAGEMENT =====
  void nextStep() {
    if (_currentStep.value < 9) {
      _currentStep.value++;
    }
  }

  void previousStep() {
    if (_currentStep.value > 1) {
      _currentStep.value--;
    }
  }

  void goToStep(int step) {
    if (step >= 1 && step <= 9) {
      _currentStep.value = step;
    }
  }

  void handleBackNavigation() {
    if (_currentStep.value > 1) {
      _currentStep.value--;
      _navigateToPreviousStep();
    } else {
      Get.back();
    }
  }

  void _navigateToPreviousStep() {
    switch (_currentStep.value) {
      case 1:
        Get.toNamed(PostJobStepperScreen.id, arguments: {'flavor': currentFlavor.value});
        break;
      case 2:
        Get.toNamed(PostJobStepperStep2Screen.id, arguments: {'flavor': currentFlavor.value});
        break;
      case 3:
        Get.toNamed(PostJobStepperStep3Screen.id, arguments: {'flavor': currentFlavor.value});
        break;
      case 4:
        Get.toNamed(PostJobStepperStep4Screen.id, arguments: {'flavor': currentFlavor.value});
        break;
      case 5:
        Get.toNamed(PostJobStepperStep5Screen.id, arguments: {'flavor': currentFlavor.value});
        break;
      case 6:
        Get.toNamed(PostJobStepperStep6Screen.id, arguments: {'flavor': currentFlavor.value});
        break;
      case 7:
        Get.toNamed(PostJobStepperStep7Screen.id, arguments: {'flavor': currentFlavor.value});
        break;
      case 8:
        Get.toNamed(PostJobStepperStep8Screen.id, arguments: {'flavor': currentFlavor.value});
        break;
      default:
        print('No navigation defined for step ${_currentStep.value}');
    }
  }

  // ===== STEP 1 - SKILL SELECTION =====
  void performSearch() {
    final query = searchController.text.toLowerCase().trim();
    
    if (query.isEmpty) {
      filteredSkills.assignAll(categorySubcategories.keys.toList());
    } else {
      // Buscar en categorías y subcategorías
      final matchingCategories = <String>[];
      
      for (final entry in categorySubcategories.entries) {
        final category = entry.key;
        final subcategories = entry.value;
        
        // Buscar en el nombre de la categoría
        if (category.toLowerCase().contains(query)) {
          matchingCategories.add(category);
        } else {
          // Buscar en las subcategorías
          final hasMatchingSubcategory = subcategories.any(
            (subcategory) => subcategory.toLowerCase().contains(query)
          );
          if (hasMatchingSubcategory) {
            matchingCategories.add(category);
          }
        }
      }
      
      filteredSkills.assignAll(matchingCategories);
    }
  }


  // ===== STEP 2 - WORKERS COUNT =====
  void updateWorkersNeeded(int workers) {
    print('🔍 updateWorkersNeeded called with: $workers');
    _postJobData.value = _postJobData.value.copyWith(workersNeeded: workers);
    print('🔍 PostJobDto workersNeeded: ${_postJobData.value.workersNeeded}');
  }

  // ===== STEP 3 - COSTS =====
  void updateHourlyRate(double rate) {
    _postJobData.value = _postJobData.value.copyWith(hourlyRate: rate);
  }

  void updateSiteAllowance(double allowance) {
    _postJobData.value = _postJobData.value.copyWith(siteAllowance: allowance);
  }

  void updateLeadingHandAllowance(double allowance) {
    _postJobData.value = _postJobData.value.copyWith(leadingHandAllowance: allowance);
  }

  void updateProductivityAllowance(double allowance) {
    _postJobData.value = _postJobData.value.copyWith(productivityAllowance: allowance);
  }

  void updateOvertimeRate(double rate) {
    _postJobData.value = _postJobData.value.copyWith(overtimeRate: rate);
  }

  void updateTravelAllowance(double allowance) {
    _postJobData.value = _postJobData.value.copyWith(travelAllowance: allowance);
  }

  double calculateTotalCost() {
    final hourlyRate = _postJobData.value.hourlyRate ?? 0.0;
    final siteAllowance = _postJobData.value.siteAllowance ?? 0.0;
    final leadingHandAllowance = _postJobData.value.leadingHandAllowance ?? 0.0;
    final productivityAllowance = _postJobData.value.productivityAllowance ?? 0.0;
    final overtimeRate = _postJobData.value.overtimeRate ?? 0.0;
    final travelAllowance = _postJobData.value.travelAllowance ?? 0.0;
    final yakkaServiceFee = 2.80; // Fixed value
    final gst = 0.28; // Fixed value (10% of Yakka Service Fee)
    
    return hourlyRate + siteAllowance + leadingHandAllowance + productivityAllowance + 
           overtimeRate + travelAllowance + yakkaServiceFee + gst;
  }

  // ===== STEP 4 - DATE SELECTION =====
  void updateStartDate(DateTime date) {
    _postJobData.value = _postJobData.value.copyWith(startDate: date);
    selectedStartDate.value = date;
    focusedDay.value = date;
    
    // Actualizar rango si hay fecha de fin
    if (selectedEndDate.value != null) {
      selectedDateRange.value = DateTimeRange(
        start: date,
        end: selectedEndDate.value!,
      );
    }
  }

  void updateEndDate(DateTime? date) {
    _postJobData.value = _postJobData.value.copyWith(endDate: date);
    selectedEndDate.value = date;
    
    // Actualizar rango si hay fecha de inicio
    if (selectedStartDate.value != null && date != null) {
      selectedDateRange.value = DateTimeRange(
        start: selectedStartDate.value!,
        end: date,
      );
    } else {
      selectedDateRange.value = null;
    }
  }

  void updateIsOngoingWork(bool isOngoing) {
    _postJobData.value = _postJobData.value.copyWith(isOngoingWork: isOngoing);
    if (isOngoing) {
      updateEndDate(null);
    }
  }

  void updateWorkOnSaturdays(bool workOnSaturdays) {
    _postJobData.value = _postJobData.value.copyWith(workOnSaturdays: workOnSaturdays);
  }

  void updateWorkOnSundays(bool workOnSundays) {
    _postJobData.value = _postJobData.value.copyWith(workOnSundays: workOnSundays);
  }

  // ===== STEP 5 - TIME & JOB TYPE =====
  void updateStartTime(TimeOfDay time) {
    _postJobData.value = _postJobData.value.copyWith(startTime: time);
    selectedStartTime.value = time;
  }

  void updateEndTime(TimeOfDay time) {
    _postJobData.value = _postJobData.value.copyWith(endTime: time);
    selectedEndTime.value = time;
  }

  void updateJobType(String jobType) {
    _postJobData.value = _postJobData.value.copyWith(jobType: jobType);
    selectedJobType.value = jobType;
  }

  // ===== STEP 6 - REQUIREMENTS =====
  void updateRequirements(List<String> requirements) {
    _postJobData.value = _postJobData.value.copyWith(requirements: requirements);
  }

  void toggleRequirement(String requirement) {
    if (selectedRequirements.contains(requirement)) {
      selectedRequirements.remove(requirement);
    } else {
      selectedRequirements.add(requirement);
    }
    updateRequirements(selectedRequirements.toList());
  }

  void setSelectedCredential(String credential) {
    selectedCredential.value = credential;
  }

  void addCredential() {
    if (selectedCredential.value.isNotEmpty && !selectedCredentials.contains(selectedCredential.value)) {
      selectedCredentials.add(selectedCredential.value);
      selectedCredential.value = '';
    }
  }

  void removeCredential(String credential) {
    selectedCredentials.remove(credential);
  }

  void updateDescription(String desc) {
    description.value = desc;
    _postJobData.value = _postJobData.value.copyWith(jobDescription: desc);
  }

  // ===== STEP 7 - PAYMENT =====
  final RxString selectedPaymentOption = ''.obs;
  final Rx<DateTime?> selectedPayDay = Rx<DateTime?>(null);

  void updatePayDay(DateTime payDay) {
    _postJobData.value = _postJobData.value.copyWith(payDay: payDay);
    selectedPayDay.value = payDay;
  }

  void updatePaymentFrequency(String frequency) {
    _postJobData.value = _postJobData.value.copyWith(paymentFrequency: frequency);
  }

  void selectPaymentOption(String option) {
    selectedPaymentOption.value = option;
    updatePaymentFrequency(option);
  }

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  // ===== STEP 8 - SUPERVISOR SIGNATURE =====
  void selectOption(String option) {
    print('🔍 selectOption called with: "$option"');
    selectedOption.value = option;
    if (option == "yes") {
      _postJobData.value = _postJobData.value.copyWith(requiresSupervisorSignature: true);
    } else {
      _postJobData.value = _postJobData.value.copyWith(requiresSupervisorSignature: false);
    }
    print('🔍 PostJobDto requiresSupervisorSignature: ${_postJobData.value.requiresSupervisorSignature}');
    print('🔍 isStep8Valid: ${isStep8Valid()}');
  }

  void updateSupervisorName(String name) {
    print('🔍 updateSupervisorName called with: "$name"');
    supervisorName.value = name;
    
    // Usar copyWith con un valor no-null para forzar la actualización
    final trimmedName = name.trim();
    print('🔍 Trimmed name: "$trimmedName"');
    
    _postJobData.value = _postJobData.value.copyWith(supervisorName: trimmedName);
    print('🔍 PostJobDto supervisorName after copyWith: "${_postJobData.value.supervisorName}"');
    
    // Verificar si el valor se guardó correctamente
    if (_postJobData.value.supervisorName != trimmedName) {
      print('🔍 ERROR: supervisorName not updated correctly!');
      // Intentar una segunda vez con un enfoque diferente
      final currentDto = _postJobData.value;
      _postJobData.value = PostJobDto(
        selectedSkill: currentDto.selectedSkill,
        jobTitle: currentDto.jobTitle,
        jobDescription: currentDto.jobDescription,
        jobLocation: currentDto.jobLocation,
        jobSiteId: currentDto.jobSiteId,
        workersNeeded: currentDto.workersNeeded,
        hourlyRate: currentDto.hourlyRate,
        siteAllowance: currentDto.siteAllowance,
        leadingHandAllowance: currentDto.leadingHandAllowance,
        productivityAllowance: currentDto.productivityAllowance,
        overtimeRate: currentDto.overtimeRate,
        travelAllowance: currentDto.travelAllowance,
        startDate: currentDto.startDate,
        endDate: currentDto.endDate,
        startTime: currentDto.startTime,
        endTime: currentDto.endTime,
        jobType: currentDto.jobType,
        isOngoingWork: currentDto.isOngoingWork,
        workOnSaturdays: currentDto.workOnSaturdays,
        workOnSundays: currentDto.workOnSundays,
        requirements: currentDto.requirements,
        payDay: currentDto.payDay,
        paymentFrequency: currentDto.paymentFrequency,
        requiresSupervisorSignature: currentDto.requiresSupervisorSignature,
        supervisorName: trimmedName,
        isPublic: currentDto.isPublic,
      );
      print('🔍 PostJobDto supervisorName after manual creation: "${_postJobData.value.supervisorName}"');
    }
    
    print('🔍 selectedOption.value: "${selectedOption.value}"');
    print('🔍 isStep8Valid: ${isStep8Valid()}');
    print('🔍 canProceedToNextStep: ${canProceedToNextStep()}');
  }

  // ===== REVIEW SCREEN =====
  void updateIsPublic(bool value) {
    isPublic.value = value;
    _postJobData.value = _postJobData.value.copyWith(isPublic: value);
  }

  // ===== VALIDATION =====
  bool isStep1Valid() {
    return selectedSkills.isNotEmpty;
  }

  bool isStep2Valid() {
    return _postJobData.value.workersNeeded != null && 
           _postJobData.value.workersNeeded! > 0;
  }

  bool isStep3Valid() {
    return _postJobData.value.hourlyRate != null && 
           _postJobData.value.hourlyRate! > 0;
  }

  bool isStep4Valid() {
    if (_postJobData.value.isOngoingWork == true) {
      return _postJobData.value.startDate != null;
    }
    return _postJobData.value.startDate != null && _postJobData.value.endDate != null;
  }

  bool isStep5Valid() {
    return _postJobData.value.startTime != null && 
           _postJobData.value.endTime != null &&
           _postJobData.value.jobType != null &&
           _postJobData.value.jobType!.isNotEmpty;
  }

  bool isStep6Valid() {
    return _postJobData.value.requirements != null && 
           _postJobData.value.requirements!.isNotEmpty;
  }

  bool isStep7Valid() {
    return _postJobData.value.paymentFrequency != null && 
           _postJobData.value.paymentFrequency!.isNotEmpty;
  }

  bool isStep8Valid() {
    print('🔍 isStep8Valid - requiresSupervisorSignature: ${_postJobData.value.requiresSupervisorSignature}');
    print('🔍 isStep8Valid - supervisorName: "${_postJobData.value.supervisorName}"');
    print('🔍 isStep8Valid - selectedOption: "${selectedOption.value}"');
    
    // Si no se ha seleccionado ninguna opción, no es válido
    if (selectedOption.value.isEmpty) {
      print('🔍 isStep8Valid - returning false (no option selected)');
      return false;
    }
    
    // Si se seleccionó "yes" (requiere supervisor), verificar que el nombre no esté vacío
    if (selectedOption.value == "yes") {
      // Verificar tanto en el DTO como en la variable local
      final dtoName = _postJobData.value.supervisorName;
      final localName = supervisorName.value;
      
      final isValid = (dtoName != null && dtoName.trim().isNotEmpty) || 
                     (localName.trim().isNotEmpty);
      
      print('🔍 isStep8Valid - dtoName: "$dtoName", localName: "$localName"');
      print('🔍 isStep8Valid - returning $isValid (supervisor required)');
      return isValid;
    }
    
    // Si se seleccionó "no", es válido
    print('🔍 isStep8Valid - returning true (supervisor not required)');
    return true;
  }

  bool canProceedToNextStep() {
    print('🔍 canProceedToNextStep called for step: ${_currentStep.value}');
    bool result = false;
    switch (_currentStep.value) {
      case 1:
        result = isStep1Valid();
        break;
      case 2:
        result = isStep2Valid();
        break;
      case 3:
        result = isStep3Valid();
        break;
      case 4:
        result = isStep4Valid();
        break;
      case 5:
        result = isStep5Valid();
        break;
      case 6:
        result = isStep6Valid();
        break;
      case 7:
        result = isStep7Valid();
        break;
      case 8:
        result = isStep8Valid();
        break;
      default:
        result = false;
    }
    print('🔍 canProceedToNextStep result: $result');
    return result;
  }

  // ===== FORMATTING METHODS =====
  String formatDateRange() {
    final startDate = _postJobData.value.startDate;
    final endDate = _postJobData.value.endDate;
    
    if (startDate == null) return "Not set";
    
    final startFormatted = "${startDate.day.toString().padLeft(2, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.year}";
    
    if (endDate == null || _postJobData.value.isOngoingWork == true) {
      return "$startFormatted - Ongoing";
    }
    
    final endFormatted = "${endDate.day.toString().padLeft(2, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.year}";
    return "$startFormatted - $endFormatted";
  }

  String formatTimeRange() {
    final startTime = _postJobData.value.startTime;
    final endTime = _postJobData.value.endTime;
    
    if (startTime == null || endTime == null) return "Not set";
    
    final startFormatted = startTime.format(Get.context!);
    final endFormatted = endTime.format(Get.context!);
    
    return "$startFormatted - $endFormatted";
  }

  String formatPaymentFrequency() {
    final frequency = _postJobData.value.paymentFrequency;
    
    switch (frequency) {
      case "weekly":
        return "Weekly payment";
      case "fortnightly":
        return "Fortnightly payment";
      case "choose_pay_day":
        final payDay = _postJobData.value.payDay;
        if (payDay != null) {
          return "Specific date: ${payDay.day.toString().padLeft(2, '0')}-${payDay.month.toString().padLeft(2, '0')}-${payDay.year}";
        }
        return "Choose pay day";
      default:
        return "Not set";
    }
  }

  // ===== JOB POSTING =====
  Future<void> postJob() async {
    if (!canProceedToNextStep()) {
      _errorMessage.value = 'Please complete all required fields';
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      // TODO: Implement actual API call to post job
      await Future.delayed(Duration(seconds: 2)); // Simulate API call
      
      // Success - reset data
      reset();
      
    } catch (e) {
      _errorMessage.value = 'Error posting job: ${e.toString()}';
    } finally {
      _isLoading.value = false;
    }
  }

  void handleContinue() {
    if (canProceedToNextStep()) {
      nextStep();
      // Navegar al siguiente paso
      _navigateToNextStep();
    }
  }

  void _navigateToNextStep() {
    switch (_currentStep.value) {
      case 2:
        Get.toNamed(PostJobStepperStep2Screen.id, arguments: {'flavor': currentFlavor.value});
        break;
      case 3:
        Get.toNamed(PostJobStepperStep3Screen.id, arguments: {'flavor': currentFlavor.value});
        break;
      case 4:
        Get.toNamed(PostJobStepperStep4Screen.id, arguments: {'flavor': currentFlavor.value});
        break;
      case 5:
        Get.toNamed(PostJobStepperStep5Screen.id, arguments: {'flavor': currentFlavor.value});
        break;
      case 6:
        Get.toNamed(PostJobStepperStep6Screen.id, arguments: {'flavor': currentFlavor.value});
        break;
      case 7:
        Get.toNamed(PostJobStepperStep7Screen.id, arguments: {'flavor': currentFlavor.value});
        break;
      case 8:
        Get.toNamed(PostJobStepperStep8Screen.id, arguments: {'flavor': currentFlavor.value});
        break;
      case 9:
        Get.toNamed(PostJobReviewScreen.id, arguments: {'flavor': currentFlavor.value});
        break;
      default:
        print('No navigation defined for step ${_currentStep.value}');
    }
  }

  void handleEdit() {
    // Navegar al paso 1 para editar
    goToStep(1);
    Get.offNamed(PostJobStepperScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void handleConfirm() async {
    print('🎯 handleConfirm called - Instance: ${this.hashCode}');
    await postJob();
    
    // Mostrar mensaje de éxito
    Get.snackbar(
      'Success',
      'Job posted successfully!',
      backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
    
    // Resetear todos los estados de las variables de las vistas
    await reset();
    
    // Navegar al home del builder
    Get.offAllNamed('/builder/home');
  }

  // ===== UTILITY METHODS =====
  Future<void> reset() async {
    print('🧹 UnifiedPostJobController reset - Instance: ${this.hashCode}');
    _postJobData.value = PostJobDto(
      requiresSupervisorSignature: false,
      supervisorName: null,
    );
    _currentStep.value = 1;
    _errorMessage.value = '';
    
    // Reset all step-specific data
    selectedStartDate.value = null;
    selectedEndDate.value = null;
    selectedDateRange.value = null;
    selectedStartTime.value = null;
    selectedEndTime.value = null;
    selectedJobType.value = '';
    selectedOption.value = '';
    supervisorName.value = '';
    supervisorNameController.clear();
    selectedRequirements.clear();
    selectedCredential.value = '';
    selectedCredentials.clear();
    description.value = '';
    selectedPaymentOption.value = '';
    selectedPayDay.value = null;
    isPublic.value = true;
    print('✅ Reset completed');
  }

  void clearError() {
    _errorMessage.value = '';
  }

  // ===== CALENDAR METHODS =====
  void updateFocusedDay(DateTime newDate) {
    focusedDay.value = newDate;
  }

  void onDaySelected(DateTime selectedDay) {
    if (selectedStartDate.value == null) {
      // First selection - start date
      selectedStartDate.value = selectedDay;
      updateStartDate(selectedDay);
    } else if (selectedEndDate.value == null && selectedDay.isAfter(selectedStartDate.value!)) {
      // Second selection - end date
      selectedEndDate.value = selectedDay;
      updateEndDate(selectedDay);
      
      // Create date range
      selectedDateRange.value = DateTimeRange(
        start: selectedStartDate.value!,
        end: selectedDay,
      );
    } else {
      // Reset and start new selection
      selectedStartDate.value = selectedDay;
      selectedEndDate.value = null;
      selectedDateRange.value = null;
      updateStartDate(selectedDay);
      updateEndDate(null);
    }
  }


  @override
  void onClose() {
    searchController.dispose();
    supervisorNameController.dispose();
    super.onClose();
  }
}

