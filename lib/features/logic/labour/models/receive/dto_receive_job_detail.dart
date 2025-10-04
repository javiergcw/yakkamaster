import 'dto_receive_builder.dart';
import 'dto_receive_jobsite.dart';
import 'dto_receive_job_requirement.dart';

/// DTO para recibir un job detail completo desde el API
class DtoReceiveJobDetail {
  final String id;
  final int manyLabours;
  final bool ongoingWork;
  final double wageSiteAllowance;
  final double wageLeadingHandAllowance;
  final double wageProductivityAllowance;
  final double extrasOvertimeRate;
  final double? wageHourlyRate;
  final double? travelAllowance;
  final double? gst;
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
  final double? totalWage;
  final String createdAt;
  final String updatedAt;
  final DtoReceiveBuilder? builderProfile;
  final DtoReceiveJobsite? jobsite;
  final DtoReceiveJobType? jobType;
  final List<DtoReceiveJobLicense> jobLicenses;
  final List<DtoReceiveJobSkill> jobSkills;
  final List<DtoReceiveJobRequirement> jobRequirements;
  final DtoReceiveApplication? application;

  DtoReceiveJobDetail({
    required this.id,
    required this.manyLabours,
    required this.ongoingWork,
    required this.wageSiteAllowance,
    required this.wageLeadingHandAllowance,
    required this.wageProductivityAllowance,
    required this.extrasOvertimeRate,
    this.wageHourlyRate,
    this.travelAllowance,
    this.gst,
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
    this.totalWage,
    required this.createdAt,
    required this.updatedAt,
    this.builderProfile,
    this.jobsite,
    this.jobType,
    this.jobLicenses = const [],
    this.jobSkills = const [],
    this.jobRequirements = const [],
    this.application,
  });

  /// Constructor desde JSON
  factory DtoReceiveJobDetail.fromJson(Map<String, dynamic> json) {
    return DtoReceiveJobDetail(
      id: json['id']?.toString() ?? '',
      manyLabours: json['many_labours'] ?? 0,
      ongoingWork: json['ongoing_work'] ?? false,
      wageSiteAllowance: (json['wage_site_allowance'] ?? 0).toDouble(),
      wageLeadingHandAllowance: (json['wage_leading_hand_allowance'] ?? 0).toDouble(),
      wageProductivityAllowance: (json['wage_productivity_allowance'] ?? 0).toDouble(),
      extrasOvertimeRate: (json['extras_overtime_rate'] ?? 0).toDouble(),
      wageHourlyRate: json['wage_hourly_rate']?.toDouble(),
      travelAllowance: json['travel_allowance']?.toDouble(),
      gst: json['gst']?.toDouble(),
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
      visibility: json['visibility']?.toString() ?? 'PUBLIC',
      paymentType: json['payment_type']?.toString() ?? 'WEEKLY',
      totalWage: json['total_wage'] != null ? _parseTotalWage(json['total_wage']) : null,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      builderProfile: json['builder_profile'] != null 
          ? DtoReceiveBuilder.fromJson(json['builder_profile'] ?? {})
          : null,
      jobsite: json['jobsite'] != null 
          ? DtoReceiveJobsite.fromJson(json['jobsite'] ?? {})
          : null,
      jobType: json['job_type'] != null 
          ? DtoReceiveJobType.fromJson(json['job_type'] ?? {})
          : null,
      jobLicenses: json['job_licenses'] != null 
          ? (json['job_licenses'] as List)
              .map((license) => DtoReceiveJobLicense.fromJson(license ?? {}))
              .toList()
          : [],
      jobSkills: json['job_skills'] != null 
          ? (json['job_skills'] as List)
              .map((skill) => DtoReceiveJobSkill.fromJson(skill ?? {}))
              .toList()
          : [],
      jobRequirements: json['job_requirements'] != null 
          ? (json['job_requirements'] as List)
              .map((req) => DtoReceiveJobRequirement.fromJson(req ?? {}))
              .toList()
          : [],
      application: json['application'] != null 
          ? DtoReceiveApplication.fromJson(json['application'] ?? {})
          : null,
    );
  }

