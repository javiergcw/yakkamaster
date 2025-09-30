/// DTO para recibir un job requirement desde el API
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
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
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

  @override
  String toString() {
    return 'DtoReceiveJobRequirement(id: $id, name: $name, isActive: $isActive)';
  }
}
