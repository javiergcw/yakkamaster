import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/app_flavor.dart';
import '../../data/applied_job_dto.dart';
import '../../../job_listings/data/dto/job_dto.dart';
import '../../../job_listings/data/dto/job_details_dto.dart';
import '../../../job_listings/presentation/widgets/job_card.dart';
import '../../../job_listings/presentation/pages/job_details_screen.dart';

class AppliedJobsScreen extends StatefulWidget {
  final AppFlavor? flavor;
  final List<AppliedJobDto> appliedJobs;

  const AppliedJobsScreen({
    super.key,
    this.flavor,
    required this.appliedJobs,
  });

  @override
  State<AppliedJobsScreen> createState() => _AppliedJobsScreenState();
}

class _AppliedJobsScreenState extends State<AppliedJobsScreen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;

  // Convertir AppliedJobDto a JobDto para usar con JobCard
  List<JobDto> get _jobCards {
    return widget.appliedJobs.map((appliedJob) => JobDto(
      id: appliedJob.id,
      title: appliedJob.jobTitle,
      hourlyRate: 25.0, // Valor por defecto, se puede ajustar
      location: appliedJob.location,
      dateRange: '${appliedJob.appliedDate.day.toString().padLeft(2, '0')}/${appliedJob.appliedDate.month.toString().padLeft(2, '0')}/${appliedJob.appliedDate.year} - ${appliedJob.appliedDate.day.toString().padLeft(2, '0')}/${appliedJob.appliedDate.month.toString().padLeft(2, '0')}/${appliedJob.appliedDate.year}',
      jobType: 'Casual Job',
      source: appliedJob.companyName,
      postedDate: '${appliedJob.appliedDate.day.toString().padLeft(2, '0')}-${appliedJob.appliedDate.month.toString().padLeft(2, '0')}',
    )).toList();
  }

  void _handleShare(JobDto job) {
    print('Share job: ${job.title}');
    // Aquí puedes implementar la lógica de compartir
  }

  void _handleShowMore(JobDto job) {
    // Convertir JobDto a JobDetailsDto para la navegación
    final jobDetails = JobDetailsDto(
      id: job.id,
      title: job.title,
      hourlyRate: job.hourlyRate,
      location: job.location,
      dateRange: job.dateRange,
      jobType: job.jobType,
      source: job.source,
      postedDate: job.postedDate,
      company: job.source,
      address: job.location,
      suburb: '',
      city: '',
      startDate: job.dateRange.split(' - ')[0],
      time: '9:00 AM - 5:00 PM',
      paymentExpected: 'Within 7 days',
      aboutJob: 'This is a detailed description of the job position.',
      requirements: [
        'Valid driver license',
        'Previous experience required',
        'Good communication skills',
      ],
      latitude: -33.8688,
      longitude: 151.2093,
    );
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => JobDetailsScreen(
          jobDetails: jobDetails,
          flavor: _currentFlavor,
          isFromAppliedJobs: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: iconSize,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Applications',
          style: GoogleFonts.poppins(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: _jobCards.isEmpty
          ? _buildEmptyState()
          : _buildJobList(),
    );
  }

  Widget _buildEmptyState() {
    final mediaQuery = MediaQuery.of(context);
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
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.045;
    final bodyFontSize = screenWidth * 0.035;
    final iconSize = screenWidth * 0.06;

    return ListView.builder(
      padding: EdgeInsets.all(horizontalPadding),
      itemCount: _jobCards.length,
      itemBuilder: (context, index) {
        final job = _jobCards[index];
        return JobCard(
          job: job,
          onShare: () => _handleShare(job),
          onShowMore: () => _handleShowMore(job),
          horizontalPadding: horizontalPadding,
          verticalSpacing: verticalSpacing,
          titleFontSize: titleFontSize,
          bodyFontSize: bodyFontSize,
          iconSize: iconSize,
          flavor: _currentFlavor,
        );
      },
    );
  }
}
