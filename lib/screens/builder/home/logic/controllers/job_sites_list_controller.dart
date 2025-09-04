import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../post_job/logic/controllers/job_site_controller.dart';
import '../../../post_job/presentation/pages/create_edit_job_site_screen.dart';

class JobSitesListController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  late JobSiteController jobSiteController;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
    jobSiteController = Get.put(JobSiteController());
  }

  void navigateBack() {
    Get.back();
  }

  void handleJobSiteDetail(dynamic jobSite) {
    showJobSiteDetailModal(jobSite);
  }

  void showJobSiteDetailModal(dynamic jobSite) {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
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
                      value: jobSite.name,
                      iconColor: Colors.blue[600],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Location Section
                    buildDetailSection(
                      icon: Icons.location_on,
                      title: 'Location',
                      value: jobSite.location,
                      iconColor: Colors.red[600],
                    ),
                    
                    // Description Section (if not empty)
                    if (jobSite.description.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      buildDetailSection(
                        icon: Icons.description,
                        title: 'Description',
                        value: jobSite.description,
                        iconColor: Colors.orange[600],
                        isDescription: true,
                      ),
                    ],
                    
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

  void handleEditJobSite(dynamic jobSite) {
    Get.toNamed(CreateEditJobSiteScreen.id, arguments: {
      'flavor': currentFlavor.value,
      'jobSite': jobSite,
    });
  }

  void handleCreateJobSite() {
    Get.toNamed(CreateEditJobSiteScreen.id, arguments: {
      'flavor': currentFlavor.value,
    });
  }
}
