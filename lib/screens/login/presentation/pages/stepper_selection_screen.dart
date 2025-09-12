import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../config/app_flavor.dart';
import '../../../../config/assets_config.dart';
import '../../../labour/create_profile_labour/presentation/widgets/stepper_selection_card.dart';
import '../../logic/controllers/stepper_selection_controller.dart';

class StepperSelectionScreen extends StatelessWidget {
  static const String id = '/stepper-selection';
  
  StepperSelectionScreen({super.key});

  final StepperSelectionController controller = Get.put(StepperSelectionController());

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06; // 6% del ancho de pantalla
    final verticalSpacing = screenHeight * 0.03; // 3% de la altura de pantalla
    final titleFontSize = screenWidth * 0.045; // 4.5% del ancho para el título pequeño
    final mainTitleFontSize = screenWidth * 0.065; // 6.5% del ancho para el título principal
    final subtitleFontSize = screenWidth * 0.035; // 3.5% del ancho para subtítulos
    final helpFontSize = screenWidth * 0.035; // 3.5% del ancho para texto de ayuda
    final iconSize = screenWidth * 0.08; // 8% del ancho para iconos
    final arrowIconSize = screenWidth * 0.05; // 5% del ancho para iconos de flecha
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con título
              SizedBox(height: verticalSpacing * 2),
              Text(
                "Let's get you started!",
                style: GoogleFonts.poppins(
                  fontSize: titleFontSize,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: verticalSpacing * 0.5),
              Text(
                "What do you want?",
                style: GoogleFonts.poppins(
                  fontSize: mainTitleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              
              SizedBox(height: verticalSpacing * 3),
              
              // Opción WORK
              Obx(() => StepperSelectionCard(
                title: "WORK",
                subtitle: "Looking for a job",
                icon: Icons.work,
                onTap: controller.handleWorkSelection,
                iconSize: iconSize,
                arrowIconSize: arrowIconSize,
                subtitleFontSize: subtitleFontSize,
                flavor: controller.currentFlavor.value,
              )),
              
              SizedBox(height: verticalSpacing * 1.5),
              
              // Opción HIRE
              Obx(() => StepperSelectionCard(
                title: "HIRE",
                subtitle: "Connect with sport proffesionals ",
                icon: Icons.person_add,
                onTap: controller.handleHireSelection,
                iconSize: iconSize,
                arrowIconSize: arrowIconSize,
                subtitleFontSize: subtitleFontSize,
                flavor: controller.currentFlavor.value,
              )),
              
              SizedBox(height: verticalSpacing * 3),
              
              // Footer con ayuda - ahora debajo de las cards
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not sure? ",
                      style: GoogleFonts.poppins(
                        fontSize: helpFontSize,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.handleGetHelp,
                      child: Text(
                        "Get help",
                        style: GoogleFonts.poppins(
                          fontSize: helpFontSize,
                          color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
