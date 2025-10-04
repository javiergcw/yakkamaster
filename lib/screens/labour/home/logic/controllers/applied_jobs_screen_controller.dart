import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/logic/labour/use_case/applications_use_case.dart';
import '../../../../labour/home/presentation/pages/labour_job_details_screen.dart';
import '../../../../../features/logic/labour/models/receive/dto_receive_job_application.dart';
import '../../data/applied_job_dto.dart';
import '../../../../job_listings/data/dto/job_dto.dart';

class AppliedJobsScreenController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final RxList<AppliedJobDto> appliedJobs = <AppliedJobDto>[].obs;
  
  // Use case para aplicaciones
  final ApplicationsUseCase _applicationsUseCase = ApplicationsUseCase();
  
  // Estados para el manejo de aplicaciones del API
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxList<DtoReceiveJobApplication> _apiApplications = <DtoReceiveJobApplication>[].obs;
  
  // Getters
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  List<DtoReceiveJobApplication> get apiApplications => _apiApplications;

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
    
    // Cargar aplicaciones del API
    loadApplications();
  }

  /// Carga las aplicaciones del API
  Future<void> loadApplications() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      
      print('AppliedJobsScreenController.loadApplications - Loading applications from API...');
      
      final result = await _applicationsUseCase.getApplicationsList();
      
      if (result.isSuccess) {
        // El use case ahora siempre retorna una lista (vacía si no hay aplicaciones)
        _apiApplications.value = result.data ?? [];
        print('AppliedJobsScreenController.loadApplications - Loaded ${_apiApplications.length} applications');
        
        if (_apiApplications.isEmpty) {
          // No hay aplicaciones - mostrar estado vacío
          appliedJobs.value = [];
          print('AppliedJobsScreenController.loadApplications - No applications found');
        } else {
          // Convertir aplicaciones del API a AppliedJobDto para compatibilidad
          _convertApiApplicationsToAppliedJobs();
        }
      } else {
        _errorMessage.value = result.message ?? 'Error loading applications';
        print('AppliedJobsScreenController.loadApplications - Error: ${result.message}');
      }
    } catch (e) {
      _errorMessage.value = 'Error loading applications: $e';
      print('AppliedJobsScreenController.loadApplications - Exception: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Convierte las aplicaciones del API a AppliedJobDto para compatibilidad
  void _convertApiApplicationsToAppliedJobs() {
    try {
      final convertedJobs = _apiApplications.map((apiApp) {
        final job = apiApp.job;
        final builderProfile = job.builderProfile;
        final jobsite = job.jobsite;
        
        return AppliedJobDto(
          id: job.id, // Usar el ID del job, no el ID de la aplicación
          jobTitle: job.description,
          companyName: builderProfile.displayName,
          location: jobsite.address,
          appliedDate: apiApp.appliedAtAsDateTime,
          status: apiApp.status,
        );
      }).toList();
      
      appliedJobs.value = convertedJobs;
      print('AppliedJobsScreenController._convertApiApplicationsToAppliedJobs - Converted ${convertedJobs.length} applications');
    } catch (e) {
      print('AppliedJobsScreenController._convertApiApplicationsToAppliedJobs - Error converting: $e');
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
    
    // Generar URL específica con el formato requerido
    final baseUrl = 'https://yakka.com/6NHtwTGCYycOchh8KroQ';
    final shareUrl = 'https://yakka.page.link?apn=com.labours.yakka&ibi=com.labours.yakka&link=${Uri.encodeComponent(baseUrl)}';
    
    // Compartir usando share_plus
    Share.share(
      'Check out this job opportunity: ${job.title} at ${job.source}\n\n$shareUrl',
      subject: 'Job Opportunity - ${job.title}',
    );
    
    // Mostrar confirmación
    Get.snackbar(
      'Shared',
      'Job shared successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void handleShowMore(JobDto job) {
    print('AppliedJobsScreenController.handleShowMore - Navigating to job details for job: ${job.id}');
    
    // Navegar a la pantalla de detalles de job usando el jobId
    // La pantalla de detalles cargará los datos usando el JobsUseCase
    Get.toNamed(LabourJobDetailsScreen.id, arguments: {
      'jobId': job.id,
      'flavor': currentFlavor.value,
      'isFromAppliedJobs': true,
    });
  }

  void handleBackNavigation() {
    Get.back();
  }

  /// Refresca las aplicaciones del API
  Future<void> refreshApplications() async {
    print('AppliedJobsScreenController.refreshApplications - Refreshing applications...');
    await loadApplications();
  }
}
