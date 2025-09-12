import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../../../../config/constants.dart';
import '../pages/edit_personal_details_screen.dart';

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

    return Container(
      width: double.infinity, // Ocupar todo el ancho
      height: double.infinity,
      color: Colors.grey[900]!.withOpacity(0.95), // Fondo semi-transparente
      child: Column(
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
                
                // User Name
                Text(
                  'testing builder',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                SizedBox(height: 8),
                
                // User ID
                Text(
                  'user ID #1321',
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
                    onTap: () async {
                      final String whatsappUrl = 'https://wa.me/${AppConstants.whatsappSupportNumber}?text=${Uri.encodeComponent(AppConstants.whatsappSupportMessage)}';
                      try {
                        if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
                          await launchUrl(
                            Uri.parse(whatsappUrl),
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      } catch (e) {
                        print('Error al abrir WhatsApp: $e');
                      }
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
                    onTap: () async {
                      try {
                        final bool launched = await launchUrl(
                          Uri.parse(AppConstants.termsAndConditionsUrl),
                          mode: LaunchMode.externalApplication,
                        );
                        if (!launched) {
                          print('No se pudo abrir los términos y condiciones');
                        }
                      } catch (e) {
                        print('Error al abrir términos y condiciones: $e');
                      }
                      onClose();
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.delete_outline,
                    title: 'Delete account',
                    onTap: () async {
                      try {
                        final bool launched = await launchUrl(
                          Uri.parse(AppConstants.deleteAccountUrl),
                          mode: LaunchMode.externalApplication,
                        );
                        if (!launched) {
                          print('No se pudo abrir el formulario de eliminación de cuenta');
                        }
                      } catch (e) {
                        print('Error al abrir formulario de eliminación de cuenta: $e');
                      }
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
                                  // TODO: Implementar logout real
                                  print('Log out confirmed');
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
      ),
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
