/// DTO para una subcategoría de habilidad simple
class DtoReceiveSkillSubcategorySimple {
  final String id;
  final String name;

  DtoReceiveSkillSubcategorySimple({
    required this.id,
    required this.name,
  });

  /// Constructor desde JSON
  factory DtoReceiveSkillSubcategorySimple.fromJson(Map<String, dynamic> json) {
    return DtoReceiveSkillSubcategorySimple(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'DtoReceiveSkillSubcategorySimple(id: $id, name: $name)';
  }
}

/// DTO para la respuesta del endpoint /api/v1/skills
class DtoReceiveSkill {
  final String id;
  final String name;
  final String description;
  final String createdAt;
  final String updatedAt;
  final List<DtoReceiveSkillSubcategorySimple> subcategories;

  DtoReceiveSkill({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.subcategories,
  });

  /// Constructor desde JSON
  factory DtoReceiveSkill.fromJson(Map<String, dynamic> json) {
    return DtoReceiveSkill(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      subcategories: (json['subcategories'] as List<dynamic>)
          .map((item) => DtoReceiveSkillSubcategorySimple.fromJson(item as Map<String, dynamic>))
          .toList(),
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
      'subcategories': subcategories.map((item) => item.toJson()).toList(),
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

  /// Obtiene el número de subcategorías
  int get subcategoriesCount => subcategories.length;

  @override
  String toString() {
    return 'DtoReceiveSkill(id: $id, name: $name, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, subcategories: ${subcategories.length} items)';
  }
}
