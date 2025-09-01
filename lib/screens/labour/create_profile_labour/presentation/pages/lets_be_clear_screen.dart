import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../../../../features/widgets/custom_button.dart';
import 'profile_created_screen.dart';

class LetsBeClearScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const LetsBeClearScreen({
    super.key,
    this.flavor,
  });

  @override
  State<LetsBeClearScreen> createState() => _LetsBeClearScreenState();
}

class _LetsBeClearScreenState extends State<LetsBeClearScreen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;

  void _handleAccept() {
    // Navegar a la pantalla de perfil creado después de aceptar los términos
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => ProfileCreatedScreen(flavor: _currentFlavor)),
        (route) => false, // Esto elimina todas las rutas anteriores del stack
      );
    }
  }

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
                    onPressed: () {
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    },
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
                     SizedBox(height: verticalSpacing * 2),
                     
                     // Logo de YAKKA
                     Center(
                       child: Container(
                         width: logoSize,
                         height: logoSize,
                         child: SvgPicture.asset(
                           AssetsConfig.getLogoMiddle(_currentFlavor),
                           fit: BoxFit.contain,
                         ),
                       ),
                     ),
                     
                     SizedBox(height: verticalSpacing * 1.5),
                     
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
                     
                     SizedBox(height: verticalSpacing * 1.2),
                     
                     // Texto descriptivo
                     Text(
                       "We connect people — we don't manage, hire, or supervise.",
                       textAlign: TextAlign.center,
                       style: GoogleFonts.poppins(
                         fontSize: bodyFontSize * 1.2,
                         color: Colors.grey[700],
                         height: 1.4,
                       ),
                     ),
                     
                     SizedBox(height: verticalSpacing * 2),
                     
                     // Sección de disclaimer
                     Align(
                       alignment: Alignment.centerLeft,
                       child: Text(
                         "YAKKA is not responsible for:",
                         textAlign: TextAlign.left,
                         style: GoogleFonts.poppins(
                           fontSize: bodyFontSize * 1.1,
                           fontWeight: FontWeight.bold,
                           color: Colors.black87,
                           height: 1.2,
                         ),
                       ),
                     ),
                     
                     SizedBox(height: verticalSpacing * 2),
                     
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
                           height: verticalSpacing * 2,
                           thickness: 1,
                         ),
                         _buildNumberedItem(
                           "2",
                           "Work conditions, payments, safety, or disputes.",
                           bodyFontSize,
                         ),
                         Divider(
                           color: Colors.grey[300],
                           height: verticalSpacing * 2,
                           thickness: 1,
                         ),
                         _buildNumberedItem(
                           "3",
                           "Hiring decisions or outcomes — we do not employ workers.",
                           bodyFontSize,
                         ),
                       ],
                     ),
                     
                     SizedBox(height: verticalSpacing * 4),
                     
                     // Botón de aceptación usando CustomButton
                     SizedBox(
                       height: 60,
                       child: CustomButton(
                         text: "I understand and accept",
                         onPressed: mounted ? _handleAccept : null,
                         isLoading: false,
                         showShadow: false,
                       ),
                     ),
                     
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
