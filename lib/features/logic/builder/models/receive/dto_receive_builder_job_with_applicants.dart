import 'dto_receive_builder_application.dart';

/// DTO para recibir un job con sus aplicantes en el contexto del builder
class DtoReceiveBuilderJobWithApplicants {
  final String jobId;
  final String jobTitle;
  final String jobStatus;
  final DateTime createdAt;
  final List<DtoReceiveBuilderApplication> applicants;

  DtoReceiveBuilderJobWithApplicants({
    required this.jobId,
    required this.jobTitle,
    required this.jobStatus,
    required this.createdAt,
    required this.applicants,
  });

  /// Constructor desde JSON
  factory DtoReceiveBuilderJobWithApplicants.fromJson(Map<String, dynamic> json) {
    return DtoReceiveBuilderJobWithApplicants(
      jobId: json['job_id']?.toString() ?? '',
      jobTitle: json['job_title']?.toString() ?? '',
      jobStatus: json['job_status']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      applicants: json['applicants'] != null 
          ? (json['applicants'] as List)
              .map((app) => DtoReceiveBuilderApplication.fromJson(app as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'job_id': jobId,
      'job_title': jobTitle,
      'job_status': jobStatus,
      'created_at': createdAt.toIso8601String(),
      'applicants': applicants.map((app) => app.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'DtoReceiveBuilderJobWithApplicants(jobId: $jobId, jobTitle: $jobTitle, applicantsCount: ${applicants.length})';
  }
}
