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
                        Switch(
                          value: controller.isPublic.value,
                          onChanged: (value) {
                            controller.updateIsPublic(value);
                          },
                          activeColor: Colors.black,
                          activeTrackColor: Colors.grey[400],
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey[300],
                        ),
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
                                  controller
                                          .postJobData
                                          .selectedSkill ??
                                      "Truck Driver",
                                  style: GoogleFonts.poppins(
                                    fontSize: subtitleFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Text(
                                "\$${(controller.postJobData.hourlyRate ?? 28.0).toStringAsFixed(1)}/hr",
                                style: GoogleFonts.poppins(
                                  fontSize: subtitleFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: verticalSpacing),

                          // Job Details
                          _buildJobDetail(
                            Icons.location_on,
                            "Address: 1 test ridge",
                            "Suburb: Sydney",
                            "City: Sydney, New South Wales",
                          ),

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
                      onPressed: controller.handleEdit,
                      type: ButtonType.secondary,
                      flavor: controller.currentFlavor.value,
                      showShadow: false,
                    ),
                  ),

                  SizedBox(height: verticalSpacing),

                  // Confirm Button
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: "Confirm",
                      onPressed: controller.handleConfirm,
                      type: ButtonType.primary,
                      flavor: controller.currentFlavor.value,
                      showShadow: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
