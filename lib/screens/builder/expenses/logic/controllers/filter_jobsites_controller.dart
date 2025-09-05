import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../post_job/data/dto/job_site_dto.dart';

class FilterJobSitesController extends GetxController {
  // Flavor
  final Rx<AppFlavor> currentFlavor = AppFlavor.sport.obs;

  // Job Sites
  final RxList<JobSiteDto> jobSites = <JobSiteDto>[].obs;
  final RxList<String> selectedJobSites = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initializeController();
  }

  void initializeController() {
    try {
      // Cargar jobsites de ejemplo
      _loadMockJobSites();
    } catch (e) {
      print('Error initializing FilterJobSitesController: $e');
    }
  }

  void _loadMockJobSites() {
    // Datos de ejemplo para jobsites
    jobSites.value = [
      JobSiteDto(
        id: '1',
        name: 'Downtown Construction',
        city: 'Downtown',
        address: '123 Main St, Downtown',
        code: 'DC001',
        location: 'Downtown',
        description: 'Construction project in downtown area',
        isSelected: false,
      ),
      JobSiteDto(
        id: '2',
        name: 'Residential Complex',
        city: 'Suburbs',
        address: '456 Oak Ave, Suburbs',
        code: 'RC002',
        location: 'Suburbs',
        description: 'Residential complex development',
        isSelected: false,
      ),
      JobSiteDto(
        id: '3',
        name: 'Office Building Project',
        city: 'City Center',
        address: '789 Business Blvd, City Center',
        code: 'OB003',
        location: 'City Center',
        description: 'Office building construction',
        isSelected: false,
      ),
      JobSiteDto(
        id: '4',
        name: 'Shopping Mall Renovation',
        city: 'Mall District',
        address: '321 Commerce St, Mall District',
        code: 'SM004',
        location: 'Mall District',
        description: 'Shopping mall renovation project',
        isSelected: false,
      ),
      JobSiteDto(
        id: '5',
        name: 'Hospital Extension',
        city: 'Medical District',
        address: '654 Health Ave, Medical District',
        code: 'HE005',
        location: 'Medical District',
        description: 'Hospital extension project',
        isSelected: false,
      ),
    ];
  }

  void loadJobSites() {
    isLoading.value = true;
    errorMessage.value = '';
    
    // Simular carga de datos
    Future.delayed(const Duration(seconds: 1), () {
      try {
        _loadMockJobSites();
        isLoading.value = false;
      } catch (e) {
        errorMessage.value = 'Failed to load job sites';
        isLoading.value = false;
      }
    });
  }

  void toggleJobSiteSelection(String jobSiteId) {
    final jobSiteIndex = jobSites.indexWhere((site) => site.id == jobSiteId);
    if (jobSiteIndex != -1) {
      final jobSite = jobSites[jobSiteIndex];
      final isSelected = jobSite.isSelected;
      
      // Toggle selection
      jobSites[jobSiteIndex] = jobSite.copyWith(isSelected: !isSelected);
      
      // Update selected list
      if (isSelected) {
        selectedJobSites.remove(jobSiteId);
      } else {
        selectedJobSites.add(jobSiteId);
      }
    }
  }

  void handleBackNavigation() {
    Get.back();
  }

  void handleApplyFilter() {
    // Aquí puedes implementar la lógica para aplicar el filtro
    // Por ejemplo, pasar los jobsites seleccionados de vuelta a la pantalla de expenses
    final selectedSites = jobSites.where((site) => site.isSelected == true).toList();
    
    // Convertir JobSiteDto a Map para compatibilidad
    final result = selectedSites.map((site) => {
      'id': site.id,
      'name': site.name,
      'address': site.address,
      'city': site.city,
      'code': site.code,
      'location': site.location,
      'description': site.description,
      'isSelected': site.isSelected,
    }).toList();
    
    // Navegar de vuelta con los resultados
    Get.back(result: result);
  }
}
