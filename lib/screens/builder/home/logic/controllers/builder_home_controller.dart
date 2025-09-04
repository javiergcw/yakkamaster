import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../applicants/logic/controllers/applicant_controller.dart';

class BuilderHomeController extends GetxController {
  final RxInt selectedIndex = 0.obs; // Home tab selected
  final RxBool isSidebarOpen = false.obs; // Control del sidebar
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  @override
  void onInit() {
    super.onInit();
    // Inicializar el controlador de applicants para el punto rojo
    Get.put(ApplicantController());
    // Asegurar que Home esté seleccionado cuando se navega desde Map
    selectedIndex.value = 0;
  }

  void toggleSidebar() {
    isSidebarOpen.value = !isSidebarOpen.value;
  }

  void closeSidebar() {
    isSidebarOpen.value = false;
  }

  void selectTab(int index) {
    selectedIndex.value = index;
    
    // Navigate to different screens based on index
    if (index == 1) { // Map
      Get.toNamed('/builder/map', arguments: {'flavor': currentFlavor.value});
    } else if (index == 2) { // Messages
      Get.toNamed('/builder/messages', arguments: {'flavor': currentFlavor.value});
    } else if (index == 3) { // Profile
      Get.toNamed('/builder/profile', arguments: {'flavor': currentFlavor.value});
    }
  }

  void navigateToJobSites() {
    Get.toNamed('/builder/job-sites-select', arguments: {'flavor': currentFlavor.value});
  }

  void navigateToMyJobs() {
    Get.toNamed('/builder/my-jobs', arguments: {'flavor': currentFlavor.value});
  }

  void navigateToApplicants() {
    Get.toNamed('/builder/applicants', arguments: {'flavor': currentFlavor.value});
  }

  void navigateToStaff() {
    Get.toNamed('/builder/staff', arguments: {'flavor': currentFlavor.value});
  }

  void navigateToJobSitesList() {
    Get.toNamed('/builder/job-sites', arguments: {'flavor': currentFlavor.value});
  }

  void navigateToInvoices() {
    Get.toNamed('/builder/invoices', arguments: {'flavor': currentFlavor.value});
  }

  void navigateToNotifications() {
    Get.toNamed('/builder/notifications', arguments: {'flavor': currentFlavor.value});
  }
}
