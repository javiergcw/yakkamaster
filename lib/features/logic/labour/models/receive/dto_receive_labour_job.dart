import 'dto_receive_builder.dart';
import 'dto_receive_jobsite.dart';
import 'dto_receive_job_skill.dart';

/// DTO para recibir un job individual desde el API de labour
class DtoReceiveLabourJob {
  final String jobId;
  final String title;
  final String description;
  final String location;
  final String jobType;
  final int manyLabours;
  final String experienceLevel;
  final String status;
  final String visibility;
  final double totalWage;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DtoReceiveBuilder builder;
  final DtoReceiveJobsite? jobsite;
  final List<DtoReceiveJobSkill> skills;
  final bool hasApplied;
  final String? applicationStatus;
  final String? applicationId;

  DtoReceiveLabourJob({
    required this.jobId,
    required this.title,
    required this.description,
    required this.location,
    required this.jobType,
    required this.manyLabours,
    required this.experienceLevel,
    required this.status,
    required this.visibility,
    required this.totalWage,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.builder,
    this.jobsite,
    this.skills = const [],
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
      manyLabours: json['many_labours'] ?? 1,
      experienceLevel: json['experience_level']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      visibility: json['visibility']?.toString() ?? '',
      totalWage: (json['total_wage'] ?? 0).toDouble(),
      startDate: DateTime.tryParse(json['start_date']?.toString() ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['end_date']?.toString() ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
      builder: DtoReceiveBuilder.fromJson(json['builder'] ?? {}),
      jobsite: json['jobsite'] != null ? DtoReceiveJobsite.fromJson(json['jobsite']) : null,
      skills: json['skills'] != null 
          ? (json['skills'] as List)
              .map((skill) => DtoReceiveJobSkill.fromJson(skill as Map<String, dynamic>))
              .toList()
          : [],
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
      'many_labours': manyLabours,
      'experience_level': experienceLevel,
      'status': status,
      'visibility': visibility,
      'total_wage': totalWage,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'builder': builder.toJson(),
      'jobsite': jobsite?.toJson(),
      'skills': skills.map((skill) => skill.toJson()).toList(),
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
