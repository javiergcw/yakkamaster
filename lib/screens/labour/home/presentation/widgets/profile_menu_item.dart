import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/assets_config.dart';
import '../../../../../config/app_flavor.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final AppFlavor? flavor;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.flavor,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.04;
    final iconSize = screenWidth * 0.045;
    final circleSize = screenWidth * 0.11;
    final currentFlavor = flavor ?? AppFlavorConfig.currentFlavor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding * 0.8,
          vertical: verticalSpacing * 0.8,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[700]!,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // Círculo amarillo con icono blanco
            Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor)),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: iconSize,
                color: Colors.white,
              ),
            ),
            
            SizedBox(width: horizontalPadding),
            
            // Texto del menú
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            
            // Flecha gris
            Icon(
              Icons.chevron_right,
              size: iconSize * 1.2,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
