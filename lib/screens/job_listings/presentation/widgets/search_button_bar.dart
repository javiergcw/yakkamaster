import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/app_flavor.dart';

class SearchButtonBar extends StatelessWidget {
  final String placeholder;
  final VoidCallback onTap;
  final double horizontalPadding;
  final double verticalSpacing;
  final double bodyFontSize;
  final double iconSize;
  final AppFlavor? flavor;

  const SearchButtonBar({
    super.key,
    required this.placeholder,
    required this.onTap,
    required this.horizontalPadding,
    required this.verticalSpacing,
    required this.bodyFontSize,
    required this.iconSize,
    this.flavor,
  });

  AppFlavor get _currentFlavor => flavor ?? AppFlavorConfig.currentFlavor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: verticalSpacing * 0.5),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: verticalSpacing * 1.8,
          width: horizontalPadding * 14, // Hacer el botón un poco más ancho
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 1),
                blurRadius: 3,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding * 0.5,
              vertical: verticalSpacing * 0.2,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    placeholder,
                    style: GoogleFonts.poppins(
                      fontSize: bodyFontSize,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                Container(
                  height: double.infinity, // El icono toma todo el alto
                  width: verticalSpacing * 1.4, // Ancho fijo para el icono
                  decoration: BoxDecoration(
                    color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: IconButton(
                    onPressed: onTap,
                    icon: Icon(
                      Icons.search,
                      size: iconSize,
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: verticalSpacing * 1.4,
                      minHeight: verticalSpacing * 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
