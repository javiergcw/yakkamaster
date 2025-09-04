import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../app/routes/app_pages.dart';
import '../../../home/presentation/pages/home_screen.dart';
import '../../../../job_listings/presentation/pages/job_listings_screen.dart';

class ProfileCreatedController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
  }

  void handleExploreYakka() {
    // Navegar a la pantalla home de YAKKA usando GetX
    Get.offAllNamed(HomeScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void handleApplyForJob() {
    // Navegar a la pantalla de job listings
    Get.toNamed(JobListingsScreen.id, arguments: {'flavor': currentFlavor.value});
  }
}
