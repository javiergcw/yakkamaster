import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../data/dto/job_site_dto.dart';

class ProjectOverviewScreen extends StatelessWidget {
  static const String id = '/builder/project-overview';

  final AppFlavor? flavor;
  final JobSiteDto? jobSite;

  ProjectOverviewScreen({super.key, this.flavor, this.jobSite});

  @override
  Widget build(BuildContext context) {
    // Obtener argumentos de Get.arguments si no se pasaron como parámetros
    final arguments = Get.arguments;
    final currentFlavor = flavor ?? arguments?['flavor'] ?? AppFlavor.labour;
    final currentJobSite = jobSite ?? arguments?['jobSite'];

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.065; // Aumentado de 0.055 a 0.065
    final sectionFontSize = screenWidth * 0.04;
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
                    onTap: () => Get.back(),
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
                      "Project overview",
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
              child: SingleChildScrollView(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project Details Section
                    Row(
                      children: [
                        Text(
                          "Project Details",
                          style: GoogleFonts.poppins(
                            fontSize: sectionFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            // TODO: Implement edit functionality
                          },
                          child: Icon(
                            Icons.edit,
                            size: iconSize * 0.7,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: verticalSpacing * 1.2),

                    // Date Information
                    Row(
                      children: [
                        // Start Date
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Start date",
                                style: GoogleFonts.poppins(
                                  fontSize: descriptionFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: verticalSpacing * 0.3),
                              Text(
                                "21/08/2025",
                                style: GoogleFonts.poppins(
                                  fontSize: descriptionFontSize,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // End Date
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "End date",
                                style: GoogleFonts.poppins(
                                  fontSize: descriptionFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: verticalSpacing * 0.3),
                              Text(
                                "21/09/2025",
                                style: GoogleFonts.poppins(
                                  fontSize: descriptionFontSize,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: verticalSpacing * 1.5),

                    // Project Admins
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Project admins",
                          style: GoogleFonts.poppins(
                            fontSize: descriptionFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: verticalSpacing * 0.3),
                        Text(
                          currentJobSite?.name ?? "Sam Lopez",
                          style: GoogleFonts.poppins(
                            fontSize: descriptionFontSize,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: verticalSpacing * 1.2),

                    // Project Contacts
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Project Contacts",
                          style: GoogleFonts.poppins(
                            fontSize: descriptionFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: verticalSpacing * 0.3),
                        Text(
                          "John Lopez",
                          style: GoogleFonts.poppins(
                            fontSize: descriptionFontSize,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: verticalSpacing * 2),

                    // Geolocations Section
                    Text(
                      "Geolocations",
                      style: GoogleFonts.poppins(
                        fontSize: sectionFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 0.5),

                    Text(
                      "Geolocations turned on",
                      style: GoogleFonts.poppins(
                        fontSize: descriptionFontSize,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 1.2),

                    // Map Container (Placeholder)
                    Container(
                      height: screenHeight * 0.4,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                        color: Colors.grey[100],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map,
                              size: iconSize * 2,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: verticalSpacing * 0.5),
                            Text(
                              "Map View",
                              style: GoogleFonts.poppins(
                                fontSize: descriptionFontSize,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: verticalSpacing * 0.3),
                            Text(
                              "Google Maps integration\ncoming soon",
                              style: GoogleFonts.poppins(
                                fontSize: descriptionFontSize * 0.8,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 2),
                  ],
                ),
              ),
            ),

            // Save & Finish Button
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing * 0.5,
              ),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement save & finish functionality
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(
                    AppFlavorConfig.getPrimaryColor(currentFlavor),
                  ),
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
                  "Save & finish",
                  style: GoogleFonts.poppins(
                    fontSize: buttonFontSize * 0.9,
                    fontWeight: FontWeight.w600,
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
