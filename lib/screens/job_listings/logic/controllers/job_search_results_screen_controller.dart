import 'package:get/get.dart';
import '../../../../config/app_flavor.dart';

// Modelo simple para los trabajos
class JobItem {
  final String id;
  final String title;
  final String hourlyRate;
  final String location;
  final String company;
  final String jobType;
  final String postedTime;
  final String? dateRange;
  final String? distance;

  JobItem({
    required this.id,
    required this.title,
    required this.hourlyRate,
    required this.location,
    required this.company,
    required this.jobType,
    required this.postedTime,
    this.dateRange,
    this.distance,
  });
}

class JobSearchResultsScreenController extends GetxController {
  // Flavor
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  // Search queries
  final RxString whatQuery = ''.obs;
  final RxString whereQuery = ''.obs;
  
  // Suggestions
  final RxList<String> whatSuggestions = <String>[].obs;
  
  // Job count
  final RxInt jobCount = 1235.obs;
  
  // Last search
  final RxString lastSearch = 'construction in All Sydney NWS'.obs;
  final RxInt newJobsCount = 99.obs;
  
  // Lista de trabajos
  final RxList<JobItem> jobList = <JobItem>[].obs;

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
    
    // Cargar trabajos de ejemplo
    _loadSampleJobs();
  }
  
  void _loadSampleJobs() {
    jobList.value = [
      JobItem(
        id: '1',
        title: 'General Labour',
        hourlyRate: '\$22.50/hr',
        location: 'City',
        company: 'Name company',
        jobType: 'Full time',
        postedTime: 'Posted 1d ago',
      ),
      JobItem(
        id: '2',
        title: 'General Labour',
        hourlyRate: '\$22.50/hr',
        location: 'Bondi, Sydney, NSW (5km from you)',
        company: '12/09/2024 - 17/09/2024',
        jobType: 'On going',
        postedTime: 'Posted 1d ago',
      ),
      JobItem(
        id: '3',
        title: 'Cleaner',
        hourlyRate: '\$25.00/hr',
        location: 'City',
        company: '12/09/2024 - 17/09/2024',
        jobType: 'Part time',
        postedTime: 'Posted 2d ago',
      ),
      JobItem(
        id: '4',
        title: 'Construction Worker',
        hourlyRate: '\$28.00/hr',
        location: 'Sydney CBD',
        company: 'ABC Construction',
        jobType: 'Full time',
        postedTime: 'Posted 3d ago',
      ),
      JobItem(
        id: '5',
        title: 'Electrician',
        hourlyRate: '\$35.00/hr',
        location: 'Parramatta, NSW',
        company: 'Electric Solutions',
        jobType: 'Contract',
        postedTime: 'Posted 4d ago',
      ),
    ];
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
    // Simular actualización del conteo de trabajos basado en las búsquedas
    // En una implementación real, esto haría una llamada a la API
    int baseCount = 1235;
    
    if (whatQuery.value.isNotEmpty) {
      baseCount += 100;
    }
    if (whereQuery.value.isNotEmpty) {
      baseCount += 50;
    }
    
    jobCount.value = baseCount;
  }

  void performSearch() {
    // Realizar una nueva búsqueda con los valores actuales
    print('=== performSearch in results screen ===');
    print('whatQuery: "${whatQuery.value}"');
    print('whereQuery: "${whereQuery.value}"');
    
    // Aquí deberías hacer la llamada a la API para obtener los resultados
    // Por ahora solo actualizamos el conteo
    _updateJobCount();
    
    // Mostrar un mensaje de que se está realizando la búsqueda
    Get.snackbar(
      'Búsqueda realizada',
      'Buscando: ${whatQuery.value.isNotEmpty ? whatQuery.value : "todos los trabajos"}${whereQuery.value.isNotEmpty ? " en $whereQuery.value" : ""}',
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
}
