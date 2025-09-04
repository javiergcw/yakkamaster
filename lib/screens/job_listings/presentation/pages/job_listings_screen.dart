import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../config/app_flavor.dart';
import '../../../../config/assets_config.dart';
import '../widgets/job_card.dart';
import '../../../../features/widgets/search_input_field.dart';
import '../../logic/controllers/job_listings_screen_controller.dart';

class JobListingsScreen extends StatelessWidget {
  static const String id = '/job-listings';
  
  final AppFlavor? flavor;
  JobListingsScreen({super.key, this.flavor});

  final JobListingsScreenController controller = Get.put(JobListingsScreenController());

  @override
  Widget build(BuildContext context) {
    // Establecer el flavor en el controlador si se proporciona
    if (flavor != null) {
      controller.currentFlavor.value = flavor!;
    }
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final sectionTitleFontSize = screenWidth * 0.045;
    final bodyFontSize = screenWidth * 0.035;
    final iconSize = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black87,
            size: iconSize,
          ),
          onPressed: controller.handleBackNavigation,
        ),
        title: Column(
          children: [
            Text(
              'Job Listings Will Be Updated in:',
              style: GoogleFonts.poppins(
                fontSize: bodyFontSize * 0.9,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            GetBuilder<JobListingsScreenController>(
              builder: (controller) => Text(
                controller.jobListingsController.countdown,
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize * 1.1,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: EdgeInsets.symmetric(vertical: verticalSpacing),
                child: SearchInputField(
                  controller: controller.searchController,
                  hintText: 'Search job or skill',
                  flavor: controller.currentFlavor.value,
                  onChanged: controller.updateSearchQuery,
                  onSearch: controller.handleSearch,
                ),
              ),
              
              // Recommended Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: verticalSpacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended for you',
                      style: GoogleFonts.poppins(
                        fontSize: sectionTitleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: verticalSpacing * 0.3),
                    GetBuilder<JobListingsScreenController>(
                      builder: (controller) => Text(
                        '+${controller.jobListingsController.totalJobs.toStringAsFixed(0)} jobs available in Australia',
                        style: GoogleFonts.poppins(
                          fontSize: bodyFontSize,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Job Listings
              Expanded(
                child: GetBuilder<JobListingsScreenController>(
                  builder: (controller) {
                    if (controller.jobListingsController.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    
                    if (controller.jobListingsController.filteredJobs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: iconSize * 3,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: verticalSpacing),
                            Text(
                              'No jobs found',
                              style: GoogleFonts.poppins(
                                fontSize: sectionTitleFontSize,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: verticalSpacing * 0.5),
                            Text(
                              'Try adjusting your search criteria',
                              style: GoogleFonts.poppins(
                                fontSize: bodyFontSize,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    return ListView.builder(
                      padding: EdgeInsets.only(bottom: verticalSpacing * 2),
                      itemCount: controller.jobListingsController.filteredJobs.length,
                      itemBuilder: (context, index) {
                        final job = controller.jobListingsController.filteredJobs[index];
                        return JobCard(
                          job: job,
                          onShare: () => controller.shareJob(job),
                          onShowMore: () => controller.showMoreDetails(job),
                          horizontalPadding: horizontalPadding,
                          verticalSpacing: verticalSpacing,
                          titleFontSize: titleFontSize,
                          bodyFontSize: bodyFontSize,
                          iconSize: iconSize,
                          flavor: controller.currentFlavor.value,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
