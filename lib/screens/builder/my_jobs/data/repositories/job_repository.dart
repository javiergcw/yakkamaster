import '../dto/job_dto.dart';

abstract class JobRepository {
  Future<List<JobDto>> getJobs({bool? isActive});
  Future<void> updateJobVisibility(String jobId, bool isVisible);
  Future<void> deleteJob(String jobId);
  Future<void> shareJob(String jobId);
}

class MockJobRepository implements JobRepository {
  final List<JobDto> _mockJobs = [
    JobDto(
      id: '1',
      title: 'Truck Driver X1',
      rate: 31.08,
      location: '1 test ridge, Sydney, Sydney',
      startDate: DateTime(2025, 8, 25),
      endDate: DateTime(2025, 8, 29),
      jobType: 'Casual Job',
      source: 'Test company by Yakka',
      postedDate: DateTime(2025, 8, 23),
      isVisible: true,
      isActive: true,
    ),
    JobDto(
      id: '2',
      title: 'Construction Worker X2',
      rate: 28.50,
      location: '2 main street, Melbourne, VIC',
      startDate: DateTime(2025, 9, 1),
      endDate: DateTime(2025, 9, 15),
      jobType: 'Full Time',
      source: 'Yakka Labour LTD',
      postedDate: DateTime(2025, 8, 20),
      isVisible: false,
      isActive: true,
    ),
    JobDto(
      id: '3',
      title: 'Plumber X1',
      rate: 35.00,
      location: '3 queen street, Brisbane, QLD',
      startDate: DateTime(2025, 7, 15),
      endDate: DateTime(2025, 7, 20),
      jobType: 'Contract',
      source: 'Construction Corp',
      postedDate: DateTime(2025, 7, 10),
      isVisible: true,
      isActive: false, // Archived
    ),
  ];

  @override
  Future<List<JobDto>> getJobs({bool? isActive}) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (isActive != null) {
      return _mockJobs.where((job) => job.isActive == isActive).toList();
    }
    return List.from(_mockJobs);
  }

  @override
  Future<void> updateJobVisibility(String jobId, bool isVisible) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 300));
    
    final jobIndex = _mockJobs.indexWhere((job) => job.id == jobId);
    if (jobIndex != -1) {
      _mockJobs[jobIndex] = _mockJobs[jobIndex].copyWith(isVisible: isVisible);
    }
  }

  @override
  Future<void> deleteJob(String jobId) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 300));
    
    _mockJobs.removeWhere((job) => job.id == jobId);
  }

  @override
  Future<void> shareJob(String jobId) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 200));
    
    // TODO: Implementar lógica de compartir
    print('Sharing job: $jobId');
  }
}
