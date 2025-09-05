import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../../config/app_flavor.dart';
import '../../presentation/pages/license_screen.dart';

class DocumentsController extends GetxController {
  // Variables reactivas
  final RxString? selectedCredential = RxString('');
  final RxList<String> credentials = <String>[
    'Driver License',
    'Forklift License',
    'White Card',
    'First Aid Certificate',
    'Working at Heights',
    'Confined Spaces',
    'Other'
  ].obs;

  final RxList<Map<String, dynamic>> documents = <Map<String, dynamic>>[
    {'type': 'Resume', 'file': null, 'uploaded': false, 'path': null, 'size': null},
    {'type': 'Cover letter', 'file': null, 'uploaded': false, 'path': null, 'size': null},
    {'type': 'Police check', 'file': null, 'uploaded': false, 'path': null, 'size': null},
    {'type': 'Other', 'file': null, 'uploaded': false, 'path': null, 'size': null},
  ].obs;
  
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
                'Select Credential',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: credentials.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      credentials[index],
                      style: TextStyle(
                        fontSize: itemFontSize,
                        color: Colors.black87,
                      ),
                    ),
                    onTap: () {
                      selectedCredential?.value = credentials[index];
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

  void addLicense() {
    // No mostrar toast, solo no hacer nada si no hay credencial seleccionada
  }

  Future<void> uploadDocument(int index) async {
    try {
      // Abrir selector de archivos
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        
        documents[index]['uploaded'] = true;
        documents[index]['file'] = file.name;
        documents[index]['path'] = file.path;
        documents[index]['size'] = file.size;

        // Archivo subido exitosamente
      } else {
        // Usuario canceló la selección
      }
    } catch (e) {
      // Error al seleccionar archivo
    }
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  void handleContinue() {
    // Navegar a la pantalla de License
    Get.toNamed(LicenseScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void handleSkip() {
    // Navegar a la pantalla de License
    Get.toNamed(LicenseScreen.id, arguments: {'flavor': currentFlavor.value});
  }
}
