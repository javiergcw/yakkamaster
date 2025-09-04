import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../widgets/job_site_card.dart';
import '../../logic/controllers/job_sites_screen_controller.dart';

class JobSitesScreen extends StatelessWidget {
  static const String id = '/builder/job-sites-select';
  
  final AppFlavor? flavor;

  JobSitesScreen({
    super.key,
    this.flavor,
  });

  final JobSitesScreenController controller = Get.put(JobSitesScreenController());



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
               decoration: BoxDecoration(
                 color: Colors.grey[800],
               ),
              child: Column(
                children: [
                                     // Header Row
                   Row(
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
                       
                       // Title
                       Expanded(
                         child: Text(
                           "Jobsites",
                           style: GoogleFonts.poppins(
                             fontSize: titleFontSize,
                             fontWeight: FontWeight.bold,
                             color: Colors.white,
                           ),
                           textAlign: TextAlign.left,
                         ),
                       ),
                       
                       // More Options Button
                       GestureDetector(
                         onTap: () {
                           controller.showMoreOptions();
                         },
                         child: Icon(
                           Icons.more_vert,
                           color: Colors.white,
                           size: iconSize,
                         ),
                       ),
                     ],
                   ),
                  
                                     SizedBox(height: verticalSpacing * 0.5),
                   
                   // Description
                   Text(
                     "Here you can see all your jobsites. You can edit, add or remove any job site.",
                     style: GoogleFonts.poppins(
                       fontSize: descriptionFontSize * 0.9,
                       fontWeight: FontWeight.w400,
                       color: Colors.white.withOpacity(0.9),
                     ),
                     textAlign: TextAlign.left,
                   ),
                ],
              ),
            ),
            
            // Main Content
            Expanded(
              child: Obx(() {
                if (controller.jobSiteController.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                if (controller.jobSiteController.errorMessage.isNotEmpty) {
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
                          controller.jobSiteController.errorMessage,
                          style: GoogleFonts.poppins(
                            fontSize: descriptionFontSize,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: verticalSpacing),
                        ElevatedButton(
                          onPressed: () => controller.jobSiteController.loadJobSites(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                
                if (controller.jobSiteController.jobSites.isEmpty) {
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
                  itemCount: controller.jobSiteController.jobSites.length + 1, // +1 para el botón de crear
                  itemBuilder: (context, index) {
                    if (index == controller.jobSiteController.jobSites.length) {
                      // Botón para crear job site al final
                      return Container(
                        margin: EdgeInsets.only(top: verticalSpacing),
                        child: ElevatedButton.icon(
                          onPressed: controller.handleCreateJobSite,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[100],
                            foregroundColor: Colors.grey[700],
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: verticalSpacing * 0.8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                            elevation: 0,
                          ),
                          icon: Icon(
                            Icons.add,
                            size: iconSize * 0.8,
                          ),
                          label: Text(
                            "Create new job site",
                            style: GoogleFonts.poppins(
                              fontSize: buttonFontSize * 0.8,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }
                    
                    final jobSite = controller.jobSiteController.jobSites[index];
                    return JobSiteCard(
                      jobSite: jobSite,
                      isSelected: jobSite.isSelected,
                      onTap: () {
                        controller.jobSiteController.toggleJobSiteSelection(jobSite.id);
                      },
                      onEdit: () {
                        controller.handleEditJobSite(jobSite);
                      },
                    );
                  },
                );
              }),
            ),
            
                         // Request Workers Button
             Obx(() => Container(
               width: double.infinity,
               padding: EdgeInsets.symmetric(
                 horizontal: horizontalPadding,
                 vertical: verticalSpacing * 0.5,
               ),
               child: ElevatedButton(
                 onPressed: controller.jobSiteController.selectedJobSites.isNotEmpty
                     ? controller.handleRequestWorkers
                     : null,
                 style: ElevatedButton.styleFrom(
                   backgroundColor: controller.jobSiteController.selectedJobSites.isNotEmpty
                       ? Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value))
                       : Colors.grey[400],
                   foregroundColor: Colors.white,
                   padding: EdgeInsets.symmetric(vertical: verticalSpacing * 1.0),
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(6),
                   ),
                   elevation: 1,
                 ),
                 child: Text(
                   "Request workers",
                   style: GoogleFonts.poppins(
                     fontSize: buttonFontSize * 0.9,
                     fontWeight: FontWeight.w600,
                   ),
                 ),
               ),
             )),
          ],
        ),
      ),
    );
  }

}
