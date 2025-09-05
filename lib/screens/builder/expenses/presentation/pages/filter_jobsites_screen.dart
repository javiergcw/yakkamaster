import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../post_job/presentation/widgets/job_site_card.dart';
import '../../logic/controllers/filter_jobsites_controller.dart';

class FilterJobSitesScreen extends StatelessWidget {
  static const String id = '/builder/expenses/filter-jobsites';

  final AppFlavor? flavor;

  FilterJobSitesScreen({super.key, this.flavor});

  final FilterJobSitesController controller = Get.put(
    FilterJobSitesController(),
  );

  @override
  Widget build(BuildContext context) {
    // Establecer el flavor en el controlador
    if (flavor != null) {
      controller.currentFlavor.value = flavor!;
    }

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final descriptionFontSize = screenWidth * 0.035;
    final buttonFontSize = screenWidth * 0.04;
    final iconSize = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header (Dark Grey)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing * 1.5,
              ),
              decoration: BoxDecoration(color: Colors.grey[800]),
              child: Row(
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => controller.handleBackNavigation(),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: iconSize,
                    ),
                  ),

                  SizedBox(width: horizontalPadding),

                  // Title (Centered)
                  Expanded(
                    child: Text(
                      "Jobsites",
                      style: GoogleFonts.poppins(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(width: iconSize + horizontalPadding), // Spacer to balance the back button
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: iconSize * 2,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: verticalSpacing),
                        Text(
                          controller.errorMessage.value,
                          style: GoogleFonts.poppins(
                            fontSize: descriptionFontSize,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: verticalSpacing),
                        ElevatedButton(
                          onPressed: () => controller.loadJobSites(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.jobSites.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off,
                          size: iconSize * 2,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: verticalSpacing),
                        Text(
                          "No job sites found",
                          style: GoogleFonts.poppins(
                            fontSize: descriptionFontSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: verticalSpacing * 0.5),
                        Text(
                          "Add your first job site to get started",
                          style: GoogleFonts.poppins(
                            fontSize: descriptionFontSize * 0.9,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalSpacing * 0.5,
                  ),
                  itemCount: controller.jobSites.length,
                  itemBuilder: (context, index) {
                    final jobSite = controller.jobSites[index];
                    return JobSiteCard(
                      jobSite: jobSite,
                      isSelected: jobSite.isSelected,
                      onTap: () {
                        controller.toggleJobSiteSelection(
                          jobSite.id,
                        );
                      },
                      onEdit: () {
                        // No edit functionality for filter screen
                      },
                    );
                  },
                );
              }),
            ),

            // Apply Filter Button
            Obx(
              () => Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalSpacing * 0.5,
                ),
                child: ElevatedButton(
                  onPressed: controller.selectedJobSites.isNotEmpty
                      ? controller.handleApplyFilter
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.selectedJobSites.isNotEmpty
                        ? Color(
                            AppFlavorConfig.getPrimaryColor(
                              controller.currentFlavor.value,
                            ),
                          )
                        : Colors.grey[400],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: verticalSpacing * 1.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 1,
                  ),
                  child: Text(
                    "Apply Filter",
                    style: GoogleFonts.poppins(
                      fontSize: buttonFontSize * 0.9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}