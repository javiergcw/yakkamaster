/// DTO para la respuesta del endpoint /api/v1/skill-categories
class DtoReceiveSkillCategory {
  final String id;
  final String name;
  final String description;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  DtoReceiveSkillCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  /// Constructor desde JSON
  factory DtoReceiveSkillCategory.fromJson(Map<String, dynamic> json) {
    return DtoReceiveSkillCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      deletedAt: json['deleted_at'] as String?,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  /// Verifica si la categoría de habilidad está activa (no eliminada)
  bool get isActive => deletedAt == null;

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
    return 'DtoReceiveSkillCategory(id: $id, name: $name, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }
}
