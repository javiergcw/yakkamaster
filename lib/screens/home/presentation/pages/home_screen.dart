import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/app_flavor.dart';
import '../../../../config/assets_config.dart';
import '../../../../features/widgets/custom_button.dart';
import '../widgets/activity_item.dart';
import '../widgets/profile_item.dart';
import '../widgets/sidebar.dart';
import '../../../job_listings/presentation/pages/job_listings_screen.dart';

class HomeScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const HomeScreen({
    super.key,
    this.flavor,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  int _selectedIndex = 0; // Home tab selected
  bool _isSidebarOpen = false; // Control del sidebar

  void _handleApplyForJob() {
    // Navegar a la pantalla de job listings
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => JobListingsScreen(flavor: _currentFlavor),
      ),
    );
  }

  void _handleBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // TODO: Implementar navegación entre tabs
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  void _closeSidebar() {
    setState(() {
      _isSidebarOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final sectionTitleFontSize = screenWidth * 0.045;
    final bodyFontSize = screenWidth * 0.035;
    final buttonFontSize = screenWidth * 0.04;
    final profileImageSize = screenWidth * 0.12;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey[100],
          body: SafeArea(
            child: Stack(
              children: [
                // Main Content
                Column(
                  children: [
                    // Header (Dark Grey)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: verticalSpacing * 2.5, // Aumentado el padding vertical para hacerlo más alto
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start, // Alinear al inicio (arriba)
                        children: [
                          SizedBox(height: verticalSpacing * 0.1), // Espacio superior mínimo
                          Row(
                            children: [
                              // Profile Image (clickeable para abrir sidebar)
                              GestureDetector(
                                onTap: _toggleSidebar,
                                child: Container(
                                  width: profileImageSize,
                                  height: profileImageSize,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[600],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: profileImageSize * 0.5,
                                  ),
                                ),
                              ),
                              
                              SizedBox(width: horizontalPadding),
                              
                              // App Name
                              Expanded(
                                child: Text(
                                  "YAKKA",
                                  style: GoogleFonts.poppins(
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              
                              // Notification Icon
                              IconButton(
                                onPressed: () {
                                  // TODO: Implementar notificaciones
                                  print('Notifications pressed');
                                },
                                icon: Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                  size: screenWidth * 0.06,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Spacer para el contenido principal - aumentado para dar espacio al banner flotante
                    SizedBox(height: verticalSpacing * 8),
                    
                    // Main Content (Scrollable)
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ACTIVITY Section
                            Text(
                              "ACTIVITY",
                              style: GoogleFonts.poppins(
                                fontSize: sectionTitleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                letterSpacing: 0.5,
                              ),
                            ),
                            
                            SizedBox(height: verticalSpacing * 1.5),
                            
                            // Activity Items
                            ActivityItem(
                              icon: Icons.receipt,
                              title: "Invoices",
                              onTap: () {
                                // TODO: Implementar navegación a invoices
                                print('Invoices pressed');
                              },
                            ),
                            
                            SizedBox(height: verticalSpacing),
                            
                            ActivityItem(
                              icon: Icons.work,
                              title: "Applied jobs",
                              onTap: () {
                                // TODO: Implementar navegación a applied jobs
                                print('Applied jobs pressed');
                              },
                            ),
                            
                            SizedBox(height: verticalSpacing),
                            
                            ActivityItem(
                              icon: Icons.warning,
                              title: "Report harassment",
                              subtitle: "You can remain anonymous",
                              onTap: () {
                                // TODO: Implementar navegación a report harassment
                                print('Report harassment pressed');
                              },
                            ),
                            
                            SizedBox(height: verticalSpacing * 3),
                            
                            // PROFILE Section
                            Text(
                              "PROFILE",
                              style: GoogleFonts.poppins(
                                fontSize: sectionTitleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                letterSpacing: 0.5,
                              ),
                            ),
                            
                            SizedBox(height: verticalSpacing * 1.5),
                            
                            // Profile Items
                            ProfileItem(
                              icon: Icons.qr_code,
                              title: "Show your QR",
                              subtitle: "Share your profile to get hired",
                              onTap: () {
                                // TODO: Implementar navegación a QR
                                print('Show QR pressed');
                              },
                            ),
                            
                            SizedBox(height: verticalSpacing * 2),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Banner flotante sobre el header
                Positioned(
                  top: verticalSpacing * 6, // Bajado más el banner
                  left: horizontalPadding,
                  right: horizontalPadding,
                  child: Container(
                    padding: EdgeInsets.all(horizontalPadding * 0.4), // Reducido más el padding
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 2),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "No active jobs yet",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: sectionTitleFontSize * 0.85, // Reducido el tamaño de fuente
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: verticalSpacing * 0.2), // Reducido más el espaciado
                        Text(
                          "Once you get hired, you'll see your timesheets to submit here",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: bodyFontSize * 0.8, // Reducido más el tamaño de fuente
                            color: Colors.grey[700],
                            height: 1.1, // Reducido más el line height
                          ),
                        ),
                        SizedBox(height: verticalSpacing * 1.0), // Reducido más el espaciado
                        Center(
                          child: SizedBox(
                            width: screenWidth * 0.45, // Más ancho para el botón
                            height: screenHeight * 0.05, // Altura más pequeña
                            child: ElevatedButton(
                              onPressed: _handleApplyForJob,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                foregroundColor: Colors.white,
                                elevation: 0, // Sin shadowbox
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                "Apply for a job now",
                                style: GoogleFonts.poppins(
                                  fontSize: buttonFontSize * 0.75, // Fuente más pequeña
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Navigation Bar
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              onTap: _handleBottomNavTap,
              selectedItemColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
              unselectedItemColor: Colors.grey[600],
              selectedLabelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: bodyFontSize * 0.9,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontSize: bodyFontSize * 0.9,
              ),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'Shifts',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.message),
                  label: 'Messages',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.more_horiz),
                  label: 'More',
                ),
              ],
            ),
          ),
        ),
        
        // Overlay para cerrar sidebar al tocar fuera (solo sobre el contenido principal)
        if (_isSidebarOpen)
          Positioned(
            left: screenWidth * 0.85, // Empezar después del sidebar
            top: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: _closeSidebar,
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
        
        // Sidebar (por encima de todo, sin overlay)
        if (_isSidebarOpen)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: screenWidth * 0.85,
              child: Sidebar(
                flavor: _currentFlavor,
                onClose: _closeSidebar,
              ),
            ),
          ),
      ],
    );
  }
}
