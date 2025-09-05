import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_flavor.dart';
import '../../presentation/widgets/account_created_modal.dart';

class EmailLoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  final RxBool isLoading = false.obs;
  final RxBool isLogin = true.obs;
  final RxBool rememberMe = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;
  final RxBool agreeToTerms = false.obs;
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
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void handleTabChanged(bool isLoginValue) {
    isLogin.value = isLoginValue;
    // Limpiar campos cuando se cambia de pestaña
    if (isLoginValue) {
      confirmPasswordController.clear();
      agreeToTerms.value = false;
    }
  }

  void handleLogin() {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      // Simular proceso de login
      Future.delayed(const Duration(seconds: 2), () {
        isLoading.value = false;
        Get.offAllNamed('/stepper-selection', arguments: {'flavor': currentFlavor.value});
      });
    }
  }

  void handleForgotPassword() {
    Get.snackbar(
      'Coming Soon',
      'Forgot password coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void handleRegister() {
    if (formKey.currentState!.validate()) {
      // Validar que el usuario haya aceptado los términos y condiciones
      if (!agreeToTerms.value) {
        Get.snackbar(
          'Error',
          'Please agree to Terms of Services & Privacy Policy',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        return;
      }

      isLoading.value = true;

      // Simular proceso de registro
      Future.delayed(const Duration(seconds: 2), () {
        isLoading.value = false;
        _showAccountCreatedModal();
      });
    }
  }

  void _showAccountCreatedModal() {
    AccountCreatedModal.show(
      context: Get.context!,
      flavor: currentFlavor.value,
      onStartPressed: () {
        Get.back(); // Cerrar el modal
        Get.offAllNamed('/stepper-selection', arguments: {'flavor': currentFlavor.value});
      },
      onClosePressed: () {
        Get.back(); // Solo cerrar el modal, no navegar
      },
    );
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  void toggleAgreeToTerms(bool? value) {
    agreeToTerms.value = value ?? false;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String getButtonText() {
    return isLogin.value ? 'Login' : 'Register';
  }

  String getFooterText() {
    return isLogin.value ? "Don't have an account? " : "Have any account? ";
  }

  String getFooterLinkText() {
    return isLogin.value ? 'Register' : 'Login';
  }

  void toggleMode() {
    handleTabChanged(!isLogin.value);
  }
}
