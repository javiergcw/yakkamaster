import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../config/app_flavor.dart';
import '../../logic/controllers/map_screen_controller.dart';

class MapScreen extends StatelessWidget {
  static const String id = '/builder/map';
  
  final AppFlavor? flavor;

  MapScreen({
    super.key,
    this.flavor,
  });

  MapScreenController get controller {
    try {
      return Get.find<MapScreenController>();
    } catch (e) {
      print('⚠️ MapScreenController not found, creating new instance: $e');
      return Get.put(MapScreenController());
    }
  }

  @override
  Widget build(BuildContext context) {
    print('=== MapScreen build called ===');
    print('Flavor: $flavor');
    
    // Si debe mostrar la lista primero, navegar automáticamente
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.showListFirst.value) {
        controller.navigateToList();
        controller.showListFirst.value = false; // Reset para futuras navegaciones
      }
    });
    
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.05;
    final verticalSpacing = screenHeight * 0.02;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top Section - Search and Filters
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing,
              ),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.searchController,
                            decoration: InputDecoration(
                              hintText: 'Search by skill',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                              border: InputBorder.none,
                            ),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.search,
                          color: Colors.grey[600],
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing),
                  
                  // Skill Chips
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.skillChips.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(right: 12),
                          child: Chip(
                            label: Text(
                              controller.skillChips[index],
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            backgroundColor: Colors.white,
                            side: BorderSide.none,
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // Map Area
            Expanded(
              child: Stack(
                children: [
                  // Google Map
                  GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      this.controller.onMapCreated(controller);
                    },
                    initialCameraPosition: MapScreenController.initialPosition,
                    mapType: MapType.normal,
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    mapToolbarEnabled: false,
                    compassEnabled: false,
                    markers: controller.createMarkers(),
                    style: MapScreenController.mapStyle,
                  ),
                  
                  // Floating Action Buttons
                  Positioned(
                    bottom: 100, // Above bottom navigation
                    left: horizontalPadding,
                    child: _buildListButton(),
                  ),
                  
                  Positioned(
                    bottom: 100, // Above bottom navigation
                    right: horizontalPadding,
                    child: _buildLocationButton(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }



  Widget _buildListButton() {
    return GestureDetector(
      onTap: () {
        controller.navigateToList();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.list,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'List',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationButton() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: IconButton(
        onPressed: () {
          controller.getCurrentLocation();
        },
        icon: Icon(
          Icons.my_location,
          color: Colors.white,
          size: 24,
        ),
      ),
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
          _buildBottomNavItem(Icons.grid_view, 'Home', 0, false),
          _buildBottomNavItem(Icons.map, 'Map', 1, true), // Map is selected
          _buildBottomNavItem(Icons.chat_bubble, 'Messages', 2, false),
          _buildBottomNavItem(Icons.person, 'Profile', 3, false),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, int index, bool isSelected) {
    return GestureDetector(
      onTap: () {
        // Navigate to different screens based on index
        if (index == 0) { // Home
          controller.navigateToHome();
        } else if (index == 1) { // Map - already here
          // Do nothing, we're already on map
        } else if (index == 2) { // Messages
          controller.navigateToMessages();
        } else if (index == 3) { // Profile
          controller.navigateToProfile();
        }
      },
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
