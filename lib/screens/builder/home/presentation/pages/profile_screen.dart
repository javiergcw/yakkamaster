import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/constants.dart';
import 'builder_home_screen.dart';
import 'map_screen.dart';
import 'messages_screen.dart';
import 'edit_personal_details_screen.dart';

class ProfileScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const ProfileScreen({
    super.key,
    this.flavor,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3; // Profile tab selected

    void _handleHelp() async {
    // Crear URL de WhatsApp usando las constantes generales
    final String whatsappUrl = 'https://wa.me/${AppConstants.whatsappSupportNumber}?text=${Uri.encodeComponent(AppConstants.whatsappSupportMessage)}';

    try {
      // Intentar abrir WhatsApp
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(
          Uri.parse(whatsappUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Si no se puede abrir WhatsApp, mostrar mensaje
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('No se pudo abrir WhatsApp. Asegúrate de tener la aplicación instalada.'),
              backgroundColor: Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)),
            ),
          );
        }
      }
    } catch (e) {
      // Manejar errores
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al abrir WhatsApp: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleTermsAndConditions() async {
    try {
      print('Intentando abrir URL: ${AppConstants.termsAndConditionsUrl}');
      
      // Intentar abrir la URL directamente
      final bool launched = await launchUrl(
        Uri.parse(AppConstants.termsAndConditionsUrl),
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No se pudo abrir los términos y condiciones.'),
            backgroundColor: Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)),
          ),
        );
      }
    } catch (e) {
      print('Error al abrir términos y condiciones: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al abrir términos y condiciones: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleDeleteAccount() async {
    try {
      print('Intentando abrir URL de eliminación de cuenta: ${AppConstants.deleteAccountUrl}');
      
      // Intentar abrir la URL directamente
      final bool launched = await launchUrl(
        Uri.parse(AppConstants.deleteAccountUrl),
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No se pudo abrir el formulario de eliminación de cuenta.'),
            backgroundColor: Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)),
          ),
        );
      }
    } catch (e) {
      print('Error al abrir formulario de eliminación de cuenta: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al abrir formulario de eliminación de cuenta: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BuilderHomeScreen(flavor: widget.flavor),
        ),
      );
    } else if (index == 1) {
      // Map
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MapScreen(flavor: widget.flavor),
        ),
      );
    } else if (index == 2) {
      // Messages
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MessagesScreen(flavor: widget.flavor),
        ),
      );
    }
    // Profile (index == 3) - already on this screen
  }

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
                        color: Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)),
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
                      onTap: _handleHelp,
                    ),
                    _buildMenuItem(
                      icon: Icons.person_outline,
                      title: 'Edit personal details',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPersonalDetailsScreen(flavor: widget.flavor),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.description_outlined,
                      title: 'Terms and conditions',
                      onTap: _handleTermsAndConditions,
                    ),
                    _buildMenuItem(
                      icon: Icons.delete_outline,
                      title: 'Delete account',
                      onTap: _handleDeleteAccount,
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
                    color: Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)),
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
          _buildBottomNavItem(Icons.grid_view, 'Home', 0, _selectedIndex == 0),
          _buildBottomNavItem(Icons.map, 'Map', 1, _selectedIndex == 1),
          _buildBottomNavItem(Icons.chat_bubble, 'Messages', 2, _selectedIndex == 2),
          _buildBottomNavItem(Icons.person, 'Profile', 3, _selectedIndex == 3),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
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
