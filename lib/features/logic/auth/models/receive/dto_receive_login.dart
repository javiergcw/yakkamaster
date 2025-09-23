/// DTO para el usuario en la respuesta de login
class DtoReceiveUser {
  final String id;
  final String email;
  final String? phone;
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? photo;
  final String status;
  final String role;
  final String? lastLoginAt;
  final String createdAt;
  final String updatedAt;
  final String? roleChangedAt;

  DtoReceiveUser({
    required this.id,
    required this.email,
    this.phone,
    this.firstName,
    this.lastName,
    this.address,
    this.photo,
    required this.status,
    required this.role,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
    this.roleChangedAt,
  });

  /// Constructor desde JSON
  factory DtoReceiveUser.fromJson(Map<String, dynamic> json) {
    return DtoReceiveUser(
      id: json['id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      address: json['address'] as String?,
      photo: json['photo'] as String?,
      status: json['status'] as String,
      role: json['role'] as String,
      lastLoginAt: json['last_login_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      roleChangedAt: json['role_changed_at'] as String?,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'first_name': firstName,
      'last_name': lastName,
      'address': address,
      'photo': photo,
      'status': status,
      'role': role,
      'last_login_at': lastLoginAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'role_changed_at': roleChangedAt,
    };
  }

  /// Obtiene el nombre completo del usuario
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    }
    return email;
  }

  /// Verifica si el usuario está activo
  bool get isActive => status == 'active';

  /// Obtiene la fecha de creación como DateTime
  DateTime get createdAtAsDateTime {
    try {
      return DateTime.parse(createdAt);
    } catch (e) {
      return DateTime.now();
    }
  }

  /// Obtiene la fecha de actualización como DateTime
  DateTime get updatedAtAsDateTime {
    try {
      return DateTime.parse(updatedAt);
    } catch (e) {
      return DateTime.now();
    }
  }

  /// Obtiene la fecha del último login como DateTime
  DateTime? get lastLoginAtAsDateTime {
    if (lastLoginAt == null) return null;
    try {
      return DateTime.parse(lastLoginAt!);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene la fecha de cambio de rol como DateTime
  DateTime? get roleChangedAtAsDateTime {
    if (roleChangedAt == null) return null;
    try {
      return DateTime.parse(roleChangedAt!);
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    return 'DtoReceiveUser(id: $id, email: $email, status: $status, role: $role, fullName: $fullName)';
  }
}

/// DTO para los perfiles en la respuesta de login
class DtoReceiveProfiles {
  final bool hasBuilderProfile;
  final bool hasLabourProfile;
  final bool hasAnyProfile;

  DtoReceiveProfiles({
    required this.hasBuilderProfile,
    required this.hasLabourProfile,
    required this.hasAnyProfile,
  });

  /// Constructor desde JSON
  factory DtoReceiveProfiles.fromJson(Map<String, dynamic> json) {
    return DtoReceiveProfiles(
      hasBuilderProfile: json['has_builder_profile'] as bool,
      hasLabourProfile: json['has_labour_profile'] as bool,
      hasAnyProfile: json['has_any_profile'] as bool,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'has_builder_profile': hasBuilderProfile,
      'has_labour_profile': hasLabourProfile,
      'has_any_profile': hasAnyProfile,
    };
  }

  @override
  String toString() {
    return 'DtoReceiveProfiles(hasBuilderProfile: $hasBuilderProfile, hasLabourProfile: $hasLabourProfile, hasAnyProfile: $hasAnyProfile)';
  }
}

/// DTO para la respuesta del endpoint /api/v1/auth/login
class DtoReceiveLogin {
  final DtoReceiveUser user;
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final DtoReceiveProfiles profiles;

  DtoReceiveLogin({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.profiles,
  });

  /// Constructor desde JSON
  factory DtoReceiveLogin.fromJson(Map<String, dynamic> json) {
    return DtoReceiveLogin(
      user: DtoReceiveUser.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresIn: json['expires_in'] as int,
      profiles: DtoReceiveProfiles.fromJson(json['profiles'] as Map<String, dynamic>),
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_in': expiresIn,
      'profiles': profiles.toJson(),
    };
  }

  /// Obtiene la fecha de expiración del token
  DateTime get tokenExpiresAt {
    return DateTime.now().add(Duration(seconds: expiresIn));
  }

  /// Verifica si el token está próximo a expirar (en los próximos 5 minutos)
  bool get isTokenExpiringSoon {
    final now = DateTime.now();
    final expiresAt = tokenExpiresAt;
    final timeUntilExpiry = expiresAt.difference(now);
    return timeUntilExpiry.inMinutes <= 5;
  }

  @override
  String toString() {
    return 'DtoReceiveLogin(user: $user, accessToken: [HIDDEN], refreshToken: [HIDDEN], expiresIn: $expiresIn, profiles: $profiles)';
  }
}
