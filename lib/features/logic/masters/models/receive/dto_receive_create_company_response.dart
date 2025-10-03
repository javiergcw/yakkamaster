import 'dto_receive_company.dart';

/// DTO para la respuesta del endpoint POST /api/v1/companies
class DtoReceiveCreateCompanyResponse {
  final DtoReceiveCompany company;
  final String message;

  DtoReceiveCreateCompanyResponse({
    required this.company,
    required this.message,
  });

  /// Constructor desde JSON
  factory DtoReceiveCreateCompanyResponse.fromJson(Map<String, dynamic> json) {
    return DtoReceiveCreateCompanyResponse(
      company: DtoReceiveCompany.fromJson(json['company'] as Map<String, dynamic>),
      message: json['message'] as String,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'company': company.toJson(),
      'message': message,
    };
  }

  /// Obtiene el ID de la empresa creada
  String get companyId => company.id;

  /// Obtiene el nombre de la empresa creada
  String get companyName => company.name;

  @override
  String toString() {
    return 'DtoReceiveCreateCompanyResponse(company: ${company.name}, message: $message)';
  }
}
