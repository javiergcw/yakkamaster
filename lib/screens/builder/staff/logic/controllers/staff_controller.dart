import 'package:get/get.dart';
import '../../data/data.dart';

class StaffController extends GetxController {
  final StaffRepository _repository = MockStaffRepository();
  
  final RxList<JobsiteWorkersDto> _jobsiteWorkers = <JobsiteWorkersDto>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _selectedJobsite = 'All Jobsites'.obs;
  final RxString _selectedSkill = 'All Skills'.obs;
  final RxString _searchQuery = ''.obs;

  // Getters
  List<JobsiteWorkersDto> get jobsiteWorkers => _jobsiteWorkers;
  bool get isLoading => _isLoading.value;
  String get selectedJobsite => _selectedJobsite.value;
  String get selectedSkill => _selectedSkill.value;
  String get searchQuery => _searchQuery.value;

  @override
  void onInit() {
    super.onInit();
    loadJobsiteWorkers();
  }

  Future<void> loadJobsiteWorkers() async {
    try {
      _isLoading.value = true;
      final workers = await _repository.getJobsiteWorkers();
      _jobsiteWorkers.assignAll(workers);
    } catch (e) {
      print('Error loading jobsite workers: $e');
      // TODO: Show error message to user
    } finally {
      _isLoading.value = false;
    }
  }

  void setSelectedJobsite(String jobsite) {
    _selectedJobsite.value = jobsite;
  }

  void setSelectedSkill(String skill) {
    _selectedSkill.value = skill;
  }

  void setSearchQuery(String query) {
    _searchQuery.value = query;
  }

  List<JobsiteWorkersDto> getFilteredJobsiteWorkers() {
    List<JobsiteWorkersDto> filtered = _jobsiteWorkers;

    // Filter by jobsite
    if (_selectedJobsite.value != 'All Jobsites') {
      filtered = filtered.where((jobsite) => 
        jobsite.jobsiteAddress == _selectedJobsite.value
      ).toList();
    }

    // Filter by skill
    if (_selectedSkill.value != 'All Skills') {
      filtered = filtered.map((jobsite) {
        final filteredWorkers = jobsite.workers.where((worker) =>
          worker.role.toLowerCase().contains(_selectedSkill.value.toLowerCase())
        ).toList();
        
        return JobsiteWorkersDto(
          jobsiteId: jobsite.jobsiteId,
          jobsiteName: jobsite.jobsiteName,
          jobsiteAddress: jobsite.jobsiteAddress,
          workers: filteredWorkers,
        );
      }).where((jobsite) => jobsite.workers.isNotEmpty).toList();
    }

    // Filter by search query
    if (_searchQuery.value.isNotEmpty) {
      filtered = filtered.map((jobsite) {
        final filteredWorkers = jobsite.workers.where((worker) =>
          worker.name.toLowerCase().contains(_searchQuery.value.toLowerCase()) ||
          worker.role.toLowerCase().contains(_searchQuery.value.toLowerCase())
        ).toList();
        
        return JobsiteWorkersDto(
          jobsiteId: jobsite.jobsiteId,
          jobsiteName: jobsite.jobsiteName,
          jobsiteAddress: jobsite.jobsiteAddress,
          workers: filteredWorkers,
        );
      }).where((jobsite) => jobsite.workers.isNotEmpty).toList();
    }

    return filtered;
  }

  List<JobsiteWorkersDto> getActiveJobsiteWorkers() {
    return getFilteredJobsiteWorkers().map((jobsite) {
      final activeWorkers = jobsite.workers.where((worker) => worker.isActive).toList();
      return JobsiteWorkersDto(
        jobsiteId: jobsite.jobsiteId,
        jobsiteName: jobsite.jobsiteName,
        jobsiteAddress: jobsite.jobsiteAddress,
        workers: activeWorkers,
      );
    }).where((jobsite) => jobsite.workers.isNotEmpty).toList();
  }

  List<JobsiteWorkersDto> getInactiveJobsiteWorkers() {
    return getFilteredJobsiteWorkers().map((jobsite) {
      final inactiveWorkers = jobsite.workers.where((worker) => !worker.isActive).toList();
      return JobsiteWorkersDto(
        jobsiteId: jobsite.jobsiteId,
        jobsiteName: jobsite.jobsiteName,
        jobsiteAddress: jobsite.jobsiteAddress,
        workers: inactiveWorkers,
      );
    }).where((jobsite) => jobsite.workers.isNotEmpty).toList();
  }

  Future<void> rateWorker(String workerId, double rating) async {
    try {
      await _repository.rateWorker(workerId, rating);
      // TODO: Show success message
    } catch (e) {
      print('Error rating worker: $e');
      // TODO: Show error message
    }
  }

  Future<void> extendWorker(String workerId, DateTime endDate) async {
    try {
      await _repository.extendWorker(workerId, endDate);
      // TODO: Show success message
    } catch (e) {
      print('Error extending worker: $e');
      // TODO: Show error message
    }
  }

  Future<void> unhireWorker(String workerId) async {
    try {
      await _repository.unhireWorker(workerId);
      // Refresh the list after unhiring
      await loadJobsiteWorkers();
      // TODO: Show success message
    } catch (e) {
      print('Error unhiring worker: $e');
      // TODO: Show error message
    }
  }

  Future<void> moveWorker(String workerId, String newJobsiteId) async {
    try {
      await _repository.moveWorker(workerId, newJobsiteId);
      // Refresh the list after moving
      await loadJobsiteWorkers();
      // TODO: Show success message
    } catch (e) {
      print('Error moving worker: $e');
      // TODO: Show error message
    }
  }

  List<String> getAvailableJobsites() {
    final jobsites = <String>['All Jobsites'];
    jobsites.addAll(_jobsiteWorkers.map((jobsite) => jobsite.jobsiteAddress));
    return jobsites;
  }

  List<String> getAvailableSkills() {
    final skills = <String>['All Skills'];
    final allSkills = <String>{};
    
    for (final jobsite in _jobsiteWorkers) {
      for (final worker in jobsite.workers) {
        allSkills.add(worker.role);
      }
    }
    
    skills.addAll(allSkills);
    return skills;
  }
}
