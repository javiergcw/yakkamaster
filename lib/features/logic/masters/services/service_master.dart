import '../../../../utils/crud_service.dart';
import '../../../../utils/response_handler.dart';
import '../api_master_constants.dart';
import '../models/receive/dto_receive_experience_level.dart';
import '../models/receive/dto_receive_license.dart';
import '../models/receive/dto_receive_skill_category.dart';
import '../models/receive/dto_receive_skill_subcategory.dart';
import '../models/receive/dto_receive_skill.dart';

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
        message: 'Error al obtener los niveles de experiencia: $e',
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
        message: 'Error al obtener las licencias: $e',
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
        message: 'Error al obtener las categorías de habilidades: $e',
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
        message: 'Error al obtener las subcategorías de habilidades: $e',
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
        message: 'Error al obtener las habilidades: $e',
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
        message: 'Error al obtener las subcategorías de la categoría $categoryId: $e',
        error: e,
      );
    }
  }
}
