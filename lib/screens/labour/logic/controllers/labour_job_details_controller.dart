import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_flavor.dart';
import '../../../../features/logic/labour/use_case/jobs_use_case.dart';
import '../../../../features/logic/labour/use_case/applications_use_case.dart';
import '../../../../features/logic/labour/models/receive/dto_receive_job_detail_response.dart';
import '../../../../features/logic/labour/models/receive/dto_receive_labour_job_detail.dart';
import '../../../../screens/job_listings/data/dto/job_details_dto.dart';

class LabourJobDetailsController extends GetxController {
  // Use case para operaciones de jobs
  final JobsUseCase _jobsUseCase = JobsUseCase();
  
  // Use case para operaciones de aplicaciones
  final ApplicationsUseCase _applicationsUseCase = ApplicationsUseCase();

  // Estados observables
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<DtoReceiveJobDetailResponse?> jobDetailResponse = Rx<DtoReceiveJobDetailResponse?>(null);
  final RxBool hasApplied = false.obs;
  final RxString applicationStatus = ''.obs;

  // Getters para facilitar el acceso a los datos
  DtoReceiveLabourJobDetail? get job => jobDetailResponse.value?.job;
  DtoReceiveApplication? get application => jobDetailResponse.value?.application;
  bool get isJobLoaded => jobDetailResponse.value != null;
  bool get isApplicationLoaded => application != null;

  /// Carga los detalles de un job con información de aplicación
  Future<void> loadJobDetailWithApplication(String jobId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('LabourJobDetailsController - Loading job detail for ID: $jobId');

      final result = await _jobsUseCase.getJobById(jobId);

      if (result.isSuccess && result.data != null) {
        jobDetailResponse.value = result.data!;
        hasApplied.value = result.data!.hasApplied;
        applicationStatus.value = result.data!.applicationStatus ?? '';
      } else {
        errorMessage.value = result.message ?? 'Error loading job details';
      }
    } catch (e) {
      errorMessage.value = 'Error loading job details: $e';
      print('LabourJobDetailsController - Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Convierte DtoReceiveLabourJobDetail a JobDetailsDto para la vista
  JobDetailsDto convertToJobDetailsDto() {
    if (job == null) {
      throw Exception('Job not loaded');
    }

    final currentJob = job!;
    
    // Crear título con skill + subskill x número de labours
    final skillName = _getSkillName(currentJob);
    final subSkillName = _getSubSkillName(currentJob);
    final title = '${skillName}, ${subSkillName} x${currentJob.manyLabours}';
    
    // Usar total_wage si está disponible, sino usar wage_site_allowance como fallback
    final totalWage = currentJob.totalWage;
    
    return JobDetailsDto(
      id: currentJob.id,
      title: title,
      hourlyRate: totalWage,
      location: currentJob.jobsite?.name ?? currentJob.jobsite?.address ?? 'Location TBD',
      dateRange: '${_formatDate(currentJob.startDateWork)} - ${_formatDate(currentJob.endDateWork)}',
      jobType: currentJob.jobType?.name ?? currentJob.paymentType,
      source: currentJob.builderProfile.displayName,
      postedDate: _formatDate(currentJob.createdAt),
      company: currentJob.builderProfile.displayName,
      address: currentJob.jobsite?.address ?? 'Address TBD',
      suburb: currentJob.jobsite?.suburb ?? '',
      city: currentJob.jobsite?.suburb ?? '', // Usar suburb como city
      startDate: _formatDate(currentJob.startDateWork),
      time: '${_formatTimeFromString(currentJob.startTime)} - ${_formatTimeFromString(currentJob.endTime)}',
      paymentExpected: _formatPaymentDay(currentJob.paymentDay),
      aboutJob: currentJob.description.isNotEmpty ? currentJob.description : 'Construction work position.',
      requirements: currentJob.jobRequirements.map((req) => req.name).toList(),
      latitude: currentJob.jobsite?.latitude ?? -33.8688,
      longitude: currentJob.jobsite?.longitude ?? 151.2093,
      wageSiteAllowance: currentJob.wageSiteAllowance,
      wageLeadingHandAllowance: currentJob.wageLeadingHandAllowance,
      wageProductivityAllowance: currentJob.wageProductivityAllowance,
      extrasOvertimeRate: currentJob.extrasOvertimeRate,
      wageHourlyRate: currentJob.wageHourlyRate,
      travelAllowance: currentJob.travelAllowance,
      gst: currentJob.gst,
    );
  }

  /// Obtiene el nombre de la skill del job
  String _getSkillName(DtoReceiveLabourJobDetail job) {
    // Buscar en job_skills para obtener el nombre de la categoría
    if (job.jobSkills.isNotEmpty) {
      final firstSkill = job.jobSkills.first;
      if (firstSkill.skillCategory != null) {
        return firstSkill.skillCategory!.name;
      }
    }
    
    // Fallback: usar description si no hay skills
    if (job.description.isNotEmpty) {
      return job.description;
    }
    
    // Último fallback
    return 'Skill';
  }

  /// Obtiene el nombre de la subskill del job
  String _getSubSkillName(DtoReceiveLabourJobDetail job) {
    // Buscar en job_skills para obtener el nombre de la subcategoría
    if (job.jobSkills.isNotEmpty) {
      final firstSkill = job.jobSkills.first;
      if (firstSkill.skillSubcategory != null) {
        return firstSkill.skillSubcategory!.name;
      }
    }
    
    // Fallback
    return 'Specialization';
  }

  /// Formatea una fecha ISO string a formato legible
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return 'Date TBD';
    }
  }

