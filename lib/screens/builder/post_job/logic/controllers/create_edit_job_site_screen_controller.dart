import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/logic/builder/use_case/jobsites_use_case.dart';
import '../../../../../features/logic/builder/models/send/dto_send_jobsite.dart';
import 'job_site_controller.dart';
import '../../data/dto/job_site_dto.dart';

class CreateEditJobSiteScreenController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final JobSiteController jobSiteController = Get.find<JobSiteController>();
  
  // Nuevo caso de uso para jobsites
  final JobsitesUseCase _jobsitesUseCase = JobsitesUseCase();
  
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
      if (editingJobSite.value != null) {
        // Actualizar job site existente (mantener funcionalidad existente)
        final jobSite = JobSiteDto(
          id: editingJobSite.value!.id,
          name: addressController.text.trim(),
          city: suburbController.text.trim(),
          address: addressController.text.trim(),
          code: editingJobSite.value!.code,
          location: suburbController.text.trim(),
          description: descriptionController.text.trim(),
        );
        
        await jobSiteController.updateJobSite(jobSite);
        Get.snackbar(
          'Success',
          'Job site updated successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // Crear nuevo job site usando el nuevo servicio
        final jobsiteData = DtoSendJobsite.create(
          address: addressController.text.trim(),
          city: suburbController.text.trim(),
          suburb: suburbController.text.trim(), // Usar suburb como suburb
          description: descriptionController.text.trim(),
          latitude: 0.0, // Valor por defecto
          longitude: 0.0, // Valor por defecto
          phone: '', // Valor por defecto
        );

        final result = await _jobsitesUseCase.createJobsite(jobsiteData);
        
        if (result.isSuccess && result.data != null) {
          Get.snackbar(
            'Success',
            'Job site created successfully!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          throw Exception(result.message ?? 'Error creating job site');
        }
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
