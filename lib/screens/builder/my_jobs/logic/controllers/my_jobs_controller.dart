import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/logic/builder/use_case/jobs_use_case.dart';
import '../../../../../features/logic/builder/models/receive/dto_receive_job.dart';
import '../../data/dto/job_dto.dart';

class MyJobsController extends GetxController {
  final JobsUseCase _jobsUseCase = JobsUseCase();
  
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final RxList<JobDto> _jobs = <JobDto>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxBool _isActiveTab = true.obs;

  List<JobDto> get jobs => _jobs;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get isActiveTab => _isActiveTab.value;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
    loadJobs();
  }

  Future<void> loadJobs() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      
      print('MyJobsController.loadJobs - Starting to load jobs...');
      final result = await _jobsUseCase.getJobs();
      
      print('MyJobsController.loadJobs - Result isSuccess: ${result.isSuccess}');
      print('MyJobsController.loadJobs - Result data length: ${result.data?.length ?? 0}');
      print('MyJobsController.loadJobs - Result message: ${result.message}');
      
      if (result.isSuccess) {
        if (result.data != null && result.data!.isNotEmpty) {
          print('MyJobsController.loadJobs - Processing ${result.data!.length} jobs...');
          
          // Filtrar jobs activos o archivados según el tab seleccionado
          final filteredJobs = result.data!.where((job) {
            if (_isActiveTab.value) {
              return job.isActive;
            } else {
              return job.isClosed;
            }
          }).toList();
          
          print('MyJobsController.loadJobs - Filtered jobs: ${filteredJobs.length}');
          
          // Convertir DtoReceiveJob a JobDto
          final jobDtos = filteredJobs.map((job) => _convertToJobDto(job)).toList();
          _jobs.assignAll(jobDtos);
          
          print('MyJobsController.loadJobs - Final jobs count: ${_jobs.length}');
        } else {
          // Caso exitoso pero sin datos (jobs: null o array vacío) - no es un error
          print('MyJobsController.loadJobs - No jobs found (successful response with null/empty jobs)');
          _jobs.clear();
          _errorMessage.value = ''; // Limpiar cualquier error previo
        }
      } else {
        // Error real de la API
        print('MyJobsController.loadJobs - API Error: ${result.message}');
        _errorMessage.value = result.message ?? 'Error loading jobs';
      }
    } catch (e) {
      print('MyJobsController.loadJobs - Exception: $e');
      _errorMessage.value = 'Error loading jobs: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  void switchTab(bool isActive) {
    _isActiveTab.value = isActive;
    loadJobs();
  }

  Future<void> updateJobVisibility(String jobId, bool isVisible) async {
    try {
      // Usar el nuevo método específico para actualizar visibilidad
      final visibility = isVisible ? 'PUBLIC' : 'PRIVATE';
      final result = await _jobsUseCase.updateJobVisibility(jobId, visibility);
      
      if (result.isSuccess && result.data != null) {
        print('Job visibility updated: ${result.data!.message}');
        print('New visibility: ${result.data!.visibility}');
        
        // Actualizar solo el job específico en la lista sin recargar
        _updateJobInList(jobId, result.data!.job);
      } else {
        _errorMessage.value = result.message ?? 'Error updating job visibility';
      }
    } catch (e) {
      _errorMessage.value = 'Error updating job visibility: $e';
    }
  }

  /// Actualiza un job específico en la lista sin recargar toda la lista
  void _updateJobInList(String jobId, DtoReceiveJob updatedJob) {
    try {
      // Buscar el índice del job en la lista
      final jobIndex = _jobs.indexWhere((job) => job.id == jobId);
      
      if (jobIndex != -1) {
        // Convertir el job actualizado a JobDto
        final updatedJobDto = _convertToJobDto(updatedJob);
        
        // Actualizar el job en la lista
        _jobs[jobIndex] = updatedJobDto;
        
        // Notificar a la UI que la lista ha cambiado
        _jobs.refresh();
        
        print('Job $jobId updated in list. New visibility: ${updatedJobDto.isVisible}');
      } else {
        print('Job $jobId not found in current list');
      }
    } catch (e) {
      print('Error updating job in list: $e');
      // Si hay error, recargar toda la lista como fallback
      loadJobs();
    }
  }

  Future<void> deleteJob(String jobId) async {
    try {
      final result = await _jobsUseCase.deleteJob(jobId);
      
      if (result.isSuccess) {
        await loadJobs(); // Recargar la lista
      } else {
        _errorMessage.value = result.message ?? 'Error deleting job';
      }
    } catch (e) {
      _errorMessage.value = 'Error deleting job: $e';
    }
  }

  Future<void> shareJob(String jobId) async {
    try {
      // Buscar el trabajo en la lista
      final job = _jobs.firstWhere((job) => job.id == jobId);
      
      // Crear el contenido para compartir usando los campos del JobDto
      final shareText = '''
🏗️ Job Opportunity: ${job.title}

💰 Rate: \$${job.rate.toStringAsFixed(2)}/hr
📍 Location: ${job.location}
📅 Dates: ${_formatDate(job.startDate)} - ${_formatDate(job.endDate)}
🔧 Type: ${job.jobType}
📱 Source: ${job.source}

Check out this job opportunity on Yakka Sports!
      ''';
      
      // Compartir usando share_plus
      await Share.share(shareText);
    } catch (e) {
      _errorMessage.value = 'Error sharing job: $e';
    }
  }


  void clearError() {
    _errorMessage.value = '';
  }

  void handleBackNavigation() {
    Get.back();
  }

  /// Convierte DtoReceiveJob a JobDto para compatibilidad con la UI
  JobDto _convertToJobDto(DtoReceiveJob job) {
    // Crear título con skill + número de labours
    final skillName = _getSkillName(job);
    final title = '${skillName} x${job.manyLabours}';
    
    // Usar total_wage si está disponible, sino calcular o usar wage_site_allowance como fallback
    // El totalWage del API es un número, no incluye el símbolo de dólar
    final totalWage = job.totalWage ?? job.wageSiteAllowance;
    
    return JobDto(
      id: job.id,
      title: title,
      rate: totalWage, // Usar total_wage como rate
      location: job.jobsite?.name ?? job.jobsiteId, // Usar jobsite name si está disponible, sino jobsiteId
      startDate: _parseDate(job.startDateWork),
      endDate: _parseDate(job.endDateWork),
      jobType: job.jobType?.name ?? job.paymentType, // Usar jobType name si está disponible, sino paymentType
      source: job.builderProfile?.displayName ?? 'Builder', // Usar builder profile name si está disponible
      postedDate: _parseDate(job.createdAt),
      isVisible: job.visibility == 'PUBLIC', // Convertir visibility a boolean
      isActive: job.isActive, // Usar el getter isActive del DtoReceiveJob
    );
  }

  /// Parsea una fecha string a DateTime
  DateTime _parseDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return DateTime.now(); // Fallback a fecha actual
    }
  }

  /// Formatea una fecha DateTime a string
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Obtiene el nombre de la skill del job
  String _getSkillName(DtoReceiveJob job) {
    // Buscar en job_skills para obtener el nombre de la subcategoría
    if (job.jobSkills.isNotEmpty) {
      final firstSkill = job.jobSkills.first;
      if (firstSkill.skillSubcategory != null) {
        return firstSkill.skillSubcategory!.name;
      }
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

  /// Obtiene un job real por ID de la API
  Future<DtoReceiveJob?> getRealJobById(String jobId) async {
    try {
      print('MyJobsController.getRealJobById - Starting with jobId: $jobId');
      
      // Usar el método específico para obtener un job por ID
      final result = await _jobsUseCase.getJobById(jobId);
      
      print('MyJobsController.getRealJobById - Result isSuccess: ${result.isSuccess}');
      print('MyJobsController.getRealJobById - Result data: ${result.data?.id}');
      print('MyJobsController.getRealJobById - Result message: ${result.message}');
      print('MyJobsController.getRealJobById - Result error: ${result.error}');
      
      if (result.isSuccess && result.data != null) {
        print('MyJobsController.getRealJobById - Success! Returning job: ${result.data!.id}');
        print('MyJobsController.getRealJobById - Job details:');
        print('  - Title: ${result.data!.description}');
        print('  - Many Labours: ${result.data!.manyLabours}');
        print('  - Total Wage: ${result.data!.totalWage}');
        print('  - Visibility: ${result.data!.visibility}');
        print('  - Is Active: ${result.data!.isActive}');
        return result.data!;
      } else {
        print('MyJobsController.getRealJobById - Job not found with ID: $jobId');
        print('MyJobsController.getRealJobById - Error message: ${result.message}');
        print('MyJobsController.getRealJobById - Error details: ${result.error}');
        return null;
      }
    } catch (e) {
      print('MyJobsController.getRealJobById - Exception getting job by ID: $e');
      print('MyJobsController.getRealJobById - Stack trace: ${StackTrace.current}');
      return null;
    }
  }
}
