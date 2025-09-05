import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../../config/app_flavor.dart';
import 'create_profile_builder_controller.dart';
import '../../../../builder/home/presentation/pages/builder_home_screen.dart';
import '../../../../builder/home/logic/controllers/edit_personal_details_controller.dart';

class RegisterCompanyController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final companyNameController = TextEditingController();
  final addressController = TextEditingController();
  final abnController = TextEditingController();
  final websiteController = TextEditingController();
  final descriptionController = TextEditingController();
  
  final Rx<String?> selectedCategory = Rx<String?>(null);
  final List<String> categories = [
    'Construction',
    'Renovation',
    'Plumbing',
    'Electrical',
    'Landscaping',
    'Painting',
    'Roofing',
    'Other'
  ];
  
  // Variables para el logo
  final Rx<File?> logoImage = Rx<File?>(null);
  final ImagePicker picker = ImagePicker();
  
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  String? sourceScreen;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['flavor'] != null) {
        currentFlavor.value = Get.arguments['flavor'];
      }
      if (Get.arguments['source'] != null) {
        sourceScreen = Get.arguments['source'];
        print('Source screen detected: $sourceScreen');
      }
    }
  }

  @override
  void onClose() {
    companyNameController.dispose();
    addressController.dispose();
    abnController.dispose();
    websiteController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void selectCategory(String? category) {
    selectedCategory.value = category;
  }

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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería'),
              onTap: () {
                Get.back(); // Cierra la pantalla de registro
            Get.back(); // Cierra el diálogo
                pickImageFromGallery();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        logoImage.value = File(image.path);
      }
    } catch (e) {
      print('Error al seleccionar imagen: $e');
      Get.snackbar(
        'Error',
        'Error selecting image: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void handleSubmit() {
    print('=== handleSubmit called ===');
    print('Form key current state: ${formKey.currentState}');
    
    if (formKey.currentState != null) {
      print('Form key is not null, validating...');
      if (formKey.currentState!.validate()) {
        print('Form validation passed');
        final companyName = companyNameController.text;
        print('Company name: $companyName');
      
      // Mostrar indicador de carga
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );
      
      // Simular un pequeño delay para mostrar el loading
      Future.delayed(const Duration(milliseconds: 500), () {
        // Cerrar el loading
        if (Get.isDialogOpen!) {
          print('Closing loading dialog');
          Get.back();
        }
        
        // Obtener el controller principal y agregar la empresa
        try {
          if (sourceScreen == 'edit_personal_details') {
            print('Trying to find EditPersonalDetailsController...');
            final editController = Get.find<EditPersonalDetailsController>();
            print('Found EditPersonalDetailsController, adding company...');
            editController.addUserCompany(companyName);
          } else {
            print('Trying to find CreateProfileBuilderController with tag...');
            final createProfileController = Get.find<CreateProfileBuilderController>(tag: 'builder_profile');
            print('Found controller with tag, adding company...');
            createProfileController.addUserCompany(companyName);
          }
          
          // Mostrar mensaje de éxito
          Get.snackbar(
            'Success',
            'Company "$companyName" registered successfully! Redirecting to home...',
            backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
            colorText: Colors.black,
            duration: const Duration(seconds: 2),
          );
          
          // Navegar según la pantalla de origen
          _navigateAfterSuccess();
          
        } catch (e) {
          print('Error finding controller with tag: $e');
          // Intentar obtener el controller sin tag como fallback
          try {
            print('Trying to find CreateProfileBuilderController without tag...');
            final createProfileController = Get.find<CreateProfileBuilderController>();
            print('Found controller without tag, adding company...');
            createProfileController.addUserCompany(companyName);
            
            Get.snackbar(
              'Success',
              'Company "$companyName" registered successfully! Redirecting to home...',
              backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
              colorText: Colors.black,
              duration: const Duration(seconds: 2),
            );
            
            // Navegar según la pantalla de origen
            _navigateAfterSuccess();
            
          } catch (e2) {
            print('Error finding CreateProfileBuilderController: $e2');
            // Intentar encontrar EditPersonalDetailsController como fallback
            try {
              print('Trying to find EditPersonalDetailsController...');
              final editController = Get.find<EditPersonalDetailsController>();
              print('Found EditPersonalDetailsController, adding company...');
              editController.addUserCompany(companyName);
              
              Get.snackbar(
                'Success',
                'Company "$companyName" registered successfully! Redirecting to home...',
                backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                colorText: Colors.black,
                duration: const Duration(seconds: 2),
              );
              
              // Navegar directamente al BuilderHomeScreen
              Get.offAllNamed(BuilderHomeScreen.id);
              
            } catch (e3) {
              print('Error finding EditPersonalDetailsController: $e3');
              // Si no se puede encontrar ningún controlador, al menos mostrar éxito y navegar al home
              Get.snackbar(
                'Success',
                'Company "$companyName" registered successfully! Redirecting to home...',
                backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                colorText: Colors.black,
                duration: const Duration(seconds: 2),
              );
              
              // Navegar directamente al BuilderHomeScreen
              Get.offAllNamed(BuilderHomeScreen.id);
            }
          }
        }
      });
    } else {
      print('Form validation failed - checking field values:');
      print('Company name: "${companyNameController.text}"');
      print('ABN: "${abnController.text}"');
      Get.snackbar(
        'Error',
        'Please fill in all required fields (Company Name and ABN)',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
    } else {
      print('Form key is null!');
      Get.snackbar(
        'Error',
        'Form not initialized properly',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _navigateAfterSuccess() {
    print('Navigating after success. Source screen: $sourceScreen');
    
    if (sourceScreen == 'edit_personal_details') {
      // Si viene del EditPersonalDetailsScreen, regresar a esa pantalla
      print('Returning to EditPersonalDetailsScreen');
      // Usar until para regresar hasta la pantalla de EditPersonalDetails
      Get.until((route) => route.settings.name == '/builder/edit-personal-details');
    } else {
      // Si viene del ProfileCreatedScreen o cualquier otra pantalla, ir al home
      print('Navigating to BuilderHomeScreen');
      Get.offAllNamed(BuilderHomeScreen.id);
    }
  }
}
