import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../data/applied_job_dto.dart';
import '../../../../job_listings/data/dto/job_dto.dart';
import '../../../../job_listings/data/dto/job_details_dto.dart';

class AppliedJobsScreenController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final RxList<AppliedJobDto> appliedJobs = <AppliedJobDto>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Establecer flavor si se proporciona en los argumentos
    final arguments = Get.arguments;
    if (arguments != null) {
      if (arguments['flavor'] != null) {
        currentFlavor.value = arguments['flavor'];
      }
      if (arguments['appliedJobs'] != null) {
        appliedJobs.value = List<AppliedJobDto>.from(arguments['appliedJobs']);
      }
    }
  }

  // Convertir AppliedJobDto a JobDto para usar con JobCard
  List<JobDto> get jobCards {
    return appliedJobs.map((appliedJob) => JobDto(
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

  void handleShare(JobDto job) {
    print('Share job: ${job.title}');
    // Aquí puedes implementar la lógica de compartir
    Get.snackbar(
      'Share',
      'Share functionality not implemented yet',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void handleShowMore(JobDto job) {
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
    
    Get.toNamed('/job-details', arguments: {
      'jobDetails': jobDetails,
      'flavor': currentFlavor.value,
      'isFromAppliedJobs': true,
    });
  }

  void handleBackNavigation() {
    Get.back();
  }
}
