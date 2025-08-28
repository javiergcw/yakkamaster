import 'worker_dto.dart';

class JobsiteWorkersDto {
  final String jobsiteId;
  final String jobsiteName;
  final String jobsiteAddress;
  final List<WorkerDto> workers;

  JobsiteWorkersDto({
    required this.jobsiteId,
    required this.jobsiteName,
    required this.jobsiteAddress,
    required this.workers,
  });

  factory JobsiteWorkersDto.fromJson(Map<String, dynamic> json) {
    return JobsiteWorkersDto(
      jobsiteId: json['jobsiteId'] ?? '',
      jobsiteName: json['jobsiteName'] ?? '',
      jobsiteAddress: json['jobsiteAddress'] ?? '',
      workers: (json['workers'] as List<dynamic>?)
          ?.map((worker) => WorkerDto.fromJson(worker))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobsiteId': jobsiteId,
      'jobsiteName': jobsiteName,
      'jobsiteAddress': jobsiteAddress,
      'workers': workers.map((worker) => worker.toJson()).toList(),
    };
  }
}
