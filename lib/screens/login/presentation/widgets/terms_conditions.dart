import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/app_flavor.dart';
import '../../../../config/assets_config.dart';

class TermsConditions extends StatelessWidget {
  final AppFlavor? flavor;
  final String? termsText;
  final String? privacyText;

  const TermsConditions({
    super.key,
    this.flavor,
    this.termsText,
    this.privacyText,
  });

  AppFlavor get _currentFlavor => flavor ?? AppFlavorConfig.currentFlavor;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    
    // Calcular valores responsive
    final fontSize = screenWidth * 0.035; // 3.5% del ancho para el tamaño de fuente
    
    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          color: Colors.grey[600],
        ),
        children: [
          const TextSpan(text: 'By registering, you accept our '),
          TextSpan(
            text: termsText ?? 'Terms and Condition',
            style: TextStyle(
              color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
              fontWeight: FontWeight.w500,
            ),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: privacyText ?? 'Privacy Policy',
            style: TextStyle(
              color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
