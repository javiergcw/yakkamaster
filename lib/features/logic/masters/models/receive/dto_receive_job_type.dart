/// DTO para un tipo de trabajo individual
class DtoReceiveJobType {
  final String id;
  final String name;
  final String description;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  DtoReceiveJobType({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Constructor desde JSON
  factory DtoReceiveJobType.fromJson(Map<String, dynamic> json) {
    return DtoReceiveJobType(
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

  /// Verifica si el tipo de trabajo es de tiempo completo
  bool get isFullTime {
    return name.toLowerCase().contains('full time') || 
           name.toLowerCase().contains('fulltime');
  }

  /// Verifica si el tipo de trabajo es de tiempo parcial
  bool get isPartTime {
    return name.toLowerCase().contains('part time') || 
           name.toLowerCase().contains('parttime');
  }

  /// Verifica si el tipo de trabajo es casual
  bool get isCasual {
    return name.toLowerCase().contains('casual');
  }

  /// Verifica si el tipo de trabajo es estacional
  bool get isSeasonal {
    return name.toLowerCase().contains('seasonal');
  }

  /// Verifica si el tipo de trabajo es FIFO (Fly In Fly Out)
  bool get isFIFO {
    return name.toLowerCase().contains('fifo');
  }

  /// Verifica si el tipo de trabajo es agrícola/granja
  bool get isAgricultural {
    return name.toLowerCase().contains('farm') || 
           name.toLowerCase().contains('agricultural');
  }

  /// Verifica si el tipo de trabajo es minero
  bool get isMining {
    return name.toLowerCase().contains('mining');
  }

  /// Verifica si el tipo de trabajo es para visa de trabajo y vacaciones
  bool get isWorkingHoliday {
    return name.toLowerCase().contains('w&h') || 
           name.toLowerCase().contains('working holiday') ||
           name.toLowerCase().contains('visa');
  }

  /// Obtiene el tipo de empleo basado en el nombre
  String get employmentType {
    if (isFullTime) return 'full_time';
    if (isPartTime) return 'part_time';
    if (isCasual) return 'casual';
    if (isSeasonal) return 'seasonal';
    if (isFIFO) return 'fifo';
    if (isAgricultural) return 'agricultural';
    if (isMining) return 'mining';
    if (isWorkingHoliday) return 'working_holiday';
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

  /// Obtiene el ícono sugerido para el tipo de trabajo
  String get suggestedIcon {
    switch (employmentType) {
      case 'full_time':
        return '💼';
      case 'part_time':
        return '⏰';
      case 'casual':
        return '🎯';
      case 'seasonal':
        return '🍂';
      case 'fifo':
        return '✈️';
      case 'agricultural':
        return '🚜';
      case 'mining':
        return '⛏️';
      case 'working_holiday':
        return '🌍';
      default:
        return '💼';
    }
  }

  /// Obtiene el color sugerido para el tipo de trabajo
  String get suggestedColor {
    switch (employmentType) {
      case 'full_time':
        return '#4CAF50'; // Verde
      case 'part_time':
        return '#2196F3'; // Azul
      case 'casual':
        return '#FF9800'; // Naranja
      case 'seasonal':
        return '#9C27B0'; // Púrpura
      case 'fifo':
        return '#F44336'; // Rojo
      case 'agricultural':
        return '#8BC34A'; // Verde claro
      case 'mining':
        return '#607D8B'; // Azul gris
      case 'working_holiday':
        return '#E91E63'; // Rosa
      default:
        return '#9E9E9E'; // Gris
    }
  }

  @override
  String toString() {
    return 'DtoReceiveJobType(id: $id, name: $name, description: $description, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DtoReceiveJobType && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// DTO para la respuesta del endpoint /api/v1/job-types
class DtoReceiveJobTypes {
  final List<DtoReceiveJobType> types;
  final String message;

  DtoReceiveJobTypes({
    required this.types,
    required this.message,
  });

  /// Constructor desde JSON
  factory DtoReceiveJobTypes.fromJson(Map<String, dynamic> json) {
    return DtoReceiveJobTypes(
      types: (json['types'] as List<dynamic>)
          .map((item) => DtoReceiveJobType.fromJson(item as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'types': types.map((type) => type.toJson()).toList(),
      'message': message,
    };
  }

  /// Obtiene el número de tipos de trabajo
  int get typesCount => types.length;

  /// Obtiene solo los tipos de trabajo activos
  List<DtoReceiveJobType> get activeTypes {
    return types.where((type) => type.isActive).toList();
  }

  /// Obtiene los tipos de trabajo por tipo de empleo
  List<DtoReceiveJobType> getTypesByEmploymentType(String employmentType) {
    return types.where((type) => type.employmentType == employmentType).toList();
  }

  /// Obtiene los tipos de trabajo de tiempo completo
  List<DtoReceiveJobType> get fullTimeTypes {
    return getTypesByEmploymentType('full_time');
  }

  /// Obtiene los tipos de trabajo de tiempo parcial
  List<DtoReceiveJobType> get partTimeTypes {
    return getTypesByEmploymentType('part_time');
  }

  /// Obtiene los tipos de trabajo casuales
  List<DtoReceiveJobType> get casualTypes {
    return getTypesByEmploymentType('casual');
  }

  /// Obtiene los tipos de trabajo estacionales
  List<DtoReceiveJobType> get seasonalTypes {
    return getTypesByEmploymentType('seasonal');
  }

  /// Obtiene los tipos de trabajo FIFO
  List<DtoReceiveJobType> get fifoTypes {
    return getTypesByEmploymentType('fifo');
  }

  /// Obtiene los tipos de trabajo agrícolas
  List<DtoReceiveJobType> get agriculturalTypes {
    return getTypesByEmploymentType('agricultural');
  }

  /// Obtiene los tipos de trabajo mineros
  List<DtoReceiveJobType> get miningTypes {
    return getTypesByEmploymentType('mining');
  }

  /// Obtiene los tipos de trabajo para visa de trabajo y vacaciones
  List<DtoReceiveJobType> get workingHolidayTypes {
    return getTypesByEmploymentType('working_holiday');
  }

  /// Busca un tipo de trabajo por nombre
  DtoReceiveJobType? getTypeByName(String name) {
    try {
      return types.firstWhere((type) => type.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Busca un tipo de trabajo por ID
  DtoReceiveJobType? getTypeById(String id) {
    try {
      return types.firstWhere((type) => type.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Verifica si existe un tipo de trabajo específico por nombre
  bool hasType(String name) {
    return getTypeByName(name) != null;
  }

  /// Obtiene los tipos de trabajo activos por tipo de empleo
  List<DtoReceiveJobType> getActiveTypesByEmploymentType(String employmentType) {
    return activeTypes.where((type) => type.employmentType == employmentType).toList();
  }

  /// Obtiene un resumen de los tipos de empleo
  Map<String, int> get employmentTypesSummary {
    final summary = <String, int>{};
    for (final type in types) {
      final employmentType = type.employmentType;
      summary[employmentType] = (summary[employmentType] ?? 0) + 1;
    }
    return summary;
  }

  /// Obtiene los tipos de trabajo más comunes
  List<DtoReceiveJobType> get mostCommonTypes {
    final sortedTypes = List<DtoReceiveJobType>.from(types);
    sortedTypes.sort((a, b) => a.name.compareTo(b.name));
    return sortedTypes;
  }

  @override
  String toString() {
    return 'DtoReceiveJobTypes(typesCount: $typesCount, message: $message)';
  }
}
