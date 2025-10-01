/// DTO para recibir el perfil del builder
class DtoReceiveBuilderProfile {
  final String id;
  final String? companyName;
  final String? displayName;
  final String? location;
  final String? bio;
  final DateTime createdAt;
  final DateTime updatedAt;

  DtoReceiveBuilderProfile({
    required this.id,
    this.companyName,
    this.displayName,
    this.location,
    this.bio,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Constructor desde JSON
  factory DtoReceiveBuilderProfile.fromJson(Map<String, dynamic> json) {
    return DtoReceiveBuilderProfile(
      id: json['id']?.toString() ?? '',
      companyName: json['company_name']?.toString(),
      displayName: json['display_name']?.toString(),
      location: json['location']?.toString(),
      bio: json['bio']?.toString(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_name': companyName,
      'display_name': displayName,
      'location': location,
      'bio': bio,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Obtiene el nombre para mostrar
  String get displayNameOrCompany {
    if (displayName != null && displayName!.isNotEmpty) {
      return displayName!;
    } else if (companyName != null && companyName!.isNotEmpty) {
      return companyName!;
    }
    return 'Builder';
  }

  /// Verifica si tiene información completa
  bool get isComplete {
    return (companyName != null && companyName!.isNotEmpty) ||
           (displayName != null && displayName!.isNotEmpty);
  }

  /// Obtiene la descripción corta
  String get shortBio {
    if (bio == null || bio!.isEmpty) return '';
    if (bio!.length <= 100) return bio!;
    return '${bio!.substring(0, 97)}...';
  }

  @override
  String toString() {
    return 'DtoReceiveBuilderProfile(id: $id, displayName: $displayNameOrCompany)';
  }
}
