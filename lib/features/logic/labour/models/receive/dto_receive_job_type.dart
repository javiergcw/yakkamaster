class DtoReceiveJobType {
  final String id;
  final String name;
  final String description;
  final String createdAt;
  final String updatedAt;

  DtoReceiveJobType({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DtoReceiveJobType.fromJson(Map<String, dynamic> json) {
    return DtoReceiveJobType(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
