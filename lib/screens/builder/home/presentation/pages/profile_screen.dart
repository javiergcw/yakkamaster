import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../logic/controllers/profile_screen_controller.dart';

class ProfileScreen extends StatelessWidget {
  static const String id = '/builder/profile';
  
  final AppFlavor? flavor;

  ProfileScreen({super.key, this.flavor});

  final ProfileScreenController controller = Get.put(ProfileScreenController());

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
            // Profile Information Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
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
                  
                  // Company & User ID
                  Text(
                    'Company linked: Test company by Yakka',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                  
                  Text(
                    'user ID #1321',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
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
                  
                  SizedBox(height: 24),
                  
                  // Botones de acción
                  Column(
                    children: [
                      // Botón Complete your profile
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 24),
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Implementar navegación a completar perfil
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Complete your profile',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Punto de notificación
                          Positioned(
                            top: 6,
                            right: 30,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 12),
                      
                      // Botón View profile
                      TextButton(
                        onPressed: () {
                          // TODO: Implementar navegación a ver perfil
                        },
                        child: Text(
                          'View profile',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Menu Options
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                    _buildMenuItem(
                      icon: Icons.help_outline,
                      title: 'Help',
                      onTap: controller.handleHelp,
                    ),
                    _buildMenuItem(
                      icon: Icons.person_outline,
                      title: 'Edit personal details',
                      onTap: controller.navigateToEditPersonalDetails,
                    ),
                    _buildMenuItem(
                      icon: Icons.description_outlined,
                      title: 'Terms and conditions',
                      onTap: controller.handleTermsAndConditions,
                    ),
                    _buildMenuItem(
                      icon: Icons.delete_outline,
                      title: 'Delete account',
                      onTap: controller.handleDeleteAccount,
                    ),
                    _buildMenuItem(
                      icon: Icons.logout,
                      title: 'Log out',
                      onTap: () {
                        // TODO: Handle logout
                      },
                    ),
                ],
              ),
            ),
            
            // App Version
            Container(
              padding: EdgeInsets.only(bottom: 16, top: 16),
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
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
                    color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
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

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomNavItem(Icons.grid_view, 'Home', 0, controller.selectedIndex.value == 0),
          _buildBottomNavItem(Icons.map, 'Map', 1, controller.selectedIndex.value == 1),
          _buildBottomNavItem(Icons.chat_bubble, 'Messages', 2, controller.selectedIndex.value == 2),
          _buildBottomNavItem(Icons.person, 'Profile', 3, controller.selectedIndex.value == 3),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.black : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: isSelected ? Colors.black : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
