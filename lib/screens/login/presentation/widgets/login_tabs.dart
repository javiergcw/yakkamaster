import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/app_flavor.dart';
import '../../../../config/assets_config.dart';

class LoginTabs extends StatelessWidget {
  final bool isLogin;
  final Function(bool) onTabChanged;
  final AppFlavor? flavor;

  const LoginTabs({
    super.key,
    required this.isLogin,
    required this.onTabChanged,
    this.flavor,
  });

  AppFlavor get _currentFlavor => flavor ?? AppFlavorConfig.currentFlavor;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    
    // Calcular valores responsive
    final fontSize = screenWidth * 0.045; // 4.5% del ancho para el tamaño de fuente
    final underlineHeight = 1.5; // Altura reducida de la línea de subrayado
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tab de Login
        GestureDetector(
          onTap: () => onTabChanged(true),
          child: Column(
            children: [
              Text(
                'Log in',
                style: GoogleFonts.poppins(
                  fontSize: fontSize,
                  fontWeight: isLogin ? FontWeight.bold : FontWeight.normal,
                  color: isLogin ? Colors.black87 : Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Container(
                width: screenWidth * 0.36, // Línea extremadamente ancha
                height: underlineHeight,
                decoration: BoxDecoration(
                  color: isLogin ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)) : Colors.transparent,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(width: screenWidth * 0.15), // Espaciado entre pestañas
        
        // Tab de Register
        GestureDetector(
          onTap: () => onTabChanged(false),
          child: Column(
            children: [
              Text(
                'Register',
                style: GoogleFonts.poppins(
                  fontSize: fontSize,
                  fontWeight: !isLogin ? FontWeight.bold : FontWeight.normal,
                  color: !isLogin ? Colors.black87 : Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Container(
                width: screenWidth * 0.36, // Línea extremadamente ancha
                height: underlineHeight,
                decoration: BoxDecoration(
                  color: !isLogin ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)) : Colors.transparent,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
