import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../../config/app_flavor.dart';

class RegisterNewCompanyController extends GetxController {
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

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
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
                Get.back();
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
        'Error al seleccionar imagen: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void handleSubmit() {
    if (formKey.currentState!.validate()) {
      // TODO: Implement company registration logic
      final companyName = companyNameController.text;
      print('Company Name: $companyName');
      print('Address: ${addressController.text}');
      print('ABN: ${abnController.text}');
      print('Category: ${selectedCategory?.value}');
      print('Website: ${websiteController.text}');
      print('Description: ${descriptionController.text}');
      
      Get.snackbar(
        'Éxito',
        'Company registered successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      
      Get.back();
    }
  }
}
