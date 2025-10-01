import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../../../../config/constants.dart';
import '../../../../job_listings/presentation/pages/job_listings_screen.dart';
import '../pages/wallet_screen.dart';
import '../pages/applied_jobs_screen.dart';
import '../pages/messages_screen.dart';
import '../../data/applied_job_dto.dart';
import '../../logic/controllers/sidebar_controller.dart';

class Sidebar extends StatefulWidget {
  final AppFlavor? flavor;
  final VoidCallback onClose;

  const Sidebar({
    super.key,
    this.flavor,
    required this.onClose,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late SidebarController _controller;
  
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(SidebarController());
  }

  @override
  void dispose() {
    Get.delete<SidebarController>();
    super.dispose();
  }

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
                vertical: verticalSpacing * 1.5,
              ),
              decoration: BoxDecoration(
                color: AppConstants.darkGreyColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  
                  SizedBox(height: verticalSpacing * 0.5),
                  
                  // User Information
                  Obx(() {
                    if (_controller.isLoading) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: screenWidth * 0.3,
                            height: titleFontSize * 0.9,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: verticalSpacing * 0.2),
                          Container(
                            width: screenWidth * 0.4,
                            height: bodyFontSize * 0.9,
                            color: Colors.grey[400],
                          ),
                        ],
                      );
                    }
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _controller.userFullName,
                          style: GoogleFonts.poppins(
                            fontSize: titleFontSize * 0.9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: verticalSpacing * 0.2),
                        Text(
                          _controller.userEmail,
                          style: GoogleFonts.poppins(
                            fontSize: bodyFontSize * 0.9,
                            color: Colors.grey[300],
                          ),
                        ),
                        if (_controller.errorMessage.isNotEmpty) ...[
                          SizedBox(height: verticalSpacing * 0.3),
                          Text(
                            'Error: ${_controller.errorMessage}',
                            style: GoogleFonts.poppins(
                              fontSize: bodyFontSize * 0.7,
                              color: Colors.red[300],
                            ),
                          ),
                        ],
                      ],
                    );
                  }),
                ],
              ),
            ),
            
            // Menu Items Section
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: verticalSpacing * 0.2),
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
                    
                    // Refresh profile
                    _buildMenuItem(
                      icon: Icons.refresh,
                      title: "Refresh profile",
                      onTap: () {
                        _controller.refreshProfile();
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
                        widget.onClose();
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
                        widget.onClose();
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
                        widget.onClose();
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
                        widget.onClose();
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
              padding: EdgeInsets.only(
                left: horizontalPadding,
                right: horizontalPadding,
                top: verticalSpacing * 0.3,
                bottom: verticalSpacing * 0.2,
              ),
              child: Obx(() {
                return Column(
                  children: [
                    if (_controller.hasLabourProfile) ...[
                      Text(
                        "Perfil Labour: ${_controller.isLabourProfileComplete ? 'Completo' : 'Incompleto'}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: bodyFontSize * 0.7,
                          color: _controller.isLabourProfileComplete ? Colors.green[600] : Colors.orange[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: verticalSpacing * 0.1),
                    ],
                    if (_controller.hasBuilderProfile) ...[
                      Text(
                        "También tienes perfil Builder",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: bodyFontSize * 0.7,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: verticalSpacing * 0.1),
                    ],
                    Text(
                      "Version 2.1",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: bodyFontSize * 0.8,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                );
              }),
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
          vertical: verticalSpacing * 0.5,
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
        vertical: verticalSpacing * 0.2,
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
