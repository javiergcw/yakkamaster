import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/constants.dart';

class ProfileScreenController extends GetxController {
  final RxInt selectedIndex = 3.obs; // Profile tab selected
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
  }

  void handleHelp() async {
    // Crear URL de WhatsApp usando las constantes generales
    final String whatsappUrl = 'https://wa.me/${AppConstants.whatsappSupportNumber}?text=${Uri.encodeComponent(AppConstants.whatsappSupportMessage)}';

    try {
      // Intentar abrir WhatsApp
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(
          Uri.parse(whatsappUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Si no se puede abrir WhatsApp, mostrar mensaje
        Get.snackbar(
          'Error',
          'No se pudo abrir WhatsApp. Asegúrate de tener la aplicación instalada.',
          backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Manejar errores
      Get.snackbar(
        'Error',
        'Error al abrir WhatsApp: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void handleTermsAndConditions() async {
    try {
      print('Intentando abrir URL: ${AppConstants.termsAndConditionsUrl}');
      
      // Intentar abrir la URL directamente
      final bool launched = await launchUrl(
        Uri.parse(AppConstants.termsAndConditionsUrl),
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched) {
        Get.snackbar(
          'Error',
          'No se pudo abrir los términos y condiciones.',
          backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error al abrir términos y condiciones: $e');
      Get.snackbar(
        'Error',
        'Error al abrir términos y condiciones: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void handleDeleteAccount() async {
    try {
      print('Intentando abrir URL de eliminación de cuenta: ${AppConstants.deleteAccountUrl}');
      
      // Intentar abrir la URL directamente
      final bool launched = await launchUrl(
        Uri.parse(AppConstants.deleteAccountUrl),
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched) {
        Get.snackbar(
          'Error',
          'No se pudo abrir el formulario de eliminación de cuenta.',
          backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error al abrir formulario de eliminación de cuenta: $e');
      Get.snackbar(
        'Error',
        'Error al abrir formulario de eliminación de cuenta: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void onItemTapped(int index) {
    selectedIndex.value = index;

    if (index == 0) {
      // Home
      Get.offAllNamed('/builder/home', arguments: {'flavor': currentFlavor.value});
    } else if (index == 1) {
      // Map
      Get.offAllNamed('/builder/map', arguments: {'flavor': currentFlavor.value});
    } else if (index == 2) {
      // Messages
      Get.offAllNamed('/builder/messages', arguments: {'flavor': currentFlavor.value});
    }
    // Profile (index == 3) - already on this screen
  }

  void navigateToEditPersonalDetails() {
    Get.toNamed('/builder/edit-personal-details', arguments: {'flavor': currentFlavor.value});
  }
}
