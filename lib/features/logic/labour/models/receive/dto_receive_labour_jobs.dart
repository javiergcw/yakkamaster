import 'dto_receive_labour_job.dart';

/// DTO para recibir la respuesta completa de jobs desde el API de labour
class DtoReceiveLabourJobs {
  final List<DtoReceiveLabourJob> jobs;
  final int total;
  final String message;

  DtoReceiveLabourJobs({
    required this.jobs,
    required this.total,
    required this.message,
  });

  /// Constructor desde JSON
  factory DtoReceiveLabourJobs.fromJson(Map<String, dynamic> json) {
    return DtoReceiveLabourJobs(
      jobs: (json['jobs'] as List<dynamic>?)
          ?.map((item) => DtoReceiveLabourJob.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      total: json['total'] ?? 0,
      message: json['message']?.toString() ?? '',
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'jobs': jobs.map((job) => job.toJson()).toList(),
      'total': total,
      'message': message,
    };
  }

  /// Obtiene jobs por status
  List<DtoReceiveLabourJob> getJobsByStatus(String status) {
    return jobs.where((job) => job.status.toLowerCase() == status.toLowerCase()).toList();
  }

  /// Obtiene jobs por tipo
  List<DtoReceiveLabourJob> getJobsByType(String jobType) {
    return jobs.where((job) => job.jobType.toLowerCase() == jobType.toLowerCase()).toList();
  }

  /// Obtiene jobs aplicados
  List<DtoReceiveLabourJob> getAppliedJobs() {
    return jobs.where((job) => job.hasApplied).toList();
  }

  /// Obtiene jobs no aplicados
  List<DtoReceiveLabourJob> getNotAppliedJobs() {
    return jobs.where((job) => !job.hasApplied).toList();
  }

  /// Obtiene jobs por nivel de experiencia
  List<DtoReceiveLabourJob> getJobsByExperienceLevel(String experienceLevel) {
    return jobs.where((job) => job.experienceLevel.toLowerCase() == experienceLevel.toLowerCase()).toList();
  }

  @override
  String toString() {
    return 'DtoReceiveLabourJobs(jobs: ${jobs.length}, total: $total, message: $message)';
  }
}
