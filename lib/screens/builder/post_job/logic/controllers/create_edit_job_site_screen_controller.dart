import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../logic/controllers/job_site_controller.dart';
import '../../data/dto/job_site_dto.dart';

class CreateEditJobSiteScreenController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final JobSiteController jobSiteController = Get.find<JobSiteController>();
  
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController suburbController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  
  final RxBool isLoading = false.obs;
  final Rx<JobSiteDto?> editingJobSite = Rx<JobSiteDto?>(null);

  @override
  void onInit() {
    super.onInit();
    // Obtener argumentos si estamos editando
    final arguments = Get.arguments;
    if (arguments != null && arguments['jobSite'] != null) {
      editingJobSite.value = arguments['jobSite'];
      _populateFields();
    }
    
    // Establecer flavor si se proporciona
    if (arguments != null && arguments['flavor'] != null) {
      currentFlavor.value = arguments['flavor'];
    }
  }

  void _populateFields() {
    if (editingJobSite.value != null) {
      addressController.text = editingJobSite.value!.address;
      suburbController.text = editingJobSite.value!.city;
      descriptionController.text = editingJobSite.value!.description;
    }
  }

  @override
  void onClose() {
    addressController.dispose();
    suburbController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void handleClose() {
    Get.back();
  }

  Future<void> handleSave() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      final jobSite = JobSiteDto(
        id: editingJobSite.value?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: addressController.text.trim(),
        city: suburbController.text.trim(),
        address: addressController.text.trim(),
        code: DateTime.now().millisecondsSinceEpoch.toString().substring(8),
        location: suburbController.text.trim(),
        description: descriptionController.text.trim(),
      );

      if (editingJobSite.value != null) {
        // Actualizar job site existente
        await jobSiteController.updateJobSite(jobSite);
        Get.snackbar(
          'Success',
          'Job site updated successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // Crear nuevo job site
        await jobSiteController.createJobSite(jobSite);
        Get.snackbar(
          'Success',
          'Job site created successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }

      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
