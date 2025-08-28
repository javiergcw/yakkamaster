import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../logic/controllers/my_jobs_controller.dart';
import '../widgets/widgets.dart';
import '../../../post_job/presentation/pages/post_job_stepper_screen.dart';
import '../../../../job_listings/presentation/pages/job_details_screen.dart';
import '../../../../job_listings/data/dto/job_details_dto.dart';

class MyJobsScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const MyJobsScreen({
    super.key,
    this.flavor,
  });

  @override
  State<MyJobsScreen> createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen> {
  late MyJobsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(MyJobsController());
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
            
            // Tabs
            _buildTabs(screenWidth),
            
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
                          onPressed: () => _controller.loadJobs(),
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (_controller.jobs.isEmpty) {
                  return EmptyStateWidget(
                    flavor: widget.flavor,
                    onPostJob: _handlePostJob,
                  );
                }

                return _buildJobsList();
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
            "Your jobs",
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
              isSelected: _controller.isActiveTab,
              onTap: () => _controller.switchTab(true),
              screenWidth: screenWidth,
            )),
          ),
          
          // Tab Archived
          Expanded(
            child: Obx(() => _buildTab(
              text: "Archived",
              isSelected: !_controller.isActiveTab,
              onTap: () => _controller.switchTab(false),
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
                ? Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor))
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

  Widget _buildJobsList() {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = screenHeight * 0.02;
    
    return ListView.builder(
      padding: EdgeInsets.only(top: topPadding),
      itemCount: _controller.jobs.length,
      itemBuilder: (context, index) {
        final job = _controller.jobs[index];
        return JobCard(
          job: job,
          flavor: widget.flavor,
          onShare: () => _handleShareJob(job.id),
          onDelete: () => _handleDeleteJob(job.id),
          onShowMore: () => _handleShowMore(job.id),
          onVisibilityChanged: (isVisible) => _handleVisibilityChanged(job.id, isVisible),
        );
      },
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

  void _handleShareJob(String jobId) {
    _controller.shareJob(jobId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing job...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleDeleteJob(String jobId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Job'),
          content: Text('Are you sure you want to delete this job?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _controller.deleteJob(jobId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Job deleted successfully'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _handleShowMore(String jobId) {
    // Buscar el trabajo en la lista para obtener los detalles
    final job = _controller.jobs.firstWhere((job) => job.id == jobId);
    
    // Crear JobDetailsDto con los datos del trabajo
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
      suburb: job.location.split(', ').length > 1 ? job.location.split(', ')[1] : '',
      city: job.location.split(', ').length > 2 ? job.location.split(', ')[2] : '',
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
      latitude: -33.8688, // Sydney coordinates as default
      longitude: 151.2093,
    );
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobDetailsScreen(
          jobDetails: jobDetails,
          flavor: widget.flavor,
          isFromAppliedJobs: false,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _handleVisibilityChanged(String jobId, bool isVisible) {
    _controller.updateJobVisibility(jobId, isVisible);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Job visibility updated'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
