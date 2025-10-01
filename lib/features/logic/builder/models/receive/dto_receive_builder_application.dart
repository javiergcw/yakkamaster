import 'dto_receive_builder_labour.dart';

/// DTO para recibir una aplicación en el contexto del builder
class DtoReceiveBuilderApplication {
  final String applicationId;
  final String status;
  final String? coverLetter;
  final double? expectedRate;
  final String? resumeUrl;
  final DateTime appliedAt;
  final DtoReceiveBuilderLabour labour;

  DtoReceiveBuilderApplication({
    required this.applicationId,
    required this.status,
    this.coverLetter,
    this.expectedRate,
    this.resumeUrl,
    required this.appliedAt,
    required this.labour,
  });

  /// Constructor desde JSON
  factory DtoReceiveBuilderApplication.fromJson(Map<String, dynamic> json) {
    return DtoReceiveBuilderApplication(
      applicationId: json['application_id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      coverLetter: json['cover_letter']?.toString(),
      expectedRate: json['expected_rate']?.toDouble(),
      resumeUrl: json['resume_url']?.toString(),
      appliedAt: DateTime.tryParse(json['applied_at']?.toString() ?? '') ?? DateTime.now(),
      labour: DtoReceiveBuilderLabour.fromJson(json['labour'] ?? {}),
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'application_id': applicationId,
      'status': status,
      'cover_letter': coverLetter,
      'expected_rate': expectedRate,
      'resume_url': resumeUrl,
      'applied_at': appliedAt.toIso8601String(),
      'labour': labour.toJson(),
    };
  }

  @override
  String toString() {
    return 'DtoReceiveBuilderApplication(applicationId: $applicationId, status: $status, appliedAt: $appliedAt)';
  }
}
