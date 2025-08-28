import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import 'builder_home_screen.dart';
import 'messages_screen.dart';

class WorkerListScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const WorkerListScreen({
    super.key,
    this.flavor,
  });

  @override
  State<WorkerListScreen> createState() => _WorkerListScreenState();
}

class _WorkerListScreenState extends State<WorkerListScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  final List<String> _skillChips = [
    'General Labourer',
    'Carpenter',
    'Electrician',
    'Plumber',
    'Painter',
    'Welder',
  ];

  // Mock data for workers
  final List<Map<String, dynamic>> _workers = [
    {
      'name': 'Robert James Hannan',
      'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      'skills': 'General Labourer - Carpenter - Lawn mower - Formworker - Steel Fixer - Han...',
      'rating': 5.0,
      'location': null,
    },
    {
      'name': 'Paula Guerrero',
      'image': 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
      'skills': 'Cleaner - General Labourer - Other',
      'rating': 5.0,
      'location': 'Wolli Creek',
    },
    {
      'name': 'Yamil Cardozo',
      'image': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      'skills': 'General Labourer - Electrician - HVAC Technician - Electrician',
      'rating': 5.0,
      'location': 'Argentina',
    },
    {
      'name': 'Tom Guibourt',
      'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
      'skills': 'Gene... Gardener - ...orker - Landscaper - Warehouse Lab.',
      'rating': 5.0,
      'location': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.05;
    final verticalSpacing = screenHeight * 0.02;

    return Scaffold(
      backgroundColor: Colors.white,
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
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
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
                      itemCount: _skillChips.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(right: 12),
                          child: Chip(
                            label: Text(
                              _skillChips[index],
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            backgroundColor: Colors.grey[100],
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
            
            // Workers List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                itemCount: _workers.length,
                itemBuilder: (context, index) {
                  final worker = _workers[index];
                  return _buildWorkerCard(worker);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildMapFloatingButton(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  void _showJobSelectionModal(BuildContext context, String workerName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Select a job',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 24),
                
                // Job Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Truck Driver',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '2025-08-25',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel Button
                    Container(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(width: 12),
                    
                    // OK Button
                    Container(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Process hire action
                          Navigator.of(context).pop();
                          // Show success message or navigate to next screen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: Text(
                          'OK',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMapFloatingButton() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: IconButton(
        onPressed: () {
          Navigator.pop(context); // Go back to map
        },
        icon: Icon(
          Icons.map,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildWorkerCard(Map<String, dynamic> worker) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                image: NetworkImage(worker['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          SizedBox(width: 16),
          
          // Worker Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  worker['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                if (worker['location'] != null)
                  Text(
                    worker['location'],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  )
                else
                  Text(
                    worker['skills'],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          
                     // Action Buttons
           Column(
             children: [
               // CHAT Button
               Container(
                 width: 80,
                 height: 32,
                 margin: EdgeInsets.only(bottom: 8),
                 child: ElevatedButton(
                   onPressed: () {
                     // TODO: Open chat
                   },
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)),
                     foregroundColor: Colors.white,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(16),
                     ),
                     padding: EdgeInsets.zero,
                   ),
                   child: Text(
                     'CHAT',
                     style: GoogleFonts.poppins(
                       fontSize: 12,
                       fontWeight: FontWeight.w600,
                     ),
                   ),
                 ),
               ),
               
                                  // HIRE Button
                   Container(
                     width: 80,
                     height: 32,
                     child: ElevatedButton(
                       onPressed: () {
                         _showJobSelectionModal(context, worker['name']);
                       },
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.grey[800],
                         foregroundColor: Colors.white,
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(16),
                         ),
                         padding: EdgeInsets.zero,
                       ),
                       child: Text(
                         'HIRE',
                         style: GoogleFonts.poppins(
                           fontSize: 12,
                           fontWeight: FontWeight.w600,
                         ),
                       ),
                     ),
                   ),
             ],
           ),
        ],
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
          _buildBottomNavItem(Icons.map, 'Map', 1, false), // Map not selected in list view
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BuilderHomeScreen(flavor: widget.flavor),
            ),
          );
        } else if (index == 1) { // Map
          Navigator.pop(context); // Go back to map
        } else if (index == 2) { // Messages
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MessagesScreen(flavor: widget.flavor),
            ),
          );
        } else if (index == 3) { // Profile
          // TODO: Navigate to Profile screen
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
