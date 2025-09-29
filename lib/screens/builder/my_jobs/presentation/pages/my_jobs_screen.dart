import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../logic/controllers/my_jobs_controller.dart';
import '../widgets/widgets.dart';
import '../../../post_job/presentation/pages/post_job_stepper_screen.dart';
import '../../../../job_listings/presentation/pages/job_details_screen.dart';
import '../../../../job_listings/data/dto/job_details_dto.dart';

class MyJobsScreen extends StatelessWidget {
  static const String id = '/builder/my-jobs';
  
  final AppFlavor? flavor;

  MyJobsScreen({
    super.key,
    this.flavor,
  });

  final MyJobsController controller = Get.put(MyJobsController());

  @override
  Widget build(BuildContext context) {
    // Establecer el flavor en el controlador
    if (flavor != null) {
      controller.currentFlavor.value = flavor!;
    }
    
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
            
            // Tabs
            _buildTabs(screenWidth),
            
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
                          onPressed: () => controller.loadJobs(),
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.jobs.isEmpty) {
                  return EmptyStateWidget(
                    flavor: flavor,
                    onPostJob: _handlePostJob,
                  );
                }

                return _buildJobsList(context);
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
        vertical: screenWidth * 0.04,
      ),
      child: Row(
        children: [
          // Botón de regreso
          GestureDetector(
            onTap: () => controller.handleBackNavigation(),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: screenWidth * 0.06,
            ),
          ),
          
          SizedBox(width: screenWidth * 0.04),
          
          // Título
          Text(
            "Your Jobs",
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

  Widget _buildTabs(double screenWidth) {
    return Container(
      color: Colors.grey[800],
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Row(
        children: [
          // Tab Active
          Expanded(
            child: Obx(() => _buildTab(
              text: "Active",
              isSelected: controller.isActiveTab,
              onTap: () => controller.switchTab(true),
              screenWidth: screenWidth,
            )),
          ),
          
          // Tab Archived
          Expanded(
            child: Obx(() => _buildTab(
              text: "Archived",
              isSelected: !controller.isActiveTab,
              onTap: () => controller.switchTab(false),
              screenWidth: screenWidth,
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
    required double screenWidth,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected 
                ? Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor))
                : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[400],
          ),
        ),
      ),
    );
  }

  Widget _buildJobsList(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = screenHeight * 0.02;
    
    return ListView.builder(
      padding: EdgeInsets.only(top: topPadding),
      itemCount: controller.jobs.length,
      itemBuilder: (context, index) {
        final job = controller.jobs[index];
        return JobCard(
          job: job,
          flavor: flavor,
          onShare: () => _handleShareJob(job.id),
          onDelete: () => _handleDeleteJob(job.id),
          onShowMore: () => _handleShowMore(job.id),
          onVisibilityChanged: (isVisible) => _handleVisibilityChanged(job.id, isVisible),
        );
      },
    );
  }

  void _handlePostJob() {
    Get.toNamed(PostJobStepperScreen.id, arguments: {
      'flavor': flavor,
    });
  }

  void _handleShareJob(String jobId) {
    controller.shareJob(jobId);
  }

  void _handleDeleteJob(String jobId) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Job'),
        content: Text('Are you sure you want to delete this job?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteJob(jobId);
              Get.snackbar(
                'Success',
                'Job deleted successfully',
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 2),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _handleShowMore(String jobId) async {
    print('_handleShowMore called with jobId: $jobId');
    try {
      // Usar el controlador para obtener el job real de la API
      final realJob = await controller.getRealJobById(jobId);
      print('_handleShowMore - realJob: ${realJob?.id}');
      
      if (realJob != null) {
        print('_handleShowMore - Navigating with realJob: ${realJob.id}');
        Get.toNamed(JobDetailsScreen.id, arguments: {
          'realJob': realJob, // Pasar el DtoReceiveJob real
          'flavor': flavor,
          'isFromAppliedJobs': false,
          'isFromBuilder': true, // Indicar que viene del builder
        });
      } else {
        print('_handleShowMore - realJob is null, using fallback');
        // Fallback: usar el JobDto convertido
        final job = controller.jobs.firstWhere((job) => job.id == jobId);
        
        // Crear JobDetailsDto con los datos del JobDto
        final jobDetails = JobDetailsDto(
          id: job.id,
          title: job.title,
          hourlyRate: job.rate,
          location: job.location,
          dateRange: '${_formatDate(job.startDate)} - ${_formatDate(job.endDate)}',
          jobType: job.jobType,
          source: job.source,
          postedDate: _formatDate(job.postedDate),
          company: job.source,
          address: job.location,
          suburb: '',
          city: '',
          startDate: _formatDate(job.startDate),
          time: '${_formatTime(job.startDate)} - ${_formatTime(job.endDate)}',
          paymentExpected: job.jobType,
          aboutJob: 'This is a ${job.jobType.toLowerCase()} position for ${job.title}.',
          requirements: [
            'Experience in ${job.title.toLowerCase()}',
            'Valid work permit',
            'Good communication skills',
            'Reliable and punctual',
          ],
          latitude: -33.8688,
          longitude: 151.2093,
          wageSiteAllowance: job.rate,
          wageLeadingHandAllowance: 0.0,
          wageProductivityAllowance: 0.0,
          extrasOvertimeRate: 1.5,
          wageHourlyRate: null,
          travelAllowance: null,
          gst: null,
        );
        
        Get.toNamed(JobDetailsScreen.id, arguments: {
          'jobDetails': jobDetails,
          'flavor': flavor,
          'isFromAppliedJobs': false,
          'isFromBuilder': true,
        });
      }
    } catch (e) {
      // En caso de error, usar el JobDto convertido como fallback
      final job = controller.jobs.firstWhere((job) => job.id == jobId);
      
      final jobDetails = JobDetailsDto(
        id: job.id,
        title: job.title,
        hourlyRate: job.rate,
        location: job.location,
        dateRange: '${_formatDate(job.startDate)} - ${_formatDate(job.endDate)}',
        jobType: job.jobType,
        source: job.source,
        postedDate: _formatDate(job.postedDate),
        company: job.source,
        address: job.location,
        suburb: '',
        city: '',
        startDate: _formatDate(job.startDate),
        time: '${_formatTime(job.startDate)} - ${_formatTime(job.endDate)}',
        paymentExpected: job.jobType,
        aboutJob: 'This is a ${job.jobType.toLowerCase()} position for ${job.title}.',
        requirements: [
          'Experience in ${job.title.toLowerCase()}',
          'Valid work permit',
          'Good communication skills',
          'Reliable and punctual',
        ],
        latitude: -33.8688,
        longitude: 151.2093,
        wageSiteAllowance: job.rate,
        wageLeadingHandAllowance: 0.0,
        wageProductivityAllowance: 0.0,
        extrasOvertimeRate: 1.5,
        wageHourlyRate: null,
        travelAllowance: null,
        gst: null,
      );
      
      Get.toNamed(JobDetailsScreen.id, arguments: {
        'jobDetails': jobDetails,
        'flavor': flavor,
        'isFromAppliedJobs': false,
        'isFromBuilder': true,
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }



  void _handleVisibilityChanged(String jobId, bool isVisible) {
    controller.updateJobVisibility(jobId, isVisible);
    Get.snackbar(
      'Success',
      'Job visibility updated',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );
  }
}
