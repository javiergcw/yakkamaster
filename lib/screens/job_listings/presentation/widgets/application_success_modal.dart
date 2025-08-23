import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/app_flavor.dart';
import '../../../../config/assets_config.dart';
import '../../data/dto/job_details_dto.dart';

class ApplicationSuccessModal extends StatelessWidget {
  final JobDetailsDto jobDetails;
  final AppFlavor? flavor;
  final VoidCallback onClose;
  final VoidCallback onViewAppliedJobs;

  const ApplicationSuccessModal({
    super.key,
    required this.jobDetails,
    required this.onClose,
    required this.onViewAppliedJobs,
    this.flavor,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final bodyFontSize = screenWidth * 0.035;
    final iconSize = screenWidth * 0.06;

    final _currentFlavor = flavor ?? AppFlavorConfig.currentFlavor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header con botón de cerrar
            Container(
              padding: EdgeInsets.all(horizontalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40), // Espacio para centrar el título
                  Expanded(
                    child: Center(
                      child: Text(
                        'Application Submitted',
                        style: GoogleFonts.poppins(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onClose,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: verticalSpacing),
            
            // Subtítulo
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                'Wait until the company replies',
                style: GoogleFonts.poppins(
                  fontSize: titleFontSize * 0.9,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            SizedBox(height: verticalSpacing * 2),
            
            // Texto descriptivo
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                'Your application for ${jobDetails.title} at ${jobDetails.company} ${jobDetails.address} ${jobDetails.suburb} has been submitted successfully. The hiring team will review your application and get back to you shortly. Good luck with your application!',
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            SizedBox(height: verticalSpacing * 3),
            
            // Botón "View Applied Jobs"
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onViewAppliedJobs,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                    foregroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(vertical: verticalSpacing * 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'View Applied Jobs',
                    style: GoogleFonts.poppins(
                      fontSize: bodyFontSize * 1.1,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
            
            SizedBox(height: verticalSpacing * 2),
          ],
        ),
      ),
    );
  }
}
