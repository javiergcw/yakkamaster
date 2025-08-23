import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/app_flavor.dart';
import '../../../../config/assets_config.dart';

class LoginHeader extends StatelessWidget {
  final AppFlavor? flavor;
  final double? topPadding;

  const LoginHeader({
    super.key,
    this.flavor,
    this.topPadding,
  });

  AppFlavor get _currentFlavor => flavor ?? AppFlavorConfig.currentFlavor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: topPadding ?? 40),
        // Greeting
        Text(
          AppFlavorConfig.getLoginGreeting(_currentFlavor),
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        // Subtitle
        Text(
          AppFlavorConfig.getLoginSubtitle(_currentFlavor),
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
