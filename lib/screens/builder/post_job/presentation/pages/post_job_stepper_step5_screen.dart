import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../../logic/controllers/unified_post_job_controller.dart';
import '../widgets/custom_time_picker_modal.dart';

class PostJobStepperStep5Screen extends StatelessWidget {
  static const String id = '/builder/post-job-step5';
  
  final AppFlavor? flavor;

  PostJobStepperStep5Screen({
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
    
    final currentFlavor = flavor ?? AppFlavorConfig.currentFlavor;

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
                  // Progress (yellow) - 5 steps completed
                  Expanded(
                    flex: 5,
                    child: Container(
                      color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor)),
                    ),
                  ),
                  // Remaining (grey)
                  Expanded(
                    flex: 4,
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
                    
                    // First Question - Time
                    Text(
                      "At what time?",
                      style: GoogleFonts.poppins(
                        fontSize: questionFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing),
                    
                    // Subtitle
                    Text(
                      "Select the start and end time",
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        color: Colors.black87,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 1.5),
                    
                    // Time input fields
                    _buildTimeInputFields(context),
                    
                    SizedBox(height: verticalSpacing * 3),
                    
                    // Second Question - Job Type
                    Text(
                      "What kind of job are you offering?",
                      style: GoogleFonts.poppins(
                        fontSize: questionFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 1.5),
                    
                    // Job type chips
                    _buildJobTypeChips(context),
                    
                    SizedBox(height: verticalSpacing * 3),
                  ],
                ),
              ),
            ),
            
            // Continue Button
            Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: Obx(() => CustomButton(
                text: "Continue",
                onPressed: controller.canProceedToNextStep() ? _handleContinue : null,
                type: ButtonType.secondary,
                flavor: currentFlavor,
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInputFields(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final currentFlavor = flavor ?? AppFlavorConfig.currentFlavor;

    return Row(
      children: [
        // Start time field
        Expanded(
          child: GestureDetector(
            onTap: () => _showTimePicker(context, true),
            child: Obx(() => CustomTextField(
              labelText: "Start time",
              hintText: "hh:mm",
              controller: TextEditingController(
                text: controller.selectedStartTime.value != null 
                    ? "${controller.selectedStartTime.value!.hour.toString().padLeft(2, '0')}:${controller.selectedStartTime.value!.minute.toString().padLeft(2, '0')}"
                    : "",
              ),
              enabled: false,
              flavor: currentFlavor,
            )),
          ),
        ),
        
        SizedBox(width: horizontalPadding * 0.5),
        
        // End time field
        Expanded(
          child: GestureDetector(
            onTap: () => _showTimePicker(context, false),
            child: Obx(() => CustomTextField(
              labelText: "End time",
              hintText: "hh:mm",
              controller: TextEditingController(
                text: controller.selectedEndTime.value != null 
                    ? "${controller.selectedEndTime.value!.hour.toString().padLeft(2, '0')}:${controller.selectedEndTime.value!.minute.toString().padLeft(2, '0')}"
                    : "",
              ),
              enabled: false,
              flavor: currentFlavor,
            )),
          ),
        ),
      ],
    );
  }

  Widget _buildJobTypeChips(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final chipHeight = screenHeight * 0.045; // Reducido de 0.06 a 0.045
    final chipFontSize = screenWidth * 0.03; // Reducido de 0.035 a 0.03
    final currentFlavor = flavor ?? AppFlavorConfig.currentFlavor;

    return Wrap(
      spacing: horizontalPadding * 0.5,
      runSpacing: verticalSpacing * 0.8,
      children: controller.jobTypes.map((jobType) {
        return Obx(() {
          final isSelected = controller.selectedJobType.value == jobType;
          
          return GestureDetector(
            onTap: () {
              controller.updateJobType(jobType);
            },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding * 0.8,
              vertical: verticalSpacing * 0.6,
            ),
            decoration: BoxDecoration(
              color: isSelected 
                  ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor))
                  : Colors.white,
              borderRadius: BorderRadius.circular(chipHeight * 0.5),
              border: Border.all(
                color: isSelected
                    ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor))
                    : Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Text(
              jobType,
              style: GoogleFonts.poppins(
                fontSize: chipFontSize,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
        });
      }).toList(),
    );
  }

  void _showTimePicker(BuildContext context, bool isStartTime) {
    print('_showTimePicker called: ${isStartTime ? "Start" : "End"} time');
    final currentFlavor = flavor ?? AppFlavorConfig.currentFlavor;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomTimePickerModal(
        flavor: currentFlavor,
        initialTime: isStartTime 
            ? (controller.selectedStartTime.value ?? TimeOfDay.now())
            : (controller.selectedEndTime.value ?? controller.selectedStartTime.value ?? TimeOfDay.now()),
        onTimeSelected: (selectedTime) {
          print('Time selected: ${selectedTime.format(context)}');
          if (isStartTime) {
            controller.updateStartTime(selectedTime);
          } else {
            controller.updateEndTime(selectedTime);
          }
        },
      ),
    );
  }

  void _handleContinue() {
    controller.handleContinue();
  }
}
