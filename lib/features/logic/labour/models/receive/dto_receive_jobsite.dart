/// DTO para recibir un jobsite desde el API
class DtoReceiveJobsite {
  final String id;
  final String name;
  final String address;
  final String suburb;
  final String description;
  final double latitude;
  final double longitude;
  final String createdAt;
  final String updatedAt;

  DtoReceiveJobsite({
    required this.id,
    required this.name,
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
    return DtoReceiveJobsite(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      suburb: json['suburb']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'suburb': suburb,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  String toString() {
    return 'DtoReceiveJobsite(id: $id, name: $name, address: $address)';
  }
}
