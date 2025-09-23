/// DTO para una habilidad en el perfil de trabajador
class DtoSendLabourSkill {
  final String categoryId;
  final String subcategoryId;
  final String experienceLevelId;
  final double yearsExperience;
  final bool isPrimary;

  DtoSendLabourSkill({
    required this.categoryId,
    required this.subcategoryId,
    required this.experienceLevelId,
    required this.yearsExperience,
    required this.isPrimary,
  });

  /// Constructor desde JSON
  factory DtoSendLabourSkill.fromJson(Map<String, dynamic> json) {
    return DtoSendLabourSkill(
      categoryId: json['category_id'] as String,
      subcategoryId: json['subcategory_id'] as String,
      experienceLevelId: json['experience_level_id'] as String,
      yearsExperience: (json['years_experience'] as num).toDouble(),
      isPrimary: json['is_primary'] as bool,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'subcategory_id': subcategoryId,
      'experience_level_id': experienceLevelId,
      'years_experience': yearsExperience,
      'is_primary': isPrimary,
    };
  }

  /// Obtiene los años de experiencia como entero
  int get yearsExperienceAsInt => yearsExperience.round();

  /// Obtiene los meses de experiencia adicionales
  int get additionalMonths {
    final months = ((yearsExperience - yearsExperienceAsInt) * 12).round();
    return months;
  }

  /// Formatea los años de experiencia como texto
  String get formattedExperience {
    if (yearsExperienceAsInt == 0) {
      return 'Menos de 1 año';
    } else if (additionalMonths == 0) {
      return '$yearsExperienceAsInt ${yearsExperienceAsInt == 1 ? 'año' : 'años'}';
    } else {
      return '$yearsExperienceAsInt ${yearsExperienceAsInt == 1 ? 'año' : 'años'} y $additionalMonths ${additionalMonths == 1 ? 'mes' : 'meses'}';
    }
  }

  @override
  String toString() {
    return 'DtoSendLabourSkill(categoryId: $categoryId, subcategoryId: $subcategoryId, experienceLevelId: $experienceLevelId, yearsExperience: $yearsExperience, isPrimary: $isPrimary)';
  }
}

/// DTO para una licencia en el perfil de trabajador
class DtoSendLabourLicense {
  final String licenseId;
  final String photoUrl;
  final String issuedAt;
  final String expiresAt;

  DtoSendLabourLicense({
    required this.licenseId,
    required this.photoUrl,
    required this.issuedAt,
    required this.expiresAt,
  });

  /// Constructor desde JSON
  factory DtoSendLabourLicense.fromJson(Map<String, dynamic> json) {
    return DtoSendLabourLicense(
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
    return 'DtoSendLabourLicense(licenseId: $licenseId, photoUrl: $photoUrl, issuedAt: $issuedAt, expiresAt: $expiresAt)';
  }
}

/// DTO para el request del endpoint /api/v1/profiles/labour
class DtoSendLabourProfile {
  final String firstName;
  final String lastName;
  final String location;
  final String bio;
  final String avatarUrl;
  final String phone;
  final List<DtoSendLabourSkill> skills;
  final List<DtoSendLabourLicense> licenses;

  DtoSendLabourProfile({
    required this.firstName,
    required this.lastName,
    required this.location,
    required this.bio,
    required this.avatarUrl,
    required this.phone,
    required this.skills,
    required this.licenses,
  });

  /// Constructor desde JSON
  factory DtoSendLabourProfile.fromJson(Map<String, dynamic> json) {
    return DtoSendLabourProfile(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      location: json['location'] as String,
      bio: json['bio'] as String,
      avatarUrl: json['avatar_url'] as String,
      phone: json['phone'] as String,
      skills: (json['skills'] as List<dynamic>)
          .map((item) => DtoSendLabourSkill.fromJson(item as Map<String, dynamic>))
          .toList(),
      licenses: (json['licenses'] as List<dynamic>)
          .map((item) => DtoSendLabourLicense.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'location': location,
      'bio': bio,
      'avatar_url': avatarUrl,
      'phone': phone,
      'skills': skills.map((skill) => skill.toJson()).toList(),
      'licenses': licenses.map((license) => license.toJson()).toList(),
    };
  }

  /// Obtiene el nombre completo del trabajador
  String get fullName => '$firstName $lastName';

  /// Obtiene el número de habilidades
  int get skillsCount => skills.length;

  /// Obtiene el número de licencias
  int get licensesCount => licenses.length;

  /// Obtiene las habilidades principales
  List<DtoSendLabourSkill> get primarySkills {
    return skills.where((skill) => skill.isPrimary).toList();
  }

  /// Obtiene las habilidades secundarias
  List<DtoSendLabourSkill> get secondarySkills {
    return skills.where((skill) => !skill.isPrimary).toList();
  }

  /// Obtiene las licencias expiradas
  List<DtoSendLabourLicense> get expiredLicenses {
    return licenses.where((license) => license.isExpired).toList();
  }

  /// Obtiene las licencias que expiran pronto
  List<DtoSendLabourLicense> get expiringSoonLicenses {
    return licenses.where((license) => license.isExpiringSoon).toList();
  }

  /// Verifica si tiene licencias válidas
  bool get hasValidLicenses {
    return licenses.any((license) => !license.isExpired);
  }

  /// Obtiene el total de años de experiencia
  double get totalYearsExperience {
    return skills.fold(0.0, (sum, skill) => sum + skill.yearsExperience);
  }

  /// Obtiene el promedio de años de experiencia
  double get averageYearsExperience {
    if (skills.isEmpty) return 0.0;
    return totalYearsExperience / skills.length;
  }

  @override
  String toString() {
    return 'DtoSendLabourProfile(fullName: $fullName, location: $location, phone: $phone, skillsCount: $skillsCount, licensesCount: $licensesCount)';
  }
}
