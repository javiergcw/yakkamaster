import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../data/data.dart';

class WorkerProfileScreen extends StatefulWidget {
  final WorkerDto worker;
  final AppFlavor? flavor;

  const WorkerProfileScreen({
    super.key,
    required this.worker,
    this.flavor,
  });

  @override
  State<WorkerProfileScreen> createState() => _WorkerProfileScreenState();
}

class _WorkerProfileScreenState extends State<WorkerProfileScreen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.05;
    final verticalSpacing = screenHeight * 0.02;
    final titleFontSize = screenWidth * 0.06;
    final nameFontSize = screenWidth * 0.055;
    final subtitleFontSize = screenWidth * 0.035;
    final bodyFontSize = screenWidth * 0.04;
    final smallFontSize = screenWidth * 0.032;
    final avatarSize = screenWidth * 0.25;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Content (Header + Content)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header Section (Yellow Background)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                      ),
                      child: Column(
                        children: [
                          // Back Button and Header
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: verticalSpacing,
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                    size: screenWidth * 0.06,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Profile Picture
                          Container(
                            width: avatarSize * 0.8,
                            height: avatarSize * 0.8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(widget.worker.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          SizedBox(height: verticalSpacing),

                          // Name
                          Text(
                            widget.worker.name,
                            style: GoogleFonts.poppins(
                              fontSize: nameFontSize * 0.9,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          SizedBox(height: verticalSpacing * 0.3),

                          // Location/Nationality
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Australia',
                                style: GoogleFonts.poppins(
                                  fontSize: subtitleFontSize,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '🇦🇺',
                                style: TextStyle(fontSize: subtitleFontSize),
                              ),
                            ],
                          ),

                          SizedBox(height: verticalSpacing * 0.3),

                          // User ID
                          Text(
                            'User ID #${widget.worker.id}',
                            style: GoogleFonts.poppins(
                              fontSize: smallFontSize,
                              color: Colors.grey[600],
                            ),
                          ),

                          SizedBox(height: verticalSpacing),

                          // Stats Row
                          Container(
                            padding: EdgeInsets.symmetric(vertical: verticalSpacing * 0.8),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Level
                                Column(
                                  children: [
                                    Text(
                                      '1',
                                      style: GoogleFonts.poppins(
                                        fontSize: titleFontSize * 0.9,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      'Level',
                                      style: GoogleFonts.poppins(
                                        fontSize: smallFontSize,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                // Rating
                                Column(
                                  children: [
                                    Text(
                                      'No reviews yet',
                                      style: GoogleFonts.poppins(
                                        fontSize: subtitleFontSize,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      'Rating',
                                      style: GoogleFonts.poppins(
                                        fontSize: smallFontSize,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content Section (White Background)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(horizontalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: verticalSpacing * 1.5),

                          // Skills Section
                          Text(
                            'SKILLS',
                            style: GoogleFonts.poppins(
                              fontSize: bodyFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          SizedBox(height: verticalSpacing * 1.5),

                          // Skills Tags
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              _buildSkillTag('General Labourer'),
                              _buildSkillTag('Construction Foreman'),
                              _buildSkillTag('Warehouse Labourer'),
                              _buildSkillTag('Kitchen Hand'),
                              _buildSkillTag('Demolition Worker'),
                              _buildSkillTag('Landscaper'),
                              _buildSkillTag('Roofer'),
                              _buildSkillTag(widget.worker.role),
                            ],
                          ),

                          SizedBox(height: verticalSpacing * 2),

                          // Location and Car Details
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: screenWidth * 0.05,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Suburb: ',
                                style: GoogleFonts.poppins(
                                  fontSize: bodyFontSize,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'kingsgrove',
                                style: GoogleFonts.poppins(
                                  fontSize: bodyFontSize,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: verticalSpacing),

                          Row(
                            children: [
                              Icon(
                                Icons.directions_car,
                                size: screenWidth * 0.05,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Has car? ',
                                style: GoogleFonts.poppins(
                                  fontSize: bodyFontSize,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'No',
                                style: GoogleFonts.poppins(
                                  fontSize: bodyFontSize,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: verticalSpacing * 2),

                          // View Resume Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Implement view resume functionality
                                print('View resume for ${widget.worker.name}');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'View Resume',
                                style: GoogleFonts.poppins(
                                  fontSize: bodyFontSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: verticalSpacing * 2),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Action Bar (Fixed at bottom)
            Container(
              padding: EdgeInsets.all(horizontalPadding),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border(
                  top: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Chat Button
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: Implement chat functionality
                          print('Chat with ${widget.worker.name}');
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: screenWidth * 0.04,
                              color: Colors.black,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Chat',
                              style: GoogleFonts.poppins(
                                fontSize: bodyFontSize * 0.85,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12),

                  // Call Button
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: Implement call functionality
                          print('Call ${widget.worker.name}');
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.phone,
                              size: screenWidth * 0.04,
                              color: Colors.black,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Call',
                              style: GoogleFonts.poppins(
                                fontSize: bodyFontSize * 0.85,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12),

                  // Hire Button
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          _showJobsPopup(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check,
                              size: screenWidth * 0.04,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6),
                                                          Text(
                                'Rehire',
                                style: GoogleFonts.poppins(
                                  fontSize: bodyFontSize * 0.75,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillTag(String skill) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Text(
        skill,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  void _showJobsPopup(BuildContext context) {
    // Create a local copy of jobs that can be modified
    List<Map<String, String>> jobs = List.from(_mockJobs);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Icon(
                          Icons.work,
                          color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Select Job',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.close,
                            color: Colors.grey[600],
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Jobs List
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: jobs.length,
                        itemBuilder: (context, index) {
                          final job = jobs[index];
                          return GestureDetector(
                            onTap: () {
                              // Toggle job selection
                              setState(() {
                                if (job['isSelected'] == 'true') {
                                  job['isSelected'] = 'false';
                                } else {
                                  // Deselect all other jobs
                                  for (var j in jobs) {
                                    j['isSelected'] = 'false';
                                  }
                                  job['isSelected'] = 'true';
                                }
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 12),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: job['isSelected'] == 'true' 
                                    ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)).withValues(alpha: 0.1)
                                    : Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: job['isSelected'] == 'true'
                                      ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                                      : Colors.grey[200]!,
                                  width: job['isSelected'] == 'true' ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          job['title']!,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: job['status'] == 'Active' 
                                              ? Colors.green[100] 
                                              : Colors.orange[100],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          job['status']!,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: job['status'] == 'Active' 
                                                ? Colors.green[700] 
                                                : Colors.orange[700],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    job['location']!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    job['date']!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey[400]!),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                // Find selected job and update its status
                                final selectedJob = jobs.firstWhere(
                                  (job) => job['isSelected'] == 'true',
                                  orElse: () => jobs.first,
                                );
                                
                                setState(() {
                                  selectedJob['status'] = 'Active';
                                  selectedJob['isSelected'] = 'false';
                                });
                                
                                // Show success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${widget.worker.name} has been rehired for ${selectedJob['title']}',
                                      style: GoogleFonts.poppins(),
                                    ),
                                    backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                                
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Rehire',
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
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Mock jobs data
  final List<Map<String, String>> _mockJobs = [
    {
      'title': 'Construction Worker - 15 Ernest St',
      'location': '15 Ernest St, Balgowlah Heights, Sydney',
      'date': 'Dec 15, 2024 - Dec 20, 2024',
      'status': 'Active',
      'isSelected': 'false',
    },
    {
      'title': 'Plumber - Downtown Project',
      'location': '123 Main St, Sydney CBD',
      'date': 'Dec 18, 2024 - Dec 25, 2024',
      'status': 'Active',
      'isSelected': 'false',
    },
    {
      'title': 'General Labourer - Warehouse',
      'location': '456 Industrial Ave, Botany',
      'date': 'Dec 10, 2024 - Dec 12, 2024',
      'status': 'Completed',
      'isSelected': 'false',
    },
    {
      'title': 'Electrician - Office Building',
      'location': '789 Business Blvd, North Sydney',
      'date': 'Dec 22, 2024 - Dec 30, 2024',
      'status': 'Active',
      'isSelected': 'false',
    },
  ];
}
