import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_flavor.dart';
import '../../logic/job_listings_controller.dart';

class JobListingsScreenController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final JobListingsController jobListingsController = JobListingsController();
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Establecer flavor si se proporciona en los argumentos
    final arguments = Get.arguments;
    if (arguments != null && arguments['flavor'] != null) {
      currentFlavor.value = arguments['flavor'];
    }
    
    // Configurar callbacks del controlador
    jobListingsController.onJobsChanged = () => update();
    jobListingsController.onSearchChanged = () => update();
    jobListingsController.onLoadingChanged = () => update();
    jobListingsController.onCountdownChanged = () => update();
    
    // Inicializar el controlador
    jobListingsController.initialize();
  }

  @override
  void onClose() {
    jobListingsController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void handleBackNavigation() {
    Get.offAllNamed('/labour/home');
  }

  void updateSearchQuery(String query) {
    jobListingsController.updateSearchQuery(query);
  }

  void handleSearch() {
    // TODO: Implement search functionality
    print('Search pressed');
  }

  void shareJob(dynamic job) {
    jobListingsController.shareJob(job);
  }

  void showMoreDetails(dynamic job) {
    jobListingsController.showMoreDetails(job);
  }
}
