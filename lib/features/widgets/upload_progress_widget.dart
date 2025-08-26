import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadProgressWidget extends StatelessWidget {
  final double progress;
  final String fileName;
  final VoidCallback? onCancel;

  const UploadProgressWidget({
    super.key,
    required this.progress,
    required this.fileName,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      margin: EdgeInsets.all(screenWidth * 0.02),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.upload_file,
                color: Colors.blue[600],
                size: screenWidth * 0.05,
              ),
              SizedBox(width: screenWidth * 0.02),
              Expanded(
                child: Text(
                  'Subiendo: $fileName',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[800],
                  ),
                ),
              ),
              if (onCancel != null)
                GestureDetector(
                  onTap: onCancel,
                  child: Icon(
                    Icons.close,
                    color: Colors.red[600],
                    size: screenWidth * 0.04,
                  ),
                ),
            ],
          ),
          SizedBox(height: screenWidth * 0.02),
          LinearProgressIndicator(
            value: progress / 100,
            backgroundColor: Colors.blue[200],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
          ),
          SizedBox(height: screenWidth * 0.01),
          Text(
            '${progress.round()}% completado',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.03,
              color: Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }
}
