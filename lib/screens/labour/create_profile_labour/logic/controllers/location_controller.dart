import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../presentation/pages/profile_photo_screen.dart';

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
    // Navegar a la pantalla de foto de perfil
    Get.toNamed(ProfilePhotoScreen.id, arguments: {'flavor': currentFlavor.value});
  }
}
