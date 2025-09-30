/// DTO para enviar una aplicación a un trabajo
class DtoSendJobApplication {
  final String jobId;
  final String? coverLetter;
  final String? resumeUrl;

  DtoSendJobApplication({
    required this.jobId,
    this.coverLetter,
    this.resumeUrl,
  });

  /// Constructor desde parámetros
  factory DtoSendJobApplication.create({
    required String jobId,
    String? coverLetter,
    String? resumeUrl,
  }) {
    return DtoSendJobApplication(
      jobId: jobId,
      coverLetter: coverLetter,
      resumeUrl: resumeUrl,
    );
  }

  /// Convierte a JSON para enviar al API
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'job_id': jobId,
    };

    // Solo agregar campos opcionales si tienen valor
    if (coverLetter != null && coverLetter!.isNotEmpty) {
      json['cover_letter'] = coverLetter;
    }

    if (resumeUrl != null && resumeUrl!.isNotEmpty) {
      json['resume_url'] = resumeUrl;
    }

    return json;
  }

  @override
  String toString() {
    return 'DtoSendJobApplication(jobId: $jobId, coverLetter: ${coverLetter != null ? 'provided' : 'null'}, resumeUrl: ${resumeUrl != null ? 'provided' : 'null'})';
  }
}
