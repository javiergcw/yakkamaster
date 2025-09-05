import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../config/app_flavor.dart';
import '../../presentation/pages/license_screen.dart';

class ProfilePhotoController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final Rx<File?> profileImage = Rx<File?>(null);
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  @override
  void onInit() {
    super.onInit();
    // Si se pasa un flavor específico, usarlo
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
  }

  void showPhotoOptions() {
    // Esta función se puede usar para mostrar un modal de opciones
    // Por ahora, directamente abrimos la galería
    pickImage(ImageSource.gallery);
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      // Verificar permisos
      if (source == ImageSource.camera) {
        final cameraStatus = await Permission.camera.request();
        if (!cameraStatus.isGranted) {
          Get.snackbar(
            'Permisos requeridos',
            'Se necesita acceso a la cámara para tomar fotos',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      } else {
        final photosStatus = await Permission.photos.request();
        if (!photosStatus.isGranted) {
          Get.snackbar(
            'Permisos requeridos',
            'Se necesita acceso a las fotos para seleccionar una imagen',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      }

      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        profileImage.value = File(image.path);
      }
    } catch (e) {
      // Manejar errores de manera más elegante
      String errorMessage = 'Error al seleccionar imagen';
      
      if (e.toString().contains('camera')) {
        errorMessage = 'Error al acceder a la cámara';
      } else if (e.toString().contains('gallery')) {
        errorMessage = 'Error al acceder a la galería';
      }
      
      // Mostrar diálogo de error más informativo
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                // Si es error de cámara, sugerir usar galería
                if (source == ImageSource.camera && 
                    (e.toString().contains('channel-error') || 
                     e.toString().contains('camera') ||
                     e.toString().contains('pigeon'))) {
                  pickImage(ImageSource.gallery);
                }
              },
              child: const Text('Intentar con galería'),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      );
      
      // Log del error para debugging
      print('Error al seleccionar imagen: $e');
    }
  }

  void handleContinue() {
    // Navegar a la pantalla de licencias
    Get.toNamed(LicenseScreen.id, arguments: {'flavor': currentFlavor.value});
  }
}
