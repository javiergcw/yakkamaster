/// Clase para representar una skill de trabajo
class JobSkill {
  final String skillCategoryId;
  final String skillSubcategoryId;

  JobSkill({
    required this.skillCategoryId,
    required this.skillSubcategoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'skill_category_id': skillCategoryId,
      'skill_subcategory_id': skillSubcategoryId,
    };
  }

  factory JobSkill.fromJson(Map<String, dynamic> json) {
    return JobSkill(
      skillCategoryId: json['skill_category_id'] as String,
      skillSubcategoryId: json['skill_subcategory_id'] as String,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JobSkill &&
        other.skillCategoryId == skillCategoryId &&
        other.skillSubcategoryId == skillSubcategoryId;
  }

  @override
  int get hashCode => skillCategoryId.hashCode ^ skillSubcategoryId.hashCode;
}

/// DTO para enviar un job al API
class DtoSendJob {
  final String jobsiteId;
  final String jobTypeId;
  final int manyLabours;
  final bool ongoingWork;
  final double wageSiteAllowance;
  final double wageLeadingHandAllowance;
  final double wageProductivityAllowance;
  final double extrasOvertimeRate;
  final double wageHourlyRate;
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
  final List<String> licenseIds;
  final List<JobSkill> jobSkills;
  final List<String> jobRequirementIds;

