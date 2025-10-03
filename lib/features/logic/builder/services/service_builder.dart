import '../../../../utils/crud_service.dart';
import '../../../../utils/response_handler.dart';
import '../api_builder_constants.dart';
import '../models/send/dto_send_builder_profile.dart';
import '../models/send/dto_send_builder_company.dart';
import '../models/receive/dto_receive_builder_company_response.dart';

/// Servicio para operaciones de builder del API
class ServiceBuilder {
  static final ServiceBuilder _instance = ServiceBuilder._internal();
  factory ServiceBuilder() => _instance;
  ServiceBuilder._internal();

  final CrudService _crudService = CrudService();
  final ResponseHandler _responseHandler = ResponseHandler();

  /// Crea o actualiza el perfil de constructor
  Future<ApiResult<Map<String, dynamic>>> createBuilderProfile(DtoSendBuilderProfile profileData) async {
    try {
      // Asegurar que el header de JWT esté configurado
      await _crudService.headerManager.loadBearerToken();
      
      // Realizar petición POST al endpoint /api/v1/profiles/builder
      final response = await _crudService.create(
        ApiBuilderConstants.builderProfile,
        profileData.toJson(),
      );
      
      // Procesar la respuesta
      final result = await _responseHandler.handleResponse<Map<String, dynamic>>(
        response,
        fromJson: (json) => json,
      );

      return result;
    } catch (e) {
      return ApiResult<Map<String, dynamic>>.error(
        message: 'Error al crear/actualizar el perfil de constructor: $e',
        error: e,
      );
    }
  }

  /// Asigna una empresa a un builder
  Future<ApiResult<DtoReceiveBuilderCompanyResponse>> assignCompany(DtoSendBuilderCompany companyData) async {
    try {
      // Validar datos de entrada
      if (!companyData.isValid) {
        return ApiResult<DtoReceiveBuilderCompanyResponse>.error(
          message: 'El ID de la empresa no es válido',
        );
      }

      if (!companyData.hasValidCompanyId) {
        return ApiResult<DtoReceiveBuilderCompanyResponse>.error(
          message: 'El ID de la empresa no tiene un formato válido',
        );
      }

      // Asegurar que el header de JWT esté configurado
      await _crudService.headerManager.loadBearerToken();
      
      // Realizar petición POST al endpoint /api/v1/builder/companies
      final response = await _crudService.create(
        ApiBuilderConstants.builderCompanies,
        companyData.toJson(),
      );
      
      // Procesar la respuesta y convertir a DtoReceiveBuilderCompanyResponse
      final result = await _responseHandler.handleResponse<DtoReceiveBuilderCompanyResponse>(
        response,
        fromJson: DtoReceiveBuilderCompanyResponse.fromJson,
      );

      return result;
    } catch (e) {
      return ApiResult<DtoReceiveBuilderCompanyResponse>.error(
        message: 'Error al asignar empresa: $e',
        error: e,
      );
    }
  }
}
