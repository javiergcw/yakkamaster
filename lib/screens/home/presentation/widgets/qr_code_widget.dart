import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class QrCodeWidget extends StatelessWidget {
  final String data;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const QrCodeWidget({
    super.key,
    required this.data,
    this.size = 200,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final qrSize = size * (screenWidth / 375); // Responsive sizing

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300] ?? Colors.grey,
          width: 1,
        ),
      ),
      child: QrImageView(
        data: data,
        version: QrVersions.auto,
        size: qrSize,
        backgroundColor: backgroundColor ?? Colors.white,
        foregroundColor: foregroundColor ?? Colors.black,
        errorCorrectionLevel: QrErrorCorrectLevel.M,
      ),
    );
  }
}
