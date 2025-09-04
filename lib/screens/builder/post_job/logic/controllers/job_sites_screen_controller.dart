import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../logic/controllers/job_site_controller.dart';
import '../../presentation/pages/create_edit_job_site_screen.dart';
import '../../presentation/pages/post_job_stepper_screen.dart';

class JobSitesScreenController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final JobSiteController jobSiteController = Get.put(JobSiteController());

  @override
  void onInit() {
    super.onInit();
    // El JobSiteController ya se inicializa en el binding
  }

  void handleBackNavigation() {
    Get.back();
  }

  void handleCreateJobSite() {
    Get.toNamed(CreateEditJobSiteScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void handleEditJobSite(dynamic jobSite) {
    Get.toNamed(CreateEditJobSiteScreen.id, arguments: {
      'flavor': currentFlavor.value,
      'jobSite': jobSite,
    });
  }

  void handleRequestWorkers() {
    // Navegar al stepper de post job con los jobsites seleccionados
    Get.toNamed(PostJobStepperScreen.id, arguments: {
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
