import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_flavor.dart';
import '../../data/dto/job_details_dto.dart';

class JobDetailsScreenController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final RxBool hasApplied = false.obs;
  final RxBool showSuccessModal = false.obs;
  final Rx<JobDetailsDto?> jobDetails = Rx<JobDetailsDto?>(null);
  final RxBool isFromAppliedJobs = false.obs;
  final RxBool isFromBuilder = false.obs;

  // Variable para activar/desactivar la verificación bancaria
  static const bool enableBankVerification = false; // Cambiar a false para desactivar

  @override
  void onInit() {
    super.onInit();
    // Establecer datos desde argumentos
    final arguments = Get.arguments;
    if (arguments != null) {
      if (arguments['jobDetails'] != null) {
        jobDetails.value = arguments['jobDetails'];
      }
      if (arguments['flavor'] != null) {
        currentFlavor.value = arguments['flavor'];
      }
      if (arguments['isFromAppliedJobs'] != null) {
        isFromAppliedJobs.value = arguments['isFromAppliedJobs'];
        // Si viene de trabajos aplicados, marcar como ya aplicado
        hasApplied.value = arguments['isFromAppliedJobs'];
      }
      if (arguments['isFromBuilder'] != null) {
        isFromBuilder.value = arguments['isFromBuilder'];
      }
    }
  }

  // Función para verificar si el usuario tiene datos bancarios configurados
  bool hasBankDetails() {
    // TODO: Implementar verificación real de datos bancarios
    // Por ahora, simulamos que no tiene datos bancarios para probar el flujo
    return false; // Cambiar a true cuando tenga datos bancarios reales
  }

  void handleBackNavigation() {
    Get.back();
  }

  void handleApply() {
    // Verificar si el usuario tiene datos bancarios configurados (solo si está habilitado)
    if (enableBankVerification && !hasBankDetails()) {
      // Mostrar diálogo para configurar datos bancarios
      showBankDetailsDialog();
      return;
    }
    
    // Si tiene datos bancarios o la verificación está deshabilitada, proceder con la aplicación
    hasApplied.value = true;
    showSuccessModal.value = true;
    print('Apply for job: ${jobDetails.value?.title}');
  }

  void showBankDetailsDialog() {
    final double screenWidth = Get.width;
    final double screenHeight = Get.height;
    
    // Calcular tamaños responsive
    final dialogWidth = screenWidth * 0.85;
    final titleFontSize = screenWidth * 0.045;
    final bodyFontSize = screenWidth * 0.035;
    final buttonFontSize = screenWidth * 0.035;
    
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: dialogWidth,
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.4,
          ),
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icono y título
              Container(
                width: screenWidth * 0.12,
                height: screenWidth * 0.12,
                decoration: BoxDecoration(
                  color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.account_balance,
                  color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                  size: screenWidth * 0.06,
                ),
              ),
              
              SizedBox(height: screenHeight * 0.02),
              
              // Título
              Text(
                'Bank Details Required',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              
              SizedBox(height: screenHeight * 0.015),
              
              // Mensaje
              Text(
                'You need to configure your bank details before applying for this job. This ensures you can receive payments.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: bodyFontSize,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              
              SizedBox(height: screenHeight * 0.025),
              
              // Botones
              Row(
                children: [
                  // Botón Cancel
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: Colors.grey[400]!,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(width: screenWidth * 0.03),
                  
                  // Botón Configure Now
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.toNamed('/labour/edit-bank-details');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                        foregroundColor: Colors.black87,
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Configure Now',
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void handleCloseModal() {
    showSuccessModal.value = false;
  }

  void handleViewAppliedJobs() {
    // TODO: Navegar a la pantalla de trabajos aplicados
    print('Navigate to applied jobs');
    handleCloseModal();
    Get.toNamed('/labour/applied-jobs');
  }

  void handleReportJob() {
    // TODO: Implementar lógica de reporte
    print('Report job: ${jobDetails.value?.title}');
  }
}
