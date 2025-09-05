import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../logic/controllers/unified_post_job_controller.dart';

class PostJobStepperStep8Screen extends StatelessWidget {
  static const String id = '/builder/post-job-step8';
  
  final AppFlavor? flavor;

  PostJobStepperStep8Screen({
    super.key,
    this.flavor,
  });

  final UnifiedPostJobController controller = Get.find<UnifiedPostJobController>();

  @override
  Widget build(BuildContext context) {
    // Establecer el flavor en el controlador
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
    
    final currentFlavor = controller.currentFlavor.value;

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
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
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
            
            // Progress Indicator
            Container(
              width: double.infinity,
              height: 2,
              child: Row(
                children: [
                  // Progress (yellow) - 8 steps completed
                  Expanded(
                    flex: 8,
                    child: Container(
                      color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor)),
                    ),
                  ),
                  // Remaining (grey)
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.grey[300],
                    ),
                  ),
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
                      "Does this job require a supervisor's signature?",
                      style: GoogleFonts.poppins(
                        fontSize: questionFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing),
                    
                    // Yes/No buttons
                    Obx(() => Row(
                      children: [
                        // Yes button
                        Expanded(
                          child: _buildSelectionButton(
                            context,
                            "Yes",
                            isSelected: controller.selectedOption.value == "yes",
                            onTap: () {
                              controller.selectOption("yes");
                            },
                          ),
                        ),
                        
                        SizedBox(width: horizontalPadding * 0.5),
                        
                        // No button
                        Expanded(
                          child: _buildSelectionButton(
                            context,
                            "No",
                            isSelected: controller.selectedOption.value == "no",
                            onTap: () {
                              controller.selectOption("no");
                            },
                          ),
                        ),
                      ],
                    )),
                    
                    // Conditional content based on selection
                    Obx(() {
                      if (controller.selectedOption.value == "yes") {
                        return Column(
                          children: [
                            SizedBox(height: verticalSpacing),
                            
                            // Supervisor name section
                            Text(
                              "Add supervisor's name",
                              style: GoogleFonts.poppins(
                                fontSize: subtitleFontSize,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            
                            SizedBox(height: verticalSpacing * 0.5),
                            
                            // Supervisor name input
                            TextFormField(
                              controller: controller.supervisorNameController,
                              decoration: InputDecoration(
                                hintText: "Supervisor name",
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.grey[400],
                                  fontSize: screenWidth * 0.04,
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor)),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding * 0.8,
                                  vertical: verticalSpacing * 0.6,
                                ),
                              ),
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.04,
                                color: Colors.black,
                              ),
                              onChanged: (value) {
                                print('🔍 TextFormField onChanged called with: "$value"');
                                controller.updateSupervisorName(value);
                              },
                            ),
                            
                            SizedBox(height: verticalSpacing),
                            
                            // Information box
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(horizontalPadding),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.blue[600],
                                        size: screenWidth * 0.05,
                                      ),
                                      SizedBox(width: horizontalPadding * 0.5),
                                      Expanded(
                                        child: Text(
                                          "The supervisor must sign before the labourer submit the timesheet.\nIf the labourer completes the timesheet incorrectly, you can always report it and edit it",
                                          style: GoogleFonts.poppins(
                                            fontSize: screenWidth * 0.032,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    }),
                  ],
                ),
              ),
            ),
            
            // Continue Button
            Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: Obx(() => CustomButton(
                text: "Continue",
                onPressed: controller.canProceedToNextStep() ? controller.handleContinue : null,
                type: ButtonType.secondary,
                flavor: currentFlavor,
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionButton(BuildContext context, String text, {required bool isSelected, required VoidCallback onTap}) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final currentFlavor = controller.currentFlavor.value;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalSpacing * 0.8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor))
                : Colors.black,
            width: isSelected ? 1 : 2,
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

}
