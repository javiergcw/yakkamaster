import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';

class UnderConstructionWidget extends StatelessWidget {
  final AppFlavor flavor;
  final String? customMessage;
  final double? avatarSize;
  final double? iconSize;

  const UnderConstructionWidget({
    super.key,
    required this.flavor,
    this.customMessage,
    this.avatarSize,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Calcular valores responsive
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.045;
    final bodyFontSize = screenWidth * 0.035;
    final avatarSizeValue = avatarSize ?? screenWidth * 0.2;
    final iconSizeValue = iconSize ?? screenWidth * 0.08;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          // Circle Avatar con icono de construcción
          Container(
            width: avatarSizeValue,
            height: avatarSizeValue,
            decoration: BoxDecoration(
              color: Color(AppFlavorConfig.getPrimaryColor(flavor)).withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(AppFlavorConfig.getPrimaryColor(flavor)),
                width: 3,
              ),
            ),
            child: Icon(
              Icons.construction,
              size: iconSizeValue,
              color: Color(AppFlavorConfig.getPrimaryColor(flavor)),
            ),
          ),

          SizedBox(height: verticalSpacing * 1.5),

          // Título principal
          Text(
            'Under Construction',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
          ),

          SizedBox(height: verticalSpacing * 0.8),

          // Mensaje descriptivo
          Text(
            customMessage ?? 
            'We are working hard to bring you an amazing experience. This feature will be available soon!',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: bodyFontSize,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),

          SizedBox(height: verticalSpacing * 1.2),

          // Indicador de progreso (opcional)
          Container(
            width: screenWidth * 0.3,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.6, // 60% de progreso
              child: Container(
                decoration: BoxDecoration(
                  color: Color(AppFlavorConfig.getPrimaryColor(flavor)),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          SizedBox(height: verticalSpacing * 0.8),

          // Texto de progreso
          Text(
            '60% Complete',
            style: GoogleFonts.poppins(
              fontSize: bodyFontSize * 0.85,
              fontWeight: FontWeight.w500,
              color: Color(AppFlavorConfig.getPrimaryColor(flavor)),
            ),
          ),
        ],
    );
  }
}
