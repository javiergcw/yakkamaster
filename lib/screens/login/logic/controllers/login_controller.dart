import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_flavor.dart';
import '../../../../utils/storage/auth_storage.dart';

class LoginController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  final RxBool isLoading = false.obs;
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  
  final AuthStorage _authStorage = AuthStorage();

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
    emailController.dispose();
    super.onClose();
  }

  void handleContinue() {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      // Guardar email si está presente
      final email = emailController.text.trim();
      if (email.isNotEmpty) {
        _saveUserEmail(email);
      }

      // Simular proceso de login
      Future.delayed(const Duration(seconds: 2), () {
        isLoading.value = false;
        Get.offAllNamed('/stepper-selection');
      });
    }
  }

  void handleEmailLogin() {
    // Obtener el email del formulario y guardar en storage
    final email = emailController.text.trim();
    if (email.isNotEmpty) {
      _saveUserEmail(email);
    }
    Get.toNamed('/email-login', arguments: {'flavor': currentFlavor.value});
  }
  
  /// Guarda el email del usuario en storage
  Future<void> _saveUserEmail(String email) async {
    try {
      await _authStorage.setUserEmail(email);
      print('Email guardado: $email');
    } catch (e) {
      print('Error al guardar email: $e');
    }
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
