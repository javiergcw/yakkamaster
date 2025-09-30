/// DTO para job skill
class DtoReceiveJobSkill {
  final String id;
  final String jobId;
  final String skillCategoryId;
  final String skillSubcategoryId;
  final DtoReceiveSkillCategory? skillCategory;
  final DtoReceiveSkillSubcategory? skillSubcategory;
  final String createdAt;

  DtoReceiveJobSkill({
    required this.id,
    required this.jobId,
    required this.skillCategoryId,
    required this.skillSubcategoryId,
    this.skillCategory,
    this.skillSubcategory,
    required this.createdAt,
  });

  factory DtoReceiveJobSkill.fromJson(Map<String, dynamic> json) {
    return DtoReceiveJobSkill(
      id: json['id']?.toString() ?? '',
      jobId: json['job_id']?.toString() ?? '',
      skillCategoryId: json['skill_category_id']?.toString() ?? '',
      skillSubcategoryId: json['skill_subcategory_id']?.toString() ?? '',
      skillCategory: json['skill_category'] != null 
          ? DtoReceiveSkillCategory.fromJson(json['skill_category'] as Map<String, dynamic>)
          : null,
      skillSubcategory: json['skill_subcategory'] != null 
          ? DtoReceiveSkillSubcategory.fromJson(json['skill_subcategory'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_id': jobId,
      'skill_category_id': skillCategoryId,
      'skill_subcategory_id': skillSubcategoryId,
      'skill_category': skillCategory?.toJson(),
      'skill_subcategory': skillSubcategory?.toJson(),
      'created_at': createdAt,
    };
  }

  @override
  String toString() {
    return 'DtoReceiveJobSkill(id: $id, jobId: $jobId)';
  }
}

/// DTO para skill category
class DtoReceiveSkillCategory {
  final String id;
  final String name;
  final String description;

  DtoReceiveSkillCategory({
    required this.id,
    required this.name,
    required this.description,
  });

  factory DtoReceiveSkillCategory.fromJson(Map<String, dynamic> json) {
    return DtoReceiveSkillCategory(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'DtoReceiveSkillCategory(id: $id, name: $name)';
  }
}

/// DTO para skill subcategory
class DtoReceiveSkillSubcategory {
  final String id;
  final String name;
  final String description;

  DtoReceiveSkillSubcategory({
    required this.id,
    required this.name,
    required this.description,
  });

  factory DtoReceiveSkillSubcategory.fromJson(Map<String, dynamic> json) {
    return DtoReceiveSkillSubcategory(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'DtoReceiveSkillSubcategory(id: $id, name: $name)';
  }
}
