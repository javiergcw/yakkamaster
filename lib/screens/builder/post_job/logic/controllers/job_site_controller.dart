import 'package:get/get.dart';
import '../../data/dto/job_site_dto.dart';
import '../../data/repositories/job_site_repository.dart';

class JobSiteController extends GetxController {
  final JobSiteRepository _repository = JobSiteRepositoryImpl();
  
  // Observable variables
  final RxList<JobSiteDto> _jobSites = <JobSiteDto>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxString _selectedJobSiteId = ''.obs;

  // Getters
  List<JobSiteDto> get jobSites => _jobSites;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  String get selectedJobSiteId => _selectedJobSiteId.value;
  
  // Computed getters
  JobSiteDto? get selectedJobSite => 
      _jobSites.firstWhereOrNull((jobSite) => jobSite.id == _selectedJobSiteId.value);
  
  List<JobSiteDto> get selectedJobSites => 
      _jobSites.where((jobSite) => jobSite.isSelected).toList();

  @override
  void onInit() {
    super.onInit();
    loadJobSites();
  }

  Future<void> loadJobSites() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      
      final jobSites = await _repository.getJobSites();
      _jobSites.assignAll(jobSites);
    } catch (e) {
      _errorMessage.value = 'Error loading job sites: $e';
      print('Error loading job sites: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> selectJobSite(String id) async {
    try {
      final success = await _repository.selectJobSite(id);
      if (success) {
        _selectedJobSiteId.value = id;
        // Update the local list
        final index = _jobSites.indexWhere((jobSite) => jobSite.id == id);
        if (index != -1) {
          _jobSites[index] = _jobSites[index].copyWith(isSelected: true);
        }
      }
    } catch (e) {
      _errorMessage.value = 'Error selecting job site: $e';
      print('Error selecting job site: $e');
    }
  }

  Future<void> deselectJobSite(String id) async {
    try {
      final success = await _repository.deselectJobSite(id);
      if (success) {
        if (_selectedJobSiteId.value == id) {
          _selectedJobSiteId.value = '';
        }
        // Update the local list
        final index = _jobSites.indexWhere((jobSite) => jobSite.id == id);
        if (index != -1) {
          _jobSites[index] = _jobSites[index].copyWith(isSelected: false);
        }
      }
    } catch (e) {
      _errorMessage.value = 'Error deselecting job site: $e';
      print('Error deselecting job site: $e');
    }
  }

  Future<void> toggleJobSiteSelection(String id) async {
    final jobSite = _jobSites.firstWhereOrNull((js) => js.id == id);
    if (jobSite != null) {
      if (jobSite.isSelected) {
        await deselectJobSite(id);
      } else {
        await selectJobSite(id);
      }
    }
  }

  Future<void> createJobSite(JobSiteDto jobSite) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      
      final newJobSite = await _repository.createJobSite(jobSite);
      _jobSites.add(newJobSite);
    } catch (e) {
      _errorMessage.value = 'Error creating job site: $e';
      print('Error creating job site: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateJobSite(JobSiteDto jobSite) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      
      final updatedJobSite = await _repository.updateJobSite(jobSite);
      final index = _jobSites.indexWhere((js) => js.id == jobSite.id);
      if (index != -1) {
        _jobSites[index] = updatedJobSite;
      }
    } catch (e) {
      _errorMessage.value = 'Error updating job site: $e';
      print('Error updating job site: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> deleteJobSite(String id) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      
      final success = await _repository.deleteJobSite(id);
      if (success) {
        _jobSites.removeWhere((jobSite) => jobSite.id == id);
        if (_selectedJobSiteId.value == id) {
          _selectedJobSiteId.value = '';
        }
      }
    } catch (e) {
      _errorMessage.value = 'Error deleting job site: $e';
      print('Error deleting job site: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void clearError() {
    _errorMessage.value = '';
  }

  void reset() {
    _jobSites.clear();
    _selectedJobSiteId.value = '';
    _errorMessage.value = '';
    _isLoading.value = false;
  }
}
