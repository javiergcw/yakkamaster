/// DTO para enviar un jobsite al API
class DtoSendJobsite {
  final String address;
  final String suburb;
  final String description;
  final double latitude;
  final double longitude;

  DtoSendJobsite({
    required this.address,
    required this.suburb,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'suburb': suburb,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  /// Constructor desde JSON
  factory DtoSendJobsite.fromJson(Map<String, dynamic> json) {
    return DtoSendJobsite(
      address: json['address'] as String,
      suburb: json['suburb'] as String,
      description: json['description'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  /// Crea un DtoSendJobsite con valores por defecto
  factory DtoSendJobsite.create({
    required String address,
    required String suburb,
    String description = '',
    double latitude = 0.0,
    double longitude = 0.0,
  }) {
    return DtoSendJobsite(
      address: address,
      suburb: suburb,
      description: description,
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Crea una copia con nuevos valores
  DtoSendJobsite copyWith({
    String? address,
    String? suburb,
    String? description,
    double? latitude,
    double? longitude,
  }) {
    return DtoSendJobsite(
      address: address ?? this.address,
      suburb: suburb ?? this.suburb,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  /// Valida que los campos requeridos no estén vacíos
  bool get isValid {
    return address.trim().isNotEmpty &&
           suburb.trim().isNotEmpty;
  }

  /// Obtiene los campos faltantes
  List<String> get missingFields {
    final missing = <String>[];
    if (address.trim().isEmpty) missing.add('address');
    if (suburb.trim().isEmpty) missing.add('suburb');
    return missing;
  }

  /// Obtiene la ubicación completa formateada
  String get fullLocation {
    return '$address, $suburb';
  }

  /// Obtiene las coordenadas como string
  String get coordinatesString {
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }

  /// Obtiene las coordenadas como Map
  Map<String, double> get coordinates {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  String toString() {
    return 'DtoSendJobsite(address: $address, suburb: $suburb, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DtoSendJobsite &&
        other.address == address &&
        other.suburb == suburb &&
        other.description == description &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    return address.hashCode ^
        suburb.hashCode ^
        description.hashCode ^
        latitude.hashCode ^
        longitude.hashCode;
  }
}
