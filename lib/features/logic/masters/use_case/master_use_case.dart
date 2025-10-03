import '../../../../utils/response_handler.dart';
import '../services/service_master.dart';
import '../models/receive/dto_receive_experience_level.dart';
import '../models/receive/dto_receive_license.dart';
import '../models/receive/dto_receive_skill_category.dart';
import '../models/receive/dto_receive_skill_subcategory.dart';
import '../models/receive/dto_receive_skill.dart';
import '../models/receive/dto_receive_payment_constant.dart';
import '../models/receive/dto_receive_job_requirement.dart';
import '../models/receive/dto_receive_job_type.dart';
import '../models/receive/dto_receive_company.dart';
import '../models/receive/dto_receive_companies_response.dart';
import '../models/send/dto_send_company.dart';
import '../models/receive/dto_receive_create_company_response.dart';

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

  /// Obtiene las constantes de pago
  /// 
  /// [activeOnly] - Si solo se deben obtener las constantes activas
  /// Retorna un [ApiResult] con las constantes de pago
  /// o un error si la operación falla
  Future<ApiResult<DtoReceivePaymentConstants>> getPaymentConstants({bool activeOnly = true}) async {
    try {
      // Llamar al servicio para obtener las constantes de pago
      final result = await _serviceMaster.getPaymentConstants(activeOnly: activeOnly);
      
      return result;
    } catch (e) {
      return ApiResult<DtoReceivePaymentConstants>.error(
        message: 'Error en el caso de uso al obtener constantes de pago: $e',
        error: e,
      );
    }
  }

  /// Obtiene los requisitos de trabajo
  /// 
  /// [activeOnly] - Si solo se deben obtener los requisitos activos
  /// Retorna un [ApiResult] con los requisitos de trabajo
  /// o un error si la operación falla
  Future<ApiResult<DtoReceiveJobRequirements>> getJobRequirements({bool activeOnly = true}) async {
    try {
      // Llamar al servicio para obtener los requisitos de trabajo
      final result = await _serviceMaster.getJobRequirements(activeOnly: activeOnly);
      
      return result;
    } catch (e) {
      return ApiResult<DtoReceiveJobRequirements>.error(
        message: 'Error en el caso de uso al obtener requisitos de trabajo: $e',
        error: e,
      );
    }
  }

  /// Obtiene solo los requisitos de trabajo activos (no eliminados)
  /// 
  /// Retorna un [ApiResult] con la lista filtrada de requisitos activos
  Future<ApiResult<DtoReceiveJobRequirements>> getActiveJobRequirements() async {
    try {
      // Obtener todos los requisitos de trabajo activos
      final result = await getJobRequirements(activeOnly: true);
      
      return result;
    } catch (e) {
      return ApiResult<DtoReceiveJobRequirements>.error(
        message: 'Error al obtener requisitos de trabajo activos: $e',
        error: e,
      );
    }
  }

  /// Obtiene los requisitos de trabajo por tipo
  /// 
  /// [type] - Tipo de requisito (safety, certification, equipment, experience, other)
  /// [activeOnly] - Si solo se deben obtener los requisitos activos
  /// Retorna un [ApiResult] con los requisitos filtrados por tipo
  Future<ApiResult<List<DtoReceiveJobRequirement>>> getJobRequirementsByType(
    String type, {
    bool activeOnly = true,
  }) async {
    try {
      // Obtener todos los requisitos de trabajo
      final result = await getJobRequirements(activeOnly: activeOnly);
      
      if (result.isSuccess && result.data != null) {
        // Filtrar por tipo
        final filteredRequirements = result.data!.getRequirementsByType(type);
        
        return ApiResult<List<DtoReceiveJobRequirement>>.success(filteredRequirements);
      }
      
      return ApiResult<List<DtoReceiveJobRequirement>>.error(
        message: result.message ?? 'Error desconocido al obtener requisitos de trabajo',
        error: result.error,
      );
    } catch (e) {
      return ApiResult<List<DtoReceiveJobRequirement>>.error(
        message: 'Error al obtener requisitos de trabajo por tipo $type: $e',
        error: e,
      );
    }
  }

  /// Obtiene los requisitos de seguridad
  /// 
  /// [activeOnly] - Si solo se deben obtener los requisitos activos
  /// Retorna un [ApiResult] con los requisitos de seguridad
  Future<ApiResult<List<DtoReceiveJobRequirement>>> getSafetyRequirements({bool activeOnly = true}) async {
    return getJobRequirementsByType('safety', activeOnly: activeOnly);
  }

  /// Obtiene los requisitos de certificación
  /// 
  /// [activeOnly] - Si solo se deben obtener los requisitos activos
  /// Retorna un [ApiResult] con los requisitos de certificación
  Future<ApiResult<List<DtoReceiveJobRequirement>>> getCertificationRequirements({bool activeOnly = true}) async {
    return getJobRequirementsByType('certification', activeOnly: activeOnly);
  }

  /// Obtiene los requisitos de equipamiento
  /// 
  /// [activeOnly] - Si solo se deben obtener los requisitos activos
  /// Retorna un [ApiResult] con los requisitos de equipamiento
  Future<ApiResult<List<DtoReceiveJobRequirement>>> getEquipmentRequirements({bool activeOnly = true}) async {
    return getJobRequirementsByType('equipment', activeOnly: activeOnly);
  }

  /// Obtiene los requisitos de experiencia
  /// 
  /// [activeOnly] - Si solo se deben obtener los requisitos activos
  /// Retorna un [ApiResult] con los requisitos de experiencia
  Future<ApiResult<List<DtoReceiveJobRequirement>>> getExperienceRequirements({bool activeOnly = true}) async {
    return getJobRequirementsByType('experience', activeOnly: activeOnly);
  }

  /// Obtiene los tipos de trabajo
  /// 
  /// [activeOnly] - Si solo se deben obtener los tipos activos
  /// Retorna un [ApiResult] con los tipos de trabajo
  /// o un error si la operación falla
  Future<ApiResult<DtoReceiveJobTypes>> getJobTypes({bool activeOnly = true}) async {
    try {
      // Llamar al servicio para obtener los tipos de trabajo
      final result = await _serviceMaster.getJobTypes(activeOnly: activeOnly);
      
      return result;
    } catch (e) {
      return ApiResult<DtoReceiveJobTypes>.error(
        message: 'Error in use case getting job types: $e',
        error: e,
      );
    }
  }

  /// Obtiene solo los tipos de trabajo activos (no eliminados)
  /// 
  /// Retorna un [ApiResult] con la lista filtrada de tipos activos
  Future<ApiResult<DtoReceiveJobTypes>> getActiveJobTypes() async {
    try {
      // Obtener todos los tipos de trabajo activos
      final result = await getJobTypes(activeOnly: true);
      
      return result;
    } catch (e) {
      return ApiResult<DtoReceiveJobTypes>.error(
        message: 'Error getting active job types: $e',
        error: e,
      );
    }
  }

  /// Obtiene los tipos de trabajo por tipo de empleo
  /// 
  /// [employmentType] - Tipo de empleo (full_time, part_time, casual, seasonal, fifo, agricultural, mining, working_holiday, other)
  /// [activeOnly] - Si solo se deben obtener los tipos activos
  /// Retorna un [ApiResult] con los tipos filtrados por tipo de empleo
  Future<ApiResult<List<DtoReceiveJobType>>> getJobTypesByEmploymentType(
    String employmentType, {
    bool activeOnly = true,
  }) async {
    try {
      // Obtener todos los tipos de trabajo
      final result = await getJobTypes(activeOnly: activeOnly);
      
      if (result.isSuccess && result.data != null) {
        // Filtrar por tipo de empleo
        final filteredTypes = result.data!.getTypesByEmploymentType(employmentType);
        
        return ApiResult<List<DtoReceiveJobType>>.success(filteredTypes);
      }
      
      return ApiResult<List<DtoReceiveJobType>>.error(
        message: result.message ?? 'Unknown error getting job types',
        error: result.error,
      );
    } catch (e) {
      return ApiResult<List<DtoReceiveJobType>>.error(
        message: 'Error getting job types by employment type $employmentType: $e',
        error: e,
      );
    }
  }

  /// Obtiene los tipos de trabajo de tiempo completo
  /// 
  /// [activeOnly] - Si solo se deben obtener los tipos activos
  /// Retorna un [ApiResult] con los tipos de tiempo completo
  Future<ApiResult<List<DtoReceiveJobType>>> getFullTimeJobTypes({bool activeOnly = true}) async {
    return getJobTypesByEmploymentType('full_time', activeOnly: activeOnly);
  }

  /// Obtiene los tipos de trabajo de tiempo parcial
  /// 
  /// [activeOnly] - Si solo se deben obtener los tipos activos
  /// Retorna un [ApiResult] con los tipos de tiempo parcial
  Future<ApiResult<List<DtoReceiveJobType>>> getPartTimeJobTypes({bool activeOnly = true}) async {
    return getJobTypesByEmploymentType('part_time', activeOnly: activeOnly);
  }

  /// Obtiene los tipos de trabajo casuales
  /// 
  /// [activeOnly] - Si solo se deben obtener los tipos activos
  /// Retorna un [ApiResult] con los tipos casuales
  Future<ApiResult<List<DtoReceiveJobType>>> getCasualJobTypes({bool activeOnly = true}) async {
    return getJobTypesByEmploymentType('casual', activeOnly: activeOnly);
  }

  /// Obtiene los tipos de trabajo estacionales
  /// 
  /// [activeOnly] - Si solo se deben obtener los tipos activos
  /// Retorna un [ApiResult] con los tipos estacionales
  Future<ApiResult<List<DtoReceiveJobType>>> getSeasonalJobTypes({bool activeOnly = true}) async {
    return getJobTypesByEmploymentType('seasonal', activeOnly: activeOnly);
  }

  /// Obtiene los tipos de trabajo FIFO
  /// 
  /// [activeOnly] - Si solo se deben obtener los tipos activos
  /// Retorna un [ApiResult] con los tipos FIFO
  Future<ApiResult<List<DtoReceiveJobType>>> getFIFOJobTypes({bool activeOnly = true}) async {
    return getJobTypesByEmploymentType('fifo', activeOnly: activeOnly);
  }

  /// Obtiene los tipos de trabajo agrícolas
  /// 
  /// [activeOnly] - Si solo se deben obtener los tipos activos
  /// Retorna un [ApiResult] con los tipos agrícolas
  Future<ApiResult<List<DtoReceiveJobType>>> getAgriculturalJobTypes({bool activeOnly = true}) async {
    return getJobTypesByEmploymentType('agricultural', activeOnly: activeOnly);
  }

  /// Obtiene los tipos de trabajo mineros
  /// 
  /// [activeOnly] - Si solo se deben obtener los tipos activos
  /// Retorna un [ApiResult] con los tipos mineros
  Future<ApiResult<List<DtoReceiveJobType>>> getMiningJobTypes({bool activeOnly = true}) async {
    return getJobTypesByEmploymentType('mining', activeOnly: activeOnly);
  }

  /// Obtiene los tipos de trabajo para visa de trabajo y vacaciones
  /// 
  /// [activeOnly] - Si solo se deben obtener los tipos activos
  /// Retorna un [ApiResult] con los tipos para visa de trabajo y vacaciones
  Future<ApiResult<List<DtoReceiveJobType>>> getWorkingHolidayJobTypes({bool activeOnly = true}) async {
    return getJobTypesByEmploymentType('working_holiday', activeOnly: activeOnly);
  }

  /// Obtiene las empresas disponibles
  /// 
  /// Retorna un [ApiResult] con la respuesta completa de empresas
  /// o un error si la operación falla
  Future<ApiResult<DtoReceiveCompaniesResponse>> getCompanies() async {
    try {
      // Llamar al servicio para obtener las empresas
      final result = await _serviceMaster.getCompanies();
      
      return result;
    } catch (e) {
      return ApiResult<DtoReceiveCompaniesResponse>.error(
        message: 'Error en el caso de uso al obtener empresas: $e',
        error: e,
      );
    }
  }

  /// Obtiene solo las empresas disponibles (lista filtrada)
  /// 
  /// Retorna un [ApiResult] con la lista de empresas
  /// o un error si la operación falla
  Future<ApiResult<List<DtoReceiveCompany>>> getCompaniesList() async {
    try {
      // Obtener la respuesta completa de empresas
      final result = await getCompanies();
      
      if (result.isSuccess && result.data != null && result.data!.hasCompanies) {
        // Retornar solo la lista de empresas
        return ApiResult<List<DtoReceiveCompany>>.success(result.data!.companies!);
      }
      
      return ApiResult<List<DtoReceiveCompany>>.error(
        message: result.message ?? 'No se encontraron empresas disponibles',
        error: result.error,
      );
    } catch (e) {
      return ApiResult<List<DtoReceiveCompany>>.error(
        message: 'Error al obtener lista de empresas: $e',
        error: e,
      );
    }
  }

  /// Crea una nueva empresa
  /// 
  /// [companyData] - Datos de la empresa a crear
  /// Retorna un [ApiResult] con la respuesta de creación
  /// o un error si la operación falla
  Future<ApiResult<DtoReceiveCreateCompanyResponse>> createCompany(DtoSendCompany companyData) async {
    try {
      // Llamar al servicio para crear la empresa
      final result = await _serviceMaster.createCompany(companyData);
      
      return result;
    } catch (e) {
      return ApiResult<DtoReceiveCreateCompanyResponse>.error(
        message: 'Error en el caso de uso al crear empresa: $e',
        error: e,
      );
    }
  }

  /// Crea una nueva empresa con validación adicional
  /// 
  /// [name] - Nombre de la empresa
  /// [description] - Descripción de la empresa
  /// [website] - Sitio web de la empresa
  /// Retorna un [ApiResult] con la respuesta de creación
  /// o un error si la operación falla
  Future<ApiResult<DtoReceiveCreateCompanyResponse>> createCompanyWithData({
    required String name,
    required String description,
    required String website,
  }) async {
    try {
      // Crear el objeto de datos de la empresa
      final companyData = DtoSendCompany(
        name: name,
        description: description,
        website: website,
      );

      // Llamar al método de creación
      return await createCompany(companyData);
    } catch (e) {
      return ApiResult<DtoReceiveCreateCompanyResponse>.error(
        message: 'Error al crear empresa con datos: $e',
        error: e,
      );
    }
  }
}
