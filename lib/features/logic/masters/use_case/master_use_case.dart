import '../../../../utils/response_handler.dart';
import '../services/service_master.dart';
import '../models/receive/dto_receive_experience_level.dart';
import '../models/receive/dto_receive_license.dart';
import '../models/receive/dto_receive_skill_category.dart';
import '../models/receive/dto_receive_skill_subcategory.dart';
import '../models/receive/dto_receive_skill.dart';

/// Caso de uso para operaciones de masters
class MasterUseCase {
  static final MasterUseCase _instance = MasterUseCase._internal();
  factory MasterUseCase() => _instance;
  MasterUseCase._internal();

  final ServiceMaster _serviceMaster = ServiceMaster();

  /// Obtiene los niveles de experiencia disponibles
  /// 
  /// Retorna un [ApiResult] con la lista de niveles de experiencia
  /// o un error si la operación falla
  Future<ApiResult<List<DtoReceiveExperienceLevel>>> getExperienceLevels() async {
    try {
      // Llamar al servicio para obtener los niveles de experiencia
      final result = await _serviceMaster.getExperienceLevels();
      
      return result;
    } catch (e) {
      return ApiResult<List<DtoReceiveExperienceLevel>>.error(
        message: 'Error en el caso de uso al obtener niveles de experiencia: $e',
        error: e,
      );
    }
  }

  /// Obtiene solo los niveles de experiencia activos (no eliminados)
  /// 
  /// Retorna un [ApiResult] con la lista filtrada de niveles activos
  Future<ApiResult<List<DtoReceiveExperienceLevel>>> getActiveExperienceLevels() async {
    try {
      // Obtener todos los niveles de experiencia
      final result = await getExperienceLevels();
      
      if (result.isSuccess && result.data != null) {
        // Filtrar solo los niveles activos
        final activeLevels = result.data!.where((level) => level.isActive).toList();
        
        return ApiResult<List<DtoReceiveExperienceLevel>>.success(activeLevels);
      }
      
      return ApiResult<List<DtoReceiveExperienceLevel>>.error(
        message: result.message ?? 'Error desconocido al obtener niveles de experiencia',
        error: result.error,
      );
    } catch (e) {
      return ApiResult<List<DtoReceiveExperienceLevel>>.error(
        message: 'Error al obtener niveles de experiencia activos: $e',
        error: e,
      );
    }
  }

  /// Obtiene las licencias disponibles
  /// 
  /// Retorna un [ApiResult] con la lista de licencias
  /// o un error si la operación falla
  Future<ApiResult<List<DtoReceiveLicense>>> getLicenses() async {
    try {
      // Llamar al servicio para obtener las licencias
      final result = await _serviceMaster.getLicenses();
      
      return result;
    } catch (e) {
      return ApiResult<List<DtoReceiveLicense>>.error(
        message: 'Error en el caso de uso al obtener licencias: $e',
        error: e,
      );
    }
  }

  /// Obtiene las categorías de habilidades disponibles
  /// 
  /// Retorna un [ApiResult] con la lista de categorías de habilidades
  /// o un error si la operación falla
  Future<ApiResult<List<DtoReceiveSkillCategory>>> getSkillCategories() async {
    try {
      // Llamar al servicio para obtener las categorías de habilidades
      final result = await _serviceMaster.getSkillCategories();
      
      return result;
    } catch (e) {
      return ApiResult<List<DtoReceiveSkillCategory>>.error(
        message: 'Error en el caso de uso al obtener categorías de habilidades: $e',
        error: e,
      );
    }
  }

  /// Obtiene solo las categorías de habilidades activas (no eliminadas)
  /// 
  /// Retorna un [ApiResult] con la lista filtrada de categorías activas
  Future<ApiResult<List<DtoReceiveSkillCategory>>> getActiveSkillCategories() async {
    try {
      // Obtener todas las categorías de habilidades
      final result = await getSkillCategories();
      
      if (result.isSuccess && result.data != null) {
        // Filtrar solo las categorías activas
        final activeCategories = result.data!.where((category) => category.isActive).toList();
        
        return ApiResult<List<DtoReceiveSkillCategory>>.success(activeCategories);
      }
      
      return ApiResult<List<DtoReceiveSkillCategory>>.error(
        message: result.message ?? 'Error desconocido al obtener categorías de habilidades',
        error: result.error,
      );
    } catch (e) {
      return ApiResult<List<DtoReceiveSkillCategory>>.error(
        message: 'Error al obtener categorías de habilidades activas: $e',
        error: e,
      );
    }
  }

