import '../dto/worker_dto.dart';
import '../dto/jobsite_workers_dto.dart';

abstract class StaffRepository {
  Future<List<JobsiteWorkersDto>> getJobsiteWorkers();
  Future<void> rateWorker(String workerId, double rating);
  Future<void> extendWorker(String workerId, DateTime endDate);
  Future<void> unhireWorker(String workerId);
  Future<void> moveWorker(String workerId, String newJobsiteId);
}

class MockStaffRepository implements StaffRepository {
  @override
  Future<List<JobsiteWorkersDto>> getJobsiteWorkers() async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      JobsiteWorkersDto(
        jobsiteId: '1',
        jobsiteName: '15 Ernest St',
        jobsiteAddress: '15 Ernest St, Balgowlah Heights, Sydney',
        workers: [
          WorkerDto(
            id: '1',
            name: 'davide rinaldo',
            role: 'General Labourer',
            hourlyRate: '\$32.00/hr',
            imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
            isActive: true,
            jobsiteId: '1',
            jobsiteName: '15 Ernest St',
          ),
          WorkerDto(
            id: '2',
            name: 'maria gonzalez',
            role: 'Carpenter',
            hourlyRate: '\$45.00/hr',
            imageUrl: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
            isActive: true,
            jobsiteId: '1',
            jobsiteName: '15 Ernest St',
          ),
          WorkerDto(
            id: '4',
            name: 'carlos rodriguez',
            role: 'Plumber',
            hourlyRate: '\$40.00/hr',
            imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
            isActive: false,
            jobsiteId: '1',
            jobsiteName: '15 Ernest St',
          ),
        ],
      ),
      JobsiteWorkersDto(
        jobsiteId: '2',
        jobsiteName: '1 Belinda Place',
        jobsiteAddress: '1 Belinda Place, New Port, Sydney',
        workers: [
          WorkerDto(
            id: '3',
            name: 'john smith',
            role: 'Electrician',
            hourlyRate: '\$50.00/hr',
            imageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
            isActive: true,
            jobsiteId: '2',
            jobsiteName: '1 Belinda Place',
          ),
          WorkerDto(
            id: '5',
            name: 'sarah wilson',
            role: 'Painter',
            hourlyRate: '\$35.00/hr',
            imageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
            isActive: false,
            jobsiteId: '2',
            jobsiteName: '1 Belinda Place',
          ),
          WorkerDto(
            id: '6',
            name: 'mike thompson',
            role: 'Welder',
            hourlyRate: '\$55.00/hr',
            imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
            isActive: false,
            jobsiteId: '2',
            jobsiteName: '1 Belinda Place',
          ),
        ],
      ),
      JobsiteWorkersDto(
        jobsiteId: '3',
        jobsiteName: 'Downtown Project',
        jobsiteAddress: '123 Main St, Sydney CBD',
        workers: [
          WorkerDto(
            id: '7',
            name: 'lisa anderson',
            role: 'Scaffolder',
            hourlyRate: '\$38.00/hr',
            imageUrl: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
            isActive: false,
            jobsiteId: '3',
            jobsiteName: 'Downtown Project',
          ),
          WorkerDto(
            id: '8',
            name: 'james brown',
            role: 'Concrete Worker',
            hourlyRate: '\$42.00/hr',
            imageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
            isActive: false,
            jobsiteId: '3',
            jobsiteName: 'Downtown Project',
          ),
        ],
      ),
    ];
  }

  @override
  Future<void> rateWorker(String workerId, double rating) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 300));
    print('Rating worker $workerId with $rating stars');
  }

  @override
  Future<void> extendWorker(String workerId, DateTime endDate) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 300));
    print('Extending worker $workerId until $endDate');
  }

  @override
  Future<void> unhireWorker(String workerId) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 300));
    print('Unhiring worker $workerId');
  }

  @override
  Future<void> moveWorker(String workerId, String newJobsiteId) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 300));
    print('Moving worker $workerId to jobsite $newJobsiteId');
  }
}
