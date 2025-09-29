import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/logic/builder/use_case/jobs_use_case.dart';
import '../../../../../features/logic/builder/models/receive/dto_receive_job.dart';
import '../../../../../features/logic/builder/models/send/dto_send_job.dart';
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
      
      final result = await _jobsUseCase.getJobs();
      
      if (result.isSuccess && result.data != null) {
        // Filtrar jobs activos o archivados según el tab seleccionado
        final filteredJobs = result.data!.where((job) {
          if (_isActiveTab.value) {
            return job.isActive;
          } else {
            return job.isClosed;
          }
        }).toList();
        
        // Convertir DtoReceiveJob a JobDto
        final jobDtos = filteredJobs.map((job) => _convertToJobDto(job)).toList();
        _jobs.assignAll(jobDtos);
      } else {
        _errorMessage.value = result.message ?? 'Error loading jobs';
      }
    } catch (e) {
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
      // Para actualizar la visibilidad, necesitamos obtener el job original de la API
      // y crear un DtoSendJob con la nueva visibilidad
      final result = await _jobsUseCase.getJobs();
      
      if (result.isSuccess && result.data != null) {
        final originalJob = result.data!.firstWhere((job) => job.id == jobId);
        
        // Crear un DtoSendJob con los datos del job original y la nueva visibilidad
        final updatedJob = DtoSendJob(
          jobsiteId: originalJob.jobsiteId,
          jobTypeId: originalJob.jobTypeId,
          manyLabours: originalJob.manyLabours,
          ongoingWork: originalJob.ongoingWork,
          wageSiteAllowance: originalJob.wageSiteAllowance,
          wageLeadingHandAllowance: originalJob.wageLeadingHandAllowance,
          wageProductivityAllowance: originalJob.wageProductivityAllowance,
          extrasOvertimeRate: originalJob.extrasOvertimeRate,
          startDateWork: originalJob.startDateWork,
          endDateWork: originalJob.endDateWork,
          workSaturday: originalJob.workSaturday,
          workSunday: originalJob.workSunday,
          startTime: originalJob.startTime,
          endTime: originalJob.endTime,
          description: originalJob.description,
          paymentDay: originalJob.paymentDay,
          requiresSupervisorSignature: originalJob.requiresSupervisorSignature,
          supervisorName: originalJob.supervisorName,
          visibility: isVisible ? 'PUBLIC' : 'PRIVATE', // Solo cambiar la visibilidad
          paymentType: originalJob.paymentType,
          licenseIds: const [], // Estos campos no están disponibles en DtoReceiveJob
          skillCategoryIds: const [],
          skillSubcategoryIds: const [],
        );
        
        final updateResult = await _jobsUseCase.updateJob(jobId, updatedJob);
        
        if (updateResult.isSuccess) {
          await loadJobs(); // Recargar la lista
        } else {
          _errorMessage.value = updateResult.message ?? 'Error updating job visibility';
        }
      } else {
        _errorMessage.value = 'Error loading job details';
      }
    } catch (e) {
      _errorMessage.value = 'Error updating job visibility: $e';
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
    return JobDto(
      id: job.id,
      title: job.description, // Usar description como título
      rate: job.wageSiteAllowance, // Usar wage_site_allowance como rate
      location: job.jobsiteId, // Usar jobsiteId como location
      startDate: _parseDate(job.startDateWork),
      endDate: _parseDate(job.endDateWork),
      jobType: job.paymentType, // Usar paymentType como jobType
      source: 'Builder', // Fuente fija para jobs del builder
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

  /// Obtiene un job real por ID de la API
  Future<DtoReceiveJob?> getRealJobById(String jobId) async {
    try {
      print('MyJobsController.getRealJobById - Starting with jobId: $jobId');
      
      // Usar el método específico para obtener un job por ID
      final result = await _jobsUseCase.getJobById(jobId);
      
      print('MyJobsController.getRealJobById - Result isSuccess: ${result.isSuccess}');
      print('MyJobsController.getRealJobById - Result data: ${result.data?.id}');
      print('MyJobsController.getRealJobById - Result message: ${result.message}');
      
      if (result.isSuccess && result.data != null) {
        print('MyJobsController.getRealJobById - Success! Returning job: ${result.data!.id}');
        return result.data!;
      } else {
        print('MyJobsController.getRealJobById - Job not found with ID: $jobId - ${result.message}');
        return null;
      }
    } catch (e) {
      print('MyJobsController.getRealJobById - Error getting job by ID: $e');
      return null;
    }
  }
}
