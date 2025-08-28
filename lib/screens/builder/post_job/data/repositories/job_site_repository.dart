import '../dto/job_site_dto.dart';

abstract class JobSiteRepository {
  Future<List<JobSiteDto>> getJobSites();
  Future<JobSiteDto?> getJobSiteById(String id);
  Future<JobSiteDto> createJobSite(JobSiteDto jobSite);
  Future<JobSiteDto> updateJobSite(JobSiteDto jobSite);
  Future<bool> deleteJobSite(String id);
  Future<bool> selectJobSite(String id);
  Future<bool> deselectJobSite(String id);
}

class JobSiteRepositoryImpl implements JobSiteRepository {
  // Mock data para simular la base de datos
  final List<JobSiteDto> _jobSites = [
    JobSiteDto(
      id: '1',
      name: '1 test ridge',
      location: 'Sydney',
      description: 'testing jobsite',
    ),
    JobSiteDto(
      id: '2',
      name: 'Labour hire and Jobs YAKKA a...',
      location: 'Albury-Wodonga',
      description: 'Test site for Yakka Labour',
    ),
    JobSiteDto(
      id: '3',
      name: 'Adelaide Hills, SA, Australia',
      location: 'A Hills',
      description: 'job site on the right with the big tree in front',
    ),
    JobSiteDto(
      id: '4',
      name: '10 Bent Street, Petersham NS...',
      location: 'Ku-ring-gai Counciln',
      description: '',
    ),
    JobSiteDto(
      id: '5',
      name: 'New Place Japanese Kitchen, ...',
      location: 'new place',
      description: '',
    ),
    JobSiteDto(
      id: '6',
      name: '1 Australia Avenue, Sydney Oly...',
      location: 'DBay',
      description: 'the big building on the corner',
    ),
  ];

  @override
  Future<List<JobSiteDto>> getJobSites() async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_jobSites);
  }

  @override
  Future<JobSiteDto?> getJobSiteById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _jobSites.firstWhere((jobSite) => jobSite.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<JobSiteDto> createJobSite(JobSiteDto jobSite) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final newJobSite = jobSite.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString());
    _jobSites.add(newJobSite);
    return newJobSite;
  }

  @override
  Future<JobSiteDto> updateJobSite(JobSiteDto jobSite) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final index = _jobSites.indexWhere((js) => js.id == jobSite.id);
    if (index != -1) {
      _jobSites[index] = jobSite;
      return jobSite;
    }
    throw Exception('Job site not found');
  }

  @override
  Future<bool> deleteJobSite(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _jobSites.indexWhere((js) => js.id == id);
    if (index != -1) {
      _jobSites.removeAt(index);
      return true;
    }
    return false;
  }

  @override
  Future<bool> selectJobSite(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _jobSites.indexWhere((js) => js.id == id);
    if (index != -1) {
      _jobSites[index] = _jobSites[index].copyWith(isSelected: true);
      return true;
    }
    return false;
  }

  @override
  Future<bool> deselectJobSite(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _jobSites.indexWhere((js) => js.id == id);
    if (index != -1) {
      _jobSites[index] = _jobSites[index].copyWith(isSelected: false);
      return true;
    }
    return false;
  }
}
