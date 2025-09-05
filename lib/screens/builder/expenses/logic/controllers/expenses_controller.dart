import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../../config/app_flavor.dart';

class ExpensesController extends GetxController {
  // ===== CORE DATA =====
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final RxString selectedDateRange = "this_week".obs;
  final RxString selectedJobsite = "".obs;
  final RxString selectedJobsiteDisplayName = "Filter jobsite".obs;
  final RxBool isLoading = false.obs;

  // ===== GETTERS =====
  AppFlavor get flavor => currentFlavor.value;

  @override
  void onInit() {
    super.onInit();
    print('🔄 ExpensesController onInit - Instance: ${this.hashCode}');
    initializeController();
  }

  void initializeController() {
    // Establecer flavor si viene en los argumentos
    try {
      if (Get.arguments != null && Get.arguments['flavor'] != null) {
        currentFlavor.value = Get.arguments['flavor'];
      }
    } catch (e) {
      print('⚠️ Error initializing controller: $e');
      // Mantener el valor por defecto
      currentFlavor.value = AppFlavorConfig.currentFlavor;
    }
  }

  // ===== DATE RANGE SELECTION =====
  void selectDateRange(String range) {
    print('🔍 selectDateRange called with: "$range"');
    selectedDateRange.value = range;
    
    // Aquí puedes agregar lógica para cargar datos según el rango seleccionado
    _loadDataForDateRange(range);
  }

  void _loadDataForDateRange(String range) {
    print('🔍 Loading data for date range: $range');
    // TODO: Implementar carga de datos según el rango de fechas
    // Por ejemplo, hacer llamadas a API para obtener datos del período seleccionado
  }

  // ===== NAVIGATION =====
  void navigateToFilterJobSites() async {
    print('🔍 Navigating to Filter JobSites');
    final result = await Get.toNamed('/builder/expenses/filter-jobsites', arguments: {
      'flavor': currentFlavor.value,
    });
    
    // Procesar el resultado del filtro
    if (result != null && result is List) {
      if (result.isNotEmpty) {
        // Si hay jobsites seleccionados, mostrar el nombre del primero
        final firstJobSite = result.first;
        if (firstJobSite is Map && firstJobSite['name'] != null) {
          selectedJobsiteDisplayName.value = firstJobSite['name'];
        } else {
          selectedJobsiteDisplayName.value = "Jobsite Selected";
        }
      } else {
        // Si no hay selección, volver al texto original
        selectedJobsiteDisplayName.value = "Filter jobsite";
      }
    }
  }

  void navigateToCustomDateRange() async {
    print('🔍 Navigating to Custom Date Range');
    final result = await Get.toNamed('/builder/expenses/custom-date-range', arguments: {
      'flavor': currentFlavor.value,
    });
    
    // Procesar el resultado del rango de fechas
    if (result != null && result is Map) {
      final fromDate = result['fromDateString'] as String?;
      final untilDate = result['untilDateString'] as String?;
      
      if (fromDate != null && untilDate != null) {
        // Actualizar el rango de fechas seleccionado
        selectedDateRange.value = "custom";
        print('📅 Custom date range selected: $fromDate - $untilDate');
        // Aquí puedes agregar lógica adicional para procesar las fechas
      }
    }
  }

