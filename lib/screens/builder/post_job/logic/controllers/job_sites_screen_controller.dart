import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../logic/controllers/job_site_controller.dart';

class JobSitesScreenController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final JobSiteController jobSiteController = Get.find<JobSiteController>();

  @override
  void onInit() {
    super.onInit();
    // El JobSiteController ya se inicializa en el binding
  }

  void handleBackNavigation() {
    Get.back();
  }

  void handleCreateJobSite() {
    Get.toNamed('/builder/create-edit-job-site', arguments: {'flavor': currentFlavor.value});
  }

  void handleEditJobSite(dynamic jobSite) {
    Get.toNamed('/builder/create-edit-job-site', arguments: {
      'flavor': currentFlavor.value,
      'jobSite': jobSite,
    });
  }

  void handleRequestWorkers() {
    // Navegar al stepper de post job con los jobsites seleccionados
    Get.toNamed('/builder/post-job', arguments: {
      'flavor': currentFlavor.value,
      'selectedJobSites': jobSiteController.selectedJobSites.toList(),
    });
  }

  void showMoreOptions() {
    // TODO: Mostrar opciones adicionales
    print('More options pressed');
    Get.snackbar(
      'Info',
      'More options feature not implemented yet',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }
}
