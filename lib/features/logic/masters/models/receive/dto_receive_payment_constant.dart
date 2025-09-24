/// DTO para una constante de pago individual
class DtoReceivePaymentConstant {
  final String id;
  final String name;
  final double value;
  final String description;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  DtoReceivePaymentConstant({
    required this.id,
    required this.name,
    required this.value,
    required this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Constructor desde JSON
  factory DtoReceivePaymentConstant.fromJson(Map<String, dynamic> json) {
    return DtoReceivePaymentConstant(
      id: json['id'] as String,
      name: json['name'] as String,
      value: (json['value'] as num).toDouble(),
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
      'value': value,
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

  /// Obtiene el valor como entero
  int get valueAsInt => value.round();

  /// Obtiene el valor como porcentaje (si es un porcentaje)
  String get valueAsPercentage => '${value.toStringAsFixed(1)}%';

  /// Obtiene el valor formateado con símbolo de moneda
  String get valueAsCurrency => '\$${value.toStringAsFixed(2)}';

  /// Obtiene el valor formateado según el tipo de constante
  String get formattedValue {
    switch (name.toUpperCase()) {
      case 'GST':
      case 'TAX':
        return valueAsPercentage;
      case 'WAGE_HOURLY':
      case 'WAGE_DAILY':
      case 'WAGE_WEEKLY':
      case 'WAGE_MONTHLY':
        return valueAsCurrency;
      default:
        return value.toString();
    }
  }

  @override
  String toString() {
    return 'DtoReceivePaymentConstant(id: $id, name: $name, value: $value, description: $description, isActive: $isActive)';
  }
}

/// DTO para la respuesta del endpoint /api/v1/payment-constants
class DtoReceivePaymentConstants {
  final List<DtoReceivePaymentConstant> constants;
  final String message;

  DtoReceivePaymentConstants({
    required this.constants,
    required this.message,
  });

  /// Constructor desde JSON
  factory DtoReceivePaymentConstants.fromJson(Map<String, dynamic> json) {
    return DtoReceivePaymentConstants(
      constants: (json['constants'] as List<dynamic>)
          .map((item) => DtoReceivePaymentConstant.fromJson(item as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'constants': constants.map((constant) => constant.toJson()).toList(),
      'message': message,
    };
  }

  /// Obtiene el número de constantes
  int get constantsCount => constants.length;

  /// Obtiene solo las constantes activas
  List<DtoReceivePaymentConstant> get activeConstants {
    return constants.where((constant) => constant.isActive).toList();
  }

  /// Busca una constante por nombre
  DtoReceivePaymentConstant? getConstantByName(String name) {
    try {
      return constants.firstWhere((constant) => constant.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene el valor de una constante por nombre
  double? getConstantValue(String name) {
    final constant = getConstantByName(name);
    return constant?.value;
  }

  /// Obtiene el GST (impuesto sobre bienes y servicios)
  double? get gst => getConstantValue('GST');

  /// Obtiene el salario por hora
  double? get hourlyWage => getConstantValue('WAGE_HOURLY');

  /// Obtiene el salario diario
  double? get dailyWage => getConstantValue('WAGE_DAILY');

  /// Obtiene el salario semanal
  double? get weeklyWage => getConstantValue('WAGE_WEEKLY');

  /// Obtiene el salario mensual
  double? get monthlyWage => getConstantValue('WAGE_MONTHLY');

  @override
  String toString() {
    return 'DtoReceivePaymentConstants(constantsCount: $constantsCount, message: $message)';
  }
}
