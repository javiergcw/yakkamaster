import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../logic/controllers/profile_created_controller.dart';

class ProfileCreatedScreen extends StatelessWidget {
  static const String id = '/profile-created';
  
  ProfileCreatedScreen({super.key});

  final ProfileCreatedController controller = Get.put(ProfileCreatedController());

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
                "Now you can start applying for construction jobs",
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
                  // Botón "Explore YAKKA" (fondo amarillo con borde negro)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: controller.handleExploreYakka,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: verticalSpacing * 1.5,
                          ),
                          child: Text(
                            "Explore YAKKA",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: buttonFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing * 1.5),
                  
                  // Botón "Apply for a job" (fondo negro con texto blanco)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: controller.handleApplyForJob,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: verticalSpacing * 1.5,
                          ),
                          child: Text(
                            "Apply for a job",
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
