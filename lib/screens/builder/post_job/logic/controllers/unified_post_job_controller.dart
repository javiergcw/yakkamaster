import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/logic/masters/use_case/master_use_case.dart';
import '../../../../../features/logic/masters/models/receive/dto_receive_license.dart';
import '../../../../../features/logic/masters/models/receive/dto_receive_skill.dart';
import '../../../../../features/logic/builder/use_case/jobs_use_case.dart';
import '../../../../../features/logic/builder/models/send/dto_send_job.dart';
import '../../../../../features/logic/masters/models/receive/dto_receive_job_type.dart';
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
  final RxList<DtoReceiveJobType> jobTypesFromApi = <DtoReceiveJobType>[].obs;
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
  final JobsUseCase _jobsUseCase = JobsUseCase();
  final RxList<DtoReceiveLicense> licensesFromApi = <DtoReceiveLicense>[].obs;
  final RxList<String> credentials = <String>[].obs;
  final RxBool isLoadingCredentials = false.obs;
  
  // Variables para constantes de pago
  final RxDouble gstPercentage = 10.0.obs; // Valor por defecto
  final RxDouble minimumHourlyWage = 28.0.obs; // Valor por defecto
  final RxBool isLoadingPaymentConstants = false.obs;

  // ===== JOBSITE SELECTION =====
  final RxList<dynamic> selectedJobSites = <dynamic>[].obs;
  final RxString selectedJobSiteId = ''.obs;

  // ===== REVIEW SCREEN =====
  final RxBool isPublic = true.obs;

  // ===== GETTERS =====
  PostJobDto get postJobData => _postJobData.value;
  int get currentStep => _currentStep.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  
  // Getters para constantes de pago
  double get currentGstPercentage => gstPercentage.value;
  double get currentMinimumHourlyWage => minimumHourlyWage.value;
  bool get isPaymentConstantsLoading => isLoadingPaymentConstants.value;

  @override
  void onInit() {
    super.onInit();
    initializeController();
  }

  void initializeController() {
    // Establecer flavor si viene en los argumentos
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
    
    // Inicializar jobsites seleccionados si vienen en los argumentos
    if (Get.arguments != null && Get.arguments['selectedJobSites'] != null) {
      selectedJobSites.value = Get.arguments['selectedJobSites'];
      if (selectedJobSites.isNotEmpty) {
        // Usar el primer jobsite seleccionado como el principal
        final firstJobSite = selectedJobSites.first;
        if (firstJobSite != null && firstJobSite.id != null) {
          selectedJobSiteId.value = firstJobSite.id;
          _postJobData.value = _postJobData.value.copyWith(jobSiteId: firstJobSite.id);
        }
      }
    }
    
    // Inicializar estado de carga
    isLoadingSkills.value = true;
    
    // Cargar habilidades desde el backend
    loadSkillsFromApi();
    
    // Inicializar estado público/privado
    isPublic.value = _postJobData.value.isPublic ?? true;
    
    // Cargar credenciales desde el backend
    loadCredentialsFromApi();
    
    // Cargar constantes de pago desde el backend
    _loadPaymentConstants();
    
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
      isLoadingSkills.value = true;
      
      final result = await _masterUseCase.getSkills();
      
      if (result.isSuccess && result.data != null) {
        allSkillsFromApi.value = result.data!;
        _processSkillsData();
      }
    } catch (e) {
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
    }
  }

  void _processSkillsData() {
    // Procesar datos de la API para crear categorías y subcategorías
    final Map<String, List<String>> categories = {};
    
    for (final skill in allSkillsFromApi) {
      final categoryName = skill.name;
      final subcategories = skill.subcategories.map((sub) => sub.name).toList();
      
      categories[categoryName] = subcategories;
    }
    
    categorySubcategories.value = categories;
    filteredSkills.value = categories.keys.toList();
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
      isLoadingJobTypes.value = true;
      
      final result = await _masterUseCase.getJobTypes();
      
      if (result.isSuccess && result.data != null) {
        // Mapear los tipos de trabajo a una lista simple de nombres
        jobTypesFromApi.value = result.data!.types;
      }
    } catch (e) {
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
    }
  }

  Future<void> loadJobRequirementsFromApi({bool showSnackbar = true}) async {
    try {
      isLoadingJobRequirements.value = true;
      
      final result = await _masterUseCase.getJobRequirements();
      
      if (result.isSuccess && result.data != null) {
        // Mapear los requisitos de trabajo a una lista simple de nombres
        jobRequirementsFromApi.value = result.data!.requirements.map((requirement) => requirement.name).toList();
      }
    } catch (e) {
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
        break;
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
    _postJobData.value = _postJobData.value.copyWith(workersNeeded: workers);
  }

  // ===== STEP 3 - COSTS =====
  void updateHourlyRate(double rate) {
    _postJobData.value = _postJobData.value.copyWith(hourlyRate: rate);
    print('✅ Hourly rate updated: \$${rate.toStringAsFixed(2)}');
    print('✅ GST will be: \$${_calculateGST(rate).toStringAsFixed(2)}');
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
    print('✅ Travel allowance updated: \$${allowance.toStringAsFixed(2)}');
  }

  double calculateTotalCost() {
    final hourlyRate = _postJobData.value.hourlyRate ?? 0.0;
    final siteAllowance = _postJobData.value.siteAllowance ?? 0.0;
    final leadingHandAllowance = _postJobData.value.leadingHandAllowance ?? 0.0;
    final productivityAllowance = _postJobData.value.productivityAllowance ?? 0.0;
    final overtimeRate = _postJobData.value.overtimeRate ?? 0.0;
    final travelAllowance = _postJobData.value.travelAllowance ?? 0.0;
    
    // Calcular GST usando el porcentaje dinámico de la API
    final gst = _calculateGST(hourlyRate);
    
    return hourlyRate + siteAllowance + leadingHandAllowance + productivityAllowance + 
           overtimeRate + travelAllowance + gst;
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
    selectedOption.value = option;
    if (option == "yes") {
      _postJobData.value = _postJobData.value.copyWith(requiresSupervisorSignature: true);
    } else {
      _postJobData.value = _postJobData.value.copyWith(requiresSupervisorSignature: false);
    }
  }

  void updateSupervisorName(String name) {
    supervisorName.value = name;
    
    // Usar copyWith con un valor no-null para forzar la actualización
    final trimmedName = name.trim();
    
    _postJobData.value = _postJobData.value.copyWith(supervisorName: trimmedName);
    
    // Verificar si el valor se guardó correctamente
    if (_postJobData.value.supervisorName != trimmedName) {
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
    }
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
    final hourlyRate = _postJobData.value.hourlyRate;
    return hourlyRate != null && 
           hourlyRate > 0 &&
           hourlyRate >= minimumHourlyWage.value;
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
    // Si no se ha seleccionado ninguna opción, no es válido
    if (selectedOption.value.isEmpty) {
      return false;
    }
    
    // Si se seleccionó "yes" (requiere supervisor), verificar que el nombre no esté vacío
    if (selectedOption.value == "yes") {
      // Verificar tanto en el DTO como en la variable local
      final dtoName = _postJobData.value.supervisorName;
      final localName = supervisorName.value;
      
      final isValid = (dtoName != null && dtoName.trim().isNotEmpty) || 
                     (localName.trim().isNotEmpty);
      
      return isValid;
    }
    
    // Si se seleccionó "no", es válido
    return true;
  }

  bool canProceedToNextStep() {
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
      case 9:
        // En el paso 9 (review), solo validamos campos absolutamente esenciales
        // para poder proceder con la confirmación
        result = selectedJobSiteId.value.isNotEmpty;
        break;
      default:
        result = false;
    }
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

  // ===== JOBSITE SELECTION =====
  void setSelectedJobSite(String jobSiteId) {
    selectedJobSiteId.value = jobSiteId;
    _postJobData.value = _postJobData.value.copyWith(jobSiteId: jobSiteId);
  }

  void addSelectedJobSite(dynamic jobSite) {
    if (!selectedJobSites.any((js) => js.id == jobSite.id)) {
      selectedJobSites.add(jobSite);
    }
  }

  void removeSelectedJobSite(String jobSiteId) {
    selectedJobSites.removeWhere((js) => js.id == jobSiteId);
    if (selectedJobSiteId.value == jobSiteId) {
      selectedJobSiteId.value = '';
      _postJobData.value = _postJobData.value.copyWith(jobSiteId: null);
    }
  }

  // ===== JOB POSTING =====
  Future<void> postJob() async {
    if (!canProceedToNextStep()) {
      _errorMessage.value = 'Please all required fields';
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      // Crear el DTO para enviar al API usando el caso de uso
      final jobData = _createJobData();
      
      // Debug: Imprimir el JSON que se va a enviar
      print('🔍 JSON que se va a enviar:');
      print(jobData.toJson());
      
      // Validar datos antes de enviar usando el caso de uso
      if (!_jobsUseCase.validateJobData(jobData)) {
        final missingFields = _jobsUseCase.getMissingJobFields(jobData);
        _errorMessage.value = 'Missing required fields: ${missingFields.join(', ')}';
        return;
      }

      // Crear el job usando el caso de uso
      final result = await _jobsUseCase.createJob(jobData);
      
      if (result.isSuccess && result.data != null) {
        // Success - job created successfully
        // Note: reset() will be called in handleConfirm() after success
      } else {
        _errorMessage.value = result.message ?? 'Error creating job';
      }
      
    } catch (e) {
      _errorMessage.value = 'Error posting job: ${e.toString()}';
    } finally {
      _isLoading.value = false;
    }
  }

  /// Crea el DTO de job con los datos del formulario
  DtoSendJob _createJobData() {
    final data = _postJobData.value;
    
      // Convertir fechas a formato ISO sin milisegundos
      final startDateWork = data.startDate != null 
          ? '${data.startDate!.toIso8601String().split('.')[0]}Z'
          : null;
      final endDateWork = data.endDate != null 
          ? '${data.endDate!.toIso8601String().split('.')[0]}Z'
          : null;

    // Convertir tiempos a formato HH:mm:ss
    final startTime = data.startTime != null 
        ? '${data.startTime!.hour.toString().padLeft(2, '0')}:${data.startTime!.minute.toString().padLeft(2, '0')}:00'
        : null;
    
    final endTime = data.endTime != null 
        ? '${data.endTime!.hour.toString().padLeft(2, '0')}:${data.endTime!.minute.toString().padLeft(2, '0')}:00'
        : null;

    // Obtener IDs de licencias seleccionadas
    final licenseIds = selectedCredentials.map((cred) {
      final license = licensesFromApi.firstWhereOrNull((l) => l.name == cred);
      return license?.id ?? '';
    }).where((id) => id.isNotEmpty).toList();

    // Obtener IDs de categorías y subcategorías de habilidades
    final skillCategoryIds = <String>[];
    final skillSubcategoryIds = <String>[];
    
    for (final skillId in selectedSkills) {
      final category = getCategoryFromUniqueId(skillId);
      final subcategory = getSkillNameFromUniqueId(skillId);
      
      if (category != null) {
        final categorySkill = allSkillsFromApi.firstWhereOrNull((s) => s.name == category);
        if (categorySkill != null) {
          skillCategoryIds.add(categorySkill.id);
          
          final subcategoryObj = categorySkill.subcategories.firstWhereOrNull((sub) => sub.name == subcategory);
          if (subcategoryObj != null) {
            skillSubcategoryIds.add(subcategoryObj.id);
          }
        }
      }
    }

    // Validar solo los campos absolutamente requeridos
    if (data.workersNeeded == null) throw Exception('Workers needed is required');
    if (data.workersNeeded! < 1) throw Exception('Workers needed must be at least 1');
    
    // Validar supervisor name solo si requiresSupervisorSignature es true
    if (data.requiresSupervisorSignature == true && (data.supervisorName == null || data.supervisorName!.trim().isEmpty)) {
      throw Exception('Supervisor name is required when supervisor signature is required');
    }

    // Obtener el hourlyRate del formulario o usar el mínimo de la API
    final hourlyRate = data.hourlyRate ?? minimumHourlyWage.value;
    final gstValue = _calculateGST(hourlyRate);
    
    // Debug: Verificar valores antes de enviar
    print('🔍 Creating job data:');
    print('  - Hourly Rate: \$${hourlyRate.toStringAsFixed(2)}');
    print('  - Travel Allowance: \$${(data.travelAllowance ?? 0.0).toStringAsFixed(2)}');
    print('  - GST: \$${gstValue.toStringAsFixed(2)} (${gstPercentage.value}%)');
    
    // Crear DtoSendJob con valores del formulario y fallbacks apropiados
    return DtoSendJob(
      jobsiteId: selectedJobSiteId.value,
      jobTypeId: _getJobTypeIdFromSelection(),
      manyLabours: data.workersNeeded!,
      ongoingWork: data.isOngoingWork ?? false,
      wageSiteAllowance: data.siteAllowance ?? 0.0,
      wageLeadingHandAllowance: data.leadingHandAllowance ?? 0.0,
      wageProductivityAllowance: data.productivityAllowance ?? 0.0,
      extrasOvertimeRate: data.overtimeRate ?? 0.0,
      wageHourlyRate: hourlyRate,
      travelAllowance: data.travelAllowance ?? 0.0,
      gst: gstValue,
      startDateWork: startDateWork ?? _formatDateForApi(DateTime.now()),
      endDateWork: endDateWork ?? _formatDateForApi(DateTime.now().add(Duration(days: 30))),
      workSaturday: data.workOnSaturdays ?? false,
      workSunday: data.workOnSundays ?? false,
      startTime: startTime ?? '08:00:00',
      endTime: endTime ?? '17:00:00',
      description: description.value.isNotEmpty ? description.value : (data.jobDescription ?? 'Job description'),
      paymentDay: data.payDay?.day ?? 1,
      requiresSupervisorSignature: data.requiresSupervisorSignature ?? false,
      supervisorName: data.supervisorName ?? 'Supervisor',
      visibility: isPublic.value ? 'PUBLIC' : 'PRIVATE',
      paymentType: _getValidPaymentType(data.paymentFrequency),
      licenseIds: licenseIds,
      skillCategoryIds: skillCategoryIds,
      skillSubcategoryIds: skillSubcategoryIds,
    );
  }

  /// Formatea una fecha para la API sin milisegundos
  String _formatDateForApi(DateTime date) {
    return '${date.toIso8601String().split('.')[0]}Z';
  }

  /// Calcula el GST basado en el salario por hora usando el porcentaje dinámico
  double _calculateGST(double hourlyRate) {
    return hourlyRate * (gstPercentage.value / 100.0);
  }

  /// Carga las constantes de pago desde la API
  Future<void> _loadPaymentConstants() async {
    try {
      isLoadingPaymentConstants.value = true;
      
      final result = await _masterUseCase.getPaymentConstants(activeOnly: true);
      
      if (result.isSuccess && result.data != null) {
        // Actualizar GST
        final gstValue = result.data!.gst;
        if (gstValue != null) {
          gstPercentage.value = gstValue;
        }
        
        // Actualizar salario mínimo por hora
        final hourlyWageValue = result.data!.hourlyWage;
        if (hourlyWageValue != null) {
          minimumHourlyWage.value = hourlyWageValue;
        }
      }
    } catch (e) {
      print('Error cargando constantes de pago: $e');
    } finally {
      isLoadingPaymentConstants.value = false;
    }
  }

  /// Obtiene un tipo de pago válido según la API
  String _getValidPaymentType(String? paymentFrequency) {
    if (paymentFrequency == null) return 'WEEKLY';
    
    switch (paymentFrequency.toUpperCase()) {
      case 'WEEKLY':
        return 'WEEKLY';
      case 'FORTNIGHTLY':
        return 'FORTNIGHTLY';
      case 'FIXED_DAY':
        return 'FIXED_DAY';
      case 'CHOOSE_PAY_DAY':
        return 'FIXED_DAY'; // Mapear a FIXED_DAY
      default:
        return 'WEEKLY';
    }
  }

  /// Obtiene el ID del tipo de trabajo seleccionado
  String _getJobTypeIdFromSelection() {
    final selectedJobTypeName = _postJobData.value.jobType;
    if (selectedJobTypeName != null && selectedJobTypeName.isNotEmpty) {
      // Buscar el ID del tipo de trabajo en los datos cargados del API
      final jobType = jobTypesFromApi.firstWhereOrNull(
        (jt) => jt.name == selectedJobTypeName
      );
      if (jobType != null) {
        return jobType.id;
      }
    }
    // Si no se encuentra, retornar el primer job type disponible como fallback
    if (jobTypesFromApi.isNotEmpty) {
      return jobTypesFromApi.first.id;
    }
    return 'default-job-type-id';
  }

  /// Método de utilidad para obtener información del job creado
  Future<void> getJobInfo(String jobId) async {
    try {
      final result = await _jobsUseCase.getJobById(jobId);
      
      if (result.isSuccess && result.data != null) {
        // Job info retrieved successfully
      }
    } catch (e) {
      // Error getting job info
    }
  }

  /// Método de utilidad para obtener todos los jobs del builder
  Future<void> getAllJobs() async {
    try {
      final result = await _jobsUseCase.getJobs();
      
      if (result.isSuccess && result.data != null) {
        // Jobs retrieved successfully
      }
    } catch (e) {
      // Error getting jobs
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
        break;
    }
  }

  void handleEdit() {
    // Navegar al paso 1 para editar
    goToStep(1);
    Get.offNamed(PostJobStepperScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void handleConfirm() async {
    // Limpiar errores previos antes de intentar crear el job
    _errorMessage.value = '';
    
    // Crear el job usando el caso de uso
    await postJob();
    
    // Verificar si la creación fue exitosa
    if (_errorMessage.value.isEmpty) {
      // Mostrar mensaje de éxito solo si no hay errores
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
    } else {
      // Mostrar error si la creación falló
      Get.snackbar(
        'Error',
        _errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  // ===== UTILITY METHODS =====
  Future<void> reset() async {
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

