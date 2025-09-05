import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../logic/controllers/applicant_controller.dart';
import '../../data/data.dart';
import '../widgets/widgets.dart';

class ApplicantsScreen extends StatelessWidget {
  static const String id = '/applicants';
  
  final AppFlavor? flavor;

  const ApplicantsScreen({
    super.key,
    this.flavor,
  });

  @override
  Widget build(BuildContext context) {
    final ApplicantController controller = Get.find<ApplicantController>();
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, screenWidth),
            
            // Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (controller.errorMessage.isNotEmpty) {
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
                          controller.errorMessage,
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        ElevatedButton(
                          onPressed: () => controller.loadJobsiteApplicants(),
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.jobsiteApplicants.isEmpty) {
                  return EmptyStateWidget(
                    flavor: flavor,
                    onPostJob: _handlePostJob,
                  );
                }

                return _buildJobsiteApplicantsList(context, controller);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double screenWidth) {
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
            onTap: () => Get.back(),
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



  Widget _buildJobsiteApplicantsList(BuildContext context, ApplicantController controller) {
    return ListView.builder(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      itemCount: controller.jobsiteApplicants.length,
      itemBuilder: (context, index) {
        final jobsiteApplicants = controller.jobsiteApplicants[index];
        return _buildJobsiteSection(context, jobsiteApplicants);
      },
    );
  }

  Widget _buildJobsiteSection(BuildContext context, JobsiteApplicantsDto jobsiteApplicants) {
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
                    color: Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor)),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: screenHeight * 0.02),
          
          // Lista horizontal de applicants
          _buildApplicantsList(context, jobsiteApplicants.applicants),
        ],
      ),
    );
  }

  Widget _buildApplicantsList(BuildContext context, List<ApplicantDto> applicants) {
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
              flavor: flavor,
              onChat: () => _handleChat(context, applicant.id),
              onDecline: () => _handleDecline(context, applicant.id),
              onHire: () => _handleHire(context, applicant.id),
            ),
          );
        },
      ),
    );
  }

  void _handlePostJob() {
    // TODO: Agregar la ruta de PostJobStepperScreen a app_pages.dart
    // Get.toNamed(PostJobStepperScreen.id, arguments: {'flavor': flavor});
    Get.snackbar(
      'Info',
      'Post Job functionality - route needs to be added to app_pages.dart',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _handleChat(BuildContext context, String applicantId) {
    final ApplicantController controller = Get.find<ApplicantController>();
    controller.chatWithApplicant(applicantId);
    Get.snackbar(
      'Chat',
      'Opening chat...',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void _handleDecline(BuildContext context, String applicantId) {
    final ApplicantController controller = Get.find<ApplicantController>();
    Get.dialog(
      AlertDialog(
        title: Text('Decline Applicant'),
        content: Text('Are you sure you want to decline this applicant?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.declineApplicant(applicantId);
              Get.snackbar(
                'Success',
                'Applicant declined',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 2),
              );
            },
            child: Text('Decline', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _handleHire(BuildContext context, String applicantId) {
    final ApplicantController controller = Get.find<ApplicantController>();
    Get.dialog(
      AlertDialog(
        title: Text('Hire Applicant'),
        content: Text('Are you sure you want to hire this applicant?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.hireApplicant(applicantId);
              Get.snackbar(
                'Success',
                'Applicant hired successfully',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 2),
              );
            },
            child: Text('Hire', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }
}
