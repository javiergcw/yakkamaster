import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/logic/builder/use_case/jobsites_use_case.dart';
import '../../../../../features/logic/builder/models/send/dto_send_jobsite.dart';
import '../../../../../features/logic/builder/models/receive/dto_receive_jobsite.dart';
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
  final Rx<DtoReceiveJobsite?> editingJobSiteReceive = Rx<DtoReceiveJobsite?>(null);
  
  // Variable para rastrear desde qué pantalla se está creando el jobsite
  String? sourceScreen;

  @override
  void onInit() {
    super.onInit();
    // Obtener argumentos si estamos editando
    final arguments = Get.arguments;
    if (arguments != null && arguments['jobSite'] != null) {
      final jobSite = arguments['jobSite'];
      if (jobSite is JobSiteDto) {
        editingJobSite.value = jobSite;
      } else if (jobSite is DtoReceiveJobsite) {
        editingJobSiteReceive.value = jobSite;
      }
      _populateFields();
    }
    
    // Establecer flavor si se proporciona
    if (arguments != null && arguments['flavor'] != null) {
      currentFlavor.value = arguments['flavor'];
    }
    
    // Obtener la pantalla de origen si se proporciona
    if (arguments != null && arguments['sourceScreen'] != null) {
      sourceScreen = arguments['sourceScreen'];
    }
  }

  void _populateFields() {
    if (editingJobSite.value != null) {
      addressController.text = editingJobSite.value!.address;
      suburbController.text = editingJobSite.value!.city;
      descriptionController.text = editingJobSite.value!.description;
    } else if (editingJobSiteReceive.value != null) {
      addressController.text = editingJobSiteReceive.value!.address;
      suburbController.text = editingJobSiteReceive.value!.suburb;
      descriptionController.text = editingJobSiteReceive.value!.description;
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

  /// Navega a la pantalla correcta después de crear/editar un jobsite
  void _navigateAfterSave() {
    // Forzar la navegación de regreso con un resultado para indicar que se completó la operación
    final isEditing = editingJobSite.value != null || editingJobSiteReceive.value != null;
    Get.back(result: {'success': true, 'action': isEditing ? 'updated' : 'created'});
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
        // Navegar directamente después de una edición exitosa
        _navigateAfterSave();
      } else if (editingJobSiteReceive.value != null) {
        // Actualizar job site existente usando el nuevo servicio
        final jobsiteData = DtoSendJobsite.create(
          address: addressController.text.trim(),
          suburb: suburbController.text.trim(),
          description: descriptionController.text.trim(),
          latitude: editingJobSiteReceive.value!.latitude,
          longitude: editingJobSiteReceive.value!.longitude,
        );

        final result = await _jobsitesUseCase.updateJobsite(
          editingJobSiteReceive.value!.id,
          jobsiteData,
        );
        
        if (result.isSuccess && result.data != null) {
          // Navegar directamente después de una edición exitosa
          _navigateAfterSave();
        } else {
          throw Exception(result.message ?? 'Error updating job site');
        }
      } else {
        // Crear nuevo job site usando el nuevo servicio
        final jobsiteData = DtoSendJobsite.create(
          address: addressController.text.trim(),
          suburb: suburbController.text.trim(), // Usar suburb como suburb
          description: descriptionController.text.trim(),
          latitude: -33.8688, // Latitud hardcodeada para Sydney
          longitude: 151.2093, // Longitud hardcodeada para Sydney
        );

        final result = await _jobsitesUseCase.createJobsite(jobsiteData);
        
        if (result.isSuccess && result.data != null) {
          Get.snackbar(
            'Success',
            'Job site created successfully!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 2),
          );
          
          // Esperar un poco para que el usuario vea el snackbar
          await Future.delayed(Duration(milliseconds: 500));
          // Navegar a la pantalla correcta después de crear
          _navigateAfterSave();
        } else {
          throw Exception(result.message ?? 'Error creating job site');
        }
      }
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
