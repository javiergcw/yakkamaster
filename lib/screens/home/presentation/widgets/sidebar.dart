import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/app_flavor.dart';
import '../../../../config/assets_config.dart';
import '../../../job_listings/presentation/pages/job_listings_screen.dart';

class Sidebar extends StatelessWidget {
  final AppFlavor? flavor;
  final VoidCallback onClose;

  const Sidebar({
    super.key,
    this.flavor,
    required this.onClose,
  });

  AppFlavor get _currentFlavor => flavor ?? AppFlavorConfig.currentFlavor;

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

    return Material(
      color: Colors.white,
      child: Container(
        width: screenWidth * 0.85, // 85% del ancho de la pantalla
        height: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            // Header Section (Dark Grey)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing * 2,
              ),
              decoration: BoxDecoration(
                color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
              ),
              child: Row(
                children: [
                  // Profile Image
                  Container(
                    width: screenWidth * 0.15,
                    height: screenWidth * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: screenWidth * 0.08,
                    ),
                  ),
                  
                  SizedBox(width: horizontalPadding),
                  
                  // User Information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "testing",
                          style: GoogleFonts.poppins(
                            fontSize: titleFontSize * 0.9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: verticalSpacing * 0.3),
                        Text(
                          "testing22@gmail.com",
                          style: GoogleFonts.poppins(
                            fontSize: bodyFontSize * 0.9,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Menu Items Section
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: verticalSpacing),
                child: Column(
                  children: [
                    // Home
                    _buildMenuItem(
                      icon: Icons.home,
                      title: "Home",
                      onTap: () {
                        // TODO: Implementar navegación
                        print('Home pressed');
                      },
                      horizontalPadding: horizontalPadding,
                      verticalSpacing: verticalSpacing,
                      bodyFontSize: bodyFontSize,
                      iconSize: iconSize,
                    ),
                    
                    // Edit account
                    _buildMenuItem(
                      icon: Icons.edit,
                      title: "Edit account",
                      onTap: () {
                        // TODO: Implementar navegación
                        print('Edit account pressed');
                      },
                      horizontalPadding: horizontalPadding,
                      verticalSpacing: verticalSpacing,
                      bodyFontSize: bodyFontSize,
                      iconSize: iconSize,
                    ),
                    
                    // Separator
                    _buildSeparator(horizontalPadding, verticalSpacing),
                    
                                                            // Apply for job
                    _buildMenuItem(
                      icon: Icons.search,
                      title: "Apply for job",
                      onTap: () {
                        // Navegar a job listings
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => JobListingsScreen(flavor: _currentFlavor),
                          ),
                        );
                        // Cerrar sidebar antes de navegar
                        onClose();
                      },
                      horizontalPadding: horizontalPadding,
                      verticalSpacing: verticalSpacing,
                      bodyFontSize: bodyFontSize,
                      iconSize: iconSize,
                    ),
                    
                    // My chats
                    _buildMenuItem(
                      icon: Icons.chat_bubble_outline,
                      title: "My chats",
                      onTap: () {
                        // TODO: Implementar navegación
                        print('My chats pressed');
                      },
                      horizontalPadding: horizontalPadding,
                      verticalSpacing: verticalSpacing,
                      bodyFontSize: bodyFontSize,
                      iconSize: iconSize,
                    ),
                    
                    // Applications
                    _buildMenuItem(
                      icon: Icons.calendar_today,
                      title: "Applications",
                      onTap: () {
                        // TODO: Implementar navegación
                        print('Applications pressed');
                      },
                      horizontalPadding: horizontalPadding,
                      verticalSpacing: verticalSpacing,
                      bodyFontSize: bodyFontSize,
                      iconSize: iconSize,
                    ),
                    
                    // See your earnings
                    _buildMenuItem(
                      icon: Icons.attach_money,
                      title: "See your earnings",
                      onTap: () {
                        // TODO: Implementar navegación
                        print('See your earnings pressed');
                      },
                      horizontalPadding: horizontalPadding,
                      verticalSpacing: verticalSpacing,
                      bodyFontSize: bodyFontSize,
                      iconSize: iconSize,
                    ),
                    
                    // Report a problem
                    _buildMenuItem(
                      icon: Icons.warning,
                      title: "Report a problem",
                      onTap: () {
                        // TODO: Implementar navegación
                        print('Report a problem pressed');
                      },
                      horizontalPadding: horizontalPadding,
                      verticalSpacing: verticalSpacing,
                      bodyFontSize: bodyFontSize,
                      iconSize: iconSize,
                    ),
                    
                    // Worksheets
                    _buildMenuItem(
                      icon: Icons.description,
                      title: "Worksheets",
                      onTap: () {
                        // TODO: Implementar navegación
                        print('Worksheets pressed');
                      },
                      horizontalPadding: horizontalPadding,
                      verticalSpacing: verticalSpacing,
                      bodyFontSize: bodyFontSize,
                      iconSize: iconSize,
                    ),
                    
                    // Separator
                    _buildSeparator(horizontalPadding, verticalSpacing),
                    
                    // Terms and conditions
                    _buildMenuItem(
                      icon: Icons.security,
                      title: "Terms and conditions",
                      onTap: () {
                        // TODO: Implementar navegación
                        print('Terms and conditions pressed');
                      },
                      horizontalPadding: horizontalPadding,
                      verticalSpacing: verticalSpacing,
                      bodyFontSize: bodyFontSize,
                      iconSize: iconSize,
                    ),
                    
                    // Delete account
                    _buildMenuItem(
                      icon: Icons.delete_forever,
                      title: "Delete account",
                      onTap: () {
                        // TODO: Implementar navegación
                        print('Delete account pressed');
                      },
                      horizontalPadding: horizontalPadding,
                      verticalSpacing: verticalSpacing,
                      bodyFontSize: bodyFontSize,
                      iconSize: iconSize,
                    ),
                    
                    // Logout
                    _buildMenuItem(
                      icon: Icons.logout,
                      title: "Logout",
                      onTap: () {
                        // TODO: Implementar navegación
                        print('Logout pressed');
                      },
                      horizontalPadding: horizontalPadding,
                      verticalSpacing: verticalSpacing,
                      bodyFontSize: bodyFontSize,
                      iconSize: iconSize,
                    ),
                  ],
                ),
              ),
            ),
            
            // Footer Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing,
              ),
              child: Text(
                "Version 2.1",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize * 0.8,
                  color: Colors.grey[500],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required double horizontalPadding,
    required double verticalSpacing,
    required double bodyFontSize,
    required double iconSize,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalSpacing * 1.2,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: iconSize,
              color: Colors.grey[700],
            ),
            SizedBox(width: horizontalPadding),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeparator(double horizontalPadding, double verticalSpacing) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalSpacing * 0.5,
      ),
      height: 1,
      color: Colors.grey[300],
    );
  }
}
