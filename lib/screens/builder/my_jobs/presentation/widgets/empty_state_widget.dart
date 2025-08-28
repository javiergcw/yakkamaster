import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';

class EmptyStateWidget extends StatelessWidget {
  final AppFlavor? flavor;
  final VoidCallback? onPostJob;

  const EmptyStateWidget({
    super.key,
    this.flavor,
    this.onPostJob,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icono principal
          Container(
            width: screenWidth * 0.25,
            height: screenWidth * 0.25,
            decoration: BoxDecoration(
              color: Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor)),
              borderRadius: BorderRadius.circular(screenWidth * 0.125),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Icono de clipboard
                Icon(
                  Icons.assignment,
                  size: screenWidth * 0.12,
                  color: Colors.black,
                ),
                // Icono de persona superpuesto
                Positioned(
                  bottom: screenWidth * 0.02,
                  right: screenWidth * 0.02,
                  child: Icon(
                    Icons.person,
                    size: screenWidth * 0.08,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.04),

          // Título principal
          Text(
            "You don't have any job yet",
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: screenHeight * 0.02),

          // Descripción
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: Text(
              "Get the right hands on deck. Post or update your job listings to find skilled workers ready to start.",
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                color: Colors.black87,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: screenHeight * 0.06),

          // Botón de acción
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPostJob,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor)),
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Post or Update a Job",
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
