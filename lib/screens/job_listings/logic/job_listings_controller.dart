import 'dart:async';
import 'package:get/get.dart';
import '../../../../config/app_flavor.dart';
import '../data/dto/job_dto.dart';
import '../data/dto/job_details_dto.dart';
import '../presentation/pages/job_details_screen.dart';

class JobListingsController {
  // Data
  List<JobDto> jobs = [];
  String searchQuery = '';
  bool isLoading = false;
  String countdown = '22:08:30';
  int totalJobs = 30000;

  // Timer for countdown
  Timer? _countdownTimer;

  // Callbacks for UI updates
  Function()? onJobsChanged;
  Function()? onSearchChanged;
  Function()? onLoadingChanged;
  Function()? onCountdownChanged;
  
  // Navigation context
  AppFlavor? _flavor;

  void initialize() {
    loadJobs();
    startCountdown();
  }
  
  void setNavigationContext(AppFlavor flavor) {
    _flavor = flavor;
  }

  void dispose() {
    _countdownTimer?.cancel();
  }

  void loadJobs() {
    isLoading = true;
    onLoadingChanged?.call();
    
    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 500), () {
      jobs = [
        JobDto(
          id: '1',
          title: 'General Labourer X2',
          hourlyRate: 28.00,
          location: 'Lane Cove NSW, Australia, lane cove, Sydney',
          dateRange: '11/08/2025 - 08/02/2026',
          jobType: 'Casual Job',
          source: 'Clearview Pressure Washing Australia',
          postedDate: '10-08',
          isRecommended: true,
        ),
        JobDto(
          id: '2',
          title: 'Glazier X1',
          hourlyRate: 35.00,
          location: '3 Dympna Street, Cromer NSW, Australia, cromer, Sydney',
          dateRange: '28/11/2025 - 30/12/2025',
          jobType: 'Full time',
          source: 'modular glass fencing',
          postedDate: '14-08',
          isRecommended: true,
        ),
        JobDto(
          id: '3',
          title: 'Construction Worker',
          hourlyRate: 32.00,
          location: 'Parramatta NSW, Australia',
          dateRange: '15/09/2025 - 20/12/2025',
          jobType: 'Part time',
          source: 'BuildCorp Construction',
          postedDate: '12-08',
          isRecommended: false,
        ),
        JobDto(
          id: '4',
          title: 'Electrician Assistant',
          hourlyRate: 40.00,
          location: 'North Sydney NSW, Australia',
          dateRange: '01/10/2025 - 31/01/2026',
          jobType: 'Full time',
          source: 'PowerTech Electrical',
          postedDate: '11-08',
          isRecommended: false,
        ),
      ];
      isLoading = false;
      onJobsChanged?.call();
      onLoadingChanged?.call();
    });
  }

  void startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Parse current countdown
      List<String> parts = countdown.split(':');
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      int seconds = int.parse(parts[2]);

      // Decrease by 1 second
      seconds--;
      if (seconds < 0) {
        seconds = 59;
        minutes--;
        if (minutes < 0) {
          minutes = 59;
          hours--;
          if (hours < 0) {
            // Reset countdown when it reaches zero
            hours = 23;
            minutes = 59;
            seconds = 59;
          }
        }
      }

      // Update countdown
      countdown = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      onCountdownChanged?.call();
    });
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    onSearchChanged?.call();
  }

  void clearSearch() {
    searchQuery = '';
    onSearchChanged?.call();
  }

  void shareJob(JobDto job) {
    // TODO: Implement share functionality
    print('Sharing job: ${job.title}');
  }

  void showMoreDetails(JobDto job) {
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
    
    Get.toNamed(JobDetailsScreen.id, arguments: {
      'jobDetails': jobDetails,
      'flavor': _flavor,
      'isFromAppliedJobs': false,
      'isFromBuilder': false,
    });
  }

  List<JobDto> get filteredJobs {
    if (searchQuery.isEmpty) {
      return jobs;
    }
    return jobs.where((job) =>
        job.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
        job.location.toLowerCase().contains(searchQuery.toLowerCase()) ||
        job.jobType.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }

  List<JobDto> get recommendedJobs {
    return jobs.where((job) => job.isRecommended).toList();
  }
}
