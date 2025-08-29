import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../post_job/logic/controllers/job_site_controller.dart';
import '../widgets/job_site_list_card.dart';
import '../../../post_job/presentation/pages/create_edit_job_site_screen.dart';

class JobSitesListScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const JobSitesListScreen({super.key, this.flavor});

  @override
  State<JobSitesListScreen> createState() => _JobSitesListScreenState();
}

class _JobSitesListScreenState extends State<JobSitesListScreen> {
  AppFlavor get _currentFlavor =>
      widget.flavor ?? AppFlavorConfig.currentFlavor;
  late JobSiteController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(JobSiteController());
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
    final descriptionFontSize = screenWidth * 0.035;
    final buttonFontSize = screenWidth * 0.04;
    final iconSize = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header (Dark Grey)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing * 1.5,
              ),
              decoration: BoxDecoration(color: Colors.grey[800]),
              child: Column(
                children: [
                  // Header Row
                  Row(
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: iconSize,
                        ),
                      ),

                      SizedBox(width: horizontalPadding),

                      // Title
                      Expanded(
                        child: Text(
                          "Job Sites",
                          style: GoogleFonts.poppins(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),

                      // Add Button
                    ],
                  ),

                  SizedBox(height: verticalSpacing * 0.5),

                  // Description
                  Text(
                    "View and manage your job sites. Tap on a job site to see details.",
                    style: GoogleFonts.poppins(
                      fontSize: descriptionFontSize * 0.9,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Obx(() {
                if (_controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (_controller.errorMessage.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: iconSize * 2,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: verticalSpacing),
                        Text(
                          _controller.errorMessage,
                          style: GoogleFonts.poppins(
                            fontSize: descriptionFontSize,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: verticalSpacing),
                        ElevatedButton(
                          onPressed: () => _controller.loadJobSites(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (_controller.jobSites.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off,
                          size: iconSize * 2,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: verticalSpacing),
                        Text(
                          "No job sites found",
                          style: GoogleFonts.poppins(
                            fontSize: descriptionFontSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: verticalSpacing * 0.5),
                        Text(
                          "Add your first job site to get started",
                          style: GoogleFonts.poppins(
                            fontSize: descriptionFontSize * 0.9,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: verticalSpacing * 2),
                        ElevatedButton.icon(
                          onPressed: _handleCreateJobSite,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(
                              AppFlavorConfig.getPrimaryColor(_currentFlavor),
                            ),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: verticalSpacing * 0.8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: Icon(Icons.add),
                          label: Text(
                            "Create Job Site",
                            style: GoogleFonts.poppins(
                              fontSize: buttonFontSize * 0.9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalSpacing * 0.5,
                  ),
                  itemCount:
                      _controller.jobSites.length +
                      1, // +1 para el botón de crear
                  itemBuilder: (context, index) {
                    if (index == _controller.jobSites.length) {
                      // Botón para crear job site al final
                      return Container(
                        margin: EdgeInsets.only(top: verticalSpacing),
                        child: ElevatedButton.icon(
                          onPressed: _handleCreateJobSite,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[100],
                            foregroundColor: Colors.grey[700],
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: verticalSpacing * 0.8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                            elevation: 0,
                          ),
                          icon: Icon(Icons.add, size: iconSize * 0.8),
                          label: Text(
                            "Create new job site",
                            style: GoogleFonts.poppins(
                              fontSize: buttonFontSize * 0.8,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }

                    final jobSite = _controller.jobSites[index];
                    return GestureDetector(
                      onTap: () => _handleJobSiteDetail(jobSite),
                      child: Container(
                        margin: EdgeInsets.only(bottom: verticalSpacing),
                        child: JobSiteListCard(
                          jobSite: jobSite,
                          onTap: () => _handleJobSiteDetail(jobSite),
                          onEdit: () => _handleEditJobSite(jobSite),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _handleJobSiteDetail(dynamic jobSite) {
    _showJobSiteDetailModal(context, jobSite);
  }

  void _showJobSiteDetailModal(BuildContext context, dynamic jobSite) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: screenHeight * 0.75,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle Bar
              Container(
                margin: EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Container(
                padding: EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Job Site Details',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'View complete information',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.grey[600],
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              Divider(height: 1, color: Colors.grey[200]),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name Section
                      _buildDetailSection(
                        icon: Icons.business,
                        title: 'Name',
                        value: jobSite.name,
                        iconColor: Colors.blue[600],
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Location Section
                      _buildDetailSection(
                        icon: Icons.location_on,
                        title: 'Location',
                        value: jobSite.location,
                        iconColor: Colors.red[600],
                      ),
                      
                      // Description Section (if not empty)
                      if (jobSite.description.isNotEmpty) ...[
                        SizedBox(height: 24),
                        _buildDetailSection(
                          icon: Icons.description,
                          title: 'Description',
                          value: jobSite.description,
                          iconColor: Colors.orange[600],
                          isDescription: true,
                        ),
                      ],
                      
                      SizedBox(height: 24),
                      
                      // Status Section
                      _buildDetailSection(
                        icon: Icons.circle,
                        title: 'Status',
                        value: 'Active',
                        iconColor: Colors.green[600],
                        isStatus: true,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Action Buttons
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]!, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey[300]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Close',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _handleEditJobSite(jobSite);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Edit',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailSection({
    required IconData icon,
    required String title,
    required String value,
    required Color? iconColor,
    bool isDescription = false,
    bool isStatus = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor!.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: isStatus ? 12 : 16,
                color: iconColor,
              ),
            ),
            SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.only(left: 44),
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: isDescription ? 14 : 16,
              fontWeight: isDescription ? FontWeight.w400 : FontWeight.w600,
              color: isStatus ? Colors.green[700] : Colors.black,
              height: isDescription ? 1.4 : 1.2,
            ),
          ),
        ),
      ],
    );
  }

  void _handleEditJobSite(dynamic jobSite) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            CreateEditJobSiteScreen(flavor: _currentFlavor, jobSite: jobSite),
      ),
    );
  }

  void _handleCreateJobSite() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateEditJobSiteScreen(flavor: _currentFlavor),
      ),
    );
  }
}
