import 'package:get/get.dart';
import '../../../../config/app_flavor.dart';
import '../../../../features/logic/labour/use_case/jobs_use_case.dart';
import '../../../../features/logic/labour/models/receive/dto_receive_labour_job.dart';


class JobSearchResultsScreenController extends GetxController {
  // Flavor
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  // Search queries
  final RxString whatQuery = ''.obs;
  final RxString whereQuery = ''.obs;
  
  // Suggestions
  final RxList<String> whatSuggestions = <String>[].obs;
  
  // Job count
  final RxInt jobCount = 0.obs;
  
  // Last search
  final RxString lastSearch = 'construction in All Sydney NWS'.obs;
  final RxInt newJobsCount = 99.obs;
  
  // Lista de trabajos
  final RxList<DtoReceiveLabourJob> jobList = <DtoReceiveLabourJob>[].obs;
  
  // Estados de carga
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  // Caso de uso para jobs
  final JobsUseCase _jobsUseCase = JobsUseCase();



  // Lista de palabras clave disponibles
  final List<String> _availableKeywords = [
    'construction',
    'labour',
    'carpenter',
    'electrician',
    'plumber',
    'painter',
    'cleaner',
    'gardener',
    'driver',
    'warehouse',
    'retail',
    'hospitality',
    'security',
    'maintenance',
    'fitter',
    'welder',
    'concrete',
    'roofing',
    'tiling',
    'landscaping',
  ];

  @override
  void onInit() {
    super.onInit();
    
    // Obtener argumentos pasados desde la navegación
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      if (arguments['flavor'] != null) {
        currentFlavor.value = arguments['flavor'];
      }
      if (arguments['whatQuery'] != null) {
        whatQuery.value = arguments['whatQuery'];
      }
      if (arguments['whereQuery'] != null) {
        whereQuery.value = arguments['whereQuery'];
      }
    }
    
    // Cargar trabajos desde el API
    loadJobs();
  }
  
  /// Carga los jobs desde el API
  Future<void> loadJobs() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final result = await _jobsUseCase.getJobs();
      
      if (result.isSuccess && result.data != null) {
        // Mapear los jobs con la nueva estructura del API
        jobList.value = result.data!.jobs;
        jobCount.value = result.data!.total;
        
        print('JobSearchResultsScreenController.loadJobs - Loaded ${jobList.length} jobs');
        print('JobSearchResultsScreenController.loadJobs - Total: ${jobCount.value}');
        
        // Debug: Verificar estructura de los jobs
        if (jobList.isNotEmpty) {
          final firstJob = jobList.first;
          print('JobSearchResultsScreenController.loadJobs - First job skills: ${firstJob.skills.length}');
          if (firstJob.skills.isNotEmpty) {
            final firstSkill = firstJob.skills.first;
            print('JobSearchResultsScreenController.loadJobs - First skill category: ${firstSkill.skillCategory?.name}');
            print('JobSearchResultsScreenController.loadJobs - First skill subcategory: ${firstSkill.skillSubcategory?.name}');
          }
        }
      } else {
        errorMessage.value = result.message ?? 'Error loading jobs';
        jobList.clear();
        jobCount.value = 0;
      }
    } catch (e) {
      errorMessage.value = 'Error loading jobs: $e';
      jobList.clear();
      jobCount.value = 0;
      print('Error details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateWhatQuery(String value) {
    whatQuery.value = value;
    _updateJobCount();
    _updateWhatSuggestions(value);
  }

  void _updateWhatSuggestions(String query) {
    if (query.isEmpty) {
      whatSuggestions.clear();
      return;
    }

    // Filtrar palabras clave que contengan el texto ingresado
    final filteredSuggestions = _availableKeywords
        .where((keyword) => keyword.toLowerCase().contains(query.toLowerCase()))
        .toList();

    whatSuggestions.value = filteredSuggestions;
  }

  void selectWhatSuggestion(String suggestion) {
    whatQuery.value = suggestion;
    whatSuggestions.clear();
    _updateJobCount();
  }

  void updateWhereQuery(String value) {
    whereQuery.value = value;
    _updateJobCount();
  }

  void clearWhatQuery() {
    whatQuery.value = '';
    whatSuggestions.clear();
    _updateJobCount();
  }

  void clearWhereQuery() {
    whereQuery.value = '';
    _updateJobCount();
  }

  void clearAllFilters() {
    whatQuery.value = '';
    whereQuery.value = '';
    whatSuggestions.clear();
    _updateJobCount();
  }

  void _updateJobCount() {
    // El conteo se actualiza automáticamente cuando se cargan los jobs desde el API
    // No necesitamos hacer cálculos simulados aquí
  }

  void performSearch() {
    // Realizar una nueva búsqueda con los valores actuales
    print('=== performSearch in results screen ===');
    print('whatQuery: "${whatQuery.value}"');
    print('whereQuery: "${whereQuery.value}"');
    
    // Recargar jobs desde el API
    loadJobs();
    
    // Mostrar un mensaje de que se está realizando la búsqueda
    Get.snackbar(
      'Search performed',
      'Searching: ${whatQuery.value.isNotEmpty ? whatQuery.value : "all jobs"}${whereQuery.value.isNotEmpty ? " in $whereQuery.value" : ""}',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );
    
    // Actualizar la última búsqueda
    if (whatQuery.value.isNotEmpty || whereQuery.value.isNotEmpty) {
      String searchText = '';
      if (whatQuery.value.isNotEmpty) {
        searchText += whatQuery.value;
      }
      if (whereQuery.value.isNotEmpty) {
        if (searchText.isNotEmpty) {
          searchText += ' in ';
        }
        searchText += whereQuery.value;
      }
      lastSearch.value = searchText;
      newJobsCount.value = 99;
    }
  }

  void useLastSearch() {
    // Usar la última búsqueda
    Get.snackbar(
      'Usando última búsqueda',
      'Aplicando: $lastSearch',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Obtiene el nombre de la skill del job para el título de la card
  String getSkillName(DtoReceiveLabourJob job) {
    print('JobSearchResultsScreenController.getSkillName - job.skills.length: ${job.skills.length}');
    
    if (job.skills.isNotEmpty) {
      final firstSkill = job.skills.first;
      print('JobSearchResultsScreenController.getSkillName - firstSkill: ${firstSkill.toString()}');
      
      // Obtener skill category y subcategory
      final skillCategory = firstSkill.skillCategory?.name ?? 'Skill';
      final skillSubcategory = firstSkill.skillSubcategory?.name ?? 'Specialization';
      
      print('JobSearchResultsScreenController.getSkillName - skillCategory: $skillCategory');
      print('JobSearchResultsScreenController.getSkillName - skillSubcategory: $skillSubcategory');
      
      return '$skillCategory, $skillSubcategory';
    }
    
    // Si no hay skills, usar el título como fallback
    if (job.title.isNotEmpty) {
      print('JobSearchResultsScreenController.getSkillName - title: ${job.title}');
      return job.title;
    }
    
    print('JobSearchResultsScreenController.getSkillName - fallback: Skill');
    return 'Skill, Specialization';
  }

  /// Obtiene el número de labours para el título de la card
  int getManyLabours(DtoReceiveLabourJob job) {
    return job.manyLabours;
  }
}
