import 'applicant_dto.dart';

class JobsiteApplicantsDto {
  final String jobsiteId;
  final String jobsiteName;
  final String jobsiteAddress;
  final List<ApplicantDto> applicants;

  JobsiteApplicantsDto({
    required this.jobsiteId,
    required this.jobsiteName,
    required this.jobsiteAddress,
    required this.applicants,
  });

  JobsiteApplicantsDto copyWith({
    String? jobsiteId,
    String? jobsiteName,
    String? jobsiteAddress,
    List<ApplicantDto>? applicants,
  }) {
    return JobsiteApplicantsDto(
      jobsiteId: jobsiteId ?? this.jobsiteId,
      jobsiteName: jobsiteName ?? this.jobsiteName,
      jobsiteAddress: jobsiteAddress ?? this.jobsiteAddress,
      applicants: applicants ?? this.applicants,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jobsiteId': jobsiteId,
      'jobsiteName': jobsiteName,
      'jobsiteAddress': jobsiteAddress,
      'applicants': applicants.map((applicant) => applicant.toMap()).toList(),
    };
  }

  factory JobsiteApplicantsDto.fromMap(Map<String, dynamic> map) {
    return JobsiteApplicantsDto(
      jobsiteId: map['jobsiteId'] ?? '',
      jobsiteName: map['jobsiteName'] ?? '',
      jobsiteAddress: map['jobsiteAddress'] ?? '',
      applicants: List<ApplicantDto>.from(
        map['applicants']?.map((x) => ApplicantDto.fromMap(x)) ?? [],
      ),
    );
  }

  @override
  String toString() {
    return 'JobsiteApplicantsDto(jobsiteId: $jobsiteId, jobsiteName: $jobsiteName, jobsiteAddress: $jobsiteAddress, applicants: $applicants)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JobsiteApplicantsDto &&
        other.jobsiteId == jobsiteId &&
        other.jobsiteName == jobsiteName &&
        other.jobsiteAddress == jobsiteAddress &&
        other.applicants == applicants;
  }

  @override
  int get hashCode {
    return jobsiteId.hashCode ^
        jobsiteName.hashCode ^
        jobsiteAddress.hashCode ^
        applicants.hashCode;
  }
}
