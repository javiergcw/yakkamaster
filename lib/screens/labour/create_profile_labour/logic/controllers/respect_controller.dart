import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../app/routes/app_pages.dart';
import '../../presentation/pages/lets_be_clear_screen.dart';

class RespectController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
  }

  void handleCommit() {
    // Navegar a la pantalla "Let's Be Clear" después del compromiso
    Get.offAllNamed(LetsBeClearScreen.id, arguments: {'flavor': currentFlavor.value});
  }
}
