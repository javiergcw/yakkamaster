import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../logic/controllers/create_profile_controller.dart';

class ProfileCreatedScreen extends StatelessWidget {
  static const String id = '/profile-created';
  
  ProfileCreatedScreen({super.key});

  final CreateProfileController controller = Get.find<CreateProfileController>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.065;
    final subtitleFontSize = screenWidth * 0.042;
    final buttonFontSize = screenWidth * 0.04;
    final checkIconSize = screenWidth * 0.15;
    final checkCircleSize = screenWidth * 0.25;

    return Obx(() => Scaffold(
      backgroundColor: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              // Espacio superior
              SizedBox(height: verticalSpacing * 4),
              
              // Ícono de confirmación (círculo negro con check blanco)
              Center(
                child: Container(
                  width: checkCircleSize,
                  height: checkCircleSize,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: checkIconSize,
                    color: Colors.white,
                  ),
                ),
              ),
              
              SizedBox(height: verticalSpacing * 4),
              
              // Título principal
              Text(
                "Profile created!",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              
              SizedBox(height: verticalSpacing * 0.8),
              
              // Subtítulo/Descripción
              Text(
                "You're ready to get started. Complete your profile now or explore Yakka right away.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: subtitleFontSize,
                  color: Colors.black,
                  height: 1.4,
                ),
              ),
              
              const Spacer(),
              
              // Botones de acción
              Column(
                children: [
                  // Botón "Start using Yakka" (fondo negro con texto blanco)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: controller.handleStartUsingYakka,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: verticalSpacing * 1.5,
                          ),
                          child: Text(
                            "Start using Yakka",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: buttonFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing * 1.5),
                  
                  // Enlace "Upload resume or more licences"
                  Center(
                    child: GestureDetector(
                      onTap: controller.handleUploadResume,
                      child: Text(
                        "Upload resume or more licences",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: verticalSpacing * 3),
            ],
          ),
        ),
      ),
    ));
  }
}
