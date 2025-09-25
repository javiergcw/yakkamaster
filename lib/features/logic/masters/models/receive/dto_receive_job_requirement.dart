/// DTO para un requisito de trabajo individual
class DtoReceiveJobRequirement {
  final String id;
  final String name;
  final String description;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  DtoReceiveJobRequirement({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Constructor desde JSON
  factory DtoReceiveJobRequirement.fromJson(Map<String, dynamic> json) {
    return DtoReceiveJobRequirement(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      isActive: json['is_active'] as bool,
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
      'is_active': isActive,
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

  /// Verifica si el requisito es de seguridad
  bool get isSafetyRequirement {
    final safetyKeywords = ['safety', 'hard hat', 'safety boots', 'high vis', 'white card'];
    return safetyKeywords.any((keyword) => 
      name.toLowerCase().contains(keyword.toLowerCase()) ||
      description.toLowerCase().contains(keyword.toLowerCase())
    );
  }

  /// Verifica si el requisito es de certificación
  bool get isCertificationRequirement {
    final certKeywords = ['license', 'certification', 'first aid', 'white card'];
    return certKeywords.any((keyword) => 
      name.toLowerCase().contains(keyword.toLowerCase()) ||
      description.toLowerCase().contains(keyword.toLowerCase())
    );
  }

  /// Verifica si el requisito es de herramientas/equipamiento
  bool get isEquipmentRequirement {
    final equipmentKeywords = ['tools', 'own tools', 'equipment'];
    return equipmentKeywords.any((keyword) => 
      name.toLowerCase().contains(keyword.toLowerCase()) ||
      description.toLowerCase().contains(keyword.toLowerCase())
    );
  }

  /// Obtiene el tipo de requisito basado en el nombre y descripción
  String get requirementType {
    if (isSafetyRequirement) return 'safety';
    if (isCertificationRequirement) return 'certification';
    if (isEquipmentRequirement) return 'equipment';
    if (name.toLowerCase().contains('experience')) return 'experience';
    return 'other';
  }

  /// Obtiene el nombre formateado para mostrar
  String get displayName {
    return name.replaceAll('_', ' ').split(' ')
        .map((word) => word.isNotEmpty ? 
          word[0].toUpperCase() + word.substring(1).toLowerCase() : '')
        .join(' ');
  }

  /// Obtiene la descripción truncada para mostrar en listas
  String get shortDescription {
    if (description.length <= 50) return description;
    return '${description.substring(0, 47)}...';
  }

  @override
  String toString() {
    return 'DtoReceiveJobRequirement(id: $id, name: $name, description: $description, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DtoReceiveJobRequirement && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// DTO para la respuesta del endpoint /api/v1/job-requirements
class DtoReceiveJobRequirements {
  final List<DtoReceiveJobRequirement> requirements;
  final String message;

  DtoReceiveJobRequirements({
    required this.requirements,
    required this.message,
  });

  /// Constructor desde JSON
  factory DtoReceiveJobRequirements.fromJson(Map<String, dynamic> json) {
    return DtoReceiveJobRequirements(
      requirements: (json['requirements'] as List<dynamic>)
          .map((item) => DtoReceiveJobRequirement.fromJson(item as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'requirements': requirements.map((requirement) => requirement.toJson()).toList(),
      'message': message,
    };
  }

  /// Obtiene el número de requisitos
  int get requirementsCount => requirements.length;

  /// Obtiene solo los requisitos activos
  List<DtoReceiveJobRequirement> get activeRequirements {
    return requirements.where((requirement) => requirement.isActive).toList();
  }

  /// Obtiene los requisitos por tipo
  List<DtoReceiveJobRequirement> getRequirementsByType(String type) {
    return requirements.where((requirement) => requirement.requirementType == type).toList();
  }

  /// Obtiene los requisitos de seguridad
  List<DtoReceiveJobRequirement> get safetyRequirements {
    return getRequirementsByType('safety');
  }

  /// Obtiene los requisitos de certificación
  List<DtoReceiveJobRequirement> get certificationRequirements {
    return getRequirementsByType('certification');
  }

  /// Obtiene los requisitos de equipamiento
  List<DtoReceiveJobRequirement> get equipmentRequirements {
    return getRequirementsByType('equipment');
  }

  /// Obtiene los requisitos de experiencia
  List<DtoReceiveJobRequirement> get experienceRequirements {
    return getRequirementsByType('experience');
  }

  /// Busca un requisito por nombre
  DtoReceiveJobRequirement? getRequirementByName(String name) {
    try {
      return requirements.firstWhere((requirement) => requirement.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Busca un requisito por ID
  DtoReceiveJobRequirement? getRequirementById(String id) {
    try {
      return requirements.firstWhere((requirement) => requirement.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Verifica si existe un requisito específico por nombre
  bool hasRequirement(String name) {
    return getRequirementByName(name) != null;
  }

  /// Obtiene los requisitos activos por tipo
  List<DtoReceiveJobRequirement> getActiveRequirementsByType(String type) {
    return activeRequirements.where((requirement) => requirement.requirementType == type).toList();
  }

  /// Obtiene un resumen de los tipos de requisitos
  Map<String, int> get requirementsSummary {
    final summary = <String, int>{};
    for (final requirement in requirements) {
      final type = requirement.requirementType;
      summary[type] = (summary[type] ?? 0) + 1;
    }
    return summary;
  }

  @override
  String toString() {
    return 'DtoReceiveJobRequirements(requirementsCount: $requirementsCount, message: $message)';
  }
}
