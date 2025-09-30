class DtoReceiveJobApplication {
  final String id;
  final String status;
  final String coverLetter;
  final String resumeUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  DtoReceiveJobApplication({
    required this.id,
    required this.status,
    required this.coverLetter,
    required this.resumeUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DtoReceiveJobApplication.fromJson(Map<String, dynamic> json) {
    return DtoReceiveJobApplication(
      id: json['id'] ?? '',
      status: json['status'] ?? '',
      coverLetter: json['cover_letter'] ?? '',
      resumeUrl: json['resume_url'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'cover_letter': coverLetter,
      'resume_url': resumeUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Verifica si la aplicación está en estado APPLIED
  bool get isApplied => status == 'APPLIED';

  /// Verifica si la aplicación está en estado APPROVED
  bool get isApproved => status == 'APPROVED';

  /// Verifica si la aplicación está en estado REJECTED
  bool get isRejected => status == 'REJECTED';

  /// Verifica si la aplicación está en estado PENDING
  bool get isPending => status == 'PENDING';
}
