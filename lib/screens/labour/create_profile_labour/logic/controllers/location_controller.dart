import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../app/routes/app_pages.dart';
import '../../presentation/pages/previous_employer_screen.dart';

class LocationController extends GetxController {
  // Controllers para los campos de texto
  final TextEditingController addressController = TextEditingController();
  final TextEditingController suburbController = TextEditingController();
  
  // Variables reactivas para las opciones
  final RxBool willingToRelocate = true.obs;
  final RxBool hasCar = true.obs;
  
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  @override
  void onInit() {
    super.onInit();
    // Si se pasa un flavor específico, usarlo
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
  }

  @override
  void onClose() {
    addressController.dispose();
    suburbController.dispose();
    super.onClose();
  }

  void handleContinue() {
    // Navegar al siguiente paso del stepper
    Get.toNamed(PreviousEmployerScreen.id, arguments: {'flavor': currentFlavor.value});
  }
}
