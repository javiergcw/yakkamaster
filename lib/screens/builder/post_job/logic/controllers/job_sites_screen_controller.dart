import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/logic/builder/use_case/jobsites_use_case.dart';
import '../../../../../features/logic/builder/models/receive/dto_receive_jobsite.dart';
import '../../logic/controllers/job_site_controller.dart';
import '../../data/dto/job_site_dto.dart';
import '../../presentation/pages/create_edit_job_site_screen.dart';
import '../../presentation/pages/post_job_stepper_screen.dart';

class JobSitesScreenController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final JobSiteController jobSiteController = Get.put(JobSiteController());
  
  // Nuevo caso de uso para jobsites del API
  final JobsitesUseCase _jobsitesUseCase = JobsitesUseCase();
  
  // Estados reactivos para jobsites del API
  final RxList<DtoReceiveJobsite> apiJobSites = <DtoReceiveJobsite>[].obs;
  final RxBool isLoadingApi = false.obs;
  final RxString errorMessageApi = ''.obs;
  
  // Sistema de selección para jobsites del API
  final RxSet<String> selectedJobSiteIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
    loadApiJobSites();
  }

  /// Carga los jobsites desde el API
  Future<void> loadApiJobSites() async {
    try {
      isLoadingApi.value = true;
      errorMessageApi.value = '';
      
      final result = await _jobsitesUseCase.getJobsites();
      
      if (result.isSuccess && result.data != null) {
        apiJobSites.value = result.data!.jobsites;
      } else {
        errorMessageApi.value = result.message ?? 'Error loading job sites';
        apiJobSites.clear();
      }
    } catch (e) {
      errorMessageApi.value = 'Error loading job sites: $e';
      apiJobSites.clear();
      print('Error details: $e');
    } finally {
      isLoadingApi.value = false;
    }
  }

  /// Convierte DtoReceiveJobsite a JobSiteDto para compatibilidad con la UI
  JobSiteDto convertToJobSiteDto(DtoReceiveJobsite jobsite) {
    final jobSiteId = jobsite.id.isNotEmpty ? jobsite.id : 'unknown';
    final isSelected = selectedJobSiteIds.contains(jobSiteId);
    
    return JobSiteDto(
      id: jobSiteId,
      name: jobsite.description.isNotEmpty ? jobsite.description : 'No description',
      address: jobsite.address.isNotEmpty ? jobsite.address : 'No address',
      city: jobsite.suburb.isNotEmpty ? jobsite.suburb : 'Unknown suburb', // Usar suburb como city
      code: jobsite.id.length >= 8 ? jobsite.id.substring(0, 8) : jobsite.id,
      location: jobsite.fullLocation.isNotEmpty ? jobsite.fullLocation : 'Unknown location',
      description: jobsite.description.isNotEmpty ? jobsite.description : 'No description',
      status: JobSiteStatus.inProgress, // Por defecto en progreso
      isSelected: isSelected, // Usar nuestro sistema de selección
    );
  }

  void handleBackNavigation() {
    Get.back();
  }

  /// Alterna la selección de un jobsite
  void toggleJobSiteSelection(String jobSiteId) {
    if (selectedJobSiteIds.contains(jobSiteId)) {
      selectedJobSiteIds.remove(jobSiteId);
    } else {
      selectedJobSiteIds.add(jobSiteId);
    }
  }

  /// Obtiene los jobsites seleccionados
  List<JobSiteDto> get selectedJobSites {
    return selectedJobSiteIds.map((id) {
      final jobsite = apiJobSites.firstWhereOrNull((js) => js.id == id);
      if (jobsite != null) {
        return convertToJobSiteDto(jobsite);
      }
      return null;
    }).where((js) => js != null).cast<JobSiteDto>().toList();
  }

  void handleCreateJobSite() async {
    final result = await Get.toNamed(CreateEditJobSiteScreen.id, arguments: {
      'flavor': currentFlavor.value,
      'sourceScreen': 'job_sites_select',
    });
    
    // Si se creó o editó un jobsite exitosamente, recargar la lista
    if (result != null && result['success'] == true) {
      loadApiJobSites();
    }
  }

  void handleEditJobSite(dynamic jobSite) async {
    final result = await Get.toNamed(CreateEditJobSiteScreen.id, arguments: {
      'flavor': currentFlavor.value,
      'jobSite': jobSite,
      'sourceScreen': 'job_sites_select',
    });
    
    // Si se creó o editó un jobsite exitosamente, recargar la lista
    if (result != null && result['success'] == true) {
      loadApiJobSites();
    }
  }

  void handleRequestWorkers() {
    // Navegar al stepper de post job con los jobsites seleccionados
    Get.toNamed(PostJobStepperScreen.id, arguments: {
      'flavor': currentFlavor.value,
      'selectedJobSites': selectedJobSites,
    });
  }

  void showMoreOptions() {
    // TODO: Mostrar opciones adicionales
    print('More options pressed');
    Get.snackbar(
      'Info',
      'More options feature not implemented yet',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }
}
