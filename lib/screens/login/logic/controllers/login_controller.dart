import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_flavor.dart';

class LoginController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  final RxBool isLoading = false.obs;
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
    phoneController.dispose();
    super.onClose();
  }

  void handleContinue() {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      // Simular proceso de login
      Future.delayed(const Duration(seconds: 2), () {
        isLoading.value = false;
        Get.offAllNamed('/stepper-selection');
      });
    }
  }

  void handleEmailLogin() {
    Get.toNamed('/email-login', arguments: {'flavor': currentFlavor.value});
  }

  void handleGoogleLogin() {
    // Implementar login con Google
    Get.snackbar(
      'Coming Soon',
      'Google login coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void handleAppleLogin() {
    // Implementar login con Apple
    Get.snackbar(
      'Coming Soon',
      'Apple login coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (value.length < 9) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String getContinueButtonText() {
    return AppFlavorConfig.getContinueButtonText(currentFlavor.value);
  }
}
