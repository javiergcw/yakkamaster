import 'dto_receive_labour_job_detail.dart';
import 'dto_receive_job_application.dart';

class DtoReceiveJobDetailResponse {
  final DtoReceiveLabourJobDetail job;
  final DtoReceiveJobApplication? application;
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
          ? DtoReceiveJobApplication.fromJson(json['application'])
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
