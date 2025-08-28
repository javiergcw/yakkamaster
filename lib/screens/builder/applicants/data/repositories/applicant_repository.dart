import '../dto/applicant_dto.dart';
import '../dto/jobsite_applicants_dto.dart';

abstract class ApplicantRepository {
  Future<List<JobsiteApplicantsDto>> getJobsiteApplicants();
  Future<void> hireApplicant(String applicantId);
  Future<void> declineApplicant(String applicantId);
  Future<void> chatWithApplicant(String applicantId);
  Future<bool> hasNewApplicants();
}

class MockApplicantRepository implements ApplicantRepository {
  @override
  Future<List<JobsiteApplicantsDto>> getJobsiteApplicants() async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      JobsiteApplicantsDto(
        jobsiteId: '1',
        jobsiteName: '1 test ridge',
        jobsiteAddress: '1 test ridge, Sydney, Sydney',
        applicants: [
          ApplicantDto(
            id: '1',
            name: 'testing testing',
            jobRole: 'Truck Driver',
            rating: 5.0,
            profileImageUrl: 'https://via.placeholder.com/100x100/4CAF50/FFFFFF?text=TT',
            isNew: true,
          ),
          ApplicantDto(
            id: '2',
            name: 'John Smith',
            jobRole: 'Construction Worker',
            rating: 4.8,
            profileImageUrl: 'https://via.placeholder.com/100x100/2196F3/FFFFFF?text=JS',
            isNew: false,
          ),
        ],
      ),
      JobsiteApplicantsDto(
        jobsiteId: '2',
        jobsiteName: 'Downtown Project',
        jobsiteAddress: '123 Main St, Melbourne, VIC',
        applicants: [
          ApplicantDto(
            id: '3',
            name: 'Maria Garcia',
            jobRole: 'Electrician',
            rating: 4.9,
            profileImageUrl: 'https://via.placeholder.com/100x100/FF9800/FFFFFF?text=MG',
            isNew: true,
          ),
          ApplicantDto(
            id: '4',
            name: 'David Wilson',
            jobRole: 'Plumber',
            rating: 4.7,
            profileImageUrl: 'https://via.placeholder.com/100x100/9C27B0/FFFFFF?text=DW',
            isNew: false,
          ),
        ],
      ),
      JobsiteApplicantsDto(
        jobsiteId: '3',
        jobsiteName: 'Westside Development',
        jobsiteAddress: '456 Oak Ave, Brisbane, QLD',
        applicants: [
          ApplicantDto(
            id: '5',
            name: 'Sarah Johnson',
            jobRole: 'Carpenter',
            rating: 4.6,
            profileImageUrl: 'https://via.placeholder.com/100x100/607D8B/FFFFFF?text=SJ',
            isNew: false,
          ),
        ],
      ),
    ];
  }

  @override
  Future<void> hireApplicant(String applicantId) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 300));
    print('Hired applicant: $applicantId');
  }

  @override
  Future<void> declineApplicant(String applicantId) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 300));
    print('Declined applicant: $applicantId');
  }

  @override
  Future<void> chatWithApplicant(String applicantId) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 200));
    print('Chat with applicant: $applicantId');
  }

  @override
  Future<bool> hasNewApplicants() async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 200));
    
    // Verificar si hay applicants nuevos
    final jobsiteApplicants = await getJobsiteApplicants();
    return jobsiteApplicants.any((jobsite) => 
      jobsite.applicants.any((applicant) => applicant.isNew)
    );
  }
}
