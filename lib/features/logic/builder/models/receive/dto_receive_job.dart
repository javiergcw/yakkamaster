/// Clase para representar el perfil del constructor
class BuilderProfile {
  final String id;
  final String companyName;
  final String displayName;
  final String createdAt;
  final String updatedAt;

  BuilderProfile({
    required this.id,
    required this.companyName,
    required this.displayName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BuilderProfile.fromJson(Map<String, dynamic> json) {
    return BuilderProfile(
      id: json['id'] as String? ?? '',
      companyName: json['company_name'] as String? ?? '',
      displayName: json['display_name'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BuilderProfile &&
        other.id == id &&
        other.companyName == companyName &&
        other.displayName == displayName &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        companyName.hashCode ^
        displayName.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}

/// Clase para representar el jobsite
class Jobsite {
  final String id;
  final String name;
  final String address;
  final String suburb;
  final String description;
  final double latitude;
  final double longitude;
  final String createdAt;
  final String updatedAt;

  Jobsite({
    required this.id,
    required this.name,
    required this.address,
    required this.suburb,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Jobsite.fromJson(Map<String, dynamic> json) {
    return Jobsite(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      suburb: json['suburb'] as String? ?? '',
      description: json['description'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Jobsite &&
        other.id == id &&
        other.name == name &&
        other.address == address &&
        other.suburb == suburb &&
        other.description == description &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        address.hashCode ^
        suburb.hashCode ^
        description.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}

/// Clase para representar el tipo de trabajo
class JobType {
  final String id;
  final String name;
  final String description;
  final String createdAt;
  final String updatedAt;

  JobType({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JobType.fromJson(Map<String, dynamic> json) {
    return JobType(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JobType &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}

/// Clase para representar una licencia
class License {
  final String id;
  final String name;
  final String description;

  License({
    required this.id,
    required this.name,
    required this.description,
  });

  factory License.fromJson(Map<String, dynamic> json) {
    return License(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is License &&
        other.id == id &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode;
  }
}

/// Clase para representar una licencia de trabajo
class JobLicense {
  final String id;
  final String jobId;
  final String licenseId;
  final License license;
  final String createdAt;

  JobLicense({
    required this.id,
    required this.jobId,
    required this.licenseId,
    required this.license,
    required this.createdAt,
  });

  factory JobLicense.fromJson(Map<String, dynamic> json) {
    return JobLicense(
      id: json['id'] as String? ?? '',
      jobId: json['job_id'] as String? ?? '',
      licenseId: json['license_id'] as String? ?? '',
      license: License.fromJson(json['license'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JobLicense &&
        other.id == id &&
        other.jobId == jobId &&
        other.licenseId == licenseId &&
        other.license == license &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        jobId.hashCode ^
        licenseId.hashCode ^
        license.hashCode ^
        createdAt.hashCode;
  }
}

/// Clase para representar una categoría de skill
class SkillCategory {
  final String id;
  final String name;
  final String description;

  SkillCategory({
    required this.id,
    required this.name,
    required this.description,
  });

  factory SkillCategory.fromJson(Map<String, dynamic> json) {
    return SkillCategory(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SkillCategory &&
        other.id == id &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ description.hashCode;
  }
}

/// Clase para representar una subcategoría de skill
class SkillSubcategory {
  final String id;
  final String name;
  final String description;

  SkillSubcategory({
    required this.id,
    required this.name,
    required this.description,
  });

  factory SkillSubcategory.fromJson(Map<String, dynamic> json) {
    return SkillSubcategory(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SkillSubcategory &&
        other.id == id &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ description.hashCode;
  }
}

/// Clase para representar una skill de trabajo
class JobSkillReceive {
  final String id;
  final String jobId;
  final String skillCategoryId;
  final String skillSubcategoryId;
  final String createdAt;
  final SkillCategory? skillCategory;
  final SkillSubcategory? skillSubcategory;

  JobSkillReceive({
    required this.id,
    required this.jobId,
    required this.skillCategoryId,
    required this.skillSubcategoryId,
    required this.createdAt,
    this.skillCategory,
    this.skillSubcategory,
  });

  factory JobSkillReceive.fromJson(Map<String, dynamic> json) {
    return JobSkillReceive(
      id: json['id'] as String? ?? '',
      jobId: json['job_id'] as String? ?? '',
      skillCategoryId: json['skill_category_id'] as String? ?? '',
      skillSubcategoryId: json['skill_subcategory_id'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      skillCategory: json['skill_category'] != null 
          ? SkillCategory.fromJson(json['skill_category'] as Map<String, dynamic>)
          : null,
      skillSubcategory: json['skill_subcategory'] != null 
          ? SkillSubcategory.fromJson(json['skill_subcategory'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JobSkillReceive &&
        other.id == id &&
        other.jobId == jobId &&
        other.skillCategoryId == skillCategoryId &&
        other.skillSubcategoryId == skillSubcategoryId &&
        other.createdAt == createdAt &&
        other.skillCategory == skillCategory &&
        other.skillSubcategory == skillSubcategory;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        jobId.hashCode ^
        skillCategoryId.hashCode ^
        skillSubcategoryId.hashCode ^
        createdAt.hashCode ^
        (skillCategory?.hashCode ?? 0) ^
        (skillSubcategory?.hashCode ?? 0);
  }
}

/// Clase para representar un requerimiento de trabajo
class JobRequirement {
  final String id;
  final String name;
  final String description;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  JobRequirement({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JobRequirement.fromJson(Map<String, dynamic> json) {
    return JobRequirement(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? false,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JobRequirement &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.isActive == isActive &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        isActive.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}

/// DTO para recibir un job del API
class DtoReceiveJob {
  final String id;
  final String? builderProfileId;
  final String jobsiteId;
  final String jobTypeId;
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
  final BuilderProfile? builderProfile;
  final Jobsite? jobsite;
  final JobType? jobType;
  final List<JobLicense> jobLicenses;
  final List<JobSkillReceive> jobSkills;
  final List<JobRequirement> jobRequirements;

  DtoReceiveJob({
    required this.id,
    this.builderProfileId,
    required this.jobsiteId,
    required this.jobTypeId,
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
  });

  /// Constructor desde JSON
  factory DtoReceiveJob.fromJson(Map<String, dynamic> json) {
    return DtoReceiveJob(
      id: json['id'] as String? ?? '',
      builderProfileId: json['builder_profile_id'] as String?,
      jobsiteId: json['jobsite_id'] as String? ?? '',
      jobTypeId: json['job_type_id'] as String? ?? '',
      manyLabours: json['many_labours'] as int? ?? 0,
      ongoingWork: json['ongoing_work'] as bool? ?? false,
      wageSiteAllowance: (json['wage_site_allowance'] as num?)?.toDouble() ?? 0.0,
      wageLeadingHandAllowance: (json['wage_leading_hand_allowance'] as num?)?.toDouble() ?? 0.0,
      wageProductivityAllowance: (json['wage_productivity_allowance'] as num?)?.toDouble() ?? 0.0,
      extrasOvertimeRate: (json['extras_overtime_rate'] as num?)?.toDouble() ?? 0.0,
      wageHourlyRate: json['wage_hourly_rate'] != null ? (json['wage_hourly_rate'] as num).toDouble() : null,
      travelAllowance: json['travel_allowance'] != null ? (json['travel_allowance'] as num).toDouble() : null,
      gst: json['gst'] != null ? (json['gst'] as num).toDouble() : null,
      startDateWork: json['start_date_work'] as String? ?? '',
      endDateWork: json['end_date_work'] as String? ?? '',
      workSaturday: json['work_saturday'] as bool? ?? false,
      workSunday: json['work_sunday'] as bool? ?? false,
      startTime: json['start_time'] as String? ?? '',
      endTime: json['end_time'] as String? ?? '',
      description: json['description'] as String? ?? '',
      paymentDay: json['payment_day'] as String? ?? '',
      requiresSupervisorSignature: json['requires_supervisor_signature'] as bool? ?? false,
      supervisorName: json['supervisor_name'] as String? ?? '',
      visibility: json['visibility'] as String? ?? 'PUBLIC',
      paymentType: json['payment_type'] as String? ?? 'WEEKLY',
      totalWage: json['total_wage'] != null ? _parseTotalWage(json['total_wage']) : null,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      builderProfile: json['builder_profile'] != null 
          ? BuilderProfile.fromJson(json['builder_profile'] as Map<String, dynamic>)
          : null,
      jobsite: json['jobsite'] != null 
          ? Jobsite.fromJson(json['jobsite'] as Map<String, dynamic>)
          : null,
      jobType: json['job_type'] != null 
          ? JobType.fromJson(json['job_type'] as Map<String, dynamic>)
          : null,
      jobLicenses: json['job_licenses'] != null 
          ? (json['job_licenses'] as List)
              .map((license) => JobLicense.fromJson(license as Map<String, dynamic>))
              .toList()
          : [],
      jobSkills: json['job_skills'] != null 
          ? (json['job_skills'] as List)
              .map((skill) => JobSkillReceive.fromJson(skill as Map<String, dynamic>))
              .toList()
          : [],
      jobRequirements: json['job_requirements'] != null 
          ? (json['job_requirements'] as List)
              .map((requirement) => JobRequirement.fromJson(requirement as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  /// Crea una copia con nuevos valores
  DtoReceiveJob copyWith({
    String? id,
    String? builderProfileId,
    String? jobsiteId,
    String? jobTypeId,
    int? manyLabours,
    bool? ongoingWork,
    double? wageSiteAllowance,
    double? wageLeadingHandAllowance,
    double? wageProductivityAllowance,
    double? extrasOvertimeRate,
    double? wageHourlyRate,
    double? travelAllowance,
    double? gst,
    String? startDateWork,
    String? endDateWork,
    bool? workSaturday,
    bool? workSunday,
    String? startTime,
    String? endTime,
    String? description,
    String? paymentDay,
    bool? requiresSupervisorSignature,
    String? supervisorName,
    String? visibility,
    String? paymentType,
    double? totalWage,
    String? createdAt,
    String? updatedAt,
    BuilderProfile? builderProfile,
    Jobsite? jobsite,
    JobType? jobType,
    List<JobLicense>? jobLicenses,
    List<JobSkillReceive>? jobSkills,
    List<JobRequirement>? jobRequirements,
  }) {
    return DtoReceiveJob(
      id: id ?? this.id,
      builderProfileId: builderProfileId ?? this.builderProfileId,
      jobsiteId: jobsiteId ?? this.jobsiteId,
      jobTypeId: jobTypeId ?? this.jobTypeId,
      manyLabours: manyLabours ?? this.manyLabours,
      ongoingWork: ongoingWork ?? this.ongoingWork,
      wageSiteAllowance: wageSiteAllowance ?? this.wageSiteAllowance,
      wageLeadingHandAllowance: wageLeadingHandAllowance ?? this.wageLeadingHandAllowance,
      wageProductivityAllowance: wageProductivityAllowance ?? this.wageProductivityAllowance,
      extrasOvertimeRate: extrasOvertimeRate ?? this.extrasOvertimeRate,
      wageHourlyRate: wageHourlyRate ?? this.wageHourlyRate,
      travelAllowance: travelAllowance ?? this.travelAllowance,
      gst: gst ?? this.gst,
      startDateWork: startDateWork ?? this.startDateWork,
      endDateWork: endDateWork ?? this.endDateWork,
      workSaturday: workSaturday ?? this.workSaturday,
      workSunday: workSunday ?? this.workSunday,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      description: description ?? this.description,
      paymentDay: paymentDay ?? this.paymentDay,
      requiresSupervisorSignature: requiresSupervisorSignature ?? this.requiresSupervisorSignature,
      supervisorName: supervisorName ?? this.supervisorName,
      visibility: visibility ?? this.visibility,
      paymentType: paymentType ?? this.paymentType,
      totalWage: totalWage ?? this.totalWage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      builderProfile: builderProfile ?? this.builderProfile,
      jobsite: jobsite ?? this.jobsite,
      jobType: jobType ?? this.jobType,
      jobLicenses: jobLicenses ?? this.jobLicenses,
      jobSkills: jobSkills ?? this.jobSkills,
      jobRequirements: jobRequirements ?? this.jobRequirements,
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

  /// Obtiene el rango de fechas formateado
  String get dateRange {
    return '$startDateWork - $endDateWork';
  }

  /// Obtiene el rango de horarios formateado
  String get timeRange {
    return '$startTime - $endTime';
  }

  /// Obtiene los días de trabajo como string
  String get workDays {
    final days = <String>[];
    if (workSaturday) days.add('Saturday');
    if (workSunday) days.add('Sunday');
    return days.isEmpty ? 'Monday-Friday' : 'Monday-Friday, ${days.join(', ')}';
  }

  /// Obtiene el total de allowances
  double get totalAllowances {
    return wageSiteAllowance + wageLeadingHandAllowance + wageProductivityAllowance;
  }

  /// Verifica si el job está activo (basado en fechas)
  bool get isActive {
    final now = DateTime.now();
    final startDate = DateTime.tryParse(startDateWork);
    final endDate = DateTime.tryParse(endDateWork);
    
    if (startDate == null) return false;
    if (endDate == null) return now.isAfter(startDate);
    
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  /// Verifica si el job está cerrado
  bool get isClosed {
    final now = DateTime.now();
    final endDate = DateTime.tryParse(endDateWork);
    
    if (endDate == null) return false;
    return now.isAfter(endDate);
  }

  /// Obtiene el status formateado
  String get formattedStatus {
    if (isActive) return 'ACTIVE';
    if (isClosed) return 'CLOSED';
    return 'PENDING';
  }

  @override
  String toString() {
    return 'DtoReceiveJob(id: $id, jobsiteId: $jobsiteId, jobTypeId: $jobTypeId, status: ${formattedStatus})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DtoReceiveJob &&
        other.id == id &&
        other.builderProfileId == builderProfileId &&
        other.jobsiteId == jobsiteId &&
        other.jobTypeId == jobTypeId &&
        other.manyLabours == manyLabours &&
        other.ongoingWork == ongoingWork &&
        other.wageSiteAllowance == wageSiteAllowance &&
        other.wageLeadingHandAllowance == wageLeadingHandAllowance &&
        other.wageProductivityAllowance == wageProductivityAllowance &&
        other.extrasOvertimeRate == extrasOvertimeRate &&
        other.wageHourlyRate == wageHourlyRate &&
        other.travelAllowance == travelAllowance &&
        other.gst == gst &&
        other.startDateWork == startDateWork &&
        other.endDateWork == endDateWork &&
        other.workSaturday == workSaturday &&
        other.workSunday == workSunday &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.description == description &&
        other.paymentDay == paymentDay &&
        other.requiresSupervisorSignature == requiresSupervisorSignature &&
        other.supervisorName == supervisorName &&
        other.visibility == visibility &&
        other.paymentType == paymentType &&
        other.totalWage == totalWage &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.builderProfile == builderProfile &&
        other.jobsite == jobsite &&
        other.jobType == jobType &&
        other.jobLicenses.toString() == jobLicenses.toString() &&
        other.jobSkills.toString() == jobSkills.toString() &&
        other.jobRequirements.toString() == jobRequirements.toString();
  }

  @override
  int get hashCode {
    return id.hashCode ^
        (builderProfileId?.hashCode ?? 0) ^
        jobsiteId.hashCode ^
        jobTypeId.hashCode ^
        manyLabours.hashCode ^
        ongoingWork.hashCode ^
        wageSiteAllowance.hashCode ^
        wageLeadingHandAllowance.hashCode ^
        wageProductivityAllowance.hashCode ^
        extrasOvertimeRate.hashCode ^
        (wageHourlyRate?.hashCode ?? 0) ^
        (travelAllowance?.hashCode ?? 0) ^
        (gst?.hashCode ?? 0) ^
        startDateWork.hashCode ^
        endDateWork.hashCode ^
        workSaturday.hashCode ^
        workSunday.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        description.hashCode ^
        paymentDay.hashCode ^
        requiresSupervisorSignature.hashCode ^
        supervisorName.hashCode ^
        visibility.hashCode ^
        paymentType.hashCode ^
        (totalWage?.hashCode ?? 0) ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        (builderProfile?.hashCode ?? 0) ^
        (jobsite?.hashCode ?? 0) ^
        (jobType?.hashCode ?? 0) ^
        jobLicenses.hashCode ^
        jobSkills.hashCode ^
        jobRequirements.hashCode;
  }
}
