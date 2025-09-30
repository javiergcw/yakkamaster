import 'dto_receive_job.dart';

/// DTO para la respuesta de actualización de visibilidad de job
class DtoReceiveJobVisibilityUpdate {
  final DtoReceiveJob job;
  final String message;

  DtoReceiveJobVisibilityUpdate({
    required this.job,
    required this.message,
  });

  /// Constructor desde JSON
  factory DtoReceiveJobVisibilityUpdate.fromJson(Map<String, dynamic> json) {
    return DtoReceiveJobVisibilityUpdate(
      job: DtoReceiveJob.fromJson(json['job'] as Map<String, dynamic>),
      message: json['message'] as String? ?? '',
    );
  }

  /// Crea una copia con nuevos valores
  DtoReceiveJobVisibilityUpdate copyWith({
    DtoReceiveJob? job,
    String? message,
  }) {
    return DtoReceiveJobVisibilityUpdate(
      job: job ?? this.job,
      message: message ?? this.message,
    );
  }

  /// Verifica si la actualización fue exitosa
  bool get isSuccess => message.toLowerCase().contains('success');

  /// Obtiene el ID del job actualizado
  String get jobId => job.id;

  /// Obtiene la nueva visibilidad del job
  String get visibility => job.visibility;

  /// Obtiene si el job es público
  bool get isPublic => job.visibility == 'PUBLIC';

  /// Obtiene si el job es privado
  bool get isPrivate => job.visibility == 'PRIVATE';

  @override
  String toString() {
    return 'DtoReceiveJobVisibilityUpdate(jobId: ${job.id}, visibility: ${job.visibility}, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DtoReceiveJobVisibilityUpdate &&
        other.job == job &&
        other.message == message;
  }

  @override
  int get hashCode {
    return job.hashCode ^ message.hashCode;
  }
}
