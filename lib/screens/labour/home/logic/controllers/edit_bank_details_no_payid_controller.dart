import 'package:get/get.dart';
import 'package:flutter/material.dart';

class EditBankDetailsNoPayIdController extends GetxController {
  // Controllers para los campos de texto
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController bsbController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController abnController = TextEditingController();
  
  // Variables observables para el estado
  final RxBool isLoading = false.obs;

  void handleSave() {
    // Validar campos requeridos
    if (accountNameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your account name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    if (bsbController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your BSB',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    if (accountNumberController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your account number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    if (abnController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your ABN',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    // Validar formato BSB (6 dígitos)
    if (bsbController.text.length != 6 || !RegExp(r'^\d{6}$').hasMatch(bsbController.text)) {
      Get.snackbar(
        'Error',
        'BSB must be 6 digits',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    // Validar formato número de cuenta (mínimo 6 dígitos)
    if (accountNumberController.text.length < 6 || !RegExp(r'^\d+$').hasMatch(accountNumberController.text)) {
      Get.snackbar(
        'Error',
        'Account number must be at least 6 digits',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    isLoading.value = true;
    
    // Simular guardado
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      
      // Mostrar mensaje de éxito
      Get.snackbar(
        'Success',
        'Bank details updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      
      // Navegar de vuelta
      Get.back();
    });
  }

  @override
  void onClose() {
    accountNameController.dispose();
    bsbController.dispose();
    accountNumberController.dispose();
    abnController.dispose();
    super.onClose();
  }
}
