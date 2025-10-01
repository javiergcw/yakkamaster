import '../models/receive/dto_receive_builder_applicants_response.dart';
import '../models/send/dto_send_hire_decision.dart';
import '../models/receive/dto_receive_hire_response.dart';
import '../models/receive/dto_receive_decline_response.dart';
import '../services/service_builder_applicants.dart';
import '../../../../utils/response_handler.dart';

/// Caso de uso para operaciones de applicants del builder
class ApplicantsUseCase {
  final ServiceBuilderApplicants _serviceBuilderApplicants = ServiceBuilderApplicants();

  /// Obtiene todos los applicants del builder
  Future<ApiResult<DtoReceiveBuilderApplicantsResponse>> getApplicants() async {
    try {
      print('ApplicantsUseCase.getApplicants - Starting...');
      
      final result = await _serviceBuilderApplicants.getApplicants();
      
      if (result.isSuccess && result.data != null) {
        print('ApplicantsUseCase.getApplicants - Applicants retrieved successfully: ${result.data!.total} total applicants across ${result.data!.jobsites.length} jobsites');
        print('ApplicantsUseCase.getApplicants - Message: ${result.data!.message}');
      } else {
        print('ApplicantsUseCase.getApplicants - Error getting applicants: ${result.message}');
      }

      return result;
    } catch (e) {
      print('ApplicantsUseCase.getApplicants - Exception: $e');
      return ApiResult<DtoReceiveBuilderApplicantsResponse>.error(
        message: 'Error in getApplicants use case: $e',
        error: e,
      );
    }
  }

  /// Obtiene el total de applicants
  int getTotalApplicants(DtoReceiveBuilderApplicantsResponse response) {
    return response.total;
  }

  /// Obtiene el número de jobsites
  int getJobsitesCount(DtoReceiveBuilderApplicantsResponse response) {
    return response.jobsites.length;
  }

  /// Obtiene el número total de jobs
  int getTotalJobs(DtoReceiveBuilderApplicantsResponse response) {
    int totalJobs = 0;
    for (final jobsite in response.jobsites) {
      totalJobs += jobsite.jobs.length;
    }
    return totalJobs;
  }

  /// Obtiene el número total de aplicaciones
  int getTotalApplications(DtoReceiveBuilderApplicantsResponse response) {
    int totalApplications = 0;
    for (final jobsite in response.jobsites) {
      for (final job in jobsite.jobs) {
        totalApplications += job.applicants.length;
      }
    }
    return totalApplications;
  }

  /// Filtra applicants por status
  List<DtoReceiveBuilderApplicantsResponse> filterApplicantsByStatus(
    DtoReceiveBuilderApplicantsResponse response, 
    String status
  ) {
    // Esta función podría ser expandida para filtrar por status específico
    // Por ahora, retorna la respuesta completa
    return [response];
  }

  /// Obtiene applicants de un jobsite específico
  List<dynamic> getApplicantsByJobsite(
    DtoReceiveBuilderApplicantsResponse response, 
    String jobsiteId
  ) {
    final jobsite = response.jobsites.firstWhere(
      (js) => js.jobsiteId == jobsiteId,
      orElse: () => throw Exception('Jobsite not found'),
    );
    
    List<dynamic> allApplicants = [];
    for (final job in jobsite.jobs) {
      allApplicants.addAll(job.applicants);
    }
    
    return allApplicants;
  }

  /// Obtiene applicants de un job específico
  List<dynamic> getApplicantsByJob(
    DtoReceiveBuilderApplicantsResponse response, 
    String jobId
  ) {
    for (final jobsite in response.jobsites) {
      for (final job in jobsite.jobs) {
        if (job.jobId == jobId) {
          return job.applicants;
        }
      }
    }
    
    return [];
  }

