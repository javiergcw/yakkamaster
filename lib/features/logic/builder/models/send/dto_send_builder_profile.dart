/// DTO para una licencia en el perfil de constructor
class DtoSendBuilderLicense {
  final String licenseId;
  final String photoUrl;
  final String issuedAt;
  final String expiresAt;

  DtoSendBuilderLicense({
    required this.licenseId,
    required this.photoUrl,
    required this.issuedAt,
    required this.expiresAt,
  });

  /// Constructor desde JSON
  factory DtoSendBuilderLicense.fromJson(Map<String, dynamic> json) {
    return DtoSendBuilderLicense(
      licenseId: json['license_id'] as String,
      photoUrl: json['photo_url'] as String,
      issuedAt: json['issued_at'] as String,
      expiresAt: json['expires_at'] as String,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'license_id': licenseId,
      'photo_url': photoUrl,
      'issued_at': issuedAt,
      'expires_at': expiresAt,
    };
  }

  /// Obtiene la fecha de emisión como DateTime
  DateTime get issuedAtAsDateTime {
    try {
      return DateTime.parse(issuedAt);
    } catch (e) {
      return DateTime.now();
    }
  }

  /// Obtiene la fecha de expiración como DateTime
  DateTime get expiresAtAsDateTime {
    try {
      return DateTime.parse(expiresAt);
    } catch (e) {
      return DateTime.now();
    }
  }

  /// Verifica si la licencia está expirada
  bool get isExpired => DateTime.now().isAfter(expiresAtAsDateTime);

  /// Verifica si la licencia expira pronto (en los próximos 30 días)
  bool get isExpiringSoon {
    final now = DateTime.now();
    final expiresAt = expiresAtAsDateTime;
    final timeUntilExpiry = expiresAt.difference(now);
    return timeUntilExpiry.inDays <= 30 && !isExpired;
  }

  @override
  String toString() {
    return 'DtoSendBuilderLicense(licenseId: $licenseId, photoUrl: $photoUrl, issuedAt: $issuedAt, expiresAt: $expiresAt)';
  }
}

/// DTO para el request del endpoint /api/v1/profiles/builder
class DtoSendBuilderProfile {
  final String companyName;
  final String displayName;
  final String location;
  final String bio;
  final String avatarUrl;
  final String phone;
  final List<DtoSendBuilderLicense> licenses;

  DtoSendBuilderProfile({
    required this.companyName,
    required this.displayName,
    required this.location,
    required this.bio,
    required this.avatarUrl,
    required this.phone,
    required this.licenses,
  });

  /// Constructor desde JSON
  factory DtoSendBuilderProfile.fromJson(Map<String, dynamic> json) {
    return DtoSendBuilderProfile(
      companyName: json['company_name'] as String,
      displayName: json['display_name'] as String,
      location: json['location'] as String,
      bio: json['bio'] as String,
      avatarUrl: json['avatar_url'] as String,
      phone: json['phone'] as String,
      licenses: (json['licenses'] as List<dynamic>)
          .map((item) => DtoSendBuilderLicense.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'company_name': companyName,
      'display_name': displayName,
      'location': location,
      'bio': bio,
      'avatar_url': avatarUrl,
      'phone': phone,
      'licenses': licenses.map((license) => license.toJson()).toList(),
    };
  }

  /// Obtiene el número de licencias
  int get licensesCount => licenses.length;

  /// Obtiene las licencias expiradas
  List<DtoSendBuilderLicense> get expiredLicenses {
    return licenses.where((license) => license.isExpired).toList();
  }

  /// Obtiene las licencias que expiran pronto
  List<DtoSendBuilderLicense> get expiringSoonLicenses {
    return licenses.where((license) => license.isExpiringSoon).toList();
  }

  /// Verifica si tiene licencias válidas
  bool get hasValidLicenses {
    return licenses.any((license) => !license.isExpired);
  }

  @override
  String toString() {
    return 'DtoSendBuilderProfile(companyName: $companyName, displayName: $displayName, location: $location, phone: $phone, licensesCount: $licensesCount)';
  }
}
