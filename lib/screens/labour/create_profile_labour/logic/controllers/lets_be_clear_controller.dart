import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../app/routes/app_pages.dart';
import '../../presentation/pages/profile_created_screen.dart';

class LetsBeClearController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
  }

  void handleAccept() {
    // Navegar a la pantalla de perfil creado después de aceptar los términos
    Get.offAllNamed(ProfileCreatedScreen.id, arguments: {'flavor': currentFlavor.value});
  }
}
