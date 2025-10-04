import 'dto_receive_labour_job_detail.dart';

/// DTO para la aplicación en la respuesta de job detail
class DtoReceiveApplication {
  final String id;
  final String status;
  final String createdAt;
  final String updatedAt;

  DtoReceiveApplication({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DtoReceiveApplication.fromJson(Map<String, dynamic> json) {
    return DtoReceiveApplication(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class DtoReceiveJobDetailResponse {
  final DtoReceiveLabourJobDetail job;
  final DtoReceiveApplication? application;
  final String message;

  DtoReceiveJobDetailResponse({
    required this.job,
    this.application,
    required this.message,
  });

  factory DtoReceiveJobDetailResponse.fromJson(Map<String, dynamic> json) {
    return DtoReceiveJobDetailResponse(
      job: DtoReceiveLabourJobDetail.fromJson(json['job']),
      application: json['application'] != null 
          ? DtoReceiveApplication.fromJson(json['application'])
          : null,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job': job.toJson(),
      'application': application?.toJson(),
      'message': message,
    };
  }

  /// Verifica si el usuario ya aplicó al trabajo
  bool get hasApplied => application != null;

  /// Obtiene el estado de la aplicación si existe
  String? get applicationStatus => application?.status;
}
