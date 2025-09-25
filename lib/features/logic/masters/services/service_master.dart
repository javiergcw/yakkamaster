import '../../../../utils/crud_service.dart';
import '../../../../utils/response_handler.dart';
import '../api_master_constants.dart';
import '../models/receive/dto_receive_experience_level.dart';
import '../models/receive/dto_receive_license.dart';
import '../models/receive/dto_receive_skill_category.dart';
import '../models/receive/dto_receive_skill_subcategory.dart';
import '../models/receive/dto_receive_skill.dart';
import '../models/receive/dto_receive_payment_constant.dart';
import '../models/receive/dto_receive_job_requirement.dart';
import '../models/receive/dto_receive_job_type.dart';

/// Servicio para operaciones de masters del API
class ServiceMaster {
  static final ServiceMaster _instance = ServiceMaster._internal();
  factory ServiceMaster() => _instance;
  ServiceMaster._internal();

  final CrudService _crudService = CrudService();
  final ResponseHandler _responseHandler = ResponseHandler();

  /// Obtiene los niveles de experiencia disponibles
  Future<ApiResult<List<DtoReceiveExperienceLevel>>> getExperienceLevels() async {
    try {
      // Asegurar que el header de licencia esté configurado
      await _crudService.headerManager.loadLicenseKey();
      
      // Realizar petición GET al endpoint /api/v1/experience-levels
      final response = await _crudService.getAll(ApiMasterConstants.experienceLevels);
      
      // Procesar la respuesta y convertir a List<DtoReceiveExperienceLevel>
      final result = await _responseHandler.handleResponse<List<DtoReceiveExperienceLevel>>(
        response,
        fromJsonList: (jsonList) => jsonList
            .map((item) => DtoReceiveExperienceLevel.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

      return result;
    } catch (e) {
      return ApiResult<List<DtoReceiveExperienceLevel>>.error(
        message: 'Error getting experience levels: $e',
        error: e,
      );
    }
  }

  /// Obtiene las licencias disponibles
  Future<ApiResult<List<DtoReceiveLicense>>> getLicenses() async {
    try {
      // Asegurar que el header de licencia esté configurado
      await _crudService.headerManager.loadLicenseKey();
      
      // Realizar petición GET al endpoint /api/v1/licenses
      final response = await _crudService.getAll(ApiMasterConstants.licenses);
      
      // Procesar la respuesta y convertir a List<DtoReceiveLicense>
      final result = await _responseHandler.handleResponse<List<DtoReceiveLicense>>(
        response,
        fromJsonList: (jsonList) => jsonList
            .map((item) => DtoReceiveLicense.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

      return result;
    } catch (e) {
      return ApiResult<List<DtoReceiveLicense>>.error(
        message: 'Error getting licenses: $e',
        error: e,
      );
    }
  }

  /// Obtiene las categorías de habilidades disponibles
  Future<ApiResult<List<DtoReceiveSkillCategory>>> getSkillCategories() async {
    try {
      // Asegurar que el header de licencia esté configurado
      await _crudService.headerManager.loadLicenseKey();
      
      // Realizar petición GET al endpoint /api/v1/skill-categories
      final response = await _crudService.getAll(ApiMasterConstants.skillCategories);
      
      // Procesar la respuesta y convertir a List<DtoReceiveSkillCategory>
      final result = await _responseHandler.handleResponse<List<DtoReceiveSkillCategory>>(
        response,
        fromJsonList: (jsonList) => jsonList
            .map((item) => DtoReceiveSkillCategory.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

      return result;
    } catch (e) {
      return ApiResult<List<DtoReceiveSkillCategory>>.error(
        message: 'Error getting skill categories: $e',
        error: e,
      );
    }
  }

  /// Obtiene las subcategorías de habilidades disponibles
  Future<ApiResult<List<DtoReceiveSkillSubcategory>>> getSkillSubcategories() async {
    try {
      // Asegurar que el header de licencia esté configurado
      await _crudService.headerManager.loadLicenseKey();
      
      // Realizar petición GET al endpoint /api/v1/skill-subcategories
      final response = await _crudService.getAll(ApiMasterConstants.skillSubcategories);
      
      // Procesar la respuesta y convertir a List<DtoReceiveSkillSubcategory>
      final result = await _responseHandler.handleResponse<List<DtoReceiveSkillSubcategory>>(
        response,
        fromJsonList: (jsonList) => jsonList
            .map((item) => DtoReceiveSkillSubcategory.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

      return result;
    } catch (e) {
      return ApiResult<List<DtoReceiveSkillSubcategory>>.error(
        message: 'Error getting skill subcategories: $e',
        error: e,
      );
    }
  }

  /// Obtiene las habilidades con sus subcategorías
  Future<ApiResult<List<DtoReceiveSkill>>> getSkills() async {
    try {
      // Asegurar que el header de licencia esté configurado
      await _crudService.headerManager.loadLicenseKey();
      
      // Realizar petición GET al endpoint /api/v1/skills
      final response = await _crudService.getAll(ApiMasterConstants.skills);
      
      // Procesar la respuesta y convertir a List<DtoReceiveSkill>
      final result = await _responseHandler.handleResponse<List<DtoReceiveSkill>>(
        response,
        fromJsonList: (jsonList) => jsonList
            .map((item) => DtoReceiveSkill.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

      return result;
    } catch (e) {
      return ApiResult<List<DtoReceiveSkill>>.error(
        message: 'Error getting skills: $e',
        error: e,
      );
    }
  }

  /// Obtiene las subcategorías de una categoría específica
  Future<ApiResult<List<DtoReceiveSkillSubcategory>>> getSkillSubcategoriesByCategory(String categoryId) async {
    try {
      // Asegurar que el header de licencia esté configurado
      await _crudService.headerManager.loadLicenseKey();
      
      // Construir el endpoint con el ID de la categoría
      final endpoint = ApiMasterConstants.skillSubcategoriesByCategory(categoryId);
      
      // Realizar petición GET al endpoint /api/v1/skill-categories/{categoryId}/subcategories
      final response = await _crudService.getAll(endpoint);
      
      // Procesar la respuesta y convertir a List<DtoReceiveSkillSubcategory>
      final result = await _responseHandler.handleResponse<List<DtoReceiveSkillSubcategory>>(
        response,
        fromJsonList: (jsonList) => jsonList
            .map((item) => DtoReceiveSkillSubcategory.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

      return result;
    } catch (e) {
      return ApiResult<List<DtoReceiveSkillSubcategory>>.error(
        message: 'Error getting subcategories for category $categoryId: $e',
        error: e,
      );
    }
  }

  /// Obtiene las constantes de pago
  Future<ApiResult<DtoReceivePaymentConstants>> getPaymentConstants({bool activeOnly = true}) async {
    try {
      // Asegurar que el header de licencia esté configurado
      await _crudService.headerManager.loadLicenseKey();
      
      // Construir parámetros de consulta
      final queryParams = <String, String>{
        'active_only': activeOnly.toString(),
      };
      
      // Realizar petición GET al endpoint /api/v1/payment-constants
      final response = await _crudService.getAll(
        ApiMasterConstants.paymentConstants,
        filters: queryParams,
      );
      
      // Procesar la respuesta y convertir a DtoReceivePaymentConstants
      final result = await _responseHandler.handleResponse<DtoReceivePaymentConstants>(
        response,
        fromJson: DtoReceivePaymentConstants.fromJson,
      );

      return result;
    } catch (e) {
      return ApiResult<DtoReceivePaymentConstants>.error(
        message: 'Error getting payment constants: $e',
        error: e,
      );
    }
  }

  /// Obtiene los requisitos de trabajo
  Future<ApiResult<DtoReceiveJobRequirements>> getJobRequirements({bool activeOnly = true}) async {
    try {
      // Asegurar que el header de licencia esté configurado
      await _crudService.headerManager.loadLicenseKey();
      
      // Construir parámetros de consulta
      final queryParams = <String, String>{
        'active_only': activeOnly.toString(),
      };
      
      // Realizar petición GET al endpoint /api/v1/job-requirements
      final response = await _crudService.getAll(
        ApiMasterConstants.jobRequirements,
        filters: queryParams,
      );
      
      // Procesar la respuesta y convertir a DtoReceiveJobRequirements
      final result = await _responseHandler.handleResponse<DtoReceiveJobRequirements>(
        response,
        fromJson: DtoReceiveJobRequirements.fromJson,
      );

      return result;
    } catch (e) {
      return ApiResult<DtoReceiveJobRequirements>.error(
        message: 'Error getting job requirements: $e',
        error: e,
      );
    }
  }

  /// Obtiene los tipos de trabajo
  Future<ApiResult<DtoReceiveJobTypes>> getJobTypes({bool activeOnly = true}) async {
    try {
      // Asegurar que el header de licencia esté configurado
      await _crudService.headerManager.loadLicenseKey();
      
      // Construir parámetros de consulta
      final queryParams = <String, String>{
        'active_only': activeOnly.toString(),
      };
      
      // Realizar petición GET al endpoint /api/v1/job-types
      final response = await _crudService.getAll(
        ApiMasterConstants.jobTypes,
        filters: queryParams,
      );
      
      // Procesar la respuesta y convertir a DtoReceiveJobTypes
      final result = await _responseHandler.handleResponse<DtoReceiveJobTypes>(
        response,
        fromJson: DtoReceiveJobTypes.fromJson,
      );

      return result;
    } catch (e) {
      return ApiResult<DtoReceiveJobTypes>.error(
        message: 'Error getting job types: $e',
        error: e,
      );
    }
  }
}
