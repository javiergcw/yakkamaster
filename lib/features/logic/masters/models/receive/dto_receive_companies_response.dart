import 'dto_receive_company.dart';

/// DTO para la respuesta completa del endpoint /api/v1/companies
class DtoReceiveCompaniesResponse {
  final List<DtoReceiveCompany>? companies;
  final int total;
  final String message;

  DtoReceiveCompaniesResponse({
    this.companies,
    required this.total,
    required this.message,
  });

  /// Constructor desde JSON
  factory DtoReceiveCompaniesResponse.fromJson(Map<String, dynamic> json) {
    return DtoReceiveCompaniesResponse(
      companies: json['companies'] != null
          ? (json['companies'] as List)
              .map((item) => DtoReceiveCompany.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      total: json['total'] as int,
      message: json['message'] as String,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'companies': companies?.map((company) => company.toJson()).toList(),
      'total': total,
      'message': message,
    };
  }

  /// Verifica si hay empresas disponibles
  bool get hasCompanies => companies != null && companies!.isNotEmpty;

  /// Obtiene el número de empresas
  int get companiesCount => companies?.length ?? 0;

  @override
  String toString() {
    return 'DtoReceiveCompaniesResponse(companies: ${companies?.length ?? 0} items, total: $total, message: $message)';
  }
}
