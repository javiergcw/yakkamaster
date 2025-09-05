import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';

class EditBankDetailsController extends GetxController {
  // Controllers para los campos de texto
  final TextEditingController abnController = TextEditingController(text: '12345678901');
  final TextEditingController payIdController = TextEditingController(text: 'test@example.com');
  
  // Variables observables para el estado
  final RxString selectedPayIdType = 'EMAIL'.obs;
  final RxBool dontHavePayId = false.obs; // Cambiar a false para que el campo Pay ID esté habilitado por defecto
  
  // Variable para activar/desactivar el comportamiento de verificación
  static const bool enableBankVerification = true; // Cambiar a false para desactivar
  
  final List<String> payIdTypes = [
    'EMAIL',
    'PHONE',
    'ABN',
    'ORGANISATION_ID'
  ];

  @override
  void onInit() {
    super.onInit();
    
    // Agregar listeners para actualizar el estado en tiempo real
    abnController.addListener(() {
      update();
    });
    
    payIdController.addListener(() {
      update();
    });
  }

  void showPayIdTypeDropdown() {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final titleFontSize = screenWidth * 0.045;
    final itemFontSize = screenWidth * 0.035;

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Text(
                'Select Pay ID Type',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: payIdTypes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      payIdTypes[index],
                      style: GoogleFonts.poppins(
                        fontSize: itemFontSize,
                        color: Colors.black87,
                      ),
                    ),
                    onTap: () {
                      selectedPayIdType.value = payIdTypes[index];
                      Get.back();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  // Función para verificar si el usuario tiene datos bancarios configurados
  bool hasBankDetails() {
    return abnController.text.isNotEmpty && 
           (!dontHavePayId.value ? payIdController.text.isNotEmpty : true);
  }

  void handleSave(AppFlavor? flavor) {
    final currentFlavor = flavor ?? AppFlavorConfig.currentFlavor;
    
    // Validar campos requeridos
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
    
    if (!dontHavePayId.value && payIdController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your Pay ID',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    // Verificar si el usuario no tiene Pay ID y la verificación está habilitada
    if (dontHavePayId.value && enableBankVerification) {
      // Navegar a la pantalla de detalles bancarios tradicionales
      Get.toNamed('/edit-bank-details-no-payid', arguments: {'flavor': currentFlavor});
      return;
    }
    
    // Mostrar mensaje de éxito
    Get.snackbar(
      'Success',
      'Bank details updated successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor)),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
    
    // Navegar de vuelta
    Get.back();
  }

  void toggleDontHavePayId() {
    dontHavePayId.value = !dontHavePayId.value;
    if (dontHavePayId.value) {
      payIdController.clear();
    }
  }

  @override
  void onClose() {
    abnController.removeListener(() {});
    payIdController.removeListener(() {});
    abnController.dispose();
    payIdController.dispose();
    super.onClose();
  }
}