/// DTO para enviar datos de empresa al endpoint POST /api/v1/companies
class DtoSendCompany {
  final String name;
  final String description;
  final String website;

  DtoSendCompany({
    required this.name,
    required this.description,
    required this.website,
  });

  /// Convierte a JSON para enviar al servidor
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'website': website,
    };
  }

  /// Constructor desde JSON (útil para validaciones o pruebas)
  factory DtoSendCompany.fromJson(Map<String, dynamic> json) {
    return DtoSendCompany(
      name: json['name'] as String,
      description: json['description'] as String,
      website: json['website'] as String,
    );
  }

  /// Valida que todos los campos requeridos estén presentes
  bool get isValid {
    return name.isNotEmpty && 
           description.isNotEmpty && 
           website.isNotEmpty;
  }

  /// Valida que el website tenga formato de URL válido
  bool get hasValidWebsite {
    try {
      final uri = Uri.parse(website);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  @override
  String toString() {
    return 'DtoSendCompany(name: $name, description: $description, website: $website)';
  }
}
