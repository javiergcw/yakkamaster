import 'package:get/get.dart';
import '../../data/data.dart';

class MyJobsController extends GetxController {
  final JobRepository _repository = MockJobRepository();
  
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
      await _repository.shareJob(jobId);
    } catch (e) {
      _errorMessage.value = 'Error sharing job: $e';
    }
  }

  void clearError() {
    _errorMessage.value = '';
  }
}
