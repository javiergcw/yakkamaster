import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/logic/builder/use_case/jobsites_use_case.dart';
import '../../../../../features/logic/builder/models/receive/dto_receive_jobsite.dart';
import '../../../post_job/data/dto/job_site_dto.dart';
import '../../../post_job/presentation/pages/create_edit_job_site_screen.dart';

class JobSitesListController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  
  // Nuevo caso de uso para jobsites
  final JobsitesUseCase _jobsitesUseCase = JobsitesUseCase();
  
  // Estados reactivos para jobsites
  final RxList<DtoReceiveJobsite> jobSites = <DtoReceiveJobsite>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
    loadJobSites();
  }

  /// Carga los jobsites desde el API
  Future<void> loadJobSites() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final result = await _jobsitesUseCase.getJobsites();
      
      if (result.isSuccess && result.data != null) {
        // Asignar jobsites directamente ya que el modelo maneja nulls
        jobSites.value = result.data!.jobsites;
      } else {
        errorMessage.value = result.message ?? 'Error loading job sites';
        jobSites.clear();
      }
    } catch (e) {
      errorMessage.value = 'Error loading job sites: $e';
      jobSites.clear();
      print('Error details: $e'); // Para debugging
    } finally {
      isLoading.value = false;
    }
  }

  /// Convierte DtoReceiveJobsite a JobSiteDto para compatibilidad con la UI
  JobSiteDto convertToJobSiteDto(DtoReceiveJobsite jobsite) {
    return JobSiteDto(
      id: jobsite.id.isNotEmpty ? jobsite.id : 'unknown',
      name: jobsite.description.isNotEmpty ? jobsite.description : 'No description',
      address: jobsite.address.isNotEmpty ? jobsite.address : 'No address',
      city: jobsite.suburb.isNotEmpty ? jobsite.suburb : 'Unknown suburb', // Usar suburb como city
      code: jobsite.id.length >= 8 ? jobsite.id.substring(0, 8) : jobsite.id,
      location: jobsite.fullLocation.isNotEmpty ? jobsite.fullLocation : 'Unknown location',
      description: jobsite.description.isNotEmpty ? jobsite.description : 'No description',
      status: JobSiteStatus.inProgress, // Por defecto en progreso
    );
  }

  void navigateBack() {
    Get.back();
  }

  void handleJobSiteDetail(DtoReceiveJobsite jobSite) {
    showJobSiteDetailModal(jobSite);
  }

  void showJobSiteDetailModal(DtoReceiveJobsite jobSite) {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenHeight = mediaQuery.size.height;
    
    Get.bottomSheet(
      Container(
        height: screenHeight * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle Bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Job Site Details',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'View complete information',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.grey[600],
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1, color: Colors.grey),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name Section
                    buildDetailSection(
                      icon: Icons.business,
                      title: 'Name',
                      value: jobSite.description, // Usar description como nombre
                      iconColor: Colors.blue[600],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Location Section
                    buildDetailSection(
                      icon: Icons.location_on,
                      title: 'Location',
                      value: jobSite.fullLocation, // Usar fullLocation del DTO
                      iconColor: Colors.red[600],
                    ),
                    
                    // Address Section
                    const SizedBox(height: 24),
                    buildDetailSection(
                      icon: Icons.home,
                      title: 'Address',
                      value: jobSite.address,
                      iconColor: Colors.purple[600],
                    ),
                    
                    // Phone Section (no disponible en el API actual)
                    // Removido porque el campo phone no existe en la respuesta del API
                    
                    // Coordinates Section
                    const SizedBox(height: 24),
                    buildDetailSection(
                      icon: Icons.my_location,
                      title: 'Coordinates',
                      value: jobSite.coordinatesString,
                      iconColor: Colors.indigo[600],
                    ),
                    
                    // Suburb Section
                    const SizedBox(height: 24),
                    buildDetailSection(
                      icon: Icons.location_city,
                      title: 'Suburb',
                      value: jobSite.suburb,
                      iconColor: Colors.amber[600],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Status Section
                    buildDetailSection(
                      icon: Icons.circle,
                      title: 'Status',
                      value: 'Active',
                      iconColor: Colors.green[600],
                      isStatus: true,
                    ),
                  ],
                ),
              ),
            ),
            
            // Action Buttons
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Close',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          handleEditJobSite(jobSite);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Edit',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget buildDetailSection({
    required IconData icon,
    required String title,
    required String value,
    required Color? iconColor,
    bool isDescription = false,
    bool isStatus = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor!.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: isStatus ? 12 : 16,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 44),
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: isDescription ? 14 : 16,
              fontWeight: isDescription ? FontWeight.w400 : FontWeight.w600,
              color: isStatus ? Colors.green[700] : Colors.black,
              height: isDescription ? 1.4 : 1.2,
            ),
          ),
        ),
      ],
    );
  }

  void handleEditJobSite(DtoReceiveJobsite jobSite) async {
    final result = await Get.toNamed(CreateEditJobSiteScreen.id, arguments: {
      'flavor': currentFlavor.value,
      'jobSite': jobSite,
      'sourceScreen': 'job_sites_list',
    });
    
    // Si se creó o editó un jobsite exitosamente, recargar la lista
    if (result != null && result['success'] == true) {
      loadJobSites();
    }
  }

  void handleCreateJobSite() async {
    final result = await Get.toNamed(CreateEditJobSiteScreen.id, arguments: {
      'flavor': currentFlavor.value,
      'sourceScreen': 'job_sites_list',
    });
    
    // Si se creó o editó un jobsite exitosamente, recargar la lista
    if (result != null && result['success'] == true) {
      loadJobSites();
    }
  }

  void handleDeleteJobSite(DtoReceiveJobsite jobSite) async {
    // Mostrar diálogo de confirmación
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text(
          'Delete Job Site',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${jobSite.description}"? This action cannot be undone.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey[700],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red[50],
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red[600],
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        isLoading.value = true;
        
        final result = await _jobsitesUseCase.deleteJobsite(jobSite.id);
        
        if (result.isSuccess) {
          Get.snackbar(
            'Success',
            'Job site deleted successfully!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 2),
          );
          
          // Recargar la lista
          loadJobSites();
        } else {
          Get.snackbar(
            'Error',
            result.message ?? 'Error deleting job site',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Error deleting job site: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      } finally {
        isLoading.value = false;
      }
    }
  }
}
