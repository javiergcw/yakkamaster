import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../../../../config/constants.dart';

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
                          "Builder",
                          style: GoogleFonts.poppins(
                            fontSize: titleFontSize * 0.8,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Company Owner",
                          style: GoogleFonts.poppins(
                            fontSize: bodyFontSize * 0.9,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Close Button
                  GestureDetector(
                    onTap: onClose,
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: iconSize,
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
                        onClose();
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
                        onClose();
                      },
                      horizontalPadding: horizontalPadding,
                      verticalSpacing: verticalSpacing,
                      bodyFontSize: bodyFontSize,
                      iconSize: iconSize,
                    ),
                    
                    // Separator
                    _buildSeparator(horizontalPadding, verticalSpacing),
                    
                    // Post a job
                    _buildMenuItem(
                      icon: Icons.add_circle,
                      title: "Post a job",
                      onTap: () {
                        // TODO: Implementar navegación
                        print('Post a job pressed');
                        onClose();
                      },
                      horizontalPadding: horizontalPadding,
                      verticalSpacing: verticalSpacing,
                      bodyFontSize: bodyFontSize,
                      iconSize: iconSize,
                    ),
                    
                    // Manage jobs
                    _buildMenuItem(
                      icon: Icons.work,
                      title: "Manage jobs",
                      onTap: () {
                        // TODO: Implementar navegación
                        print('Manage jobs pressed');
                        onClose();
                      },
                      horizontalPadding: horizontalPadding,
                      verticalSpacing: verticalSpacing,
                      bodyFontSize: bodyFontSize,
                      iconSize: iconSize,
                    ),
                    
                    // Staff management
                    _buildMenuItem(
                      icon: Icons.people,
                      title: "Staff management",
                      onTap: () {
                        // TODO: Implementar navegación
                        print('Staff management pressed');
                        onClose();
                      },
                      horizontalPadding: horizontalPadding,
                      verticalSpacing: verticalSpacing,
                      bodyFontSize: bodyFontSize,
                      iconSize: iconSize,
                    ),
                    
                    // Job sites
                    _buildMenuItem(
                      icon: Icons.location_on,
                      title: "Job sites",
                      onTap: () {
                        // TODO: Implementar navegación
                        print('Job sites pressed');
                        onClose();
                      },
                      horizontalPadding: horizontalPadding,
                      verticalSpacing: verticalSpacing,
                      bodyFontSize: bodyFontSize,
                      iconSize: iconSize,
                    ),
                    
                    // Separator
                    _buildSeparator(horizontalPadding, verticalSpacing),
                    
                    // Invoices & payments
                    _buildMenuItem(
                      icon: Icons.receipt,
                      title: "Invoices & payments",
                      onTap: () {
                        // TODO: Implementar navegación
                        print('Invoices & payments pressed');
                        onClose();
                      },
                      horizontalPadding: horizontalPadding,
                      verticalSpacing: verticalSpacing,
                      bodyFontSize: bodyFontSize,
                      iconSize: iconSize,
                    ),
                    
                    // Expenses
                    _buildMenuItem(
                      icon: Icons.account_balance_wallet,
                      title: "Expenses",
                      onTap: () {
                        // TODO: Implementar navegación
                        print('Expenses pressed');
                        onClose();
                      },
                      horizontalPadding: horizontalPadding,
                      verticalSpacing: verticalSpacing,
                      bodyFontSize: bodyFontSize,
                      iconSize: iconSize,
                    ),
                    
                    // Separator
                    _buildSeparator(horizontalPadding, verticalSpacing),
                    
                    // Messages
                    _buildMenuItem(
                      icon: Icons.message,
                      title: "Messages",
                      onTap: () {
                        // TODO: Implementar navegación
                        print('Messages pressed');
                        onClose();
                      },
                      horizontalPadding: horizontalPadding,
                      verticalSpacing: verticalSpacing,
                      bodyFontSize: bodyFontSize,
                      iconSize: iconSize,
                    ),
                    
                    // Notifications
                    _buildMenuItem(
                      icon: Icons.notifications,
                      title: "Notifications",
                      onTap: () {
                        // TODO: Implementar navegación
                        print('Notifications pressed');
                        onClose();
                      },
                      horizontalPadding: horizontalPadding,
                      verticalSpacing: verticalSpacing,
                      bodyFontSize: bodyFontSize,
                      iconSize: iconSize,
                    ),
                    
                    // Separator
                    _buildSeparator(horizontalPadding, verticalSpacing),
                    
                    // Report a problem
                    _buildMenuItem(
                      icon: Icons.warning,
                      title: "Report a problem",
                      onTap: () async {
                        try {
                          final Uri url = Uri.parse(AppConstants.reportHarassmentUrl);
                          final bool launched = await launchUrl(
                            url,
                            mode: LaunchMode.platformDefault,
                          );
                          
                          if (!launched) {
                            _showUrlDialog(context, AppConstants.reportHarassmentUrl);
                          }
                        } catch (e) {
                          print('Error launching URL: $e');
                          _showUrlDialog(context, AppConstants.reportHarassmentUrl);
                        }
                        onClose();
                      },
                      horizontalPadding: horizontalPadding,
                      verticalSpacing: verticalSpacing,
                      bodyFontSize: bodyFontSize,
                      iconSize: iconSize,
                    ),
                    
                    // Terms and conditions
                    _buildMenuItem(
                      icon: Icons.description,
                      title: "Terms and conditions",
                      onTap: () async {
                        try {
                          final Uri url = Uri.parse(AppConstants.termsAndConditionsUrl);
                          final bool launched = await launchUrl(
                            url,
                            mode: LaunchMode.platformDefault,
                          );
                          
                          if (!launched) {
                            _showUrlDialog(context, AppConstants.termsAndConditionsUrl);
                          }
                        } catch (e) {
                          print('Error launching URL: $e');
                          _showUrlDialog(context, AppConstants.termsAndConditionsUrl);
                        }
                        onClose();
                      },
                      horizontalPadding: horizontalPadding,
                      verticalSpacing: verticalSpacing,
                      bodyFontSize: bodyFontSize,
                      iconSize: iconSize,
                    ),
                    
                    // Privacy policy
                    _buildMenuItem(
                      icon: Icons.privacy_tip,
                      title: "Privacy policy",
                      onTap: () {
                        // TODO: Implementar navegación a privacy policy
                        print('Privacy policy pressed');
                        onClose();
                      },
                      horizontalPadding: horizontalPadding,
                      verticalSpacing: verticalSpacing,
                      bodyFontSize: bodyFontSize,
                      iconSize: iconSize,
                    ),
                    
                    // Separator
                    _buildSeparator(horizontalPadding, verticalSpacing),
                    
                    // Logout
                    _buildMenuItem(
                      icon: Icons.logout,
                      title: "Logout",
                      onTap: () {
                        // TODO: Implementar logout
                        print('Logout pressed');
                        onClose();
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalSpacing,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.grey[700],
              size: iconSize,
            ),
            SizedBox(width: horizontalPadding),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
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

  void _showUrlDialog(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('URL no disponible'),
          content: Text('No se pudo abrir: $url'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
