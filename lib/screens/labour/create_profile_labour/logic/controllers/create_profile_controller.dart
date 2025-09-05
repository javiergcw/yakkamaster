import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../../../../../config/app_flavor.dart';
import '../../presentation/pages/create_profile_step2_screen.dart';

class CreateProfileController extends GetxController {
  // Controllers para los campos de texto
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController(text: '0412345678');
  final TextEditingController emailController = TextEditingController(text: 'testing22@gmail.com');
  final TextEditingController birthCountryController = TextEditingController();
  
  // Variables para la imagen de perfil
  final Rx<File?> profileImage = Rx<File?>(null);
  final ImagePicker picker = ImagePicker();
  
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
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    birthCountryController.dispose();
    super.onClose();
  }

  // Función para mostrar opciones de selección de imagen
  void showImageSourceDialog() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Seleccionar imagen',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Cámara'),
              subtitle: const Text('Tomar una nueva foto'),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text('Galería'),
              subtitle: const Text('Seleccionar de la galería'),
              onTap: () {
                Get.back();
                pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Función para verificar y solicitar permisos
  Future<bool> requestPermissions(ImageSource source) async {
    if (source == ImageSource.camera) {
      // Solicitar permiso de cámara
      PermissionStatus status = await Permission.camera.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        Get.dialog(
          AlertDialog(
            title: const Text('Permiso de Cámara'),
            content: const Text('Esta aplicación necesita acceso a la cámara para tomar fotos. Por favor, concede el permiso en la configuración.'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  openAppSettings();
                },
                child: const Text('Configuración'),
              ),
            ],
          ),
        );
        return false;
      }
      return status.isGranted;
    } else {
      // Para galería, verificar permisos de almacenamiento
      PermissionStatus status = await Permission.photos.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        // Intentar con permisos de almacenamiento como fallback
        status = await Permission.storage.request();
      }
      return status.isGranted;
    }
  }

  // Función para seleccionar imagen
  Future<void> pickImage(ImageSource source) async {
    try {
      // Verificar permisos primero
      bool hasPermission = await requestPermissions(source);
      if (!hasPermission) {
        return;
      }

      // Mostrar indicador de carga
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      // Intentar seleccionar imagen con configuración más simple
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      // Cerrar indicador de carga
      if (Get.isDialogOpen!) {
        Get.back();
      }
      
      if (image != null) {
        profileImage.value = File(image.path);
        
        // Mostrar mensaje de éxito
        Get.snackbar(
          'Éxito',
          'Imagen seleccionada exitosamente',
          backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      // Cerrar indicador de carga si está abierto
      if (Get.isDialogOpen!) {
        Get.back();
      }
      
      // Manejo específico de errores
      String errorMessage = 'Error al seleccionar imagen';
      
      if (e.toString().contains('channel-error')) {
        errorMessage = 'Error de comunicación. Intenta:\n1. Reiniciar la app\n2. Verificar permisos de cámara\n3. Usar galería en lugar de cámara';
      } else if (e.toString().contains('permission')) {
        errorMessage = 'Permisos no concedidos. Ve a:\nConfiguración > Aplicaciones > Yakka Sports > Permisos';
      } else if (e.toString().contains('camera')) {
        errorMessage = 'Error al acceder a la cámara. Intenta usar la galería.';
      } else if (e.toString().contains('pigeon')) {
        errorMessage = 'Error interno del plugin. Intenta:\n1. Reiniciar la app\n2. Usar galería en lugar de cámara';
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

  void handleNext() {
    // Validar campos requeridos
    if (firstNameController.text.isEmpty || lastNameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    
    // Navegar a la siguiente pantalla (step 2)
    Get.toNamed(CreateProfileStep2Screen.id, arguments: {'flavor': currentFlavor.value});
  }

  void handleNextStep2() {
    // Validar campo de email
    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    
    // Validar formato de email
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailController.text)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    
    // Validar campo de teléfono
    if (phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your phone number',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    
    // Navegar a la pantalla de habilidades (step 3)
    Get.toNamed('/skills-experience', arguments: {'flavor': currentFlavor.value});
  }
}
