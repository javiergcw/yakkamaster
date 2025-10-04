import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/data.dart';
import '../../../../../features/logic/builder/use_case/applicants_use_case.dart';
import '../../../../../features/logic/builder/models/receive/dto_receive_builder_applicants_response.dart';
import '../../../../../features/logic/builder/models/receive/dto_receive_builder_application.dart';

class ApplicantController extends GetxController {
  final ApplicantsUseCase _applicantsUseCase = ApplicantsUseCase();
  
  final RxList<JobsiteApplicantsDto> _jobsiteApplicants = <JobsiteApplicantsDto>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxBool _hasNewApplicants = false.obs;

  // Getters
  List<JobsiteApplicantsDto> get jobsiteApplicants => _jobsiteApplicants;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get hasNewApplicants => _hasNewApplicants.value;

  @override
  void onInit() {
    super.onInit();
    print('ApplicantController.onInit - Inicializando controlador...');
    loadJobsiteApplicants();
    checkForNewApplicants();
  }

  /// Fuerza la inicialización del controlador
  void forceInit() {
    print('ApplicantController.forceInit - Forzando inicialización...');
    loadJobsiteApplicants();
    checkForNewApplicants();
  }

  /// Fuerza la recarga de datos (para controladores existentes)
  void forceReload() {
    print('ApplicantController.forceReload - Forzando recarga de datos...');
    _isLoading.value = true;
    _errorMessage.value = '';
    loadJobsiteApplicants();
  }

  Future<void> loadJobsiteApplicants() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      
      print('ApplicantController.loadJobsiteApplicants - Iniciando carga de applicants...');
      
      // Usar el nuevo caso de uso
      final result = await _applicantsUseCase.getApplicants();
      
