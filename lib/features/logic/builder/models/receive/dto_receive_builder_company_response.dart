/// DTO para la respuesta del endpoint POST /api/v1/builder/companies
class DtoReceiveBuilderCompanyResponse {
  final DtoReceiveBuilderProfileData builderProfile;
  final String message;

  DtoReceiveBuilderCompanyResponse({
    required this.builderProfile,
    required this.message,
  });

  /// Constructor desde JSON
  factory DtoReceiveBuilderCompanyResponse.fromJson(Map<String, dynamic> json) {
    return DtoReceiveBuilderCompanyResponse(
      builderProfile: DtoReceiveBuilderProfileData.fromJson(json['builder_profile'] as Map<String, dynamic>),
      message: json['message'] as String,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'builder_profile': builderProfile.toJson(),
      'message': message,
    };
  }

  /// Obtiene el ID del builder profile
  String get builderProfileId => builderProfile.id;

  /// Obtiene el ID de la empresa asignada
  String get companyId => builderProfile.companyId;

  /// Obtiene el nombre de display del builder
  String get displayName => builderProfile.displayName;

  @override
  String toString() {
    return 'DtoReceiveBuilderCompanyResponse(builderProfile: ${builderProfile.displayName}, message: $message)';
  }
}

/// DTO para los datos del builder profile en la respuesta
class DtoReceiveBuilderProfileData {
  final String id;
  final String userId;
  final String companyId;
  final String displayName;
  final String location;
  final String bio;
  final String? avatarUrl;
  final String createdAt;
  final String updatedAt;

  DtoReceiveBuilderProfileData({
    required this.id,
    required this.userId,
    required this.companyId,
    required this.displayName,
    required this.location,
    required this.bio,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Constructor desde JSON
  factory DtoReceiveBuilderProfileData.fromJson(Map<String, dynamic> json) {
    return DtoReceiveBuilderProfileData(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      companyId: json['company_id'] as String,
      displayName: json['display_name'] as String,
      location: json['location'] as String,
      bio: json['bio'] as String,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'company_id': companyId,
      'display_name': displayName,
      'location': location,
      'bio': bio,
      'avatar_url': avatarUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

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

  @override
  String toString() {
    return 'DtoReceiveBuilderProfileData(id: $id, displayName: $displayName, companyId: $companyId)';
  }
}
