import 'package:flutter/material.dart';

class PostJobDto {
  final String? selectedSkill;
  final String? jobTitle;
  final String? jobDescription;
  final String? jobLocation;
  final String? jobSiteId;
  final int? workersNeeded;
  final double? hourlyRate;
  final double? siteAllowance;
  final double? leadingHandAllowance;
  final double? productivityAllowance;
  final double? overtimeRate;
  final double? travelAllowance;
  final DateTime? startDate;
  final DateTime? endDate;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final String? jobType;
  final bool? isOngoingWork;
  final bool? workOnSaturdays;
  final bool? workOnSundays;
  final List<String>? requirements;
  final DateTime? payDay;
  final String? paymentFrequency;
  final bool? requiresSupervisorSignature;
  final String? supervisorName;
  final bool? isPublic;

  PostJobDto({
    this.selectedSkill,
    this.jobTitle,
    this.jobDescription,
    this.jobLocation,
    this.jobSiteId,
    this.workersNeeded,
    this.hourlyRate,
    this.siteAllowance,
    this.leadingHandAllowance,
    this.productivityAllowance,
    this.overtimeRate,
    this.travelAllowance,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.jobType,
    this.isOngoingWork,
    this.workOnSaturdays,
    this.workOnSundays,
    this.requirements,
    this.payDay,
    this.paymentFrequency,
    this.requiresSupervisorSignature,
    this.supervisorName,
    this.isPublic,
  });

  PostJobDto copyWith({
    String? selectedSkill,
    String? jobTitle,
    String? jobDescription,
    String? jobLocation,
    String? jobSiteId,
    int? workersNeeded,
    double? hourlyRate,
    double? siteAllowance,
    double? leadingHandAllowance,
    double? productivityAllowance,
    double? overtimeRate,
    double? travelAllowance,
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? jobType,
    bool? isOngoingWork,
    bool? workOnSaturdays,
    bool? workOnSundays,
    List<String>? requirements,
    DateTime? payDay,
    String? paymentFrequency,
    bool? requiresSupervisorSignature,
    String? supervisorName,
    bool? isPublic,
  }) {
    return PostJobDto(
      selectedSkill: selectedSkill ?? this.selectedSkill,
      jobTitle: jobTitle ?? this.jobTitle,
      jobDescription: jobDescription ?? this.jobDescription,
      jobLocation: jobLocation ?? this.jobLocation,
      jobSiteId: jobSiteId ?? this.jobSiteId,
      workersNeeded: workersNeeded ?? this.workersNeeded,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      siteAllowance: siteAllowance ?? this.siteAllowance,
      leadingHandAllowance: leadingHandAllowance ?? this.leadingHandAllowance,
      productivityAllowance: productivityAllowance ?? this.productivityAllowance,
      overtimeRate: overtimeRate ?? this.overtimeRate,
      travelAllowance: travelAllowance ?? this.travelAllowance,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      jobType: jobType ?? this.jobType,
      isOngoingWork: isOngoingWork ?? this.isOngoingWork,
      workOnSaturdays: workOnSaturdays ?? this.workOnSaturdays,
      workOnSundays: workOnSundays ?? this.workOnSundays,
      requirements: requirements ?? this.requirements,
      payDay: payDay ?? this.payDay,
      paymentFrequency: paymentFrequency ?? this.paymentFrequency,
      requiresSupervisorSignature: requiresSupervisorSignature ?? this.requiresSupervisorSignature,
      supervisorName: supervisorName ?? this.supervisorName,
      isPublic: isPublic ?? this.isPublic,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'selectedSkill': selectedSkill,
      'jobTitle': jobTitle,
      'jobDescription': jobDescription,
      'jobLocation': jobLocation,
      'jobSiteId': jobSiteId,
      'workersNeeded': workersNeeded,
      'hourlyRate': hourlyRate,
      'siteAllowance': siteAllowance,
      'leadingHandAllowance': leadingHandAllowance,
      'productivityAllowance': productivityAllowance,
      'overtimeRate': overtimeRate,
      'travelAllowance': travelAllowance,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'startTime': startTime != null ? '${startTime!.hour}:${startTime!.minute}' : null,
      'endTime': endTime != null ? '${endTime!.hour}:${endTime!.minute}' : null,
      'jobType': jobType,
      'isOngoingWork': isOngoingWork,
      'workOnSaturdays': workOnSaturdays,
      'workOnSundays': workOnSundays,
      'requirements': requirements,
      'payDay': payDay?.toIso8601String(),
      'paymentFrequency': paymentFrequency,
      'requiresSupervisorSignature': requiresSupervisorSignature,
      'supervisorName': supervisorName,
      'isPublic': isPublic,
    };
  }

