import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../../../../../features/widgets/phone_input.dart';
import '../../logic/controllers/create_profile_controller.dart';

class PreviousEmployerScreen extends StatelessWidget {
  static const String id = '/previous-employer';
  
  PreviousEmployerScreen({super.key});

  final CreateProfileController controller = Get.put(CreateProfileController());

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final instructionFontSize = screenWidth * 0.038;
    final buttonFontSize = screenWidth * 0.035;
    final progressBarHeight = screenHeight * 0.008;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header con botón de regreso y título
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: screenWidth * 0.065,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Previous employer",
                            style: GoogleFonts.poppins(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.065),
                    ],
                  ),
                  
                  SizedBox(height: verticalSpacing * 2),
                  
                  // Barra de progreso (aproximadamente 50% completado)
                  Container(
                    width: double.infinity,
                    height: progressBarHeight,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(progressBarHeight / 2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.5, // 50% completado
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                          borderRadius: BorderRadius.circular(progressBarHeight / 2),
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing * 0.8),
                  
                  // Texto instructivo
                  Text(
                    "Please provide the contact information for your previous supervisor or employer. Our team will get in touch with them to verify your work experience. Avoid listing friends as references.",
                    style: GoogleFonts.poppins(
                      fontSize: instructionFontSize,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing * 0.8),
                  
                  // Primer Supervisor
                  Obx(() => controller.firstSupervisor.value == null
                      ? GestureDetector(
                          onTap: () => controller.showAddSupervisorModal(true),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: verticalSpacing * 0.8,
                            ),
                            decoration: BoxDecoration(
                              color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person_add,
                                  color: Colors.black,
                                  size: screenWidth * 0.06,
                                ),
                                SizedBox(width: horizontalPadding * 0.5),
                                Expanded(
                                  child: Text(
                                    "Add Supervisor",
                                    style: GoogleFonts.poppins(
                                      fontSize: buttonFontSize,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                  size: screenWidth * 0.05,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: verticalSpacing * 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => controller.showEditSupervisorModal(true),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                                        size: screenWidth * 0.05,
                                      ),
                                      SizedBox(width: horizontalPadding * 0.5),
                                      Expanded(
                                        child: Text(
                                          controller.firstSupervisor.value!['name']!,
                                          style: GoogleFonts.poppins(
                                            fontSize: buttonFontSize,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.edit,
                                        color: Colors.grey[600],
                                        size: screenWidth * 0.045,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: horizontalPadding * 0.5),
                              GestureDetector(
                                onTap: () => controller.showDeleteConfirmationDialog(true),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red[600],
                                    size: screenWidth * 0.045,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  
                  SizedBox(height: verticalSpacing * 2),
                  
                  // Texto instructivo adicional (siempre visible)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(horizontalPadding * 0.8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Please provide a second reference in case we are unable to contact the first one.",
                      style: GoogleFonts.poppins(
                        fontSize: instructionFontSize,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing * 0.8),
                  
                  // Segundo Supervisor
                  Obx(() => controller.secondSupervisor.value == null
                      ? GestureDetector(
                          onTap: () => controller.showAddSupervisorModal(false),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: verticalSpacing * 0.8,
                            ),
                            decoration: BoxDecoration(
                              color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person_add,
                                  color: Colors.black,
                                  size: screenWidth * 0.06,
                                ),
                                SizedBox(width: horizontalPadding * 0.5),
                                Expanded(
                                  child: Text(
                                    "Add Supervisor",
                                    style: GoogleFonts.poppins(
                                      fontSize: buttonFontSize,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                  size: screenWidth * 0.05,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: verticalSpacing * 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => controller.showEditSupervisorModal(false),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                                        size: screenWidth * 0.05,
                                      ),
                                      SizedBox(width: horizontalPadding * 0.5),
                                      Expanded(
                                        child: Text(
                                          controller.secondSupervisor.value!['name']!,
                                          style: GoogleFonts.poppins(
                                            fontSize: buttonFontSize,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.edit,
                                        color: Colors.grey[600],
                                        size: screenWidth * 0.045,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: horizontalPadding * 0.5),
                              GestureDetector(
                                onTap: () => controller.showDeleteConfirmationDialog(false),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red[600],
                                    size: screenWidth * 0.045,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  
                  const Spacer(),
                  
                  // Botón Continue
                  CustomButton(
                    text: "Continue",
                    onPressed: controller.handlePreviousEmployerContinue,
                    isLoading: false,
                    showShadow: false,
                  ),
                  
                  SizedBox(height: verticalSpacing),
                  
                  // Botón Skip
                  Center(
                    child: GestureDetector(
                      onTap: controller.handleSkip,
                      child: Text(
                        "Skip",
                        style: GoogleFonts.poppins(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing * 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
