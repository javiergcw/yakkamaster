import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../config/app_flavor.dart';
import '../../data/data.dart';

class MyJobsController extends GetxController {
  final JobRepository _repository = MockJobRepository();
  
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
      
      final jobs = await _repository.getJobs(isActive: _isActiveTab.value);
      _jobs.assignAll(jobs);
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
      await _repository.updateJobVisibility(jobId, isVisible);
      await loadJobs(); // Recargar la lista
    } catch (e) {
      _errorMessage.value = 'Error updating job visibility: $e';
    }
  }

  Future<void> deleteJob(String jobId) async {
    try {
      await _repository.deleteJob(jobId);
      await loadJobs(); // Recargar la lista
    } catch (e) {
      _errorMessage.value = 'Error deleting job: $e';
    }
  }

  Future<void> shareJob(String jobId) async {
    try {
      // Buscar el trabajo en la lista
      final job = _jobs.firstWhere((job) => job.id == jobId);
      
      // Crear el contenido para compartir
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void clearError() {
    _errorMessage.value = '';
  }

  void handleBackNavigation() {
    Get.back();
  }
}
