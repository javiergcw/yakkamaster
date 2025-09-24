/// DTO para la respuesta de crear perfil de trabajador
class DtoReceiveCreateLabourProfile {
  final DtoReceiveLabourProfile profile;
  final String message;

  DtoReceiveCreateLabourProfile({
    required this.profile,
    required this.message,
  });

  /// Constructor desde JSON
  factory DtoReceiveCreateLabourProfile.fromJson(Map<String, dynamic> json) {
    return DtoReceiveCreateLabourProfile(
      profile: DtoReceiveLabourProfile.fromJson(json['profile'] as Map<String, dynamic>),
      message: json['message'] as String,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'profile': profile.toJson(),
      'message': message,
    };
  }

  /// Obtiene el ID del perfil
  String get profileId => profile.id;

  /// Obtiene el ID del usuario
  String get userId => profile.userId;

  /// Obtiene el nombre completo
  String get fullName => '${profile.firstName} ${profile.lastName}';

  /// Obtiene la fecha de creación formateada
  String get formattedCreatedAt {
    final date = DateTime.parse(profile.createdAt);
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Obtiene la fecha de actualización formateada
  String get formattedUpdatedAt {
    final date = DateTime.parse(profile.updatedAt);
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// DTO para el perfil de trabajador en la respuesta
class DtoReceiveLabourProfile {
  final String id;
  final String userId;
  final String firstName;
  final String lastName;
  final String location;
  final String bio;
  final String? avatarUrl;
  final String createdAt;
  final String updatedAt;

  DtoReceiveLabourProfile({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.location,
    required this.bio,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Constructor desde JSON
  factory DtoReceiveLabourProfile.fromJson(Map<String, dynamic> json) {
    return DtoReceiveLabourProfile(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
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
      'first_name': firstName,
      'last_name': lastName,
      'location': location,
      'bio': bio,
      'avatar_url': avatarUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Obtiene el nombre completo
  String get fullName => '$firstName $lastName';

  /// Verifica si tiene avatar
  bool get hasAvatar => avatarUrl != null && avatarUrl!.isNotEmpty;

  /// Obtiene la fecha de creación como DateTime
  DateTime get createdAtDateTime => DateTime.parse(createdAt);

  /// Obtiene la fecha de actualización como DateTime
  DateTime get updatedAtDateTime => DateTime.parse(updatedAt);

  /// Obtiene la fecha de creación formateada
  String get formattedCreatedAt {
    final date = createdAtDateTime;
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Obtiene la fecha de actualización formateada
  String get formattedUpdatedAt {
    final date = updatedAtDateTime;
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Obtiene la fecha de creación con hora
  String get formattedCreatedAtWithTime {
    final date = createdAtDateTime;
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  /// Obtiene la fecha de actualización con hora
  String get formattedUpdatedAtWithTime {
    final date = updatedAtDateTime;
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
