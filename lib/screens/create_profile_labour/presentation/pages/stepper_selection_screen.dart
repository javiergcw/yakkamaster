import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/app_flavor.dart';
import '../../../../config/assets_config.dart';
import '../widgets/stepper_selection_card.dart';
import 'industry_selection_screen.dart';

class StepperSelectionScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const StepperSelectionScreen({
    super.key,
    this.flavor,
  });

  @override
  State<StepperSelectionScreen> createState() => _StepperSelectionScreenState();
}

class _StepperSelectionScreenState extends State<StepperSelectionScreen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;

  void _handleWorkSelection() {
    // Navegar al siguiente paso del stepper para WORK
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => IndustrySelectionScreen(flavor: _currentFlavor),
      ),
    );
  }

  void _handleHireSelection() {
    // Navegar al siguiente paso del stepper para HIRE
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Hire flow coming soon!')),
    );
  }

  void _handleGetHelp() {
    // Mostrar ayuda
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Help section coming soon!')),
    );
  }

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
              StepperSelectionCard(
                title: "WORK",
                subtitle: "Looking for a job now",
                icon: Icons.work,
                onTap: _handleWorkSelection,
                iconSize: iconSize,
                arrowIconSize: arrowIconSize,
                subtitleFontSize: subtitleFontSize,
                flavor: _currentFlavor,
              ),
              
              SizedBox(height: verticalSpacing * 1.5),
              
              // Opción HIRE
              StepperSelectionCard(
                title: "HIRE",
                subtitle: "Connect with trusted labourers today",
                icon: Icons.person_add,
                onTap: _handleHireSelection,
                iconSize: iconSize,
                arrowIconSize: arrowIconSize,
                subtitleFontSize: subtitleFontSize,
                flavor: _currentFlavor,
              ),
              
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
                      onTap: _handleGetHelp,
                      child: Text(
                        "Get help",
                        style: GoogleFonts.poppins(
                          fontSize: helpFontSize,
                          color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
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
