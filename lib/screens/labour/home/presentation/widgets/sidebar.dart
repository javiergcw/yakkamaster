import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../../../../config/constants.dart';
import '../../../../job_listings/presentation/pages/job_listings_screen.dart';
import '../pages/wallet_screen.dart';
import '../pages/applied_jobs_screen.dart';
import '../pages/notifications_screen.dart';
import '../pages/messages_screen.dart';
import '../../data/applied_job_dto.dart';

class Sidebar extends StatelessWidget {
  final AppFlavor? flavor;
  final VoidCallback onClose;

  const Sidebar({
    super.key,
    this.flavor,
    required this.onClose,
  });

  AppFlavor get _currentFlavor => flavor ?? AppFlavorConfig.currentFlavor;

  // Datos de ejemplo para las aplicaciones
  List<AppliedJobDto> get _appliedJobs => [
    AppliedJobDto(
      id: '1',
      companyName: 'ABC Construction',
      jobTitle: 'Construction Worker',
      location: 'Sydney, NSW',
      status: 'Applied',
      appliedDate: DateTime.now().subtract(Duration(days: 1)),
    ),
    AppliedJobDto(
      id: '2',
      companyName: 'XYZ Renovations',
      jobTitle: 'Renovation Specialist',
      location: 'Melbourne, VIC',
      status: 'Applied',
      appliedDate: DateTime.now().subtract(Duration(days: 3)),
    ),
  ];

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
        width: screenWidth * 0.7, // 70% del ancho de la pantalla
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
                color: AppConstants.darkGreyColor,
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MessagesScreen(flavor: _currentFlavor),
                          ),
                        );
                        onClose();
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AppliedJobsScreen(
                              flavor: _currentFlavor,
                              appliedJobs: _appliedJobs,
                            ),
                          ),
                        );
                        onClose();
                      },
                      horizontalPadding: horizontalPadding,
                      verticalSpacing: verticalSpacing,
                      bodyFontSize: bodyFontSize,
                      iconSize: iconSize,
                    ),
                    
                    // Separator
                    _buildSeparator(horizontalPadding, verticalSpacing),
                    
                    // See your earnings
                    _buildMenuItem(
                      icon: Icons.attach_money,
                      title: "See your earnings",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WalletScreen(flavor: _currentFlavor),
                          ),
                        );
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

  void _showUrlDialog(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Report a Problem'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Please copy and paste this URL in your browser:'),
              SizedBox(height: 8),
              SelectableText(
                url,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
