import 'dto_receive_job_application.dart';

/// DTO para la respuesta del endpoint GET /api/v1/labour/applicants
class DtoReceiveApplicationsResponse {
  final List<DtoReceiveJobApplication>? applications;
  final int total;
  final String message;

  DtoReceiveApplicationsResponse({
    this.applications,
    required this.total,
    required this.message,
  });

  /// Constructor desde JSON
  factory DtoReceiveApplicationsResponse.fromJson(Map<String, dynamic> json) {
    return DtoReceiveApplicationsResponse(
      applications: (json['applications'] as List<dynamic>?)
          ?.map((e) => DtoReceiveJobApplication.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      message: json['message'] as String,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'applications': applications?.map((e) => e.toJson()).toList(),
      'total': total,
      'message': message,
    };
  }

  /// Retorna true si hay aplicaciones en la lista
  bool get hasApplications => applications != null && applications!.isNotEmpty;

  /// Retorna el número de aplicaciones
  int get applicationsCount => applications?.length ?? 0;

  /// Obtiene aplicaciones por estado
  List<DtoReceiveJobApplication> getApplicationsByStatus(String status) {
    if (applications == null) return [];
    return applications!.where((app) => app.status == status).toList();
  }

  /// Obtiene aplicaciones aplicadas
  List<DtoReceiveJobApplication> get appliedApplications => getApplicationsByStatus('APPLIED');

  /// Obtiene aplicaciones aceptadas
  List<DtoReceiveJobApplication> get acceptedApplications => getApplicationsByStatus('ACCEPTED');

  /// Obtiene aplicaciones rechazadas
  List<DtoReceiveJobApplication> get rejectedApplications => getApplicationsByStatus('REJECTED');

  @override
  String toString() {
    return 'DtoReceiveApplicationsResponse(applications: ${applicationsCount}, total: $total, message: $message)';
  }
}
