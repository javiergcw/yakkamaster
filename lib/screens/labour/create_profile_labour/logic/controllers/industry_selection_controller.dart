import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../app/routes/app_pages.dart';
import '../../presentation/pages/create_profile_screen.dart';

class IndustrySelectionController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  @override
  void onInit() {
    super.onInit();
    // Si se pasa un flavor específico, usarlo
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
  }

  void handleConstructionSelection() {
    // Navegar a la pantalla de crear perfil
    Get.toNamed(CreateProfileScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void handleHospitalitySelection() {
    // Navegar a la pantalla de crear perfil
    Get.toNamed(CreateProfileScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void handleBothSelection() {
    // Navegar a la pantalla de crear perfil
    Get.toNamed(CreateProfileScreen.id, arguments: {'flavor': currentFlavor.value});
  }
}
