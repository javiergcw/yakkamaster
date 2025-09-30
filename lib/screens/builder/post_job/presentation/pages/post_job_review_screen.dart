import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../logic/controllers/unified_post_job_controller.dart';

class PostJobReviewScreen extends StatelessWidget {
  static const String id = '/builder/post-job-review';

  final AppFlavor? flavor;

  PostJobReviewScreen({super.key, this.flavor});

  final UnifiedPostJobController controller = Get.find<UnifiedPostJobController>();

  @override
  Widget build(BuildContext context) {
    // Establecer el flavor en el controlador si se proporciona
    if (flavor != null) {
      controller.currentFlavor.value = flavor!;
    }

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final questionFontSize = screenWidth * 0.075;
    final subtitleFontSize = screenWidth * 0.045;
    final iconSize = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing * 0.6,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
              ),
              child: Row(
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () {
                      controller.handleBackNavigation();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: iconSize,
                    ),
                  ),

                  SizedBox(width: horizontalPadding),

                  // Title
                  Expanded(
                    child: Text(
                      "Post a job",
                      style: GoogleFonts.poppins(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(width: horizontalPadding + iconSize),
                ],
              ),
            ),

            // Progress Indicator - Completado
            Container(
              width: double.infinity,
              height: 2,
              child: Row(
                children: [
                  // Progress (yellow) - 9 steps completed
                  Expanded(
                    flex: 9,
                    child: Container(
                      color: Color(
                        AppFlavorConfig.getPrimaryColor(
                          controller.currentFlavor.value,
                        ),
                      ),
                    ),
                  ),
                  // Remaining (grey) - 0 remaining
                  Expanded(flex: 0, child: Container(color: Colors.grey[300])),
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
                    SizedBox(height: verticalSpacing * 0.2),

                    // Main Question
                    Text(
                      "Ready to post your job?",
                      style: GoogleFonts.poppins(
                        fontSize: questionFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: verticalSpacing),

                    // Public/Private Toggle Section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Public",
                                style: GoogleFonts.poppins(
                                  fontSize: subtitleFontSize,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: verticalSpacing * 0.2),
                              Text(
                                "Turn off job visibility to hide this job temporarily. Only you'll see it.",
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.032,
                                  color: Colors.black87,
                                ),
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                        Obx(() => Switch(
                          value: controller.isPublic.value,
                          onChanged: (value) {
                            controller.updateIsPublic(value);
                          },
                          activeColor: Colors.black,
                          activeTrackColor: Colors.grey[400],
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey[300],
                        )),
                      ],
                    ),

                    SizedBox(height: verticalSpacing),

                    // Job Summary Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(horizontalPadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Job Title and Rate
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _getJobTitle(),
                                  style: GoogleFonts.poppins(
                                    fontSize: subtitleFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Text(
                                "\$${(controller.postJobData.hourlyRate ?? 0.0).toStringAsFixed(1)}/hr",
                                style: GoogleFonts.poppins(
                                  fontSize: subtitleFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: verticalSpacing),

                          // Job Details - Jobsite Information
                          Obx(() {
                            final selectedJobSite = controller.selectedJobSites.isNotEmpty 
                                ? controller.selectedJobSites.first 
                                : null;
                            
                            return _buildJobDetail(
                              Icons.location_on,
                              selectedJobSite != null 
                                  ? "Address: ${selectedJobSite.address ?? 'No address'}"
                                  : "Address: No job site selected",
                              selectedJobSite != null 
                                  ? "Suburb: ${selectedJobSite.city ?? 'No suburb'}"
                                  : "Suburb: No job site selected",
                              selectedJobSite != null 
                                  ? "Location: ${selectedJobSite.location ?? 'No location'}"
                                  : "Location: No job site selected",
                            );
                          }),

                          SizedBox(height: verticalSpacing * 0.8),

                          _buildJobDetail(
                            Icons.calendar_today,
                            "Dates: ${controller.formatDateRange()}",
                          ),

                          SizedBox(height: verticalSpacing * 0.8),

                          _buildJobDetail(
                            Icons.access_time,
                            "Time: ${controller.formatTimeRange()}",
                          ),

                          SizedBox(height: verticalSpacing * 0.8),

                          _buildJobDetail(
                            Icons.description,
                            "Payment is expected: ${controller.formatPaymentFrequency()}",
                          ),

                          SizedBox(height: verticalSpacing * 0.8),

                          _buildJobDetail(
                            Icons.list,
                            "Description: ${controller.postJobData.jobDescription ?? "asd"}",
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: verticalSpacing),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: Column(
                children: [
                  // Edit Button
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: "Edit",
                      onPressed: () {
                        controller.goToStep(1);
                      },
                      type: ButtonType.outline,
                      flavor: controller.currentFlavor.value,
                      showShadow: false,
                    ),
                  ),

                  SizedBox(height: verticalSpacing),

                  // Confirm Button
                  Obx(() => SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: controller.isLoading ? "Creating Job..." : "Confirm",
                      onPressed: controller.isLoading ? null : controller.handleConfirm,
                      type: ButtonType.primary,
                      flavor: controller.currentFlavor.value,
                      showShadow: false,
                    ),
                  )),

                  // Error Message
                  Obx(() {
                    if (controller.errorMessage.isNotEmpty) {
                      return Container(
                        margin: EdgeInsets.only(top: verticalSpacing),
                        padding: EdgeInsets.all(horizontalPadding * 0.5),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red[300]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red[600], size: iconSize * 0.8),
                            SizedBox(width: horizontalPadding * 0.5),
                            Expanded(
                              child: Text(
                                controller.errorMessage,
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.032,
                                  color: Colors.red[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el título del job con la skill seleccionada y número de labours
  String _getJobTitle() {
    final selectedSkill = controller.postJobData.selectedSkill;
    final workersNeeded = controller.postJobData.workersNeeded;
    
    if (selectedSkill != null && selectedSkill.isNotEmpty) {
      final skillName = selectedSkill;
      final workersText = workersNeeded != null && workersNeeded > 1 
          ? '$workersNeeded labours' 
          : '1 labour';
      
      return '$skillName - $workersText';
    }
    
    // Fallback si no hay skill seleccionada
    final workersText = workersNeeded != null && workersNeeded > 1 
        ? '$workersNeeded labours' 
        : '1 labour';
    
    return 'Job - $workersText';
  }

  Widget _buildJobDetail(
    IconData icon,
    String mainText, [
    String? subtitle1,
    String? subtitle2,
  ]) {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final verticalSpacing = mediaQuery.size.height * 0.025;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey[600], size: screenWidth * 0.04),
        SizedBox(width: screenWidth * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mainText,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.032,
                  color: Colors.black87,
                ),
              ),
              if (subtitle1 != null) ...[
                SizedBox(height: verticalSpacing * 0.2),
                Text(
                  subtitle1,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.032,
                    color: Colors.black87,
                  ),
                ),
              ],
              if (subtitle2 != null) ...[
                SizedBox(height: verticalSpacing * 0.2),
                Text(
                  subtitle2,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.032,
                    color: Colors.black87,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
