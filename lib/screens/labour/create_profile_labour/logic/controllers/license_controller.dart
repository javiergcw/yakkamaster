import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../../config/app_flavor.dart';
import '../../presentation/pages/respect_screen.dart';

class LicenseController extends GetxController {
  // Lista de credenciales disponibles
  final List<String> availableCredentials = [
    'Driver License',
    'White Card',
    'First Aid Certificate',
    'Forklift License',
    'Crane License',
    'Excavator License',
    'Other',
  ];

  // Credencial seleccionada
  final Rx<String?> selectedCredential = Rx<String?>(null);

  // Lista de documentos
  final RxList<Map<String, dynamic>> documents = <Map<String, dynamic>>[].obs;

  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  @override
  void onInit() {
    super.onInit();
    // Si se pasa un flavor específico, usarlo
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
  }

  void showCredentialDropdown() {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final modalHeight = screenHeight * 0.6;
    final modalPadding = screenWidth * 0.06;
    final titleFontSize = screenWidth * 0.048;
    final itemFontSize = screenWidth * 0.035;

    Get.bottomSheet(
      Container(
        height: modalHeight,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Header del modal
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: modalPadding,
                vertical: modalPadding * 1.2,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Text(
                'Select Credential',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            
            // Lista de credenciales
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: modalPadding),
                itemCount: availableCredentials.length,
                itemBuilder: (context, index) {
                  final credential = availableCredentials[index];
                  final isSelected = selectedCredential.value == credential;
                  
                  return GestureDetector(
                    onTap: () {
                      selectedCredential.value = credential;
                      Get.back();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)).withOpacity(0.1) : Colors.transparent,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              credential,
                              style: TextStyle(
                                fontSize: itemFontSize,
                                color: isSelected ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)) : Colors.black,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check,
                              color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                              size: itemFontSize * 1.2,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void addLicense() {
    if (selectedCredential.value == null) {
      Get.snackbar(
        'Error',
        'Please select a credential type first',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Agregar el documento a la lista
    documents.add({
      'type': selectedCredential.value!,
      'uploaded': false,
      'file': null,
      'size': null,
    });

    // Limpiar la selección
    selectedCredential.value = null;

    Get.snackbar(
      'Success',
      'License added successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> uploadDocument(int index) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        
        // Actualizar el documento en la lista
        documents[index] = {
          'type': documents[index]['type'],
          'uploaded': true,
          'file': file.name,
          'size': file.size,
        };

        Get.snackbar(
          'Success',
          'Document uploaded successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload document: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  void removeLicense(int index) {
    if (index >= 0 && index < documents.length) {
      documents.removeAt(index);
      Get.snackbar(
        'Success',
        'License removed successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void handleContinue() {
    // Navegar a la pantalla de respeto
    Get.toNamed(RespectScreen.id, arguments: {'flavor': currentFlavor.value});
  }
}
