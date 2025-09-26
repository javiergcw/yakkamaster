import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../logic/controllers/unified_post_job_controller.dart';
import '../widgets/cost_edit_modal.dart';
// import 'post_job_stepper_step4_screen.dart'; // Removed to avoid Container name conflict

class PostJobStepperStep3Screen extends StatelessWidget {
  static const String id = '/builder/post-job-step3';

  final AppFlavor? flavor;

  PostJobStepperStep3Screen({super.key, this.flavor});

  final UnifiedPostJobController controller =
      Get.find<UnifiedPostJobController>();

  @override
  Widget build(BuildContext context) {
    // Establecer el flavor en el controlador
    if (flavor != null) {
      controller.currentFlavor.value = flavor!;
    }
    // El controlador ya se inicializa en onInit()

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
                  bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
              ),
              child: Row(
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () {
                      controller.handleBackNavigation();
                      Navigator.of(context).pop();
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
                  // Progress (yellow) - 3 steps completed
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Color(
                        AppFlavorConfig.getPrimaryColor(currentFlavor),
                      ),
                    ),
                  ),
                  // Remaining (grey)
                  Expanded(flex: 6, child: Container(color: Colors.grey[300])),
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
                    SizedBox(height: verticalSpacing * 1.0),

                    // Main Question
                    Text(
                      "Calculate your labour costs",
                      style: GoogleFonts.poppins(
                        fontSize: questionFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: verticalSpacing),

                    // Instruction
                    Text(
                      "Tap on each field to calculate your total labour cost.",
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 2),

                    // Adjustable Costs Section
                    Center(
                      child: Text(
                        "Adjustable Costs",
                        style: GoogleFonts.poppins(
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    SizedBox(height: verticalSpacing),

                    // Wage (Hourly Rate)
                    Obx(
                      () => _buildCostCard(
                        context,
                        "Wage (Hourly Rate)*",
                        controller.postJobData.hourlyRate ?? 28.0,
                        isRequired: true,
                        hasError:
                            controller.postJobData.hourlyRate == null ||
                            controller.postJobData.hourlyRate! <= 0,
                        errorMessage: "This field is required.",
                        onTap: () => _showCostModal(
                          context,
                          "Wage (Hourly Rate)",
                          controller.postJobData.hourlyRate ?? 28.0,
                          controller.updateHourlyRate,
                        ),
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 0.5),

                    // Site Allowance
                    Obx(
                      () => _buildCostCard(
                        context,
                        "Site Allowance (\$/hr)",
                        controller.postJobData.siteAllowance ?? 0.0,
                        onTap: () => _showCostModal(
                          context,
                          "Site Allowance",
                          controller.postJobData.siteAllowance ?? 0.0,
                          controller.updateSiteAllowance,
                        ),
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 0.5),

                    // Leading Hand Allowance
                    Obx(
                      () => _buildCostCard(
                        context,
                        "Leading Hand Allowance (\$/hr)",
                        controller.postJobData.leadingHandAllowance ?? 0.0,
                        onTap: () => _showCostModal(
                          context,
                          "Leading Hand Allowance",
                          controller.postJobData.leadingHandAllowance ?? 0.0,
                          controller.updateLeadingHandAllowance,
                        ),
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 0.5),

                    // Productivity Allowance
                    Obx(
                      () => _buildCostCard(
                        context,
                        "Productivity Allowance (\$/hr)",
                        controller.postJobData.productivityAllowance ?? 0.0,
                        onTap: () => _showCostModal(
                          context,
                          "Productivity Allowance",
                          controller.postJobData.productivityAllowance ?? 0.0,
                          controller.updateProductivityAllowance,
                        ),
                      ),
                    ),

                    SizedBox(height: verticalSpacing),

                    // Yakka Services Section
                    // Center(
                    //   child: Text(
                    //     "Yakka services",
                    //     style: GoogleFonts.poppins(
                    //       fontSize: subtitleFontSize,
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.black,
                    //     ),
                    //   ),
                    // ),

                    // SizedBox(height: verticalSpacing * 0.5),

                    // // Yakka Service Fee
                    // _buildServiceCard(
                    //   context,
                    //   "Yakka Service Fee",
                    //   "\$2.80/hr",
                    // ),

                    // // Divider
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: horizontalPadding * 0.8,
                    //   ),
                    //   child: Divider(color: Colors.grey[300], height: 1),
                    // ),

                    // // GST
                    // _buildServiceCard(context, "GST (+10%)", "\$0.28/hr"),

                    // Extras Section
                    Center(
                      child: Text(
                        "Extras",
                        style: GoogleFonts.poppins(
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 0.5),

                    // Divider
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding * 0.8,
                      ),
                      child: Divider(color: Colors.grey[300], height: 1),
                    ),

                    // No additional service fees text
                    Center(
                      child: Text(
                        "No additional service fees apply",
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    SizedBox(height: verticalSpacing),

                    // Overtime Rate
                    Obx(
                      () => _buildCostCardWithDescription(
                        context,
                        "Overtime Rate (\$/hr)",
                        controller.postJobData.overtimeRate ?? 0.0,
                        "Rate for hours worked beyond the regular schedule. (Hourly Rate)",
                        onTap: () => _showCostModal(
                          context,
                          "Overtime Rate",
                          controller.postJobData.overtimeRate ?? 0.0,
                          controller.updateOvertimeRate,
                        ),
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 0.5),

                    // Travel Allowance
                    Obx(
                      () => _buildCostCardWithDescription(
                        context,
                        "Travel Allowance",
                        controller.postJobData.travelAllowance ?? 0.0,
                        "Compensation for travel-related expenses.",
                        onTap: () => _showCostModal(
                          context,
                          "Travel Allowance",
                          controller.postJobData.travelAllowance ?? 0.0,
                          controller.updateTravelAllowance,
                        ),
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 2),
                  ],
                ),
              ),
            ),

            // Final Labour Cost
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Obx(() {
                final totalCost = _calculateTotalCost();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Final Labour Cost",
                      style: GoogleFonts.poppins(
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "\$${totalCost.toStringAsFixed(2)}/hr",
                      style: GoogleFonts.poppins(
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                );
              }),
            ),

            SizedBox(height: verticalSpacing),

            // Continue Button
            Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: Obx(
                () => CustomButton(
                  text: "Continue",
                  onPressed: controller.canProceedToNextStep()
                      ? _handleContinue
                      : null,
                  type: ButtonType.secondary,
                  flavor: currentFlavor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostCard(
    BuildContext context,
    String title,
    double value, {
    bool isRequired = false,
    bool hasError = false,
    String? errorMessage,
    VoidCallback? onTap,
  }) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final cardHeight = screenHeight * 0.08;
    final titleFontSize = screenWidth * 0.035;
    final valueFontSize = screenWidth * 0.035;
    final errorFontSize = screenWidth * 0.03;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: cardHeight,
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding * 0.8,
              vertical: verticalSpacing * 0.4,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: hasError ? Colors.red[300]! : Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: GoogleFonts.poppins(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isRequired)
                            Text(
                              " *",
                              style: GoogleFonts.poppins(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            ),
                        ],
                      ),
                      if (hasError && errorMessage != null)
                        Text(
                          errorMessage,
                          style: GoogleFonts.poppins(
                            fontSize: errorFontSize,
                            color: Colors.red[600],
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  "\$${value.toStringAsFixed(2)}/hr",
                  style: GoogleFonts.poppins(
                    fontSize: valueFontSize,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(width: horizontalPadding * 0.3),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[600],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(BuildContext context, String title, String value) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final cardHeight = screenHeight * 0.06;
    final titleFontSize = screenWidth * 0.035;
    final valueFontSize = screenWidth * 0.035;

    return Container(
      height: cardHeight,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding * 0.8,
        vertical: verticalSpacing * 0.4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: titleFontSize,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: valueFontSize,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostCardWithDescription(
    BuildContext context,
    String title,
    double value,
    String description, {
    VoidCallback? onTap,
  }) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final cardHeight = screenHeight * 0.1;
    final titleFontSize = screenWidth * 0.035;
    final valueFontSize = screenWidth * 0.035;
    final descriptionFontSize = screenWidth * 0.03;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: cardHeight,
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding * 0.8,
              vertical: verticalSpacing * 0.4,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        description,
                        style: GoogleFonts.poppins(
                          fontSize: descriptionFontSize,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(
                  "\$${value.toStringAsFixed(2)}/hr",
                  style: GoogleFonts.poppins(
                    fontSize: valueFontSize,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(width: horizontalPadding * 0.3),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[600],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showCostModal(
    BuildContext context,
    String title,
    double initialValue,
    Function(double) onSave,
  ) {
    final currentFlavor = flavor ?? AppFlavorConfig.currentFlavor;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CostEditModal(
        flavor: currentFlavor,
        title: "Choose your $title",
        initialValue: initialValue,
        onSave: onSave,
      ),
    );
  }

  double _calculateTotalCost() {
    return controller.calculateTotalCost();
  }

  void _handleContinue() {
    controller.handleContinue();
  }
}
