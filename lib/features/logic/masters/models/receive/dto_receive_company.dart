/// DTO para la respuesta del endpoint /api/v1/companies
class DtoReceiveCompany {
  final String id;
  final String name;
  final String description;
  final String website;
  final String createdAt;
  final String updatedAt;

  DtoReceiveCompany({
    required this.id,
    required this.name,
    required this.description,
    required this.website,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Constructor desde JSON
  factory DtoReceiveCompany.fromJson(Map<String, dynamic> json) {
    return DtoReceiveCompany(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      website: json['website'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'website': website,
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
    return 'DtoReceiveCompany(id: $id, name: $name, description: $description, website: $website, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