  DtoSendJob({
    required this.jobsiteId,
    required this.jobTypeId,
    required this.manyLabours,
    this.ongoingWork = false,
    this.wageSiteAllowance = 0.0,
    this.wageLeadingHandAllowance = 0.0,
    this.wageProductivityAllowance = 0.0,
    this.extrasOvertimeRate = 0.0,
    this.wageHourlyRate = 0.0,
    this.travelAllowance = 0.0,
    this.gst = 0.0,
    this.startDateWork = '',
    this.endDateWork = '',
    this.workSaturday = false,
    this.workSunday = false,
    this.startTime = '',
    this.endTime = '',
    this.description = '',
    this.paymentDay = '',
    this.requiresSupervisorSignature = false,
    this.supervisorName = '',
    this.visibility = 'PUBLIC',
    this.paymentType = 'WEEKLY',
    this.licenseIds = const [],
    this.jobSkills = const [],
    this.jobRequirementIds = const [],
  });

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'jobsite_id': jobsiteId,
      'job_type_id': jobTypeId,
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
      'license_ids': licenseIds,
      'job_skills': jobSkills.map((skill) => skill.toJson()).toList(),
      'job_requirement_ids': jobRequirementIds,
    };
  }

  /// Constructor desde JSON
  factory DtoSendJob.fromJson(Map<String, dynamic> json) {
    return DtoSendJob(
      jobsiteId: json['jobsite_id'] as String,
      jobTypeId: json['job_type_id'] as String,
      manyLabours: json['many_labours'] as int,
      ongoingWork: json['ongoing_work'] as bool,
      wageSiteAllowance: (json['wage_site_allowance'] as num).toDouble(),
      wageLeadingHandAllowance: (json['wage_leading_hand_allowance'] as num).toDouble(),
      wageProductivityAllowance: (json['wage_productivity_allowance'] as num).toDouble(),
      extrasOvertimeRate: (json['extras_overtime_rate'] as num).toDouble(),
      wageHourlyRate: (json['wage_hourly_rate'] as num).toDouble(),
      travelAllowance: (json['travel_allowance'] as num).toDouble(),
      gst: (json['gst'] as num).toDouble(),
      startDateWork: json['start_date_work'] as String,
      endDateWork: json['end_date_work'] as String,
      workSaturday: json['work_saturday'] as bool,
      workSunday: json['work_sunday'] as bool,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      description: json['description'] as String,
      paymentDay: json['payment_day'] as String,
      requiresSupervisorSignature: json['requires_supervisor_signature'] as bool,
      supervisorName: json['supervisor_name'] as String,
      visibility: json['visibility'] as String,
      paymentType: json['payment_type'] as String,
      licenseIds: List<String>.from(json['license_ids'] as List),
      jobSkills: (json['job_skills'] as List)
          .map((skill) => JobSkill.fromJson(skill as Map<String, dynamic>))
          .toList(),
      jobRequirementIds: List<String>.from(json['job_requirement_ids'] as List),
    );
  }

  /// Crea un DtoSendJob con valores por defecto
  factory DtoSendJob.create({
    required String jobsiteId,
    required String jobTypeId,
    int manyLabours = 1,
    bool ongoingWork = false,
    double wageSiteAllowance = 0.0,
    double wageLeadingHandAllowance = 0.0,
    double wageProductivityAllowance = 0.0,
    double extrasOvertimeRate = 1.5,
    double wageHourlyRate = 0.0,
    double travelAllowance = 0.0,
    double gst = 0.0,
    String startDateWork = '',
    String endDateWork = '',
    bool workSaturday = false,
    bool workSunday = false,  
    String startTime = '08:00:00',
    String endTime = '17:00:00',
    String description = '',
    String paymentDay = '',
    bool requiresSupervisorSignature = false,
    String supervisorName = '',
    String visibility = 'PUBLIC',
    String paymentType = 'WEEKLY',
    List<String> licenseIds = const [],
    List<JobSkill> jobSkills = const [],
    List<String> jobRequirementIds = const [],
  }) {
    return DtoSendJob(
      jobsiteId: jobsiteId,
      jobTypeId: jobTypeId,
      manyLabours: manyLabours,
      ongoingWork: ongoingWork,
      wageSiteAllowance: wageSiteAllowance,
      wageLeadingHandAllowance: wageLeadingHandAllowance,
      wageProductivityAllowance: wageProductivityAllowance,
      extrasOvertimeRate: extrasOvertimeRate,
      wageHourlyRate: wageHourlyRate,
      travelAllowance: travelAllowance,
      gst: gst,
      startDateWork: startDateWork,
      endDateWork: endDateWork,
      workSaturday: workSaturday,
      workSunday: workSunday,
      startTime: startTime,
      endTime: endTime,
      description: description,
      paymentDay: paymentDay,
      requiresSupervisorSignature: requiresSupervisorSignature,
      supervisorName: supervisorName,
      visibility: visibility,
      paymentType: paymentType,
      licenseIds: licenseIds,
      jobSkills: jobSkills,
      jobRequirementIds: jobRequirementIds,
    );
  }

  /// Crea una copia con nuevos valores
  DtoSendJob copyWith({
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
    List<String>? licenseIds,
    List<JobSkill>? jobSkills,
    List<String>? jobRequirementIds,
  }) {
    return DtoSendJob(
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
      licenseIds: licenseIds ?? this.licenseIds,
      jobSkills: jobSkills ?? this.jobSkills,
      jobRequirementIds: jobRequirementIds ?? this.jobRequirementIds,
    );
  }

  /// Valida que los campos requeridos no estén vacíos
  bool get isValid {
    // Solo validar campos absolutamente requeridos según la API
    return jobsiteId.trim().isNotEmpty &&
           jobTypeId.trim().isNotEmpty &&
           manyLabours >= 1;
  }

  /// Obtiene los campos faltantes
  List<String> get missingFields {
    final missing = <String>[];
    if (jobsiteId.trim().isEmpty) missing.add('jobsite_id');
    if (jobTypeId.trim().isEmpty) missing.add('job_type_id');
    if (manyLabours < 1) missing.add('many_labours');
    return missing;
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

  /// Obtiene el costo total por hora incluyendo todos los componentes
  double get totalHourlyCost {
    return wageHourlyRate + totalAllowances + travelAllowance + gst;
  }

  @override
  String toString() {
    return 'DtoSendJob(jobsiteId: $jobsiteId, jobTypeId: $jobTypeId, manyLabours: $manyLabours, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DtoSendJob &&
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
        other.licenseIds.toString() == licenseIds.toString() &&
        other.jobSkills.toString() == jobSkills.toString() &&
        other.jobRequirementIds.toString() == jobRequirementIds.toString();
  }

  @override
  int get hashCode {
    return jobsiteId.hashCode ^
        jobTypeId.hashCode ^
        manyLabours.hashCode ^
        ongoingWork.hashCode ^
        wageSiteAllowance.hashCode ^
        wageLeadingHandAllowance.hashCode ^
        wageProductivityAllowance.hashCode ^
        extrasOvertimeRate.hashCode ^
        wageHourlyRate.hashCode ^
        travelAllowance.hashCode ^
        gst.hashCode ^
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
        licenseIds.hashCode ^
        jobSkills.hashCode ^
        jobRequirementIds.hashCode;
  }
}
