import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../logic/controllers/respect_controller.dart';

class RespectScreen extends StatelessWidget {
  static const String id = '/respect';
  
  RespectScreen({super.key});

  final RespectController controller = Get.put(RespectController());

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final headlineFontSize = screenWidth * 0.065;
    final bodyFontSize = screenWidth * 0.035;
    final buttonFontSize = screenWidth * 0.04;
    final iconSize = screenWidth * 0.25;

    return Obx(() => Scaffold(
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
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.grey[600],
                      size: screenWidth * 0.065,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Respect",
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
            
            // Contenido principal centrado
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icono de manos
                    Container(
                      width: iconSize,
                      height: iconSize,
                      child: Image.asset(
                        AssetsConfig.getRespect(controller.currentFlavor.value),
                        fit: BoxFit.contain,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 3),
                    
                    // Título principal
                    Text(
                      "Respect comes first",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: headlineFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 2),
                    
                    // Texto descriptivo
                    Text(
                      "By using YAKKA, you agree to foster a safe and respectful work environment.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: bodyFontSize,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Botón de compromiso usando CustomButton
            Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: SizedBox(
                height: 60,
                child: CustomButton(
                  text: "I commit to being respectful",
                  onPressed: controller.handleCommit,
                  isLoading: false,
                  showShadow: false,
                ),
              ),
            ),
            
            SizedBox(height: verticalSpacing * 2),
          ],
        ),
      ),
    ));
  }
}
