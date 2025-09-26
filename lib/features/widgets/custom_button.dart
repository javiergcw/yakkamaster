import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/app_flavor.dart';
import '../../../config/assets_config.dart';

enum ButtonType { primary, secondary, outline }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final String? iconAsset;
  final bool isLoading;
  final double? width;
  final double? height;
  final AppFlavor? flavor;
  final bool showShadow;
  final Border? customBorder;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.iconAsset,
    this.isLoading = false,
    this.width,
    this.height,
    this.flavor,
    this.showShadow = true,
    this.customBorder,
  });

  AppFlavor get _currentFlavor => flavor ?? AppFlavorConfig.currentFlavor;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    // Calcular valores responsive
    final buttonHeight = height ?? (screenHeight * 0.065); // 6.5% de la altura
    final iconSize =
        screenWidth * 0.05; // 5% del ancho para el tamaño del icono

    return SizedBox(
      width: width ?? double.infinity,
      height: buttonHeight,
      child: customBorder != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
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
                      width: 4,
                    ),
                    bottom: BorderSide(
                      color: Colors.black.withOpacity(0.9),
                      width: 4,
                    ),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: isLoading ? null : onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getBackgroundColor(),
                    foregroundColor: _getForegroundColor(),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide.none,
                    ),
                  ),
                  child: _buildButtonContent(context, screenWidth, iconSize),
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: (type == ButtonType.primary && showShadow)
                    ? [
                        BoxShadow(
                          color: const Color(0xFF000000),
                          offset: const Offset(0, 8),
                          blurRadius: 20,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getBackgroundColor(),
                  foregroundColor: _getForegroundColor(),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: _getBorderSide(),
                  ),
                ),
                child: _buildButtonContent(context, screenWidth, iconSize),
              ),
            ),
    );
  }

  Widget _buildButtonContent(
    BuildContext context,
    double screenWidth,
    double iconSize,
  ) {
    final fontSize = screenWidth * 0.04;

    return isLoading
        ? SizedBox(
            width: screenWidth * 0.05,
            height: screenWidth * 0.05,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(_getForegroundColor()),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null || iconAsset != null) ...[
                if (icon != null)
                  Icon(icon, size: iconSize)
                else if (iconAsset != null)
                  Image.asset(
                    iconAsset!,
                    width: iconSize,
                    height: iconSize,
                    fit: BoxFit.contain,
                  ),
               // Espacio reducido
              ],
              Spacer(),
              Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: _getForegroundColor(),
                ),
              ),
              Spacer(),
            ],
          );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case ButtonType.primary:
        return Color(AppFlavorConfig.getPrimaryColor(_currentFlavor));
      case ButtonType.secondary:
        return AppFlavorConfig.getJoinBackgroundColor(_currentFlavor);
      case ButtonType.outline:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor() {
    switch (type) {
      case ButtonType.primary:
        return Colors.white;
      case ButtonType.secondary:
        return Colors.white;
      case ButtonType.outline:
        return Colors.black;
    }
  }


  BorderSide _getBorderSide() {
    if (customBorder != null) {
      return BorderSide
          .none; // El borde personalizado se maneja en el Container
    }

    switch (type) {
      case ButtonType.primary:
      case ButtonType.secondary:
        return BorderSide.none;
      case ButtonType.outline:
        return BorderSide(
          color: Colors.black,
          width: 1.5,
        );
    }
  }
}
