import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';

class StepperSelectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final double iconSize;
  final double arrowIconSize;
  final double subtitleFontSize;
  final AppFlavor? flavor;

  const StepperSelectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    required this.iconSize,
    required this.arrowIconSize,
    required this.subtitleFontSize,
    this.flavor,
  });

  AppFlavor get _currentFlavor => flavor ?? AppFlavorConfig.currentFlavor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            top: BorderSide(
              color: Colors.black.withOpacity(0.9),
              width: 1,
            ),
            left: BorderSide(
              color: Colors.black.withOpacity(0.9),
              width: 1,
            ),
            right: BorderSide(
              color: Colors.black.withOpacity(0.9),
              width: 3,
            ),
            bottom: BorderSide(
              color: Colors.black.withOpacity(0.9),
              width: 3,
            ),
          ),
          boxShadow: [
            // Sombra para efecto de elevación en todos los lados
            BoxShadow(
              color: Colors.black.withOpacity(0.8),
              blurRadius: 0,
              offset: const Offset(3, 3),
              spreadRadius: 0,
            ),
            // Sombra adicional para mayor grosor
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 0,
              offset: const Offset(2, 2),
              spreadRadius: 0,
            ),
            // Sombra sutil para completar el efecto
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 0,
              offset: const Offset(1, 1),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            // Icono circular con color del flavor
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: iconSize * 0.6,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Texto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: subtitleFontSize * 1.2,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: subtitleFontSize,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            
            // Flecha
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black87,
              size: arrowIconSize,
            ),
          ],
        ),
      ),
    );
  }
}
