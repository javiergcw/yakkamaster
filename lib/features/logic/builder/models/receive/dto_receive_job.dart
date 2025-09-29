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
  final int paymentDay;
  final bool requiresSupervisorSignature;
  final String supervisorName;
  final String visibility;
  final String paymentType;
  final String createdAt;
  final String updatedAt;

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
    required this.createdAt,
    required this.updatedAt,
  });

  /// Constructor desde JSON
  factory DtoReceiveJob.fromJson(Map<String, dynamic> json) {
    return DtoReceiveJob(
      id: json['id'] as String,
      builderProfileId: json['builder_profile_id'] as String?,
      jobsiteId: json['jobsite_id'] as String,
      jobTypeId: json['job_type_id'] as String,
      manyLabours: json['many_labours'] as int,
      ongoingWork: json['ongoing_work'] as bool,
      wageSiteAllowance: (json['wage_site_allowance'] as num).toDouble(),
      wageLeadingHandAllowance: (json['wage_leading_hand_allowance'] as num).toDouble(),
      wageProductivityAllowance: (json['wage_productivity_allowance'] as num).toDouble(),
      extrasOvertimeRate: (json['extras_overtime_rate'] as num).toDouble(),
      wageHourlyRate: json['wage_hourly_rate'] != null ? (json['wage_hourly_rate'] as num).toDouble() : null,
      travelAllowance: json['travel_allowance'] != null ? (json['travel_allowance'] as num).toDouble() : null,
      gst: json['gst'] != null ? (json['gst'] as num).toDouble() : null,
      startDateWork: json['start_date_work'] as String,
      endDateWork: json['end_date_work'] as String,
      workSaturday: json['work_saturday'] as bool,
      workSunday: json['work_sunday'] as bool,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      description: json['description'] as String,
      paymentDay: json['payment_day'] as int,
      requiresSupervisorSignature: json['requires_supervisor_signature'] as bool,
      supervisorName: json['supervisor_name'] as String,
      visibility: json['visibility'] as String,
      paymentType: json['payment_type'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
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
    int? paymentDay,
    bool? requiresSupervisorSignature,
    String? supervisorName,
    String? visibility,
    String? paymentType,
    String? createdAt,
    String? updatedAt,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
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
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
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
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
