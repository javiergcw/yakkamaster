import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../logic/controllers/unified_post_job_controller.dart';

class PostJobStepperStep7Screen extends StatelessWidget {
  static const String id = '/builder/post-job-step7';

  final AppFlavor? flavor;

  PostJobStepperStep7Screen({super.key, this.flavor});

  final UnifiedPostJobController controller =
      Get.find<UnifiedPostJobController>();

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

            // Progress Indicator
            Container(
              width: double.infinity,
              height: 2,
              child: Row(
                children: [
                  // Progress (yellow) - 7 steps completed
                  Expanded(
                    flex: 7,
                    child: Container(
                      color: Color(
                        AppFlavorConfig.getPrimaryColor(currentFlavor),
                      ),
                    ),
                  ),
                  // Remaining (grey)
                  Expanded(flex: 2, child: Container(color: Colors.grey[300])),
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
                      "When will the worker be paid?",
                      style: GoogleFonts.poppins(
                        fontSize: questionFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: verticalSpacing),

                    // Choose pay day option
                    Obx(
                      () => _buildPaymentOption(
                        context,
                        "Choose pay day",
                        isSelected:
                            controller.selectedPaymentOption.value ==
                            "choose_pay_day",
                        onTap: () {
                          controller.selectPaymentOption("choose_pay_day");
                          _showPayDayPicker(context);
                        },
                      ),
                    ),

                    SizedBox(height: verticalSpacing),

                    // On going jobs section
                    Text(
                      "On going jobs",
                      style: GoogleFonts.poppins(
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 0.5),

                    // Weekly payment option
                    Obx(
                      () => _buildPaymentOption(
                        context,
                        "Weekly payment",
                        isSelected:
                            controller.selectedPaymentOption.value == "weekly",
                        onTap: () {
                          controller.selectPaymentOption("weekly");
                        },
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 0.5),

                    // Fortnightly payment option
                    Obx(
                      () => _buildPaymentOption(
                        context,
                        "Fortnightly payment",
                        isSelected:
                            controller.selectedPaymentOption.value ==
                            "fortnightly",
                        onTap: () {
                          controller.selectPaymentOption("fortnightly");
                        },
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 2),

                    // Warning box
                    GestureDetector(
                      onTap: _openFAQsPage,
                      child: Container(
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
                                  Icons.warning_amber_rounded,
                                  color: Colors.orange[600],
                                  size: screenWidth * 0.05,
                                ),
                                SizedBox(width: horizontalPadding * 0.5),
                                Expanded(
                                  child: Text(
                                    "What happens if I don't pay the labourer?",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.035,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey[600],
                                  size: screenWidth * 0.04,
                                ),
                              ],
                            ),
                            SizedBox(height: verticalSpacing * 0.5),
                            Text(
                              "YAKKA cannot get involved. However, if payment is not made, the worker may take legal action, and your reputation on the platform may be affected.",
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.032,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

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

  Widget _buildPaymentOption(
    BuildContext context,
    String text, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final currentFlavor = flavor ?? AppFlavorConfig.currentFlavor;

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
        child: Row(
          children: [
            // Radio button
            Container(
              width: screenWidth * 0.05,
              height: screenWidth * 0.05,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor))
                      : Colors.black,
                  width: isSelected ? 2 : 3,
                ),
                color: isSelected
                    ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor))
                    : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: screenWidth * 0.03,
                      color: Colors.white,
                    )
                  : null,
            ),

            SizedBox(width: horizontalPadding * 0.8),

            // Text
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),

            // Show selected pay day if applicable
            if (text == "Choose pay day" &&
                controller.selectedPayDay.value != null)
              Text(
                controller.formatDate(controller.selectedPayDay.value!),
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.03,
                  color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor)),
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showPayDayPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedPayDay.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(
                AppFlavorConfig.getPrimaryColor(
                  flavor ?? AppFlavorConfig.currentFlavor,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.updatePayDay(picked);
    }
  }

  void _handleContinue() {
    controller.handleContinue();
  }

  void _openFAQsPage() async {
    const url = 'https://yakkalabour.com.au/faqs/';

    try {
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Error opening FAQs: $e');
      // No mostrar ningún modal, simplemente no hacer nada
    }
  }
}
