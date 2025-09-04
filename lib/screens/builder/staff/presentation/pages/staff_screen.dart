import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/search_input_field.dart';
import '../../data/data.dart';
import '../../logic/controllers/staff_screen_controller.dart';

class StaffScreen extends StatelessWidget {
  static const String id = '/builder/staff';
  
  final AppFlavor? flavor;

  StaffScreen({
    super.key,
    this.flavor,
  });

  final StaffScreenController controller = Get.put(StaffScreenController());

  @override
  Widget build(BuildContext context) {
    // Establecer flavor en el controlador
    if (flavor != null) {
      controller.currentFlavor.value = flavor!;
    }
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.05;
    final verticalSpacing = screenHeight * 0.02;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(),
            
            // Search and Filters Section
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing,
              ),
              child: Column(
                children: [
                                                       // Search Bar
                  SearchInputField(
                    controller: controller.searchController.value,
                    hintText: 'Search Workers',
                    flavor: flavor,
                    height: 40,
                    fontSize: 14,
                    onChanged: controller.handleSearchChanged,
                    onSearch: () {
                      // Search is handled by onChanged
                    },
                  ),
                  
                  SizedBox(height: verticalSpacing),
                  
                                     // Dropdown Filters
                   Obx(() => Row(
                     children: [
                       Expanded(
                         child: _buildDropdown(
                           value: controller.staffController.selectedJobsite,
                           items: controller.staffController.getAvailableJobsites(),
                           onChanged: (value) {
                             controller.staffController.setSelectedJobsite(value!);
                           },
                         ),
                       ),
                       SizedBox(width: 12),
                       Expanded(
                         child: _buildDropdown(
                           value: controller.staffController.selectedSkill,
                           items: controller.staffController.getAvailableSkills(),
                           onChanged: (value) {
                             controller.staffController.setSelectedSkill(value!);
                           },
                         ),
                       ),
                     ],
                   )),
                  
                  SizedBox(height: verticalSpacing * 1.5),
                  
                  // Quick Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildQuickActionButton(
                        icon: Icons.people,
                        label: 'Move Workers',
                        onTap: controller.navigateToMoveWorkers,
                      ),
                      _buildQuickActionButton(
                        icon: Icons.access_time,
                        label: 'Extend shifts',
                        onTap: controller.navigateToExtendShifts,
                      ),
                      _buildQuickActionButton(
                        icon: Icons.person_remove,
                        label: 'Unhire workers',
                        onTap: controller.navigateToUnhireWorkers,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Workers List
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  _buildWorkersList(true), // Active workers
                  _buildWorkersList(false), // Inactive workers
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: Colors.grey[900],
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          // Header with back button and title
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  controller.handleBackNavigation();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Text(
                'Workers',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          
                     SizedBox(height: 8),
          
                     // Tabs
           AnimatedBuilder(
             animation: controller.tabController,
             builder: (context, child) {
               return Row(
                 children: [
                   Expanded(
                     child: GestureDetector(
                       onTap: () => controller.handleTabChange(0),
                       child: Column(
                         children: [
                           Text(
                             'Active',
                             style: GoogleFonts.poppins(
                               fontSize: 16,
                               fontWeight: controller.tabController.index == 0 ? FontWeight.w600 : FontWeight.w400,
                               color: Colors.white,
                             ),
                           ),
                                                      SizedBox(height: 12),
                           if (controller.tabController.index == 0)
                             Container(
                               height: 3,
                               width: 150,
                                decoration: BoxDecoration(
                                  color: Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor)),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                         ],
                       ),
                     ),
                   ),
                   Expanded(
                     child: GestureDetector(
                       onTap: () => controller.handleTabChange(1),
                       child: Column(
                         children: [
                           Text(
                             'Inactive',
                             style: GoogleFonts.poppins(
                               fontSize: 16,
                               fontWeight: controller.tabController.index == 1 ? FontWeight.w600 : FontWeight.w400,
                               color: Colors.white,
                             ),
                           ),
                                                      SizedBox(height: 12),
                           if (controller.tabController.index == 1)
                             Container(
                               height: 3,
                               width: 150,
                                decoration: BoxDecoration(
                                  color: Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor)),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                         ],
                       ),
                     ),
                   ),
                 ],
               );
             },
           ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButton<String>(
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        underline: SizedBox(),
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 20),
        isExpanded: true,
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor)),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

    Widget _buildWorkersList(bool isActive) {
    return Obx(() {
      final jobsiteWorkers = isActive 
          ? controller.staffController.getActiveJobsiteWorkers()
          : controller.staffController.getInactiveJobsiteWorkers();
      
      if (controller.staffController.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      
      if (jobsiteWorkers.isEmpty) {
        return Center(
          child: Text(
            'No ${isActive ? 'active' : 'inactive'} workers found',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        );
      }
      
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: jobsiteWorkers.length,
        itemBuilder: (context, index) {
          final jobsite = jobsiteWorkers[index];
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(
                'Jobsite: ${jobsite.jobsiteAddress}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: jobsite.workers.length,
                  itemBuilder: (context, workerIndex) {
                    final worker = jobsite.workers[workerIndex];
                    return _buildWorkerCard(worker, isActive: isActive);
                  },
                ),
              ),
            ],
          );
        },
      );
    });
  }

