/// DTO para recibir el perfil del labour
class DtoReceiveLabourProfile {
  final String id;
  final String? location;
  final String? bio;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DtoReceiveLabourProfile({
    required this.id,
    this.location,
    this.bio,
    this.createdAt,
    this.updatedAt,
  });

  /// Constructor desde JSON
  factory DtoReceiveLabourProfile.fromJson(Map<String, dynamic> json) {
    return DtoReceiveLabourProfile(
      id: json['id']?.toString() ?? '',
      location: json['location']?.toString(),
      bio: json['bio']?.toString(),
      createdAt: json['created_at'] != null && json['created_at'].toString().isNotEmpty
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null && json['updated_at'].toString().isNotEmpty
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location': location,
      'bio': bio,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Verifica si el perfil está vacío (sin datos)
  bool get isEmpty {
    return (id.isEmpty || id == '') &&
           (location == null || location!.isEmpty) &&
           (bio == null || bio!.isEmpty);
  }

  /// Verifica si tiene información básica
  bool get hasBasicInfo {
    return (location != null && location!.isNotEmpty) ||
           (bio != null && bio!.isNotEmpty);
  }

  /// Obtiene la descripción corta
  String get shortBio {
    if (bio == null || bio!.isEmpty) return '';
    if (bio!.length <= 100) return bio!;
    return '${bio!.substring(0, 97)}...';
  }

  @override
  String toString() {
    return 'DtoReceiveLabourProfile(id: $id, hasBasicInfo: $hasBasicInfo)';
  }
}
