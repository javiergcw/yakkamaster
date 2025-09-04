import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import 'builder_profile_controller.dart';

class CompanyDetailsController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final BuilderProfileController builderProfileController = Get.find<BuilderProfileController>();
  
  // TextEditingControllers
  final TextEditingController companyAddressController = TextEditingController();
  final TextEditingController companyPhoneController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  
  // Lista de industrias disponibles
  final List<String> industries = [
    'Construction',
    'Renovation',
    'Plumbing',
    'Electrical',
    'HVAC',
    'Landscaping',
    'Roofing',
    'Painting',
    'Carpentry',
    'General Contracting',
    'Other'
  ];
  
  // Lista de tamaños de empresa
  final List<String> companySizes = [
    '1-10 employees',
    '11-50 employees',
    '51-200 employees',
    '201-500 employees',
    '500+ employees'
  ];

  @override
  void onInit() {
    super.onInit();
    initializeController();
  }

  void initializeController() {
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
    
    // Inicializar los controladores de texto con valores existentes
    companyAddressController.text = builderProfileController.profile.companyAddress ?? '';
    companyPhoneController.text = builderProfileController.profile.companyPhone ?? '';
    websiteController.text = builderProfileController.profile.website ?? '';
    descriptionController.text = builderProfileController.profile.description ?? '';
    
    // Agregar listeners a los controladores
    companyAddressController.addListener(() {
      builderProfileController.updateCompanyAddress(companyAddressController.text);
    });
    
    companyPhoneController.addListener(() {
      builderProfileController.updateCompanyPhone(companyPhoneController.text);
    });
    
    websiteController.addListener(() {
      builderProfileController.updateWebsite(websiteController.text);
    });
    
    descriptionController.addListener(() {
      builderProfileController.updateDescription(descriptionController.text);
    });
  }

  void handleBackNavigation() {
    Get.back();
  }

  void handleNext() async {
    // Validar campos requeridos usando el controlador
    if (!builderProfileController.isProfileValid) {
      Get.snackbar(
        'Error',
        builderProfileController.validationErrors.join(', '),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    // Guardar el perfil usando el controlador
    final success = await builderProfileController.saveProfile();
    
    if (success) {
      // Navegar de vuelta a la pantalla principal
      Get.offAllNamed('/builder/home');
    }
  }

  @override
  void onClose() {
    companyAddressController.dispose();
    companyPhoneController.dispose();
    websiteController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
