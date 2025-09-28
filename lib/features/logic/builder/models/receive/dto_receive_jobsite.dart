import 'dart:math';

/// DTO para un jobsite individual
class DtoReceiveJobsite {
  final String id;
  final String builderId;
  final String address;
  final String suburb;
  final String description;
  final double latitude;
  final double longitude;
  final String createdAt;
  final String updatedAt;

  DtoReceiveJobsite({
    required this.id,
    required this.builderId,
    required this.address,
    required this.suburb,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Constructor desde JSON
  factory DtoReceiveJobsite.fromJson(Map<String, dynamic> json) {
    try {
      print('DtoReceiveJobsite.fromJson - JSON recibido: $json');
      
      final id = json['id']?.toString() ?? '';
      final builderId = json['builder_id']?.toString() ?? '';
      final address = json['address']?.toString() ?? '';
      final suburb = json['suburb']?.toString() ?? '';
      final description = json['description']?.toString() ?? '';
      final latitude = (json['latitude'] as num?)?.toDouble() ?? 0.0;
      final longitude = (json['longitude'] as num?)?.toDouble() ?? 0.0;
      final createdAt = json['created_at']?.toString() ?? '';
      final updatedAt = json['updated_at']?.toString() ?? '';
      
      print('DtoReceiveJobsite.fromJson - Valores procesados:');
      print('  id: $id');
      print('  builderId: $builderId');
      print('  address: $address');
      print('  suburb: $suburb');
      print('  description: $description');
      print('  latitude: $latitude');
      print('  longitude: $longitude');
      print('  createdAt: $createdAt');
      print('  updatedAt: $updatedAt');
      
      return DtoReceiveJobsite(
        id: id,
        builderId: builderId,
        address: address,
        suburb: suburb,
        description: description,
        latitude: latitude,
        longitude: longitude,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } catch (e) {
      print('Error en DtoReceiveJobsite.fromJson: $e');
      print('JSON que causó el error: $json');
      rethrow;
    }
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'builder_id': builderId,
      'address': address,
      'suburb': suburb,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
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

  /// Obtiene la ubicación completa formateada
  String get fullLocation {
    return '$address, $suburb';
  }

  /// Obtiene la ubicación corta (solo suburb)
  String get shortLocation {
    return suburb;
  }

  /// Obtiene las coordenadas como string
  String get coordinatesString {
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }

  /// Obtiene las coordenadas como LatLng (para mapas)
  Map<String, double> get coordinates {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  /// Verifica si el jobsite está en Sydney (basado en suburb)
  bool get isInSydney {
    return suburb.toLowerCase().contains('sydney');
  }

  /// Verifica si el jobsite está en Melbourne (basado en suburb)
  bool get isInMelbourne {
    return suburb.toLowerCase().contains('melbourne');
  }

  /// Verifica si el jobsite está en Brisbane (basado en suburb)
  bool get isInBrisbane {
    return suburb.toLowerCase().contains('brisbane');
  }

  /// Verifica si el jobsite está en Perth (basado en suburb)
  bool get isInPerth {
    return suburb.toLowerCase().contains('perth');
  }

  /// Obtiene el estado basado en la ciudad
  String get state {
    if (isInSydney) return 'NSW';
    if (isInMelbourne) return 'VIC';
    if (isInBrisbane) return 'QLD';
    if (isInPerth) return 'WA';
    return 'Unknown';
  }

  /// Obtiene el emoji de la bandera del estado
  String get stateFlag {
    switch (state) {
      case 'NSW':
        return '🏴󠁧󠁢󠁥󠁮󠁧󠁿'; // Bandera de Inglaterra (NSW)
      case 'VIC':
        return '🏴󠁧󠁢󠁥󠁮󠁧󠁿'; // Bandera de Inglaterra (VIC)
      case 'QLD':
        return '🏴󠁧󠁢󠁥󠁮󠁧󠁿'; // Bandera de Inglaterra (QLD)
      case 'WA':
        return '🏴󠁧󠁢󠁥󠁮󠁧󠁿'; // Bandera de Inglaterra (WA)
      default:
        return '🇦🇺'; // Bandera de Australia
    }
  }

  /// Obtiene la descripción truncada para mostrar en listas
  String get shortDescription {
    if (description.length <= 50) return description;
    return '${description.substring(0, 47)}...';
  }

  /// Obtiene el teléfono formateado (no disponible en el API actual)
  String get formattedPhone {
    return 'No phone available';
  }

  /// Obtiene la distancia aproximada desde el centro de la ciudad (en km)
  double getDistanceFromCityCenter() {
    // Coordenadas del centro de las principales ciudades australianas
    final cityCenters = {
      'sydney': {'lat': -33.8688, 'lng': 151.2093},
      'melbourne': {'lat': -37.8136, 'lng': 144.9631},
      'brisbane': {'lat': -27.4698, 'lng': 153.0251},
      'perth': {'lat': -31.9505, 'lng': 115.8605},
    };

    final cityKey = suburb.toLowerCase();
    if (cityCenters.containsKey(cityKey)) {
      final center = cityCenters[cityKey]!;
      return _calculateDistance(
        latitude, longitude,
        center['lat']!, center['lng']!,
      );
    }
    return 0.0;
  }

  /// Calcula la distancia entre dos puntos usando la fórmula de Haversine
  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371; // Radio de la Tierra en km
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLng = _degreesToRadians(lng2 - lng1);
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLng / 2) * sin(dLng / 2);
    final double c = 2 * asin(sqrt(a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  /// Obtiene el ícono sugerido para el tipo de construcción
  String get suggestedIcon {
    if (description.toLowerCase().contains('residential') || 
        description.toLowerCase().contains('residencial')) {
      return '🏠';
    }
    if (description.toLowerCase().contains('commercial') || 
        description.toLowerCase().contains('comercial')) {
      return '🏢';
    }
    if (description.toLowerCase().contains('industrial') || 
        description.toLowerCase().contains('industrial')) {
      return '🏭';
    }
    if (description.toLowerCase().contains('renovation') || 
        description.toLowerCase().contains('renovación')) {
      return '🔨';
    }
    return '🏗️'; // Construcción general
  }

  @override
  String toString() {
    return 'DtoReceiveJobsite(id: $id, address: $address, suburb: $suburb)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DtoReceiveJobsite && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// DTO para la respuesta del endpoint /api/v1/jobsites
class DtoReceiveJobsites {
  final List<DtoReceiveJobsite> jobsites;
  final int total;

  DtoReceiveJobsites({
    required this.jobsites,
    required this.total,
  });

  /// Constructor desde JSON
  factory DtoReceiveJobsites.fromJson(Map<String, dynamic> json) {
    return DtoReceiveJobsites(
      jobsites: (json['jobsites'] as List<dynamic>?)
          ?.map((item) => DtoReceiveJobsite.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      total: json['total'] as int? ?? 0,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'jobsites': jobsites.map((jobsite) => jobsite.toJson()).toList(),
      'total': total,
    };
  }

  /// Obtiene el número de jobsites
  int get jobsitesCount => jobsites.length;

  /// Obtiene los jobsites por suburbio
  List<DtoReceiveJobsite> getJobsitesBySuburb(String suburb) {
    return jobsites.where((jobsite) => 
      jobsite.suburb.toLowerCase() == suburb.toLowerCase()).toList();
  }

  /// Obtiene los jobsites de Sydney
  List<DtoReceiveJobsite> get sydneyJobsites {
    return getJobsitesBySuburb('Sydney');
  }

  /// Obtiene los jobsites de Melbourne
  List<DtoReceiveJobsite> get melbourneJobsites {
    return getJobsitesBySuburb('Melbourne');
  }

  /// Obtiene los jobsites de Brisbane
  List<DtoReceiveJobsite> get brisbaneJobsites {
    return getJobsitesBySuburb('Brisbane');
  }

  /// Obtiene los jobsites de Perth
  List<DtoReceiveJobsite> get perthJobsites {
    return getJobsitesBySuburb('Perth');
  }

  /// Busca un jobsite por ID
  DtoReceiveJobsite? getJobsiteById(String id) {
    try {
      return jobsites.firstWhere((jobsite) => jobsite.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Busca jobsites por builder ID
  List<DtoReceiveJobsite> getJobsitesByBuilderId(String builderId) {
    return jobsites.where((jobsite) => jobsite.builderId == builderId).toList();
  }

  /// Obtiene un resumen por suburbio
  Map<String, int> get suburbsSummary {
    final summary = <String, int>{};
    for (final jobsite in jobsites) {
      final suburb = jobsite.suburb;
      summary[suburb] = (summary[suburb] ?? 0) + 1;
    }
    return summary;
  }

  /// Obtiene un resumen por estado
  Map<String, int> get statesSummary {
    final summary = <String, int>{};
    for (final jobsite in jobsites) {
      final state = jobsite.state;
      summary[state] = (summary[state] ?? 0) + 1;
    }
    return summary;
  }

  /// Obtiene los jobsites ordenados por fecha de creación (más recientes primero)
  List<DtoReceiveJobsite> get jobsitesByDate {
    final sortedJobsites = List<DtoReceiveJobsite>.from(jobsites);
    sortedJobsites.sort((a, b) => b.createdAtAsDateTime.compareTo(a.createdAtAsDateTime));
    return sortedJobsites;
  }

  /// Obtiene los jobsites ordenados por suburbio
  List<DtoReceiveJobsite> get jobsitesBySuburb {
    final sortedJobsites = List<DtoReceiveJobsite>.from(jobsites);
    sortedJobsites.sort((a, b) => a.suburb.compareTo(b.suburb));
    return sortedJobsites;
  }

  @override
  String toString() {
    return 'DtoReceiveJobsites(jobsitesCount: $jobsitesCount, total: $total)';
  }
}
