import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../logic/controllers/post_job_controller.dart';

class PostJobReviewScreenController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final PostJobController postJobController = Get.find<PostJobController>();
  
  final RxBool isPublic = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Inicializar el estado público/privado
    isPublic.value = postJobController.postJobData.isPublic ?? true;
    
    // Establecer flavor si se proporciona en los argumentos
    final arguments = Get.arguments;
    if (arguments != null && arguments['flavor'] != null) {
      currentFlavor.value = arguments['flavor'];
    }
  }

  void handleBackNavigation() {
    Get.back();
  }

  void handleEdit() {
    // TODO: Implementar navegación de vuelta al primer paso para editar
    Get.back();
  }

  void handleConfirm() {
    // TODO: Implementar lógica de confirmación y publicación
    postJobController.postJob();
    
    // Mostrar mensaje de éxito
    Get.snackbar(
      'Success',
      'Job posted successfully!',
      backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
    
    // Navegar de vuelta a la pantalla principal
    Get.offAllNamed('/');
  }

  void updateIsPublic(bool value) {
    isPublic.value = value;
    postJobController.updateIsPublic(value);
  }

  String formatDateRange() {
    final startDate = postJobController.postJobData.startDate;
    final endDate = postJobController.postJobData.endDate;
    
    if (startDate == null) return "Not set";
    
    final startFormatted = "${startDate.day.toString().padLeft(2, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.year}";
    
    if (endDate == null || postJobController.postJobData.isOngoingWork == true) {
      return "$startFormatted - Ongoing";
    }
    
    final endFormatted = "${endDate.day.toString().padLeft(2, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.year}";
    return "$startFormatted - $endFormatted";
  }

  String formatTimeRange() {
    final startTime = postJobController.postJobData.startTime;
    final endTime = postJobController.postJobData.endTime;
    
    if (startTime == null || endTime == null) return "Not set";
    
    final startFormatted = startTime.format(Get.context!);
    final endFormatted = endTime.format(Get.context!);
    
    return "$startFormatted - $endFormatted";
  }

  String formatPaymentFrequency() {
    final frequency = postJobController.postJobData.paymentFrequency;
    
    switch (frequency) {
      case "weekly":
        return "Weekly payment";
      case "fortnightly":
        return "Fortnightly payment";
      case "choose_pay_day":
        final payDay = postJobController.postJobData.payDay;
        if (payDay != null) {
          return "Specific date: ${payDay.day.toString().padLeft(2, '0')}-${payDay.month.toString().padLeft(2, '0')}-${payDay.year}";
        }
        return "Choose pay day";
      default:
        return "Not set";
    }
  }
}
