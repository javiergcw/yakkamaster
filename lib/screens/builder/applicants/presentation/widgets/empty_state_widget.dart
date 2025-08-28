import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../config/app_flavor.dart';

class EmptyStateWidget extends StatelessWidget {
  final AppFlavor? flavor;
  final VoidCallback onPostJob;

  const EmptyStateWidget({
    super.key,
    this.flavor,
    required this.onPostJob,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final iconSize = screenWidth * 0.2;
    final titleFontSize = screenWidth * 0.05;
    final bodyFontSize = screenWidth * 0.04;
    final buttonFontSize = screenWidth * 0.04;
    final horizontalPadding = screenWidth * 0.05;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor)),
                borderRadius: BorderRadius.circular(iconSize * 0.2),
              ),
              child: Icon(
                Icons.person_add,
                size: iconSize * 0.5,
                color: Colors.white,
              ),
            ),
            
            SizedBox(height: screenHeight * 0.04),
            
            // Título
            Text(
              'You have no applicants\nfor your jobs',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
            
            SizedBox(height: screenHeight * 0.03),
            
            // Descripción
            Text(
              'Get the right hands on deck.\nPost or update your job listings\nto find skilled workers ready to start.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: bodyFontSize,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            
            SizedBox(height: screenHeight * 0.05),
            
            // Botón de acción
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPostJob,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor)),
                  foregroundColor: Colors.black87,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Post or Update a Job',
                  style: GoogleFonts.poppins(
                    fontSize: buttonFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
