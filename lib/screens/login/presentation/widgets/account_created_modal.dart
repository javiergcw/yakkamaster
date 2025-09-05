import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/app_flavor.dart';

class AccountCreatedModal extends StatelessWidget {
  final AppFlavor? flavor;
  final VoidCallback? onStartPressed;
  final VoidCallback? onClosePressed;

  const AccountCreatedModal({
    super.key,
    this.flavor,
    this.onStartPressed,
    this.onClosePressed,
  });


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06; // 6% del ancho
    final verticalPadding = screenHeight * 0.03; // 3% de la altura
    final titleFontSize = screenWidth * 0.06; // 6% del ancho para el título
    final bodyFontSize = screenWidth * 0.04; // 4% del ancho para el texto del cuerpo
    final buttonFontSize = screenWidth * 0.045; // 4.5% del ancho para el botón
    final iconSize = screenWidth * 0.06; // 6% del ancho para el icono de cerrar
    final borderRadius = screenWidth * 0.03; // 3% del ancho para el radio del borde

    return Container(
      width: double.infinity, // Toma todo el ancho de la pantalla
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar (línea gris en la parte superior)
          Container(
            width: screenWidth * 0.15, // 15% del ancho
            height: 4,
            margin: EdgeInsets.only(top: verticalPadding * 0.5),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Close button
          Positioned(
            top: verticalPadding * 0.5,
            right: horizontalPadding * 0.5,
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(
                  top: verticalPadding * 0.5,
                  right: horizontalPadding * 0.5,
                ),
                child: GestureDetector(
                  onTap: onClosePressed ?? () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.close,
                    size: iconSize,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Column(
              children: [
                // Title
                Text(
                  'Account created',
                  style: GoogleFonts.poppins(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: verticalPadding * 0.8),

                // Body text
                Column(
                  children: [
                    Text(
                      'Complete your profile to get hired faster.',
                      style: GoogleFonts.poppins(
                        fontSize: bodyFontSize,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: verticalPadding * 0.3),
                    Text(
                      'Takes 2 min.',
                      style: GoogleFonts.poppins(
                        fontSize: bodyFontSize,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                SizedBox(height: verticalPadding * 1.5),

                // Start button
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.065, // 6.5% de la altura
                  child: ElevatedButton(
                    onPressed: onStartPressed ?? () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Start',
                      style: GoogleFonts.poppins(
                        fontSize: buttonFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void show({
    required BuildContext context,
    AppFlavor? flavor,
    VoidCallback? onStartPressed,
    VoidCallback? onClosePressed,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AccountCreatedModal(
        flavor: flavor,
        onStartPressed: onStartPressed,
        onClosePressed: onClosePressed,
      ),
    );
  }
}
