import '../../../../utils/crud_service.dart';
import '../../../../utils/response_handler.dart';
import '../api_builder_constants.dart';
import '../models/receive/dto_receive_jobsite.dart';
import '../models/send/dto_send_jobsite.dart';

/// Servicio para operaciones de jobsites del API
class ServiceJobsites {
  static final ServiceJobsites _instance = ServiceJobsites._internal();
  factory ServiceJobsites() => _instance;
  ServiceJobsites._internal();

  final CrudService _crudService = CrudService();
  final ResponseHandler _responseHandler = ResponseHandler();

  /// Obtiene los jobsites
  Future<ApiResult<DtoReceiveJobsites>> getJobsites() async {
    try {
      // Asegurar que el header de JWT esté configurado
      await _crudService.headerManager.loadBearerToken();
      
      // Realizar petición GET al endpoint /api/v1/jobsites
      final response = await _crudService.getAll(ApiBuilderConstants.jobsites);
      
      // Procesar la respuesta y convertir a DtoReceiveJobsites
      final result = await _responseHandler.handleResponse<DtoReceiveJobsites>(
        response,
        fromJson: DtoReceiveJobsites.fromJson,
      );

      return result;
    } catch (e) {
      return ApiResult<DtoReceiveJobsites>.error(
        message: 'Error getting jobsites: $e',
        error: e,
      );
    }
  }

  /// Obtiene un jobsite por ID
  Future<ApiResult<DtoReceiveJobsite>> getJobsiteById(String id) async {
    try {
      // Asegurar que el header de JWT esté configurado
      await _crudService.headerManager.loadBearerToken();
      
      // Realizar petición GET al endpoint /api/v1/jobsites/:id
      final response = await _crudService.getById(ApiBuilderConstants.jobsites, id);
      
      // Procesar la respuesta y convertir a DtoReceiveJobsite
      final result = await _responseHandler.handleResponse<DtoReceiveJobsite>(
        response,
        fromJson: DtoReceiveJobsite.fromJson,
      );

      return result;
    } catch (e) {
      return ApiResult<DtoReceiveJobsite>.error(
        message: 'Error getting jobsite by ID: $e',
        error: e,
      );
    }
  }

  /// Crea un nuevo jobsite
  Future<ApiResult<DtoReceiveJobsite>> createJobsite(DtoSendJobsite jobsiteData) async {
    try {
      // Asegurar que el header de JWT esté configurado
      await _crudService.headerManager.loadBearerToken();
      
      // Realizar petición POST al endpoint /api/v1/jobsites
      final response = await _crudService.create(
        ApiBuilderConstants.jobsites,
        jobsiteData.toJson(),
      );
      
      // Procesar la respuesta y convertir a DtoReceiveJobsite
      final result = await _responseHandler.handleResponse<DtoReceiveJobsite>(
        response,
        fromJson: DtoReceiveJobsite.fromJson,
      );

      return result;
    } catch (e) {
      return ApiResult<DtoReceiveJobsite>.error(
        message: 'Error creating jobsite: $e',
        error: e,
      );
    }
  }

  /// Actualiza un jobsite existente
  Future<ApiResult<DtoReceiveJobsite>> updateJobsite(String id, DtoSendJobsite jobsiteData) async {
    try {
      // Asegurar que el header de JWT esté configurado
      await _crudService.headerManager.loadBearerToken();
      
      // Realizar petición PUT al endpoint /api/v1/jobsites/:id
      final response = await _crudService.update(
        ApiBuilderConstants.jobsites,
        id,
        jobsiteData.toJson(),
      );
      
      // Procesar la respuesta y convertir a DtoReceiveJobsite
      final result = await _responseHandler.handleResponse<DtoReceiveJobsite>(
        response,
        fromJson: DtoReceiveJobsite.fromJson,
      );

      return result;
    } catch (e) {
      return ApiResult<DtoReceiveJobsite>.error(
        message: 'Error updating jobsite: $e',
        error: e,
      );
    }
  }

  /// Elimina un jobsite
  Future<ApiResult<bool>> deleteJobsite(String id) async {
    try {
      // Asegurar que el header de JWT esté configurado
      await _crudService.headerManager.loadBearerToken();
      
      // Realizar petición DELETE al endpoint /api/v1/jobsites/:id
      final response = await _crudService.delete(
        ApiBuilderConstants.jobsites,
        id,
      );
      
      // Procesar la respuesta
      final result = await _responseHandler.handleResponse<bool>(
        response,
        fromJson: (json) => true, // Si la respuesta es exitosa, consideramos que se eliminó
      );

      return result;
    } catch (e) {
      return ApiResult<bool>.error(
        message: 'Error deleting jobsite: $e',
        error: e,
      );
    }
  }
}
