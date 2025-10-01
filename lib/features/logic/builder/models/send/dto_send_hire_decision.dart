/// DTO para enviar decisión de contratación (hire/decline)
class DtoSendHireDecision {
  final String applicationId;
  final bool hired;
  final String? startDate;
  final String? endDate;
  final String? reason;

  DtoSendHireDecision({
    required this.applicationId,
    required this.hired,
    this.startDate,
    this.endDate,
    this.reason,
  });

  /// Constructor para contratar
  factory DtoSendHireDecision.hire({
    required String applicationId,
    String? startDate,
    String? endDate,
    String? reason,
  }) {
    return DtoSendHireDecision(
      applicationId: applicationId,
      hired: true,
      startDate: startDate,
      endDate: endDate,
      reason: reason,
    );
  }

  /// Constructor para rechazar
  factory DtoSendHireDecision.decline({
    required String applicationId,
    String? reason,
  }) {
    return DtoSendHireDecision(
      applicationId: applicationId,
      hired: false,
      reason: reason,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    final json = {
      'application_id': applicationId,
      'hired': hired,
    };

    if (startDate != null) {
      json['start_date'] = startDate!;
    }
    if (endDate != null) {
      json['end_date'] = endDate!;
    }
    if (reason != null) {
      json['reason'] = reason!;
    }

    return json;
  }

  /// Valida los datos antes de enviar
  bool get isValid {
    if (applicationId.trim().isEmpty) return false;
    if (hired && startDate != null && endDate != null) {
      // Validar que startDate sea anterior a endDate
      try {
        final start = DateTime.parse(startDate!);
        final end = DateTime.parse(endDate!);
        return start.isBefore(end);
      } catch (e) {
        return false;
      }
    }
    return true;
  }

  /// Obtiene los campos faltantes
  List<String> get missingFields {
    final missing = <String>[];
    if (applicationId.trim().isEmpty) missing.add('application_id');
    return missing;
  }

  /// Obtiene los campos con errores de validación
  List<String> get validationErrors {
    final errors = <String>[];
    
    if (applicationId.trim().isEmpty) {
      errors.add('Application ID is required');
    }
    
    if (hired && startDate != null && endDate != null) {
      try {
        final start = DateTime.parse(startDate!);
        final end = DateTime.parse(endDate!);
        if (start.isAfter(end)) {
          errors.add('Start date must be before end date');
        }
      } catch (e) {
        errors.add('Invalid date format');
      }
    }
    
    return errors;
  }

  @override
  String toString() {
    return 'DtoSendHireDecision(applicationId: $applicationId, hired: $hired, startDate: $startDate, endDate: $endDate)';
  }
}
