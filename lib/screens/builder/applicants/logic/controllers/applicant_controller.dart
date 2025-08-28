import 'package:get/get.dart';
import '../../data/data.dart';

class ApplicantController extends GetxController {
  final ApplicantRepository _repository = MockApplicantRepository();
  
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
    loadJobsiteApplicants();
    checkForNewApplicants();
  }

  Future<void> loadJobsiteApplicants() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      
      final jobsiteApplicants = await _repository.getJobsiteApplicants();
      _jobsiteApplicants.assignAll(jobsiteApplicants);
    } catch (e) {
      _errorMessage.value = 'Error loading applicants: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> checkForNewApplicants() async {
    try {
      final hasNew = await _repository.hasNewApplicants();
      _hasNewApplicants.value = hasNew;
    } catch (e) {
      print('Error checking for new applicants: $e');
    }
  }

  Future<void> hireApplicant(String applicantId) async {
    try {
      await _repository.hireApplicant(applicantId);
      // Remover el applicant de la lista
      for (int i = 0; i < _jobsiteApplicants.length; i++) {
        _jobsiteApplicants[i].applicants.removeWhere((applicant) => applicant.id == applicantId);
      }
      // Verificar si aún hay nuevos applicants
      await checkForNewApplicants();
    } catch (e) {
      _errorMessage.value = 'Error hiring applicant: $e';
    }
  }

  Future<void> declineApplicant(String applicantId) async {
    try {
      await _repository.declineApplicant(applicantId);
      // Remover el applicant de la lista
      for (int i = 0; i < _jobsiteApplicants.length; i++) {
        _jobsiteApplicants[i].applicants.removeWhere((applicant) => applicant.id == applicantId);
      }
      // Verificar si aún hay nuevos applicants
      await checkForNewApplicants();
    } catch (e) {
      _errorMessage.value = 'Error declining applicant: $e';
    }
  }

  Future<void> chatWithApplicant(String applicantId) async {
    try {
      await _repository.chatWithApplicant(applicantId);
    } catch (e) {
      _errorMessage.value = 'Error opening chat: $e';
    }
  }

  void clearError() {
    _errorMessage.value = '';
  }
}