  /// Obtiene las subcategorías de habilidades disponibles
  /// 
  /// Retorna un [ApiResult] con la lista de subcategorías de habilidades
  /// o un error si la operación falla
  Future<ApiResult<List<DtoReceiveSkillSubcategory>>> getSkillSubcategories() async {
    try {
      // Llamar al servicio para obtener las subcategorías de habilidades
      final result = await _serviceMaster.getSkillSubcategories();
      
      return result;
    } catch (e) {
      return ApiResult<List<DtoReceiveSkillSubcategory>>.error(
        message: 'Error en el caso de uso al obtener subcategorías de habilidades: $e',
        error: e,
      );
    }
  }

  /// Obtiene solo las subcategorías de habilidades activas (no eliminadas)
  /// 
  /// Retorna un [ApiResult] con la lista filtrada de subcategorías activas
  Future<ApiResult<List<DtoReceiveSkillSubcategory>>> getActiveSkillSubcategories() async {
    try {
      // Obtener todas las subcategorías de habilidades
      final result = await getSkillSubcategories();
      
      if (result.isSuccess && result.data != null) {
        // Filtrar solo las subcategorías activas
        final activeSubcategories = result.data!.where((subcategory) => subcategory.isActive).toList();
        
        return ApiResult<List<DtoReceiveSkillSubcategory>>.success(activeSubcategories);
      }
      
      return ApiResult<List<DtoReceiveSkillSubcategory>>.error(
        message: result.message ?? 'Error desconocido al obtener subcategorías de habilidades',
        error: result.error,
      );
    } catch (e) {
      return ApiResult<List<DtoReceiveSkillSubcategory>>.error(
        message: 'Error al obtener subcategorías de habilidades activas: $e',
        error: e,
      );
    }
  }

  /// Obtiene las habilidades con sus subcategorías
  /// 
  /// Retorna un [ApiResult] con la lista de habilidades
  /// o un error si la operación falla
  Future<ApiResult<List<DtoReceiveSkill>>> getSkills() async {
    try {
      // Llamar al servicio para obtener las habilidades
      final result = await _serviceMaster.getSkills();
      
      return result;
    } catch (e) {
      return ApiResult<List<DtoReceiveSkill>>.error(
        message: 'Error en el caso de uso al obtener habilidades: $e',
        error: e,
      );
    }
  }

  /// Obtiene las subcategorías de una categoría específica
  /// 
  /// [categoryId] - ID de la categoría para obtener sus subcategorías
  /// Retorna un [ApiResult] con la lista de subcategorías
  /// o un error si la operación falla
  Future<ApiResult<List<DtoReceiveSkillSubcategory>>> getSkillSubcategoriesByCategory(String categoryId) async {
    try {
      // Llamar al servicio para obtener las subcategorías de la categoría
      final result = await _serviceMaster.getSkillSubcategoriesByCategory(categoryId);
      
      return result;
    } catch (e) {
      return ApiResult<List<DtoReceiveSkillSubcategory>>.error(
        message: 'Error en el caso de uso al obtener subcategorías de la categoría $categoryId: $e',
        error: e,
      );
    }
  }

  /// Obtiene solo las subcategorías activas de una categoría específica
  /// 
  /// [categoryId] - ID de la categoría para obtener sus subcategorías activas
  /// Retorna un [ApiResult] con la lista filtrada de subcategorías activas
  Future<ApiResult<List<DtoReceiveSkillSubcategory>>> getActiveSkillSubcategoriesByCategory(String categoryId) async {
    try {
      // Obtener todas las subcategorías de la categoría
      final result = await getSkillSubcategoriesByCategory(categoryId);

      if (result.isSuccess && result.data != null) {
        // Filtrar solo las subcategorías activas
        final activeSubcategories = result.data!.where((subcategory) => subcategory.isActive).toList();

        return ApiResult<List<DtoReceiveSkillSubcategory>>.success(activeSubcategories);
      }

      return ApiResult<List<DtoReceiveSkillSubcategory>>.error(
        message: result.message ?? 'Error desconocido al obtener subcategorías de la categoría $categoryId',
        error: result.error,
      );
    } catch (e) {
      return ApiResult<List<DtoReceiveSkillSubcategory>>.error(
        message: 'Error al obtener subcategorías activas de la categoría $categoryId: $e',
        error: e,
      );
    }
  }
}