      if (result.isSuccess && result.data != null) {
        final response = result.data!;
        print('ApplicantController.loadJobsiteApplicants - Respuesta exitosa:');
        print('  - Total applicants: ${response.total}');
        print('  - Jobsites: ${response.jobsites.length}');
        print('  - Mensaje: ${response.message}');
        
        // Mapear los datos del nuevo formato a JobsiteApplicantsDto
        final jobsiteApplicants = _mapToJobsiteApplicantsDto(response);
        _jobsiteApplicants.assignAll(jobsiteApplicants);
        
        print('ApplicantController.loadJobsiteApplicants - Mapeados ${jobsiteApplicants.length} jobsites con applicants');
        
        // Verificar si hay nuevos applicants después de cargar
        await checkForNewApplicants();
      } else {
        _errorMessage.value = result.message ?? 'Error loading applicants';
        _jobsiteApplicants.clear();
        print('ApplicantController.loadJobsiteApplicants - Error: ${result.message}');
      }
    } catch (e) {
      _errorMessage.value = 'Error loading applicants: $e';
      print('ApplicantController.loadJobsiteApplicants - Excepción: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> checkForNewApplicants() async {
    try {
      // Verificar si hay applicants nuevos en la lista actual
      final hasNew = _jobsiteApplicants.any((jobsite) => 
        jobsite.applicants.any((applicant) => applicant.isNew));
      _hasNewApplicants.value = hasNew;
    } catch (e) {
      print('Error checking for new applicants: $e');
    }
  }

  Future<void> hireApplicant(String applicantId) async {
    try {
      print('ApplicantController.hireApplicant - Iniciando contratación de applicant: $applicantId');
      
      // Llamar al endpoint de contratación
      final result = await _applicantsUseCase.hireApplicant(
        applicationId: applicantId,
        startDate: DateTime.now().add(const Duration(days: 1)).toIso8601String(), // Fecha de inicio: mañana
        endDate: DateTime.now().add(const Duration(days: 90)).toIso8601String(), // Fecha de fin: 90 días
        reason: 'Contratado por el builder',
      );
      
      if (result.isSuccess && result.data != null) {
        final response = result.data!;
        print('ApplicantController.hireApplicant - Applicant contratado exitosamente:');
        print('  - Application ID: ${response.applicationId}');
        print('  - Assignment ID: ${response.assignmentId}');
        print('  - Message: ${response.message}');
        
        // Remover de la lista local después de contratación exitosa
        for (int i = 0; i < _jobsiteApplicants.length; i++) {
          _jobsiteApplicants[i].applicants.removeWhere((applicant) => applicant.id == applicantId);
        }
        
        // Recargar applicants del servidor
        await loadJobsiteApplicants();
        
        // Mostrar mensaje de éxito
        Get.snackbar(
          'Éxito',
          'Applicant contratado exitosamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
          duration: const Duration(seconds: 3),
        );
      } else {
        _errorMessage.value = result.message ?? 'Error hiring applicant';
        print('ApplicantController.hireApplicant - Error: ${result.message}');
        
        // Mostrar mensaje de error
        Get.snackbar(
          'Error',
          result.message ?? 'Error hiring applicant',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      _errorMessage.value = 'Error hiring applicant: $e';
      print('ApplicantController.hireApplicant - Excepción: $e');
      
      // Mostrar mensaje de error
      Get.snackbar(
        'Error',
        'Error hiring applicant: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> declineApplicant(String applicantId) async {
    try {
      print('ApplicantController.declineApplicant - Iniciando rechazo de applicant: $applicantId');
      
      // Llamar al endpoint de rechazo
      final result = await _applicantsUseCase.declineApplicant(
        applicationId: applicantId,
        reason: 'No seleccionado por el builder',
      );
      
      if (result.isSuccess && result.data != null) {
        final response = result.data!;
        print('ApplicantController.declineApplicant - Applicant rechazado exitosamente:');
        print('  - Application ID: ${response.applicationId}');
        print('  - Message: ${response.message}');
        
        // Remover de la lista local después de rechazo exitoso
        for (int i = 0; i < _jobsiteApplicants.length; i++) {
          _jobsiteApplicants[i].applicants.removeWhere((applicant) => applicant.id == applicantId);
        }
        
        // Recargar applicants del servidor
        await loadJobsiteApplicants();
        
        // Mostrar mensaje de éxito
        Get.snackbar(
          'Éxito',
          'Applicant rechazado exitosamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange[100],
          colorText: Colors.orange[800],
          duration: const Duration(seconds: 3),
        );
      } else {
        _errorMessage.value = result.message ?? 'Error declining applicant';
        print('ApplicantController.declineApplicant - Error: ${result.message}');
        
        // Mostrar mensaje de error
        Get.snackbar(
          'Error',
          result.message ?? 'Error declining applicant',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      _errorMessage.value = 'Error declining applicant: $e';
      print('ApplicantController.declineApplicant - Excepción: $e');
      
      // Mostrar mensaje de error
      Get.snackbar(
        'Error',
        'Error declining applicant: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> chatWithApplicant(String applicantId) async {
    try {
      // TODO: Implementar funcionalidad de chat
      print('ApplicantController.chatWithApplicant - Opening chat with: $applicantId');
    } catch (e) {
      _errorMessage.value = 'Error opening chat: $e';
      print('ApplicantController.chatWithApplicant - Error: $e');
    }
  }

  void clearError() {
    _errorMessage.value = '';
  }

  /// Refresca los datos de applicants
  Future<void> refreshApplicants() async {
    print('ApplicantController.refreshApplicants - Refrescando datos...');
    await loadJobsiteApplicants();
  }

  /// Obtiene estadísticas de applicants
  Map<String, dynamic> getApplicantsStatistics() {
    final totalApplicants = _jobsiteApplicants.fold(0, (sum, jobsite) => sum + jobsite.applicants.length);
    final newApplicants = _jobsiteApplicants.fold(0, (sum, jobsite) => 
        sum + jobsite.applicants.where((applicant) => applicant.isNew).length);
    
    return {
      'totalJobsites': _jobsiteApplicants.length,
      'totalApplicants': totalApplicants,
      'newApplicants': newApplicants,
      'hasNewApplicants': newApplicants > 0,
      'filterStatus': 'APPLIED', // Solo applicants con status APPLIED
    };
  }

  /// Obtiene estadísticas de filtrado de applicants
  Map<String, dynamic> getFilteringStatistics() {
    int totalApplications = 0;
    int appliedApplications = 0;
    int otherStatusApplications = 0;
    
    // Contar todas las aplicaciones (incluyendo las filtradas)
    for (final jobsite in _jobsiteApplicants) {
      // Nota: Este método solo cuenta los applicants ya filtrados
      // Para contar todos necesitaríamos acceso a los datos originales
      totalApplications += jobsite.applicants.length;
      appliedApplications += jobsite.applicants.length; // Todos los mostrados son APPLIED
    }
    
    return {
      'totalApplications': totalApplications,
      'appliedApplications': appliedApplications,
      'otherStatusApplications': otherStatusApplications,
      'filterApplied': true,
      'filterStatus': 'APPLIED',
    };
  }

  /// Verifica si un applicant tiene status APPLIED
  bool isApplicantApplied(String applicantId) {
    for (final jobsite in _jobsiteApplicants) {
      final hasApplicant = jobsite.applicants.any((app) => app.id == applicantId);
      if (hasApplicant) {
        // Si está en la lista, significa que tiene status APPLIED (ya filtrado)
        return true;
      }
    }
    return false;
  }

  /// Obtiene información de filtrado para debugging
  Map<String, dynamic> getFilteringInfo() {
    return {
      'filterEnabled': true,
      'filterStatus': 'APPLIED',
      'description': 'Solo se muestran applicants con status APPLIED',
      'totalJobsites': _jobsiteApplicants.length,
      'totalFilteredApplicants': _jobsiteApplicants.fold(0, (sum, jobsite) => sum + jobsite.applicants.length),
    };
  }

  /// Contrata un applicant con fechas personalizadas
  Future<void> hireApplicantWithDates({
    required String applicantId,
    required DateTime startDate,
    required DateTime endDate,
    String? reason,
  }) async {
    try {
      print('ApplicantController.hireApplicantWithDates - Iniciando contratación con fechas personalizadas:');
      print('  - Applicant ID: $applicantId');
      print('  - Start Date: $startDate');
      print('  - End Date: $endDate');
      print('  - Reason: $reason');
      
      // Validar fechas
      if (startDate.isAfter(endDate)) {
        Get.snackbar(
          'Error',
          'La fecha de inicio debe ser anterior a la fecha de fin',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
          duration: const Duration(seconds: 3),
        );
        return;
      }
      
      // Llamar al endpoint de contratación
      final result = await _applicantsUseCase.hireApplicant(
        applicationId: applicantId,
        startDate: startDate.toIso8601String(),
        endDate: endDate.toIso8601String(),
        reason: reason ?? 'Contratado por el builder',
      );
      
      if (result.isSuccess && result.data != null) {
        final response = result.data!;
        print('ApplicantController.hireApplicantWithDates - Applicant contratado exitosamente:');
        print('  - Application ID: ${response.applicationId}');
        print('  - Assignment ID: ${response.assignmentId}');
        print('  - Message: ${response.message}');
        
        // Remover de la lista local después de contratación exitosa
        for (int i = 0; i < _jobsiteApplicants.length; i++) {
          _jobsiteApplicants[i].applicants.removeWhere((applicant) => applicant.id == applicantId);
        }
        
        // Recargar applicants del servidor
        await loadJobsiteApplicants();
        
        // Mostrar mensaje de éxito
        Get.snackbar(
          'Éxito',
          'Applicant contratado exitosamente con fechas personalizadas',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
          duration: const Duration(seconds: 3),
        );
      } else {
        _errorMessage.value = result.message ?? 'Error hiring applicant';
        print('ApplicantController.hireApplicantWithDates - Error: ${result.message}');
        
        // Mostrar mensaje de error
        Get.snackbar(
          'Error',
          result.message ?? 'Error hiring applicant',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      _errorMessage.value = 'Error hiring applicant: $e';
      print('ApplicantController.hireApplicantWithDates - Excepción: $e');
      
      // Mostrar mensaje de error
      Get.snackbar(
        'Error',
        'Error hiring applicant: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        duration: const Duration(seconds: 3),
      );
    }
  }

  /// Rechaza un applicant con razón personalizada
  Future<void> declineApplicantWithReason({
    required String applicantId,
    required String reason,
  }) async {
    try {
      print('ApplicantController.declineApplicantWithReason - Iniciando rechazo con razón personalizada:');
      print('  - Applicant ID: $applicantId');
      print('  - Reason: $reason');
      
      // Llamar al endpoint de rechazo
      final result = await _applicantsUseCase.declineApplicant(
        applicationId: applicantId,
        reason: reason,
      );
      
      if (result.isSuccess && result.data != null) {
        final response = result.data!;
        print('ApplicantController.declineApplicantWithReason - Applicant rechazado exitosamente:');
        print('  - Application ID: ${response.applicationId}');
        print('  - Message: ${response.message}');
        
        // Remover de la lista local después de rechazo exitoso
        for (int i = 0; i < _jobsiteApplicants.length; i++) {
          _jobsiteApplicants[i].applicants.removeWhere((applicant) => applicant.id == applicantId);
        }
        
        // Recargar applicants del servidor
        await loadJobsiteApplicants();
        
        // Mostrar mensaje de éxito
        Get.snackbar(
          'Éxito',
          'Applicant rechazado exitosamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange[100],
          colorText: Colors.orange[800],
          duration: const Duration(seconds: 3),
        );
      } else {
        _errorMessage.value = result.message ?? 'Error declining applicant';
        print('ApplicantController.declineApplicantWithReason - Error: ${result.message}');
        
        // Mostrar mensaje de error
        Get.snackbar(
          'Error',
          result.message ?? 'Error declining applicant',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      _errorMessage.value = 'Error declining applicant: $e';
      print('ApplicantController.declineApplicantWithReason - Excepción: $e');
      
      // Mostrar mensaje de error
      Get.snackbar(
        'Error',
        'Error declining applicant: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        duration: const Duration(seconds: 3),
      );
    }
  }

  /// Mapea los datos del nuevo formato API a JobsiteApplicantsDto
  List<JobsiteApplicantsDto> _mapToJobsiteApplicantsDto(DtoReceiveBuilderApplicantsResponse response) {
    print('ApplicantController._mapToJobsiteApplicantsDto - Mapeando ${response.jobsites.length} jobsites');
    
    final filteredJobsites = <JobsiteApplicantsDto>[];
    
    for (final jobsite in response.jobsites) {
      print('ApplicantController._mapToJobsiteApplicantsDto - Procesando jobsite: ${jobsite.jobsiteName}');
      print('  - Jobs en jobsite: ${jobsite.jobs.length}');
      
      // Obtener todos los applicants de todos los jobs en este jobsite
      final allApplicants = <ApplicantDto>[];
      
      for (final job in jobsite.jobs) {
        print('  - Job: ${job.jobTitle} (${job.jobStatus}) con ${job.applicants.length} applicants');
        
        for (final application in job.applicants) {
          // Filtrar solo applicants con status "APPLIED"
          if (application.status == 'APPLIED') {
            final applicant = _mapApplicationToApplicantDto(application);
            allApplicants.add(applicant);
            print('    - Applicant: ${applicant.name} (${applicant.id}) - Status: ${application.status}');
          } else {
            print('    - Applicant filtrado: ${application.labour.fullName} (${application.applicationId}) - Status: ${application.status}');
          }
        }
      }
      
      print('  - Total applicants en jobsite: ${allApplicants.length}');
      
      // Solo agregar jobsite si tiene applicants con status APPLIED
      if (allApplicants.isNotEmpty) {
        print('  - Jobsite incluido: ${jobsite.jobsiteName} (${allApplicants.length} applicants APPLIED)');
        filteredJobsites.add(JobsiteApplicantsDto(
          jobsiteId: jobsite.jobsiteId,
          jobsiteName: jobsite.jobsiteName,
          jobsiteAddress: jobsite.address,
          applicants: allApplicants,
        ));
      } else {
        print('  - Jobsite excluido: ${jobsite.jobsiteName} (sin applicants APPLIED)');
      }
    }
    
    print('ApplicantController._mapToJobsiteApplicantsDto - Jobsites filtrados: ${filteredJobsites.length} de ${response.jobsites.length}');
    
    return filteredJobsites;
  }

  /// Mapea una aplicación del API a ApplicantDto
  ApplicantDto _mapApplicationToApplicantDto(DtoReceiveBuilderApplication application) {
    print('ApplicantController._mapApplicationToApplicantDto - Mapeando aplicación:');
    print('  - Application ID: ${application.applicationId}');
    print('  - Status: ${application.status}');
    print('  - Labour: ${application.labour.fullName}');
    print('  - Email: ${application.labour.email}');
    print('  - Applied at: ${application.appliedAt}');
    
    // Generar avatar por defecto si no hay uno
    final avatarUrl = application.labour.avatarUrl ?? 
        'https://via.placeholder.com/100x100/4CAF50/FFFFFF?text=${application.labour.fullName.isNotEmpty ? application.labour.fullName.substring(0, 1).toUpperCase() : 'U'}';
    
    final applicant = ApplicantDto(
      id: application.applicationId,
      name: application.labour.fullName.isNotEmpty ? application.labour.fullName : 'Unknown User',
      jobRole: 'Applicant', // Por defecto, se puede mejorar extrayendo del job
      rating: 4.5, // Por defecto, se puede mejorar si viene en el API
      profileImageUrl: avatarUrl,
      isNew: _isNewApplication(application),
    );
    
    print('  - Mapeado a ApplicantDto: ${applicant.name} (${applicant.id})');
    
    return applicant;
  }

  /// Determina si una aplicación es nueva basándose en la fecha
  bool _isNewApplication(DtoReceiveBuilderApplication application) {
    try {
      final now = DateTime.now();
      final appliedAt = application.appliedAt;
      final difference = now.difference(appliedAt);
      
      // Considerar nueva si fue aplicada en las últimas 24 horas
      final isNew = difference.inHours < 24;
      
      print('ApplicantController._isNewApplication - ${application.labour.fullName}:');
      print('  - Applied at: $appliedAt');
      print('  - Hours ago: ${difference.inHours}');
      print('  - Is new: $isNew');
      
      return isNew;
    } catch (e) {
      print('ApplicantController._isNewApplication - Error calculando fecha: $e');
      return false; // Por defecto, no es nueva si hay error
    }
  }
}
