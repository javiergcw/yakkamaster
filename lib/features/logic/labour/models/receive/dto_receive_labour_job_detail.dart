import 'dto_receive_builder.dart';
import 'dto_receive_jobsite.dart';
import 'dto_receive_job_skill.dart';
import 'dto_receive_job_requirement.dart';
import 'dto_receive_job_license.dart';
import 'dto_receive_job_type.dart';

/// DTO para recibir los detalles completos de un job desde el API de labour
class DtoReceiveLabourJobDetail {
  final String id;
  final int manyLabours;
  final bool ongoingWork;
  final double wageSiteAllowance;
  final double wageLeadingHandAllowance;
  final double wageProductivityAllowance;
  final double extrasOvertimeRate;
  final double? wageHourlyRate;
  final double travelAllowance;
  final double gst;
  final String startDateWork;
  final String endDateWork;
  final bool workSaturday;
  final bool workSunday;
  final String startTime;
  final String endTime;
  final String description;
  final String paymentDay;
  final bool requiresSupervisorSignature;
  final String supervisorName;
  final String visibility;
  final String paymentType;
  final double totalWage;
  final String createdAt;
  final String updatedAt;
  final DtoReceiveBuilder builderProfile;
  final DtoReceiveJobsite? jobsite;
  final DtoReceiveJobType? jobType;
  final List<DtoReceiveJobLicense> jobLicenses;
  final List<DtoReceiveJobSkill> jobSkills;
  final List<DtoReceiveJobRequirement> jobRequirements;

  DtoReceiveLabourJobDetail({
    required this.id,
    required this.manyLabours,
    required this.ongoingWork,
    required this.wageSiteAllowance,
    required this.wageLeadingHandAllowance,
    required this.wageProductivityAllowance,
    required this.extrasOvertimeRate,
    this.wageHourlyRate,
    required this.travelAllowance,
    required this.gst,
    required this.startDateWork,
    required this.endDateWork,
    required this.workSaturday,
    required this.workSunday,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.paymentDay,
    required this.requiresSupervisorSignature,
    required this.supervisorName,
    required this.visibility,
    required this.paymentType,
    required this.totalWage,
    required this.createdAt,
    required this.updatedAt,
    required this.builderProfile,
    this.jobsite,
    this.jobType,
    this.jobLicenses = const [],
    this.jobSkills = const [],
    this.jobRequirements = const [],
  });

  /// Constructor desde JSON
  factory DtoReceiveLabourJobDetail.fromJson(Map<String, dynamic> json) {
    return DtoReceiveLabourJobDetail(
      id: json['id']?.toString() ?? '',
      manyLabours: json['many_labours'] ?? 0,
      ongoingWork: json['ongoing_work'] ?? false,
      wageSiteAllowance: (json['wage_site_allowance'] ?? 0).toDouble(),
      wageLeadingHandAllowance: (json['wage_leading_hand_allowance'] ?? 0).toDouble(),
      wageProductivityAllowance: (json['wage_productivity_allowance'] ?? 0).toDouble(),
      extrasOvertimeRate: (json['extras_overtime_rate'] ?? 0).toDouble(),
      wageHourlyRate: json['wage_hourly_rate']?.toDouble(),
      travelAllowance: (json['travel_allowance'] ?? 0).toDouble(),
      gst: (json['gst'] ?? 0).toDouble(),
      startDateWork: json['start_date_work']?.toString() ?? '',
      endDateWork: json['end_date_work']?.toString() ?? '',
      workSaturday: json['work_saturday'] ?? false,
      workSunday: json['work_sunday'] ?? false,
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      paymentDay: json['payment_day']?.toString() ?? '',
      requiresSupervisorSignature: json['requires_supervisor_signature'] ?? false,
      supervisorName: json['supervisor_name']?.toString() ?? '',
      visibility: json['visibility']?.toString() ?? '',
      paymentType: json['payment_type']?.toString() ?? '',
      totalWage: (json['total_wage'] ?? 0).toDouble(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      builderProfile: DtoReceiveBuilder.fromJson(json['builder_profile'] ?? {}),
      jobsite: json['jobsite'] != null ? DtoReceiveJobsite.fromJson(json['jobsite']) : null,
      jobType: json['job_type'] != null ? DtoReceiveJobType.fromJson(json['job_type']) : null,
      jobLicenses: json['job_licenses'] != null 
          ? (json['job_licenses'] as List)
              .map((license) => DtoReceiveJobLicense.fromJson(license as Map<String, dynamic>))
              .toList()
          : [],
      jobSkills: json['job_skills'] != null 
          ? (json['job_skills'] as List)
              .map((skill) => DtoReceiveJobSkill.fromJson(skill as Map<String, dynamic>))
              .toList()
          : [],
      jobRequirements: json['job_requirements'] != null 
          ? (json['job_requirements'] as List)
              .map((req) => DtoReceiveJobRequirement.fromJson(req as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'many_labours': manyLabours,
      'ongoing_work': ongoingWork,
      'wage_site_allowance': wageSiteAllowance,
      'wage_leading_hand_allowance': wageLeadingHandAllowance,
      'wage_productivity_allowance': wageProductivityAllowance,
      'extras_overtime_rate': extrasOvertimeRate,
      'wage_hourly_rate': wageHourlyRate,
      'travel_allowance': travelAllowance,
      'gst': gst,
      'start_date_work': startDateWork,
      'end_date_work': endDateWork,
      'work_saturday': workSaturday,
      'work_sunday': workSunday,
      'start_time': startTime,
      'end_time': endTime,
      'description': description,
      'payment_day': paymentDay,
      'requires_supervisor_signature': requiresSupervisorSignature,
      'supervisor_name': supervisorName,
      'visibility': visibility,
      'payment_type': paymentType,
      'total_wage': totalWage,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'builder_profile': builderProfile.toJson(),
      'jobsite': jobsite?.toJson(),
      'job_type': jobType?.toJson(),
      'job_licenses': jobLicenses.map((license) => license.toJson()).toList(),
      'job_skills': jobSkills.map((skill) => skill.toJson()).toList(),
      'job_requirements': jobRequirements.map((req) => req.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'DtoReceiveLabourJobDetail(id: $id, manyLabours: $manyLabours, totalWage: $totalWage, description: $description)';
  }
}
