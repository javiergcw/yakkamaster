/// DTO para recibir información de una licencia
class DtoReceiveLicense {
  final String id;
  final String name;
  final String description;

  DtoReceiveLicense({
    required this.id,
    required this.name,
    required this.description,
  });

  factory DtoReceiveLicense.fromJson(Map<String, dynamic> json) {
    return DtoReceiveLicense(
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
}
