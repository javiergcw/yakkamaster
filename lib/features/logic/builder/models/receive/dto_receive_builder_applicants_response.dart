import 'dto_receive_builder_job_with_applicants.dart';

/// DTO para recibir la respuesta de aplicantes del builder
class DtoReceiveBuilderApplicantsResponse {
  final List<DtoReceiveBuilderJobWithApplicants> jobs;
  final int total;
  final String message;

  DtoReceiveBuilderApplicantsResponse({
    required this.jobs,
    required this.total,
    required this.message,
  });

  /// Constructor desde JSON
  factory DtoReceiveBuilderApplicantsResponse.fromJson(Map<String, dynamic> json) {
    return DtoReceiveBuilderApplicantsResponse(
      jobs: json['jobs'] != null 
          ? (json['jobs'] as List)
              .map((job) => DtoReceiveBuilderJobWithApplicants.fromJson(job as Map<String, dynamic>))
              .toList()
          : [],
      total: json['total']?.toInt() ?? 0,
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

  @override
  String toString() {
    return 'DtoReceiveBuilderApplicantsResponse(jobs: ${jobs.length}, total: $total, message: $message)';
  }
}
