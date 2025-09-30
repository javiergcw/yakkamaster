import 'dto_receive_license.dart';

/// DTO para recibir información de licencia de un job
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_id': jobId,
      'license_id': licenseId,
      'license': license.toJson(),
      'created_at': createdAt,
    };
  }
}
