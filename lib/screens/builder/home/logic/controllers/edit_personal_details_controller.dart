import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../../../../../config/app_flavor.dart';
import '../../presentation/pages/builder_home_screen.dart';
import '../../presentation/pages/camera_with_overlay_screen.dart';

class EditPersonalDetailsController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  
  // Controllers para los campos de texto - precargados con datos actuales
  final TextEditingController firstNameController = TextEditingController(text: 'testing');
  final TextEditingController lastNameController = TextEditingController(text: 'builder');
  final TextEditingController companyNameController = TextEditingController(text: 'Test company by Yakka');
  final TextEditingController phoneController = TextEditingController(text: '2222222');
  final TextEditingController emailController = TextEditingController(text: 'testingbuilder@gmail.com');
  
  // Variable reactiva para el nombre de empresa
  final RxString selectedCompanyName = 'Test company by Yakka'.obs;
  
  // Variables para la imagen de perfil
  final Rx<File?> profileImage = Rx<File?>(null);
  final ImagePicker picker = ImagePicker();
  
  // Lista de empresas creadas por el usuario
  final RxList<String> userCreatedCompanies = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    print('EditPersonalDetailsController initialized');
    print('Initial profileImage.value: ${profileImage.value?.path}');
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    companyNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
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
                'Select image',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Camera'),
              subtitle: const Text('Take a new photo'),
              onTap: () {
                Get.back();
                _openCameraWithOverlay();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text('Gallery'),
              subtitle: const Text('Select from gallery'),
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

  // Función para abrir la cámara con overlay
  Future<void> _openCameraWithOverlay() async {
    try {
      // Verificar permisos de cámara
      PermissionStatus status = await Permission.camera.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        Get.dialog(
          AlertDialog(
            title: const Text('Camera Permission'),
            content: const Text('This app needs camera access to take photos. Please grant permission in settings.'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  openAppSettings();
                },
                child: const Text('Settings'),
              ),
            ],
          ),
        );
        return;
      }

      if (!status.isGranted) {
        return;
      }

      // Navegar a la pantalla de cámara con overlay
      final File? capturedImage = await Get.to<File>(
        CameraWithOverlayScreen(
          flavor: currentFlavor.value,
          onImageCaptured: (File image) {
            // Este callback se ejecutará cuando se capture la imagen
            print('Image captured callback executed: ${image.path}');
          },
        ),
      );

      // Si se capturó una imagen, actualizarla
      if (capturedImage != null) {
        print('Image received from camera: ${capturedImage.path}');
        print('Before updating profileImage.value: ${profileImage.value?.path}');
        profileImage.value = capturedImage;
        print('After updating profileImage.value: ${profileImage.value?.path}');
        
        // Mostrar mensaje de éxito
        Get.snackbar(
          'Success',
          'Image updated successfully',
          backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        print('No image captured');
      }
    } catch (e) {
      print('Error opening camera with overlay: $e');
      Get.snackbar(
        'Error',
        'Error opening camera: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Función para verificar y solicitar permisos
  Future<bool> requestPermissions(ImageSource source) async {
    if (source == ImageSource.camera) {
      // Solicitar permiso de cámara
      PermissionStatus status = await Permission.camera.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        Get.dialog(
          AlertDialog(
            title: const Text('Camera Permission'),
            content: const Text('This app needs camera access to take photos. Please grant permission in settings.'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  openAppSettings();
                },
                child: const Text('Settings'),
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
          'Success',
          'Image updated successfully',
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
      String errorMessage = 'Error selecting image';
      
      if (e.toString().contains('channel-error')) {
        errorMessage = 'Communication error. Try:\n1. Restart the app\n2. Check camera permissions\n3. Use gallery instead of camera';
      } else if (e.toString().contains('permission')) {
        errorMessage = 'Permissions not granted. Go to:\nSettings > Apps > Yakka Sports > Permissions';
      } else if (e.toString().contains('camera')) {
        errorMessage = 'Error accessing camera. Try using gallery.';
      } else if (e.toString().contains('pigeon')) {
        errorMessage = 'Plugin internal error. Try:\n1. Restart the app\n2. Use gallery instead of camera';
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
              child: const Text('Try with gallery'),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
      
      // Log del error para debugging
      print('Error al seleccionar imagen: $e');
    }
  }

  void handleSave() {
    print('=== handleSave called ===');
    print('First name: "${firstNameController.text}"');
    print('Last name: "${lastNameController.text}"');
    print('Company name: "${selectedCompanyName.value}"');
    print('Email: "${emailController.text}"');
    
    // Validar campos requeridos
    if (firstNameController.text.isEmpty || 
        lastNameController.text.isEmpty ||
        selectedCompanyName.value.isEmpty ||
        emailController.text.isEmpty) {
      print('Validation failed - missing required fields');
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }
    
    print('Validation passed - saving changes');
    
    // TODO: Aquí se guardarían los cambios en el backend
    // Por ahora solo mostramos un mensaje de éxito y navegamos al home
    Get.snackbar(
      'Success',
      'Personal details updated successfully',
      backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
    
    // Navegar al BuilderHomeScreen
    print('Navigating to BuilderHomeScreen');
    Get.offAllNamed(BuilderHomeScreen.id);
  }

  void navigateBack() {
    Get.back();
  }

  void addUserCompany(String company) {
    print('Adding user company to EditPersonalDetailsController: $company');
    if (!userCreatedCompanies.contains(company)) {
      userCreatedCompanies.add(company);
      print('Company added to list. Total companies: ${userCreatedCompanies.length}');
    } else {
      print('Company already exists in list');
    }
    
    // Actualizar tanto el controller como la variable reactiva
    try {
      companyNameController.text = company;
      selectedCompanyName.value = company;
      print('Updated companyNameController and selectedCompanyName with: $company');
    } catch (e) {
      print('Warning: Could not update companyNameController, it may be disposed: $e');
    }
  }
}
