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
        child: Column(
          children: [
            // Profile Information Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  // Profile Picture
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                        width: 2,
                      ),
                      image: DecorationImage(
                        image: NetworkImage('https://via.placeholder.com/100/00ff00/000000?text=TB'),
                        fit: BoxFit.cover,
                      ),
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
                  
                  // Statistics Row
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey[700]!),
                        bottom: BorderSide(color: Colors.grey[700]!),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Jobs Statistic
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '1',
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Jobs',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Vertical Divider
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.white,
                        ),
                        
                        // Rating Statistic
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '5.0',
                                    style: GoogleFonts.poppins(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 24,
                                  ),
                                ],
                              ),
                              Text(
                                'Rating',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
