import '../../../../utils/response_handler.dart';
import '../services/service_jobsites.dart';
import '../models/receive/dto_receive_jobsite.dart';
import '../models/send/dto_send_jobsite.dart';

/// Caso de uso para operaciones de jobsites
class JobsitesUseCase {
  static final JobsitesUseCase _instance = JobsitesUseCase._internal();
  factory JobsitesUseCase() => _instance;
  JobsitesUseCase._internal();

  final ServiceJobsites _serviceJobsites = ServiceJobsites();

  /// Obtiene los jobsites
  /// 
  /// Retorna un [ApiResult] con la lista de jobsites
  /// o un error si la operación falla
  Future<ApiResult<DtoReceiveJobsites>> getJobsites() async {
    try {
      // Llamar al servicio para obtener los jobsites
      final result = await _serviceJobsites.getJobsites();
      
      return result;
    } catch (e) {
      return ApiResult<DtoReceiveJobsites>.error(
        message: 'Error in use case getting jobsites: $e',
        error: e,
      );
    }
  }

  /// Obtiene los jobsites por suburbio
  /// 
  /// [suburb] - Suburbio para filtrar los jobsites
  /// Retorna un [ApiResult] con los jobsites filtrados por suburbio
  Future<ApiResult<List<DtoReceiveJobsite>>> getJobsitesBySuburb(String suburb) async {
    try {
      // Obtener todos los jobsites
      final result = await getJobsites();
      
      if (result.isSuccess && result.data != null) {
        // Filtrar por suburbio
        final filteredJobsites = result.data!.getJobsitesBySuburb(suburb);
        
        return ApiResult<List<DtoReceiveJobsite>>.success(filteredJobsites);
      }
      
      return ApiResult<List<DtoReceiveJobsite>>.error(
        message: result.message ?? 'Unknown error getting jobsites',
        error: result.error,
      );
    } catch (e) {
      return ApiResult<List<DtoReceiveJobsite>>.error(
        message: 'Error getting jobsites by suburb $suburb: $e',
        error: e,
      );
    }
  }

  /// Obtiene los jobsites por builder ID
  /// 
  /// [builderId] - ID del builder para filtrar los jobsites
  /// Retorna un [ApiResult] con los jobsites filtrados por builder
  Future<ApiResult<List<DtoReceiveJobsite>>> getJobsitesByBuilderId(String builderId) async {
    try {
      // Obtener todos los jobsites
      final result = await getJobsites();
      
      if (result.isSuccess && result.data != null) {
        // Filtrar por builder ID
        final filteredJobsites = result.data!.getJobsitesByBuilderId(builderId);
        
        return ApiResult<List<DtoReceiveJobsite>>.success(filteredJobsites);
      }
      
      return ApiResult<List<DtoReceiveJobsite>>.error(
        message: result.message ?? 'Unknown error getting jobsites',
        error: result.error,
      );
    } catch (e) {
      return ApiResult<List<DtoReceiveJobsite>>.error(
        message: 'Error getting jobsites by builder ID $builderId: $e',
        error: e,
      );
    }
  }

  /// Obtiene los jobsites de Sydney
  /// 
  /// Retorna un [ApiResult] con los jobsites de Sydney
  Future<ApiResult<List<DtoReceiveJobsite>>> getSydneyJobsites() async {
    return getJobsitesBySuburb('Sydney');
  }

  /// Obtiene los jobsites de Melbourne
  /// 
  /// Retorna un [ApiResult] con los jobsites de Melbourne
  Future<ApiResult<List<DtoReceiveJobsite>>> getMelbourneJobsites() async {
    return getJobsitesBySuburb('Melbourne');
  }

  /// Obtiene los jobsites de Brisbane
  /// 
  /// Retorna un [ApiResult] con los jobsites de Brisbane
  Future<ApiResult<List<DtoReceiveJobsite>>> getBrisbaneJobsites() async {
    return getJobsitesBySuburb('Brisbane');
  }

  /// Obtiene los jobsites de Perth
  /// 
  /// Retorna un [ApiResult] con los jobsites de Perth
  Future<ApiResult<List<DtoReceiveJobsite>>> getPerthJobsites() async {
    return getJobsitesBySuburb('Perth');
  }

  /// Obtiene un jobsite específico por ID
  /// 
  /// [jobsiteId] - ID del jobsite a buscar
  /// Retorna un [ApiResult] con el jobsite encontrado o null
  Future<ApiResult<DtoReceiveJobsite?>> getJobsiteById(String jobsiteId) async {
    try {
      // Obtener todos los jobsites
      final result = await getJobsites();
      
      if (result.isSuccess && result.data != null) {
        // Buscar por ID
        final jobsite = result.data!.getJobsiteById(jobsiteId);
        
        return ApiResult<DtoReceiveJobsite?>.success(jobsite);
      }
      
      return ApiResult<DtoReceiveJobsite?>.error(
        message: result.message ?? 'Unknown error getting jobsite',
        error: result.error,
      );
    } catch (e) {
      return ApiResult<DtoReceiveJobsite?>.error(
        message: 'Error getting jobsite by ID $jobsiteId: $e',
        error: e,
      );
    }
  }

  /// Obtiene un jobsite específico por ID directamente del API
  /// 
  /// [jobsiteId] - ID del jobsite a buscar
  /// Retorna un [ApiResult] con el jobsite encontrado
  Future<ApiResult<DtoReceiveJobsite>> getJobsiteByIdDirect(String jobsiteId) async {
    try {
      // Llamar al servicio para obtener el jobsite por ID
      final result = await _serviceJobsites.getJobsiteById(jobsiteId);
      
      return result;
    } catch (e) {
      return ApiResult<DtoReceiveJobsite>.error(
        message: 'Error in use case getting jobsite by ID: $e',
        error: e,
      );
    }
  }

  /// Crea un nuevo jobsite
  /// 
  /// [jobsiteData] - Datos del jobsite a crear
  /// Retorna un [ApiResult] con el jobsite creado
  Future<ApiResult<DtoReceiveJobsite>> createJobsite(DtoSendJobsite jobsiteData) async {
    try {
      // Llamar al servicio para crear el jobsite
      final result = await _serviceJobsites.createJobsite(jobsiteData);
      
      return result;
    } catch (e) {
      return ApiResult<DtoReceiveJobsite>.error(
        message: 'Error in use case creating jobsite: $e',
        error: e,
      );
    }
  }
}
