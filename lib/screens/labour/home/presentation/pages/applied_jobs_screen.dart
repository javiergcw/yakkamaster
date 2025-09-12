import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/constants.dart';
import '../../data/applied_job_dto.dart';
import '../../../../job_listings/data/dto/job_dto.dart';
import '../../../../job_listings/presentation/widgets/job_card.dart';
import '../../logic/controllers/applied_jobs_screen_controller.dart';

class AppliedJobsScreen extends StatelessWidget {
  static const String id = '/labour/applied-jobs';
  
  final AppFlavor? flavor;
  final List<AppliedJobDto>? appliedJobs;

  AppliedJobsScreen({
    super.key,
    this.flavor,
    this.appliedJobs,
  });

  final AppliedJobsScreenController controller = Get.put(AppliedJobsScreenController());

  @override
  Widget build(BuildContext context) {
    // Establecer el flavor y appliedJobs en el controlador si se proporcionan
    if (flavor != null) {
      controller.currentFlavor.value = flavor!;
    }
    if (appliedJobs != null) {
      controller.appliedJobs.value = appliedJobs!;
    }
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final bodyFontSize = screenWidth * 0.035;
    final iconSize = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppConstants.darkGreyColor,
        elevation: 0,
        toolbarHeight: screenHeight * 0.08, // Aumentar la altura del AppBar
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: iconSize,
          ),
          onPressed: controller.handleBackNavigation,
        ),
        title: Text(
          'Applications',
          style: GoogleFonts.poppins(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() => controller.jobCards.isEmpty
          ? _buildEmptyState()
          : _buildJobList()),
    );
  }

  Widget _buildEmptyState() {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.045;
    final bodyFontSize = screenWidth * 0.035;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_off,
              size: screenWidth * 0.2,
              color: Colors.grey[400],
            ),
            SizedBox(height: verticalSpacing * 2),
            Text(
              'No applications yet',
              style: GoogleFonts.poppins(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: verticalSpacing),
            Text(
              'Start applying for jobs to see your applications here',
              style: GoogleFonts.poppins(
                fontSize: bodyFontSize,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobList() {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.045;
    final bodyFontSize = screenWidth * 0.035;
    final iconSize = screenWidth * 0.06;

    return ListView.builder(
      padding: EdgeInsets.all(horizontalPadding),
      itemCount: controller.jobCards.length,
      itemBuilder: (context, index) {
        final job = controller.jobCards[index];
        return JobCard(
          job: job,
          onShare: () => controller.handleShare(job),
          onShowMore: () => controller.handleShowMore(job),
          horizontalPadding: horizontalPadding,
          verticalSpacing: verticalSpacing,
          titleFontSize: titleFontSize,
          bodyFontSize: bodyFontSize,
          iconSize: iconSize,
          flavor: controller.currentFlavor.value,
        );
      },
    );
  }
}
