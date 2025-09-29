import 'dto_receive_builder.dart';

/// DTO para recibir un job individual desde el API de labour
class DtoReceiveLabourJob {
  final String jobId;
  final String title;
  final String description;
  final String location;
  final String jobType;
  final String experienceLevel;
  final String status;
  final String visibility;
  final double budget;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DtoReceiveBuilder builder;
  final bool hasApplied;
  final String? applicationStatus;
  final String? applicationId;

  DtoReceiveLabourJob({
    required this.jobId,
    required this.title,
    required this.description,
    required this.location,
    required this.jobType,
    required this.experienceLevel,
    required this.status,
    required this.visibility,
    required this.budget,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.builder,
    required this.hasApplied,
    this.applicationStatus,
    this.applicationId,
  });

  /// Constructor desde JSON
  factory DtoReceiveLabourJob.fromJson(Map<String, dynamic> json) {
    return DtoReceiveLabourJob(
      jobId: json['job_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      jobType: json['job_type']?.toString() ?? '',
      experienceLevel: json['experience_level']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      visibility: json['visibility']?.toString() ?? '',
      budget: (json['budget'] ?? 0).toDouble(),
      startDate: DateTime.tryParse(json['start_date']?.toString() ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['end_date']?.toString() ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
      builder: DtoReceiveBuilder.fromJson(json['builder'] ?? {}),
      hasApplied: json['has_applied'] ?? false,
      applicationStatus: json['application_status']?.toString(),
      applicationId: json['application_id']?.toString(),
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'job_id': jobId,
      'title': title,
      'description': description,
      'location': location,
      'job_type': jobType,
      'experience_level': experienceLevel,
      'status': status,
      'visibility': visibility,
      'budget': budget,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'builder': builder.toJson(),
      'has_applied': hasApplied,
      'application_status': applicationStatus,
      'application_id': applicationId,
    };
  }

  @override
  String toString() {
    return 'DtoReceiveLabourJob(jobId: $jobId, title: $title, location: $location, jobType: $jobType, status: $status, hasApplied: $hasApplied)';
  }
}