  // ===== CHART DATA =====
  List<FlSpot> getChartData() {
    switch (selectedDateRange.value) {
      case "this_week":
        return [
          FlSpot(0, 7), // Domingo
          FlSpot(1, 5), // Lunes
          FlSpot(2, 3), // Martes
          FlSpot(3, 4), // Miércoles
          FlSpot(4, 2), // Jueves
          FlSpot(5, 6), // Viernes
          FlSpot(6, 8), // Sábado
        ];
      case "last_30_days":
        return [
          FlSpot(0, 6), FlSpot(1, 8), FlSpot(2, 5), FlSpot(3, 7), FlSpot(4, 9),
          FlSpot(5, 4), FlSpot(6, 6), FlSpot(7, 8), FlSpot(8, 5), FlSpot(9, 7),
          FlSpot(10, 6), FlSpot(11, 8), FlSpot(12, 5), FlSpot(13, 7), FlSpot(14, 9),
          FlSpot(15, 4), FlSpot(16, 6), FlSpot(17, 8), FlSpot(18, 5), FlSpot(19, 7),
          FlSpot(20, 6), FlSpot(21, 8), FlSpot(22, 5), FlSpot(23, 7), FlSpot(24, 9),
          FlSpot(25, 4), FlSpot(26, 6), FlSpot(27, 8), FlSpot(28, 5), FlSpot(29, 7),
        ];
      case "custom":
        return [
          FlSpot(0, 5),
          FlSpot(1, 5),
          FlSpot(2, 5),
          FlSpot(3, 5),
          FlSpot(4, 5),
          FlSpot(5, 5),
          FlSpot(6, 5),
        ];
      default:
        return [
          FlSpot(0, 7),
          FlSpot(1, 5),
          FlSpot(2, 3),
          FlSpot(3, 4),
          FlSpot(4, 2),
          FlSpot(5, 6),
          FlSpot(6, 8),
        ];
    }
  }

  List<String> getChartLabels() {
    switch (selectedDateRange.value) {
      case "this_week":
        return ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
      case "last_30_days":
        return ["1", "5", "10", "15", "20", "25", "30"];
      case "custom":
        return ["Day1", "Day2", "Day3", "Day4", "Day5", "Day6", "Day7"];
      default:
        return ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    }
  }

  // ===== JOBSITE FILTER =====
  void selectJobsite(String jobsite) {
    print('🔍 selectJobsite called with: "$jobsite"');
    selectedJobsite.value = jobsite;
    
    // Aquí puedes agregar lógica para filtrar datos por jobsite
    _filterDataByJobsite(jobsite);
  }

  void _filterDataByJobsite(String jobsite) {
    print('🔍 Filtering data for jobsite: $jobsite');
    // TODO: Implementar filtrado de datos por jobsite
  }

  // ===== DATA LOADING =====
  Future<void> loadExpensesData() async {
    isLoading.value = true;
    
    try {
      // TODO: Implementar carga de datos real desde API
      await Future.delayed(Duration(seconds: 1)); // Simular carga
      
      print('✅ Expenses data loaded successfully');
      
    } catch (e) {
      print('❌ Error loading expenses data: $e');
      Get.snackbar(
        'Error',
        'Failed to load expenses data',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ===== EXPORT FUNCTIONALITY =====
  Future<void> exportData() async {
    print('🔍 Exporting expenses data...');
    
    try {
      // TODO: Implementar exportación de datos
      // Por ejemplo, generar PDF o CSV con los datos de expenses
      
      Get.snackbar(
        'Success',
        'Data exported successfully',
        backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
      
    } catch (e) {
      print('❌ Error exporting data: $e');
      Get.snackbar(
        'Error',
        'Failed to export data',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  // ===== SEARCH FUNCTIONALITY =====
  void searchWorkers(String query) {
    print('🔍 Searching workers with query: "$query"');
    // TODO: Implementar búsqueda de trabajadores
  }

  // ===== NAVIGATION =====
  void navigateBack() {
    Get.back();
  }

  void navigateToWorkerDetails(String workerId) {
    print('🔍 Navigating to worker details: $workerId');
    // TODO: Implementar navegación a detalles del trabajador
  }

  void navigateToJobsiteDetails(String jobsiteId) {
    print('🔍 Navigating to jobsite details: $jobsiteId');
    // TODO: Implementar navegación a detalles del jobsite
  }

  // ===== UTILITY METHODS =====
  String formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  String formatHours(double hours) {
    return '${hours.toStringAsFixed(0)}h';
  }

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  @override
  void onClose() {
    print('🧹 ExpensesController disposed - Instance: ${this.hashCode}');
    super.onClose();
  }
}
