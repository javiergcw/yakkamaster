import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../logic/controllers/profile_created_controller.dart';

class ProfileCreatedScreen extends StatelessWidget {
  static const String id = '/builder/profile-created';
  
  final AppFlavor? flavor;

  ProfileCreatedScreen({
    super.key,
    this.flavor,
  });

  final ProfileCreatedController controller = Get.put(ProfileCreatedController());

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
    final checkmarkSize = screenWidth * 0.25;
    final titleFontSize = screenWidth * 0.06;
    final subtitleFontSize = screenWidth * 0.04;
    final buttonFontSize = screenWidth * 0.045;
    final horizontalPadding = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)).withOpacity(0.9),
                Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              children: [
                // Espacio superior
                SizedBox(height: screenHeight * 0.15),
                
                // Icono de checkmark
                Container(
                  width: checkmarkSize,
                  height: checkmarkSize,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
                
                SizedBox(height: screenHeight * 0.05),
                
                // Título principal
                Text(
                  "Profile created!",
                  style: GoogleFonts.poppins(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: screenHeight * 0.03),
                
                // Subtítulo
                Text(
                  "Welcome to YAKKA community.",
                  style: GoogleFonts.poppins(
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const Spacer(),
                
                // Botón Next
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: screenHeight * 0.05),
                  child: ElevatedButton(
                    onPressed: controller.handleNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.2),
                    ),
                    child: Text(
                      'Next',
                      style: GoogleFonts.poppins(
                        fontSize: buttonFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
