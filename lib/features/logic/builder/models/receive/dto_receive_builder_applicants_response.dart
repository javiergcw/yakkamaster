import 'dto_receive_jobsite.dart';
import 'dto_receive_builder_job_with_applicants.dart';

/// DTO específico para jobsite con jobs en el contexto de applicants
class DtoReceiveBuilderJobsiteWithJobs {
  final String jobsiteId;
  final String jobsiteName;
  final String address;
  final String suburb;
  final List<DtoReceiveBuilderJobWithApplicants> jobs;

  DtoReceiveBuilderJobsiteWithJobs({
    required this.jobsiteId,
    required this.jobsiteName,
    required this.address,
    required this.suburb,
    required this.jobs,
  });

  /// Constructor desde JSON
  factory DtoReceiveBuilderJobsiteWithJobs.fromJson(Map<String, dynamic> json) {
    return DtoReceiveBuilderJobsiteWithJobs(
      jobsiteId: json['jobsite_id']?.toString() ?? '',
      jobsiteName: json['jobsite_name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      suburb: json['suburb']?.toString() ?? '',
      jobs: json['jobs'] != null 
          ? (json['jobs'] as List)
              .map((job) => DtoReceiveBuilderJobWithApplicants.fromJson(job as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'jobsite_id': jobsiteId,
      'jobsite_name': jobsiteName,
      'address': address,
      'suburb': suburb,
      'jobs': jobs.map((job) => job.toJson()).toList(),
    };
  }

  /// Convierte a DtoReceiveJobsite existente
  DtoReceiveJobsite toDtoReceiveJobsite() {
    return DtoReceiveJobsite(
      id: jobsiteId,
      builderId: '', // No disponible en este contexto
      address: address,
      suburb: suburb,
      description: jobsiteName, // Usar el nombre como descripción
      latitude: 0.0, // No disponible en este contexto
      longitude: 0.0, // No disponible en este contexto
      createdAt: DateTime.now().toIso8601String(), // No disponible en este contexto
      updatedAt: DateTime.now().toIso8601String(), // No disponible en este contexto
    );
  }

  @override
  String toString() {
    return 'DtoReceiveBuilderJobsiteWithJobs(jobsiteId: $jobsiteId, jobsiteName: $jobsiteName, jobsCount: ${jobs.length})';
  }
}

/// DTO para recibir la respuesta completa de applicants del builder
class DtoReceiveBuilderApplicantsResponse {
  final List<DtoReceiveBuilderJobsiteWithJobs> jobsites;
  final int total;
  final String message;

  DtoReceiveBuilderApplicantsResponse({
    required this.jobsites,
    required this.total,
    required this.message,
  });

  /// Constructor desde JSON
  factory DtoReceiveBuilderApplicantsResponse.fromJson(Map<String, dynamic> json) {
    return DtoReceiveBuilderApplicantsResponse(
      jobsites: json['jobsites'] != null 
          ? (json['jobsites'] as List)
              .map((jobsite) => DtoReceiveBuilderJobsiteWithJobs.fromJson(jobsite as Map<String, dynamic>))
              .toList()
          : [],
      total: json['total']?.toInt() ?? 0,
      message: json['message']?.toString() ?? '',
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'jobsites': jobsites.map((jobsite) => jobsite.toJson()).toList(),
      'total': total,
      'message': message,
    };
  }

  /// Convierte a DtoReceiveJobsites existente
  DtoReceiveJobsites toDtoReceiveJobsites() {
    return DtoReceiveJobsites(
      jobsites: jobsites.map((js) => js.toDtoReceiveJobsite()).toList(),
      total: total,
    );
  }

  @override
  String toString() {
    return 'DtoReceiveBuilderApplicantsResponse(jobsites: ${jobsites.length}, total: $total, message: $message)';
  }
}
