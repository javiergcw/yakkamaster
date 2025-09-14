import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../config/app_flavor.dart';
import '../../presentation/pages/job_search_results_screen.dart';
import '../../../../app/bindings/job_listings_binding.dart';

class JobSearchScreenController extends GetxController {
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
    // Navegar a la pantalla de resultados de búsqueda
    print('=== performSearch called ===');
    print('Controller hash: ${hashCode}');
    print('whatQuery: "${whatQuery.value}"');
    print('whereQuery: "${whereQuery.value}"');
    print('Navigating to: /job-search-results');
    
    try {
      // Verificar que la ruta existe
      print('Current route: ${Get.currentRoute}');
      print('Available routes: ${Get.routing.route}');
      
      // Navegación directa con binding
      Get.to(
        () => JobSearchResultsScreen(
          flavor: currentFlavor.value,
          whatQuery: whatQuery.value,
          whereQuery: whereQuery.value,
        ),
        binding: JobListingsBinding(),
        arguments: {
          'flavor': currentFlavor.value,
          'whatQuery': whatQuery.value,
          'whereQuery': whereQuery.value,
        },
      );
      print('Navigation call completed successfully');
    } catch (e) {
      print('Navigation error: $e');
      // Mostrar error al usuario
      Get.snackbar(
        'Error de navegación',
        'No se pudo navegar a la pantalla de resultados: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    
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
