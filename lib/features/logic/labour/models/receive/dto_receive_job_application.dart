/// DTO para recibir información de una aplicación de trabajo
class DtoReceiveJobApplication {
  final String applicationId;
  final String jobId;
  final String status;
  final String? coverLetter;
  final double? expectedRate;
  final String? resumeUrl;
  final String appliedAt;
  final DtoReceiveJobDetails job;

  DtoReceiveJobApplication({
    required this.applicationId,
    required this.jobId,
    required this.status,
    this.coverLetter,
    this.expectedRate,
    this.resumeUrl,
    required this.appliedAt,
    required this.job,
  });

  /// Constructor desde JSON
  factory DtoReceiveJobApplication.fromJson(Map<String, dynamic> json) {
    return DtoReceiveJobApplication(
      applicationId: json['application_id']?.toString() ?? '',
      jobId: json['job_id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      coverLetter: json['cover_letter']?.toString(),
      expectedRate: json['expected_rate']?.toDouble(),
      resumeUrl: json['resume_url']?.toString(),
      appliedAt: json['applied_at']?.toString() ?? '',
      job: DtoReceiveJobDetails.fromJson(json['job'] ?? {}),
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'application_id': applicationId,
      'job_id': jobId,
      'status': status,
      'cover_letter': coverLetter,
      'expected_rate': expectedRate,
      'resume_url': resumeUrl,
      'applied_at': appliedAt,
      'job': job.toJson(),
    };
  }

  /// Obtiene la fecha de aplicación como DateTime
  DateTime get appliedAtAsDateTime {
    try {
      return DateTime.parse(appliedAt);
    } catch (e) {
      return DateTime.now();
    }
  }

  /// Verifica si la aplicación está en estado APPLIED
  bool get isApplied => status == 'APPLIED';

  /// Verifica si la aplicación está en estado ACCEPTED
  bool get isAccepted => status == 'ACCEPTED';

  /// Verifica si la aplicación está en estado REJECTED
  bool get isRejected => status == 'REJECTED';

  @override
  String toString() {
    return 'DtoReceiveJobApplication(applicationId: $applicationId, jobId: $jobId, status: $status)';
  }
}

/// DTO para los detalles del trabajo en la aplicación
class DtoReceiveJobDetails {
  final String id;
  final String description;
  final String startDate;
  final String endDate;
  final double wageHourlyRate;
  final String visibility;
  final String createdAt;
  final DtoReceiveBuilderProfile builderProfile;
  final DtoReceiveJobsite jobsite;
  final DtoReceiveJobType jobType;

  DtoReceiveJobDetails({
    required this.id,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.wageHourlyRate,
    required this.visibility,
    required this.createdAt,
    required this.builderProfile,
    required this.jobsite,
    required this.jobType,
  });

  /// Constructor desde JSON
  factory DtoReceiveJobDetails.fromJson(Map<String, dynamic> json) {
    return DtoReceiveJobDetails(
      id: json['id'] as String,
      description: json['description'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      wageHourlyRate: (json['wage_hourly_rate'] as num).toDouble(),
      visibility: json['visibility'] as String,
      createdAt: json['created_at'] as String,
      builderProfile: DtoReceiveBuilderProfile.fromJson(json['builder_profile'] as Map<String, dynamic>),
      jobsite: DtoReceiveJobsite.fromJson(json['jobsite'] as Map<String, dynamic>),
      jobType: DtoReceiveJobType.fromJson(json['job_type'] as Map<String, dynamic>),
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'wage_hourly_rate': wageHourlyRate,
      'visibility': visibility,
      'created_at': createdAt,
      'builder_profile': builderProfile.toJson(),
      'jobsite': jobsite.toJson(),
      'job_type': jobType.toJson(),
    };
  }

  /// Obtiene la fecha de inicio como DateTime
  DateTime get startDateAsDateTime {
    try {
      return DateTime.parse(startDate);
    } catch (e) {
      return DateTime.now();
    }
  }

  /// Obtiene la fecha de fin como DateTime
  DateTime get endDateAsDateTime {
    try {
      return DateTime.parse(endDate);
    } catch (e) {
      return DateTime.now();
    }
  }

  @override
  String toString() {
    return 'DtoReceiveJobDetails(id: $id, description: $description, wageHourlyRate: $wageHourlyRate)';
  }
}

/// DTO para el perfil del builder en la aplicación
class DtoReceiveBuilderProfile {
  final String id;
  final String? companyName;
  final String displayName;
  final String? location;

  DtoReceiveBuilderProfile({
    required this.id,
    this.companyName,
    required this.displayName,
    this.location,
  });

  /// Constructor desde JSON
  factory DtoReceiveBuilderProfile.fromJson(Map<String, dynamic> json) {
    return DtoReceiveBuilderProfile(
      id: json['id'] as String,
      companyName: json['company_name'] as String?,
      displayName: json['display_name'] as String,
      location: json['location'] as String?,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_name': companyName,
      'display_name': displayName,
      'location': location,
    };
  }

  @override
  String toString() {
    return 'DtoReceiveBuilderProfile(id: $id, displayName: $displayName)';
  }
}

/// DTO para el jobsite en la aplicación
class DtoReceiveJobsite {
  final String id;
  final String name;
  final String address;
  final String? city;
  final String? suburb;
  final String? description;

  DtoReceiveJobsite({
    required this.id,
    required this.name,
    required this.address,
    this.city,
    this.suburb,
    this.description,
  });

  /// Constructor desde JSON
  factory DtoReceiveJobsite.fromJson(Map<String, dynamic> json) {
    return DtoReceiveJobsite(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      city: json['city'] as String?,
      suburb: json['suburb'] as String?,
      description: json['description'] as String?,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'suburb': suburb,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'DtoReceiveJobsite(id: $id, name: $name, address: $address)';
  }
}

/// DTO para el tipo de trabajo en la aplicación
class DtoReceiveJobType {
  final String id;
  final String name;
  final String description;

  DtoReceiveJobType({
    required this.id,
    required this.name,
    required this.description,
  });

  /// Constructor desde JSON
  factory DtoReceiveJobType.fromJson(Map<String, dynamic> json) {
    return DtoReceiveJobType(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'DtoReceiveJobType(id: $id, name: $name)';
  }
}