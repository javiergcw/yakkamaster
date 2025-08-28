import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../logic/controllers/applicant_controller.dart';
import '../../data/data.dart';
import '../widgets/widgets.dart';
import '../../../post_job/presentation/pages/post_job_stepper_screen.dart';

class ApplicantsScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const ApplicantsScreen({
    super.key,
    this.flavor,
  });

  @override
  State<ApplicantsScreen> createState() => _ApplicantsScreenState();
}

class _ApplicantsScreenState extends State<ApplicantsScreen> {
  late ApplicantController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ApplicantController());
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(screenWidth),
            
            // Content
            Expanded(
              child: Obx(() {
                if (_controller.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (_controller.errorMessage.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          _controller.errorMessage,
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        ElevatedButton(
                          onPressed: () => _controller.loadJobsiteApplicants(),
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (_controller.jobsiteApplicants.isEmpty) {
                  return EmptyStateWidget(
                    flavor: widget.flavor,
                    onPostJob: _handlePostJob,
                  );
                }

                return _buildJobsiteApplicantsList();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Container(
      color: Colors.grey[800],
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenWidth * 0.06, // Aumentar altura del app bar
      ),
      child: Row(
        children: [
          // Botón de regreso
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: screenWidth * 0.06,
            ),
          ),
          
          SizedBox(width: screenWidth * 0.04),
          
          // Título
          Text(
            "Applicants",
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.055,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildJobsiteApplicantsList() {
    return ListView.builder(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      itemCount: _controller.jobsiteApplicants.length,
      itemBuilder: (context, index) {
        final jobsiteApplicants = _controller.jobsiteApplicants[index];
        return _buildJobsiteSection(jobsiteApplicants);
      },
    );
  }

  Widget _buildJobsiteSection(JobsiteApplicantsDto jobsiteApplicants) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final titleFontSize = screenWidth * 0.045;
    final subtitleFontSize = screenWidth * 0.035;
    final sectionPadding = screenWidth * 0.05;

    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del jobsite directamente en la vista
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sectionPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jobsiteApplicants.jobsiteName,
                  style: GoogleFonts.poppins(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  jobsiteApplicants.jobsiteAddress,
                  style: GoogleFonts.poppins(
                    fontSize: subtitleFontSize,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  '${jobsiteApplicants.applicants.length} applicant${jobsiteApplicants.applicants.length != 1 ? 's' : ''}',
                  style: GoogleFonts.poppins(
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w500,
                    color: Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: screenHeight * 0.02),
          
          // Lista horizontal de applicants
          _buildApplicantsList(jobsiteApplicants.applicants),
        ],
      ),
    );
  }

  Widget _buildApplicantsList(List<ApplicantDto> applicants) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    if (applicants.isEmpty) {
      return Container(
        height: screenHeight * 0.15,
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                size: screenWidth * 0.08,
                color: Colors.grey[400],
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'No applicants yet',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

         return Container(
       height: screenHeight * 0.2, // Reducir altura de la card
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        itemCount: applicants.length,
        itemBuilder: (context, index) {
          final applicant = applicants[index];
                     return Container(
             width: screenWidth * 0.75, // Aumentar ligeramente el ancho
            margin: EdgeInsets.only(right: screenWidth * 0.04),
            child: ApplicantCard(
              applicant: applicant,
              flavor: widget.flavor,
              onChat: () => _handleChat(applicant.id),
              onDecline: () => _handleDecline(applicant.id),
              onHire: () => _handleHire(applicant.id),
            ),
          );
        },
      ),
    );
  }

  void _handlePostJob() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostJobStepperScreen(
          flavor: widget.flavor,
        ),
      ),
    );
  }

  void _handleChat(String applicantId) {
    _controller.chatWithApplicant(applicantId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening chat...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleDecline(String applicantId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Decline Applicant'),
          content: Text('Are you sure you want to decline this applicant?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _controller.declineApplicant(applicantId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Applicant declined'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Text('Decline', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _handleHire(String applicantId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hire Applicant'),
          content: Text('Are you sure you want to hire this applicant?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _controller.hireApplicant(applicantId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Applicant hired successfully'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Text('Hire', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }
}
