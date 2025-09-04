import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_flavor.dart';
import '../../../../app/routes/app_pages.dart';

class StepperSelectionController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  @override
  void onInit() {
    super.onInit();
    // Si se pasa un flavor específico, usarlo
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
  }

  void handleWorkSelection() {
    // Navegar al siguiente paso del stepper para WORK
    Get.toNamed('/industry-selection', arguments: {'flavor': currentFlavor.value});
  }

  void handleHireSelection() {
    // Navegar al flujo de crear perfil para BUILDERS (empleadores)
    Get.toNamed('/create-profile-builder', arguments: {'flavor': currentFlavor.value});
  }

  void handleGetHelp() {
    // Mostrar ayuda
    Get.snackbar(
      'Coming Soon',
      'Help section coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}