  Widget _buildWorkerCard(WorkerDto worker, {bool isActive = true}) {
    return Container(
      width: 280,
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.fromLTRB(12, 12, 12, 8),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with profile picture, info, and chat button
          Row(
            children: [
              // Profile Picture
              Container(
                width: 45,
                height: 45,
                                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(22.5),
                   image: DecorationImage(
                     image: NetworkImage(worker.imageUrl),
                     fit: BoxFit.cover,
                   ),
                 ),
              ),
              
              SizedBox(width: 10),
              
              // Worker Information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                                                     child: Text(
                             worker.name,
                             style: GoogleFonts.poppins(
                               fontSize: 15,
                               fontWeight: FontWeight.bold,
                               color: Colors.black,
                             ),
                           ),
                        ),
                        // Chat Button
                        GestureDetector(
                          onTap: () => controller.navigateToChat(
                            worker.name,
                            worker.name.isNotEmpty ? worker.name[0].toUpperCase() : 'W',
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: 3),
                                Text(
                                  'Chat',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                                         Text(
                       worker.role,
                       style: GoogleFonts.poppins(
                         fontSize: 13,
                         color: Colors.grey[600],
                       ),
                     ),
                     SizedBox(height: 1),
                     Text(
                       worker.hourlyRate,
                       style: GoogleFonts.poppins(
                         fontSize: 13,
                         fontWeight: FontWeight.w600,
                         color: Colors.black,
                       ),
                     ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12),
          
          // Action Buttons - Different for active vs inactive
          if (isActive) ...[
            // Active workers: Rate, Extend, Unhire
            Row(
              children: [
                // Rate Button
                Expanded(
                  child: SizedBox(
                    height: 32,
                    child: OutlinedButton(
                      onPressed: () {
                        controller.showFeedbackModal(worker.id, worker.name);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.grey[600]),
                          SizedBox(width: 3),
                          Text(
                            'Rate',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                SizedBox(width: 6),
                
                // Extend Button
                Expanded(
                  child: SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.showExtendShiftsModal(worker.id, worker.name);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor)),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today, size: 14),
                          SizedBox(width: 3),
                          Text(
                            'Extend',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                SizedBox(width: 6),
                
                // Unhire Button
                Expanded(
                  child: SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.showUnhireConfirmationModal(worker.id, worker.name);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.close, size: 14),
                          SizedBox(width: 3),
                          Text(
                            'Unhire',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            // Inactive workers: Rate, Rehire
            Row(
              children: [
                // Rate Button
                Expanded(
                  child: SizedBox(
                    height: 32,
                    child: OutlinedButton(
                      onPressed: () {
                        controller.showFeedbackModal(worker.id, worker.name);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.grey[600]),
                          SizedBox(width: 3),
                          Text(
                            'Rate',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                SizedBox(width: 6),
                
                // Rehire Button
                Expanded(
                  child: SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () => controller.navigateToWorkerProfile(worker),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor)),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_add, size: 14),
                          SizedBox(width: 3),
                          Text(
                            'Rehire',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
