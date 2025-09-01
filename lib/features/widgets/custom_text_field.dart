import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_flavor.dart';
import '../../config/assets_config.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final VoidCallback? onTap;
  final AppFlavor? flavor;
  final bool showBorder;
  final double? borderRadius;

  const CustomTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.onTap,
    this.flavor,
    this.showBorder = true,
    this.borderRadius,
  });

  AppFlavor get _currentFlavor => flavor ?? AppFlavorConfig.currentFlavor;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final fontSize = screenWidth * 0.04; // 4% del ancho para el tamaño de fuente
    final horizontalPadding = screenWidth * 0.04; // 4% del ancho para padding horizontal
    final verticalPadding = screenHeight * 0.015; // 1.5% de la altura para padding vertical
    final defaultBorderRadius = borderRadius ?? 12.0;
    
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      onTap: onTap,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: showBorder,
        fillColor: showBorder ? Colors.grey[50] : Colors.transparent,
        border: showBorder ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ) : InputBorder.none,
        enabledBorder: showBorder ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ) : InputBorder.none,
        focusedBorder: showBorder ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          borderSide: BorderSide(
            color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
            width: 2,
          ),
        ) : InputBorder.none,
        errorBorder: showBorder ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          borderSide: BorderSide(
            color: Colors.red[400]!,
            width: 1,
          ),
        ) : InputBorder.none,
        focusedErrorBorder: showBorder ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          borderSide: BorderSide(
            color: Colors.red[400]!,
            width: 2,
          ),
        ) : InputBorder.none,
        hintStyle: GoogleFonts.poppins(
          fontSize: fontSize,
          color: Colors.grey[500],
        ),
        labelStyle: GoogleFonts.poppins(
          fontSize: fontSize,
          color: Colors.grey[600],
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
      ),
    );
  }
}
