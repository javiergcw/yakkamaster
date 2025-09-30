/// DTO para recibir la respuesta de una aplicación a un trabajo
class DtoReceiveJobApplicationResponse {
  final String applicationId;
  final String jobId;
  final String status;
  final String message;
  final DateTime createdAt;

  DtoReceiveJobApplicationResponse({
    required this.applicationId,
    required this.jobId,
    required this.status,
    required this.message,
    required this.createdAt,
  });

  /// Constructor desde JSON
  factory DtoReceiveJobApplicationResponse.fromJson(Map<String, dynamic> json) {
    return DtoReceiveJobApplicationResponse(
      applicationId: json['application_id']?.toString() ?? '',
      jobId: json['job_id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'application_id': applicationId,
      'job_id': jobId,
      'status': status,
      'message': message,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'DtoReceiveJobApplicationResponse(applicationId: $applicationId, jobId: $jobId, status: $status, message: $message)';
  }
}
