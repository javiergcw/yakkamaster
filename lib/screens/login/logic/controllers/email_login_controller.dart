import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_flavor.dart';
import '../../../../features/logic/auth/use_case/auth_use_case.dart';
import '../../../../utils/storage/auth_storage.dart';
import '../../presentation/widgets/account_created_modal.dart';
import '../../../labour/home/presentation/pages/home_screen.dart';
import '../../../builder/home/presentation/pages/builder_home_screen.dart';
import '../../presentation/pages/stepper_selection_screen.dart';

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
  
  // Instancia del AuthUseCase
  final AuthUseCase _authUseCase = AuthUseCase();
  
  // Instancia del AuthStorage para guardar tokens
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

  void handleLogin() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      try {
        // Llamar al AuthUseCase para realizar el login
        final result = await _authUseCase.login(
          emailController.text.trim(),
          passwordController.text,
        );

        if (result.isSuccess) {
          // Guardar tokens en el almacenamiento local
          await _authStorage.setBearerToken(result.data!.accessToken);
          await _authStorage.setRefreshToken(result.data!.refreshToken);
          
          // Mostrar mensaje de éxito
          Get.snackbar(
            'Success',
            'Login successful',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
          
          // Verificar si el usuario ya tiene perfiles creados
          final profiles = result.data!.profiles;
          if (profiles.hasAnyProfile == true) {
            // Usuario ya tiene perfiles, redirigir al home correspondiente
            if (profiles.hasLabourProfile == true) {
              // Redirigir al home de labour
              Get.offAllNamed(HomeScreen.id, arguments: {'flavor': currentFlavor.value});
            } else if (profiles.hasBuilderProfile == true) {
              // Redirigir al home de builder
              Get.offAllNamed(BuilderHomeScreen.id, arguments: {'flavor': currentFlavor.value});
            } else {
              // Fallback al stepper selection
              Get.offAllNamed(StepperSelectionScreen.id, arguments: {'flavor': currentFlavor.value});
            }
          } else {
            // Usuario no tiene perfiles, ir al stepper selection
            Get.offAllNamed(StepperSelectionScreen.id, arguments: {'flavor': currentFlavor.value});
          }
        } else {
          // Mostrar mensaje de error
          Get.snackbar(
            'Error',
            result.message ?? 'Login failed',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      } catch (e) {
        // Manejar errores inesperados
        Get.snackbar(
          'Error',
          'Unexpected error during login',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  void handleForgotPassword() {
    Get.snackbar(
      'Information',
      'Password recovery functionality coming soon',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void handleRegister() async {
    if (formKey.currentState!.validate()) {
      // Validar que el usuario haya aceptado los términos y condiciones
      if (!agreeToTerms.value) {
        Get.snackbar(
          'Warning',
          'You must accept the terms and conditions',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        return;
      }

      isLoading.value = true;

      try {
        // Llamar al AuthUseCase para realizar el registro
        final result = await _authUseCase.register(
          emailController.text.trim(),
          passwordController.text,
          autoVerify: true, // Auto-verificar el usuario
        );

        if (result.isSuccess) {
          // Mostrar mensaje de éxito
          Get.snackbar(
            'Success',
            'Account created successfully',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
          
          // Mostrar modal de cuenta creada
          _showAccountCreatedModal();
        } else {
          // Mostrar mensaje de error
          Get.snackbar(
            'Error',
            result.message ?? 'Failed to create account',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      } catch (e) {
        // Manejar errores inesperados
        Get.snackbar(
          'Error',
          'Unexpected error while creating account',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  void _showAccountCreatedModal() {
    AccountCreatedModal.show(
      context: Get.context!,
      flavor: currentFlavor.value,
      onStartPressed: () async {
        Get.back(); // Cerrar el modal
        
        // Hacer login automático con las credenciales registradas
        await _autoLoginAfterRegistration();
      },
      onClosePressed: () {
        Get.back(); // Solo cerrar el modal, no navegar
      },
    );
  }
  
  /// Realiza login automático después del registro
  Future<void> _autoLoginAfterRegistration() async {
    try {
      isLoading.value = true;
      
      // Usar las credenciales del formulario actual
      final result = await _authUseCase.login(
        emailController.text.trim(),
        passwordController.text,
      );

      if (result.isSuccess) {
        // Guardar tokens en el almacenamiento local
        await _authStorage.setBearerToken(result.data!.accessToken);
        await _authStorage.setRefreshToken(result.data!.refreshToken);
        
        // Verificar si el usuario ya tiene perfiles creados
        final profiles = result.data!.profiles;
        if (profiles.hasAnyProfile == true) {
          // Usuario ya tiene perfiles, redirigir al home correspondiente
          if (profiles.hasLabourProfile == true) {
            // Redirigir al home de labour
            Get.offAllNamed(HomeScreen.id, arguments: {'flavor': currentFlavor.value});
          } else if (profiles.hasBuilderProfile == true) {
            // Redirigir al home de builder
            Get.offAllNamed(BuilderHomeScreen.id, arguments: {'flavor': currentFlavor.value});
          } else {
            // Fallback al stepper selection
            Get.offAllNamed(StepperSelectionScreen.id, arguments: {'flavor': currentFlavor.value});
          }
        } else {
          // Usuario no tiene perfiles, ir al stepper selection
          Get.offAllNamed(StepperSelectionScreen.id, arguments: {'flavor': currentFlavor.value});
        }
      } else {
        // Si el login automático falla, ir al stepper selection
        Get.snackbar(
          'Info',
          'Please log in manually',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        Get.offAllNamed(StepperSelectionScreen.id, arguments: {'flavor': currentFlavor.value});
      }
    } catch (e) {
      // Si hay error, ir al stepper selection
      Get.snackbar(
        'Info',
        'Please log in manually',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      Get.offAllNamed(StepperSelectionScreen.id, arguments: {'flavor': currentFlavor.value});
    } finally {
      isLoading.value = false;
    }
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