  /// Contrata un applicant
  Future<ApiResult<DtoReceiveHireResponse>> hireApplicant({
    required String applicationId,
    String? startDate,
    String? endDate,
    String? reason,
  }) async {
    try {
      print('ApplicantsUseCase.hireApplicant - Iniciando contratación...');
      print('  - Application ID: $applicationId');
      print('  - Start Date: $startDate');
      print('  - End Date: $endDate');
      print('  - Reason: $reason');
      
      // Crear DTO de decisión de contratación
      final hireDecision = DtoSendHireDecision.hire(
        applicationId: applicationId,
        startDate: startDate,
        endDate: endDate,
        reason: reason,
      );
      
      // Validar datos
      if (!hireDecision.isValid) {
        print('ApplicantsUseCase.hireApplicant - Datos inválidos: ${hireDecision.validationErrors}');
        return ApiResult<DtoReceiveHireResponse>.error(
          message: 'Invalid hire decision data. Errors: ${hireDecision.validationErrors.join(', ')}',
        );
      }
      
      // Llamar al servicio
      final result = await _serviceBuilderApplicants.hireApplicant(hireDecision);
      
      if (result.isSuccess && result.data != null) {
        print('ApplicantsUseCase.hireApplicant - Applicant contratado exitosamente:');
        print('  - Application ID: ${result.data!.applicationId}');
        print('  - Assignment ID: ${result.data!.assignmentId}');
        print('  - Message: ${result.data!.message}');
      } else {
        print('ApplicantsUseCase.hireApplicant - Error contratando applicant: ${result.message}');
      }
      
      return result;
    } catch (e) {
      print('ApplicantsUseCase.hireApplicant - Excepción: $e');
      return ApiResult<DtoReceiveHireResponse>.error(
        message: 'Error in hireApplicant use case: $e',
        error: e,
      );
    }
  }

  /// Rechaza un applicant
  Future<ApiResult<DtoReceiveDeclineResponse>> declineApplicant({
    required String applicationId,
    String? reason,
  }) async {
    try {
      print('ApplicantsUseCase.declineApplicant - Iniciando rechazo...');
      print('  - Application ID: $applicationId');
      print('  - Reason: $reason');
      
      // Crear DTO de decisión de rechazo
      final declineDecision = DtoSendHireDecision.decline(
        applicationId: applicationId,
        reason: reason,
      );
      
      // Validar datos
      if (!declineDecision.isValid) {
        print('ApplicantsUseCase.declineApplicant - Datos inválidos: ${declineDecision.validationErrors}');
        return ApiResult<DtoReceiveDeclineResponse>.error(
          message: 'Invalid decline decision data. Errors: ${declineDecision.validationErrors.join(', ')}',
        );
      }
      
      // Llamar al servicio
      final result = await _serviceBuilderApplicants.declineApplicant(declineDecision);
      
      if (result.isSuccess && result.data != null) {
        print('ApplicantsUseCase.declineApplicant - Applicant rechazado exitosamente:');
        print('  - Application ID: ${result.data!.applicationId}');
        print('  - Message: ${result.data!.message}');
      } else {
        print('ApplicantsUseCase.declineApplicant - Error rechazando applicant: ${result.message}');
      }
      
      return result;
    } catch (e) {
      print('ApplicantsUseCase.declineApplicant - Excepción: $e');
      return ApiResult<DtoReceiveDeclineResponse>.error(
        message: 'Error in declineApplicant use case: $e',
        error: e,
      );
    }
  }

  /// Crea un DTO de decisión de contratación con fechas
  DtoSendHireDecision createHireDecision({
    required String applicationId,
    String? startDate,
    String? endDate,
    String? reason,
  }) {
    return DtoSendHireDecision.hire(
      applicationId: applicationId,
      startDate: startDate,
      endDate: endDate,
      reason: reason,
    );
  }

  /// Crea un DTO de decisión de rechazo
  DtoSendHireDecision createDeclineDecision({
    required String applicationId,
    String? reason,
  }) {
    return DtoSendHireDecision.decline(
      applicationId: applicationId,
      reason: reason,
    );
  }

  /// Valida fechas de contratación
  bool validateHireDates(String? startDate, String? endDate) {
    if (startDate == null || endDate == null) return true;
    
    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);
      return start.isBefore(end);
    } catch (e) {
      return false;
    }
  }

  /// Obtiene estadísticas de decisiones
  Map<String, dynamic> getDecisionStats({
    required int totalApplicants,
    required int hiredCount,
    required int declinedCount,
  }) {
    final pendingCount = totalApplicants - hiredCount - declinedCount;
    
    return {
      'totalApplicants': totalApplicants,
      'hiredCount': hiredCount,
      'declinedCount': declinedCount,
      'pendingCount': pendingCount,
      'hireRate': totalApplicants > 0 ? (hiredCount / totalApplicants * 100).toStringAsFixed(1) : '0.0',
      'declineRate': totalApplicants > 0 ? (declinedCount / totalApplicants * 100).toStringAsFixed(1) : '0.0',
    };
  }
}
