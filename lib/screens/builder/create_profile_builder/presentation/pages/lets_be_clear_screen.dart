import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../logic/controllers/create_profile_builder_controller.dart';

class LetsBeClearScreen extends StatelessWidget {
  static const String id = '/builder/lets-be-clear';
  
  final AppFlavor? flavor;

  LetsBeClearScreen({
    super.key,
    this.flavor,
  });

  final CreateProfileBuilderController controller = Get.find<CreateProfileBuilderController>(tag: 'builder_profile');

  @override
  Widget build(BuildContext context) {
    // Establecer flavor en el controlador
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
    final headlineFontSize = screenWidth * 0.065;
    final bodyFontSize = screenWidth * 0.035;
    final logoSize = screenWidth * 0.25;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header con botón de regreso y título
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: [
                  IconButton(
                    onPressed: controller.handleRespectBackNavigation,
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.grey[600],
                      size: screenWidth * 0.065,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Let's Be Clear",
                        style: GoogleFonts.poppins(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.065),
                ],
              ),
            ),
            
            // Contenido principal con botón integrado
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    SizedBox(height: verticalSpacing * 1.5),
                    
                    // Logo de YAKKA
                    Center(
                      child: Container(
                        width: logoSize,
                        height: logoSize,
                        child: SvgPicture.asset(
                          AssetsConfig.getLogoMiddle(controller.currentFlavor.value),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 2),
                    
                    // Título principal
                    Text(
                      "Let's be clear",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: headlineFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 1.5),
                    
                    // Texto descriptivo
                    Text(
                      "We connect people — we don't manage, hire, or supervise.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: bodyFontSize,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 1.5),
                    
                    // Sección de disclaimer
                    Text(
                      "YAKKA is not responsible for:",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                        fontSize: bodyFontSize * 1.1,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 1.5),
                    
                    // Lista numerada de responsabilidades
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildNumberedItem(
                          "1",
                          "Employment contracts or agreements between users.",
                          bodyFontSize,
                        ),
                        Divider(
                          color: Colors.grey[300],
                          height: verticalSpacing * 1.5,
                          thickness: 1,
                        ),
                        _buildNumberedItem(
                          "2",
                          "Work conditions, payments, safety, or disputes.",
                          bodyFontSize,
                        ),
                        Divider(
                          color: Colors.grey[300],
                          height: verticalSpacing * 1.5,
                          thickness: 1,
                        ),
                        _buildNumberedItem(
                          "3",
                          "Hiring decisions or outcomes — we do not employ workers.",
                          bodyFontSize,
                        ),
                      ],
                    ),
                    
                    SizedBox(height: verticalSpacing * 3),
                    
                    // Botón de aceptación usando CustomButton
                    Obx(() => CustomButton(
                      text: "I understand and accept",
                      onPressed: controller.isLoading.value ? null : controller.handleAccept,
                      isLoading: controller.isLoading.value,
                      showShadow: false,
                    )),
                    
                    SizedBox(height: verticalSpacing * 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberedItem(String number, String text, double fontSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.poppins(
                fontSize: fontSize * 0.8,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
