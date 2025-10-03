import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/logic/masters/use_case/master_use_case.dart';
import '../../../../../features/logic/masters/models/send/dto_send_company.dart';
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
  
  // Use case para operaciones de companies
  final MasterUseCase _masterUseCase = MasterUseCase();
  
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

  void handleSubmit() async {
    print('=== handleSubmit called ===');
    print('Form key current state: ${formKey.currentState}');
    
    if (formKey.currentState != null) {
      print('Form key is not null, validating...');
      if (formKey.currentState!.validate()) {
        print('Form validation passed');
        final companyName = companyNameController.text;
        final website = websiteController.text;
        final description = descriptionController.text;
        print('Company name: $companyName');
        print('Website: $website');
        print('Description: $description');
      
        // Mostrar indicador de carga
        Get.dialog(
          const Center(
            child: CircularProgressIndicator(),
          ),
          barrierDismissible: false,
        );
        
        try {
          // Crear el objeto de datos de la empresa
          final companyData = DtoSendCompany(
            name: companyName,
            description: description.isNotEmpty ? description : 'No description provided',
            website: website.isNotEmpty ? website : 'https://example.com',
          );
          
          // Crear la empresa usando el API
          final result = await _masterUseCase.createCompany(companyData);
          
          // Cerrar el loading
          if (Get.isDialogOpen!) {
            print('Closing loading dialog');
            Get.back();
          }
          
          if (result.isSuccess && result.data != null) {
            print('Company created successfully: ${result.data!.company.name}');
            
            // Agregar la empresa a los controladores locales para mantener la lista actualizada
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
            } catch (e) {
              print('Error updating local controllers: $e');
              // Continuar aunque no se pueda actualizar los controladores locales
            }
            
            // Mostrar mensaje de éxito
            Get.snackbar(
              'Success',
              'Company "$companyName" registered successfully! Redirecting...',
              backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
            
            // Navegar según la pantalla de origen
            _navigateAfterSuccess();
            
          } else {
            print('Error creating company: ${result.message}');
            Get.snackbar(
              'Error',
              'Failed to create company: ${result.message ?? 'Unknown error'}',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
          }
          
        } catch (e) {
          // Cerrar el loading si está abierto
          if (Get.isDialogOpen!) {
            Get.back();
          }
          
          print('Exception creating company: $e');
          Get.snackbar(
            'Error',
            'Error creating company: $e',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
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
