/// DTO para recibir respuesta de rechazo
class DtoReceiveDeclineResponse {
  final String applicationId;
  final bool hired;
  final String message;

  DtoReceiveDeclineResponse({
    required this.applicationId,
    required this.hired,
    required this.message,
  });

  /// Constructor desde JSON
  factory DtoReceiveDeclineResponse.fromJson(Map<String, dynamic> json) {
    return DtoReceiveDeclineResponse(
      applicationId: json['application_id']?.toString() ?? '',
      hired: json['hired'] == true,
      message: json['message']?.toString() ?? '',
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'application_id': applicationId,
      'hired': hired,
      'message': message,
    };
  }

  /// Verifica si fue rechazado
  bool get isDeclined => !hired;

  @override
  String toString() {
    return 'DtoReceiveDeclineResponse(applicationId: $applicationId, hired: $hired)';
  }
}
