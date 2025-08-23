import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/app_flavor.dart';
import '../../../../config/assets_config.dart';
import '../../../../features/widgets/custom_button.dart';
import '../../../home/presentation/pages/home_screen.dart';
import '../../../job_listings/presentation/pages/job_listings_screen.dart';

class ProfileCreatedScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const ProfileCreatedScreen({
    super.key,
    this.flavor,
  });

  @override
  State<ProfileCreatedScreen> createState() => _ProfileCreatedScreenState();
}

class _ProfileCreatedScreenState extends State<ProfileCreatedScreen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;

  void _handleExploreYakka() {
    // Navegar a la pantalla home de YAKKA
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen(flavor: _currentFlavor)),
    );
  }

  void _handleApplyForJob() {
    // Navegar a la pantalla de job listings
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => JobListingsScreen(flavor: _currentFlavor),
      ),
    );
  }

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

    return Scaffold(
      backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
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
              
              SizedBox(height: verticalSpacing * 2),
              
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
                      color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _handleExploreYakka,
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
                        onTap: _handleApplyForJob,
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
    );
  }
}