  factory PostJobDto.fromMap(Map<String, dynamic> map) {
    return PostJobDto(
      selectedSkill: map['selectedSkill'],
      jobTitle: map['jobTitle'],
      jobDescription: map['jobDescription'],
      jobLocation: map['jobLocation'],
      jobSiteId: map['jobSiteId'],
      workersNeeded: map['workersNeeded'],
      hourlyRate: map['hourlyRate']?.toDouble(),
      siteAllowance: map['siteAllowance']?.toDouble(),
      leadingHandAllowance: map['leadingHandAllowance']?.toDouble(),
      productivityAllowance: map['productivityAllowance']?.toDouble(),
      overtimeRate: map['overtimeRate']?.toDouble(),
      travelAllowance: map['travelAllowance']?.toDouble(),
      startDate: map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      startTime: map['startTime'] != null ? _parseTimeOfDay(map['startTime']) : null,
      endTime: map['endTime'] != null ? _parseTimeOfDay(map['endTime']) : null,
      jobType: map['jobType'],
      isOngoingWork: map['isOngoingWork'],
      workOnSaturdays: map['workOnSaturdays'],
      workOnSundays: map['workOnSundays'],
      requirements: map['requirements'] != null ? List<String>.from(map['requirements']) : null,
      payDay: map['payDay'] != null ? DateTime.parse(map['payDay']) : null,
      paymentFrequency: map['paymentFrequency'],
      requiresSupervisorSignature: map['requiresSupervisorSignature'],
      supervisorName: map['supervisorName'],
      isPublic: map['isPublic'],
    );
  }

  @override
  String toString() {
    return 'PostJobDto(selectedSkill: $selectedSkill, jobTitle: $jobTitle, jobDescription: $jobDescription, jobLocation: $jobLocation, jobSiteId: $jobSiteId, workersNeeded: $workersNeeded, hourlyRate: $hourlyRate, siteAllowance: $siteAllowance, leadingHandAllowance: $leadingHandAllowance, productivityAllowance: $productivityAllowance, overtimeRate: $overtimeRate, travelAllowance: $travelAllowance, startDate: $startDate, endDate: $endDate, startTime: $startTime, endTime: $endTime, jobType: $jobType, isOngoingWork: $isOngoingWork, workOnSaturdays: $workOnSaturdays, workOnSundays: $workOnSundays, requirements: $requirements, payDay: $payDay, paymentFrequency: $paymentFrequency)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostJobDto &&
        other.selectedSkill == selectedSkill &&
        other.jobTitle == jobTitle &&
        other.jobDescription == jobDescription &&
        other.jobLocation == jobLocation &&
        other.jobSiteId == jobSiteId &&
        other.workersNeeded == workersNeeded &&
        other.hourlyRate == hourlyRate &&
        other.siteAllowance == siteAllowance &&
        other.leadingHandAllowance == leadingHandAllowance &&
        other.productivityAllowance == productivityAllowance &&
        other.overtimeRate == overtimeRate &&
        other.travelAllowance == travelAllowance &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.jobType == jobType &&
        other.isOngoingWork == isOngoingWork &&
        other.workOnSaturdays == workOnSaturdays &&
        other.workOnSundays == workOnSundays &&
        other.requirements == requirements &&
        other.payDay == payDay &&
        other.paymentFrequency == paymentFrequency;
  }

  @override
  int get hashCode {
    return selectedSkill.hashCode ^
        jobTitle.hashCode ^
        jobDescription.hashCode ^
        jobLocation.hashCode ^
        jobSiteId.hashCode ^
        workersNeeded.hashCode ^
        hourlyRate.hashCode ^
        siteAllowance.hashCode ^
        leadingHandAllowance.hashCode ^
        productivityAllowance.hashCode ^
        overtimeRate.hashCode ^
        travelAllowance.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        jobType.hashCode ^
        isOngoingWork.hashCode ^
        workOnSaturdays.hashCode ^
        workOnSundays.hashCode ^
        requirements.hashCode ^
        payDay.hashCode ^
        paymentFrequency.hashCode;
  }

  static TimeOfDay _parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }
}
