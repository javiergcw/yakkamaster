/// DTO para enviar datos de asignación de empresa al endpoint POST /api/v1/builder/companies
class DtoSendBuilderCompany {
  final String companyId;

  DtoSendBuilderCompany({
    required this.companyId,
  });

  /// Convierte a JSON para enviar al servidor
  Map<String, dynamic> toJson() {
    return {
      'company_id': companyId,
    };
  }

  /// Constructor desde JSON (útil para validaciones o pruebas)
  factory DtoSendBuilderCompany.fromJson(Map<String, dynamic> json) {
    return DtoSendBuilderCompany(
      companyId: json['company_id'] as String,
    );
  }

  /// Valida que el companyId esté presente y no esté vacío
  bool get isValid {
    return companyId.isNotEmpty;
  }

  /// Valida que el companyId tenga formato de UUID válido
  bool get hasValidCompanyId {
    // Expresión regular para validar formato UUID v4
    final uuidRegex = RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$', caseSensitive: false);
    return uuidRegex.hasMatch(companyId);
  }

  @override
  String toString() {
    return 'DtoSendBuilderCompany(companyId: $companyId)';
  }
}
