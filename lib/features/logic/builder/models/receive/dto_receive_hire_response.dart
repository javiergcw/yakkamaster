/// DTO para recibir respuesta de contratación exitosa
class DtoReceiveHireResponse {
  final String applicationId;
  final bool hired;
  final String? assignmentId;
  final String message;

  DtoReceiveHireResponse({
    required this.applicationId,
    required this.hired,
    this.assignmentId,
    required this.message,
  });

  /// Constructor desde JSON
  factory DtoReceiveHireResponse.fromJson(Map<String, dynamic> json) {
    return DtoReceiveHireResponse(
      applicationId: json['application_id']?.toString() ?? '',
      hired: json['hired'] == true,
      assignmentId: json['assignment_id']?.toString(),
      message: json['message']?.toString() ?? '',
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'application_id': applicationId,
      'hired': hired,
      'assignment_id': assignmentId,
      'message': message,
    };
  }

  /// Verifica si la contratación fue exitosa
  bool get isHired => hired;

  /// Verifica si tiene assignment ID (solo para contrataciones exitosas)
  bool get hasAssignmentId => assignmentId != null && assignmentId!.isNotEmpty;

  @override
  String toString() {
    return 'DtoReceiveHireResponse(applicationId: $applicationId, hired: $hired, assignmentId: $assignmentId)';
  }
}
