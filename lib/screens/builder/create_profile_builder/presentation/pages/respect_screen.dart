import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../logic/controllers/create_profile_builder_controller.dart';

class RespectScreen extends StatelessWidget {
  static const String id = '/builder/respect';
  
  final AppFlavor? flavor;

  RespectScreen({
    super.key,
    this.flavor,
  });

  final CreateProfileBuilderController controller = Get.put(CreateProfileBuilderController(), tag: 'builder_profile');

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
    final iconSize = screenWidth * 0.25;
    
    final currentFlavor = controller.currentFlavor.value;

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
                        AssetsConfig.getRespect(currentFlavor),
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
              child: CustomButton(
                text: "I commit to being respectful",
                onPressed: controller.handleRespectCommit,
                isLoading: false,
              ),
            ),
            
            SizedBox(height: verticalSpacing * 2),
          ],
        ),
      ),
    );
  }
}