  /// Parsea el total_wage que puede venir como número o string con símbolo de dólar
  static double? _parseTotalWage(dynamic value) {
    if (value == null) return null;
    
    if (value is num) {
      return value.toDouble();
    }
    
    if (value is String) {
      // Remover símbolo de dólar y espacios si están presentes
      final cleanValue = value.replaceAll(RegExp(r'[\$,\s]'), '');
      return double.tryParse(cleanValue);
    }
    
    return null;
  }

  @override
  String toString() {
    return 'DtoReceiveJobDetail(id: $id, manyLabours: $manyLabours, totalWage: $totalWage)';
  }
}

/// DTO para application
class DtoReceiveApplication {
  final String id;
  final String status;
  final String coverLetter;
  final String resumeUrl;
  final String createdAt;
  final String updatedAt;

  DtoReceiveApplication({
    required this.id,
    required this.status,
    required this.coverLetter,
    required this.resumeUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DtoReceiveApplication.fromJson(Map<String, dynamic> json) {
    return DtoReceiveApplication(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      coverLetter: json['cover_letter']?.toString() ?? '',
      resumeUrl: json['resume_url']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  @override
  String toString() {
    return 'DtoReceiveApplication(id: $id, status: $status)';
  }
}

/// DTO para job type
class DtoReceiveJobType {
  final String id;
  final String name;
  final String description;
  final String createdAt;
  final String updatedAt;

  DtoReceiveJobType({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DtoReceiveJobType.fromJson(Map<String, dynamic> json) {
    return DtoReceiveJobType(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }
}

/// DTO para job license
class DtoReceiveJobLicense {
  final String id;
  final String jobId;
  final String licenseId;
  final DtoReceiveLicense license;
  final String createdAt;

  DtoReceiveJobLicense({
    required this.id,
    required this.jobId,
    required this.licenseId,
    required this.license,
    required this.createdAt,
  });

  factory DtoReceiveJobLicense.fromJson(Map<String, dynamic> json) {
    return DtoReceiveJobLicense(
      id: json['id']?.toString() ?? '',
      jobId: json['job_id']?.toString() ?? '',
      licenseId: json['license_id']?.toString() ?? '',
      license: DtoReceiveLicense.fromJson(json['license'] ?? {}),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}

/// DTO para license
class DtoReceiveLicense {
  final String id;
  final String name;
  final String description;

  DtoReceiveLicense({
    required this.id,
    required this.name,
    required this.description,
  });

  factory DtoReceiveLicense.fromJson(Map<String, dynamic> json) {
    return DtoReceiveLicense(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}

/// DTO para job skill
class DtoReceiveJobSkill {
  final String id;
  final String jobId;
  final String skillCategoryId;
  final String skillSubcategoryId;
  final String createdAt;
  final DtoReceiveSkillCategory? skillCategory;
  final DtoReceiveSkillSubcategory? skillSubcategory;

  DtoReceiveJobSkill({
    required this.id,
    required this.jobId,
    required this.skillCategoryId,
    required this.skillSubcategoryId,
    required this.createdAt,
    this.skillCategory,
    this.skillSubcategory,
  });

  factory DtoReceiveJobSkill.fromJson(Map<String, dynamic> json) {
    return DtoReceiveJobSkill(
      id: json['id']?.toString() ?? '',
      jobId: json['job_id']?.toString() ?? '',
      skillCategoryId: json['skill_category_id']?.toString() ?? '',
      skillSubcategoryId: json['skill_subcategory_id']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      skillCategory: json['skill_category'] != null 
          ? DtoReceiveSkillCategory.fromJson(json['skill_category'] ?? {})
          : null,
      skillSubcategory: json['skill_subcategory'] != null 
          ? DtoReceiveSkillSubcategory.fromJson(json['skill_subcategory'] ?? {})
          : null,
    );
  }
}

/// DTO para skill category
class DtoReceiveSkillCategory {
  final String id;
  final String name;
  final String description;

  DtoReceiveSkillCategory({
    required this.id,
    required this.name,
    required this.description,
  });

  factory DtoReceiveSkillCategory.fromJson(Map<String, dynamic> json) {
    return DtoReceiveSkillCategory(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}

/// DTO para skill subcategory
class DtoReceiveSkillSubcategory {
  final String id;
  final String name;
  final String description;

  DtoReceiveSkillSubcategory({
    required this.id,
    required this.name,
    required this.description,
  });

  factory DtoReceiveSkillSubcategory.fromJson(Map<String, dynamic> json) {
    return DtoReceiveSkillSubcategory(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}
