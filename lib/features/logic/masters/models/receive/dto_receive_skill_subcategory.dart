import 'dto_receive_skill_category.dart';

/// DTO para la respuesta del endpoint /api/v1/skill-subcategories
class DtoReceiveSkillSubcategory {
  final String id;
  final String categoryId;
  final String name;
  final String description;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final DtoReceiveSkillCategory category;

  DtoReceiveSkillSubcategory({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.category,
  });

  /// Constructor desde JSON
  factory DtoReceiveSkillSubcategory.fromJson(Map<String, dynamic> json) {
    return DtoReceiveSkillSubcategory(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      deletedAt: json['deleted_at'] as String?,
      category: DtoReceiveSkillCategory.fromJson(json['category'] as Map<String, dynamic>),
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'category': category.toJson(),
    };
  }

  /// Verifica si la subcategoría de habilidad está activa (no eliminada)
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
    return 'DtoReceiveSkillSubcategory(id: $id, categoryId: $categoryId, name: $name, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, category: $category)';
  }
}