  /// Formatea un string de tiempo en formato "HH:mm:ss" a "HH:mm"
  String _formatTimeFromString(String timeString) {
    try {
      if (timeString.isEmpty) return 'Time TBD';
      
      // Si ya está en formato "HH:mm:ss", extraer solo "HH:mm"
      if (timeString.contains(':')) {
        final parts = timeString.split(':');
        if (parts.length >= 2) {
          return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
        }
      }
      
      return timeString;
    } catch (e) {
      return 'Time TBD';
    }
  }

  /// Formatea el payment_day de ISO string a formato legible
  String _formatPaymentDay(String paymentDayString) {
    try {
      if (paymentDayString.isEmpty) return 'Payment day TBD';
      
      final date = DateTime.parse(paymentDayString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return 'Payment day TBD';
    }
  }

  /// Maneja la navegación hacia atrás
  void handleBackNavigation() {
    Get.back();
  }

  /// Maneja la aplicación al trabajo
  Future<void> handleApply() async {
    if (job == null) {
      print('LabourJobDetailsController.handleApply - No job available');
      Get.snackbar(
        'Error',
        'No job data available',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
      return;
    }

    try {
      print('LabourJobDetailsController.handleApply - Applying to job: ${job!.id}');
      
      // Mostrar loading
      isLoading.value = true;
      errorMessage.value = '';

      // Aplicar al trabajo
      final result = await _applicationsUseCase.applyToJob(
        jobId: job!.id,
        coverLetter: null, // Por ahora sin carta de presentación
        resumeUrl: null, // Por ahora sin CV
      );

      if (result.isSuccess && result.data != null) {
        print('LabourJobDetailsController.handleApply - Application successful: ${result.data!.applicationId}');
        
        // Actualizar estado
        hasApplied.value = true;
        applicationStatus.value = result.data!.status;
        
        // Mostrar modal de éxito
        showSuccessModal.value = true;
        
        Get.snackbar(
          'Success',
          'Application submitted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
        );
      } else {
        print('LabourJobDetailsController.handleApply - Application failed: ${result.message}');
        errorMessage.value = result.message ?? 'Failed to submit application';
        
        Get.snackbar(
          'Error',
          result.message ?? 'Failed to submit application',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
      }
    } catch (e) {
      print('LabourJobDetailsController.handleApply - Error: $e');
      errorMessage.value = 'Error submitting application: $e';
      
      Get.snackbar(
        'Error',
        'Error submitting application: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Maneja el reporte del trabajo
  void handleReportJob() {
    // TODO: Implementar lógica de reporte
    print('LabourJobDetailsController - Report job');
  }

  /// Maneja el cierre del modal de éxito
  void handleCloseModal() {
    print('LabourJobDetailsController - Closing success modal');
    showSuccessModal.value = false;
  }

  /// Maneja la navegación a trabajos aplicados
  void handleViewAppliedJobs() {
    print('LabourJobDetailsController - Navigating to applied jobs');
    
    // Cerrar el modal primero
    showSuccessModal.value = false;
    
    // Navegar a la pantalla de trabajos aplicados
    // Por ahora, navegar de vuelta a la pantalla anterior
    // TODO: Implementar navegación específica a trabajos aplicados cuando esté disponible
    Get.back();
  }

  /// Observable para mostrar el modal de éxito
  final RxBool showSuccessModal = false.obs;
}