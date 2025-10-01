import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../pages/edit_personal_details_screen.dart';
import '../../logic/controllers/sidebar_controller.dart';

class Sidebar extends StatelessWidget {
  final AppFlavor? flavor;
  final VoidCallback onClose;

  const Sidebar({
    super.key,
    this.flavor,
    required this.onClose,
  });

  AppFlavor get _currentFlavor => flavor ?? AppFlavorConfig.currentFlavor;
  
  // Obtener el controlador del sidebar
  SidebarController get controller => Get.put(SidebarController());

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity, // Ocupar todo el ancho
      height: double.infinity,
      color: Colors.grey[900]!.withOpacity(0.95), // Fondo semi-transparente
      child: Obx(() {
        // Mostrar loading si está cargando
        if (controller.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
            ),
          );
        }

        // Mostrar error si hay error
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                SizedBox(height: 16),
                Text(
                  'Error',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  controller.errorMessage,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.refreshProfile(),
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
          // Profile Information Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                // Close Button (top-left)
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: onClose,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 16),
                
                // Profile Picture
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.account_circle,
                    size: 100,
                    color: Colors.grey[600],
                  ),
                ),
                
                SizedBox(height: 16),
                
                // User Name (Display name del builder o user full name)
                Text(
                  controller.hasBuilderProfile ? controller.builderDisplayName : controller.userFullName,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                SizedBox(height: 8),
                
                // Company (solo si tiene perfil builder y empresa)
                if (controller.hasBuilderProfile && controller.builderCompanyName.isNotEmpty)
                  Text(
                    'Company: ${controller.builderCompanyName}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                
                // User/Builder ID
                Text(
                  controller.hasBuilderProfile 
                      ? 'builder ID #${controller.builderProfileId}'
                      : 'user ID #${controller.userId}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
                
                SizedBox(height: 24),
              ],
            ),
          ),
          
          // Menu Options
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: 'Help',
                    onTap: () {
                      controller.handleHelp();
                      onClose();
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    title: 'Personal details',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditPersonalDetailsScreen(flavor: _currentFlavor),
                        ),
                      );
                      onClose();
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.description_outlined,
                    title: 'Terms and conditions',
                    onTap: () {
                      controller.handleTermsAndConditions();
                      onClose();
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.delete_outline,
                    title: 'Delete account',
                    onTap: () {
                      controller.handleDeleteAccount();
                      onClose();
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: 'Log out',
                    onTap: () {
                      // Mostrar diálogo de confirmación
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Log out'),
                            content: Text('Are you sure you want to log out?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  controller.handleLogout();
                                  onClose();
                                },
                                child: Text('Log out'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // App Version
          Container(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              '4.3.53+153',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
        );
      }),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                
                SizedBox(width: 16),
                
                // Title
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                
                // Arrow
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        
        // Divider
        Container(
          height: 1,
          color: Colors.grey[700],
        ),
      ],
    );
  }
}
