import '../../../../utils/response_handler.dart';
import '../services/service_builder_applicants.dart';
import '../models/receive/dto_receive_builder_applicants_response.dart';

/// Caso de uso para operaciones de aplicantes del builder
class BuilderApplicantsUseCase {
  static final BuilderApplicantsUseCase _instance = BuilderApplicantsUseCase._internal();
  factory BuilderApplicantsUseCase() => _instance;
  BuilderApplicantsUseCase._internal();

  final ServiceBuilderApplicants _serviceBuilderApplicants = ServiceBuilderApplicants();

  /// Obtiene los aplicantes de los trabajos del builder
  /// 
  /// Retorna un [ApiResult] con la lista de trabajos y sus aplicantes
  Future<ApiResult<DtoReceiveBuilderApplicantsResponse>> getApplicants() async {
    try {
      print('BuilderApplicantsUseCase.getApplicants - Getting applicants');

      // Llamar al servicio
      final result = await _serviceBuilderApplicants.getApplicants();
      
      if (result.isSuccess) {
        print('BuilderApplicantsUseCase.getApplicants - Success: ${result.data?.total} total applicants');
      } else {
        print('BuilderApplicantsUseCase.getApplicants - Error: ${result.message}');
      }
      
      return result;
    } catch (e) {
      print('BuilderApplicantsUseCase.getApplicants - Error: $e');
      return ApiResult<DtoReceiveBuilderApplicantsResponse>.error(
        message: 'Error in use case getting applicants: $e',
        error: e,
      );
    }
  }
}
