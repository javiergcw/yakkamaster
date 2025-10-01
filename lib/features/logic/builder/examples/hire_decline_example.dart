import '../use_case/applicants_use_case.dart';

/// Ejemplo de uso de los endpoints de hire y decline
class HireDeclineExample {
  final ApplicantsUseCase _applicantsUseCase = ApplicantsUseCase();

  /// Ejemplo de cómo contratar un applicant
  Future<void> exampleHireApplicant() async {
    print('=== Ejemplo: Contratar Applicant ===');
    
    try {
      const applicationId = 'ab329a18-d216-4521-8365-75f0499b82cf';
      const startDate = '2025-10-01T00:00:00Z';
      const endDate = '2025-12-31T23:59:59Z';
      const reason = 'Excelente experiencia en construcción';
      
      print('📋 Datos de contratación:');
      print('  - Application ID: $applicationId');
      print('  - Start Date: $startDate');
      print('  - End Date: $endDate');
      print('  - Reason: $reason');
      
      // Contratar applicant
      final result = await _applicantsUseCase.hireApplicant(
        applicationId: applicationId,
        startDate: startDate,
        endDate: endDate,
        reason: reason,
      );
      
      if (result.isSuccess && result.data != null) {
        final response = result.data!;
        print('✅ Applicant contratado exitosamente:');
        print('  - Application ID: ${response.applicationId}');
        print('  - Hired: ${response.hired}');
        print('  - Assignment ID: ${response.assignmentId}');
        print('  - Message: ${response.message}');
        
        if (response.hasAssignmentId) {
          print('🎯 Assignment ID generado: ${response.assignmentId}');
        }
      } else {
        print('❌ Error contratando applicant: ${result.message}');
      }
    } catch (e) {
      print('❌ Excepción: $e');
    }
  }

  /// Ejemplo de cómo rechazar un applicant
  Future<void> exampleDeclineApplicant() async {
    print('\n=== Ejemplo: Rechazar Applicant ===');
    
    try {
      const applicationId = '86dd1e80-4da5-4399-942a-ddec8484a86b';
      const reason = 'No cumple con los requisitos del puesto';
      
      print('📋 Datos de rechazo:');
      print('  - Application ID: $applicationId');
      print('  - Reason: $reason');
      
      // Rechazar applicant
      final result = await _applicantsUseCase.declineApplicant(
        applicationId: applicationId,
        reason: reason,
      );
      
      if (result.isSuccess && result.data != null) {
        final response = result.data!;
        print('✅ Applicant rechazado exitosamente:');
        print('  - Application ID: ${response.applicationId}');
        print('  - Hired: ${response.hired}');
        print('  - Message: ${response.message}');
        
        if (response.isDeclined) {
          print('🚫 Applicant rechazado correctamente');
        }
      } else {
        print('❌ Error rechazando applicant: ${result.message}');
      }
    } catch (e) {
      print('❌ Excepción: $e');
    }
  }

  /// Ejemplo de validación de fechas
  Future<void> exampleValidateDates() async {
    print('\n=== Ejemplo: Validación de Fechas ===');
    
    try {
      const validStartDate = '2025-10-01T00:00:00Z';
      const validEndDate = '2025-12-31T23:59:59Z';
      const invalidStartDate = '2025-12-31T23:59:59Z';
      const invalidEndDate = '2025-10-01T00:00:00Z';
      
      print('📅 Validando fechas:');
      
      // Fechas válidas
      final validDates = _applicantsUseCase.validateHireDates(validStartDate, validEndDate);
      print('  - Fechas válidas ($validStartDate -> $validEndDate): $validDates');
      
      // Fechas inválidas
      final invalidDates = _applicantsUseCase.validateHireDates(invalidStartDate, invalidEndDate);
      print('  - Fechas inválidas ($invalidStartDate -> $invalidEndDate): $invalidDates');
      
      // Crear DTOs de decisión
      final hireDecision = _applicantsUseCase.createHireDecision(
        applicationId: 'test-id',
        startDate: validStartDate,
        endDate: validEndDate,
        reason: 'Test reason',
      );
      
      print('  - DTO válido: ${hireDecision.isValid}');
      print('  - Errores de validación: ${hireDecision.validationErrors}');
      
    } catch (e) {
      print('❌ Error: $e');
    }
  }

  /// Ejemplo de estadísticas de decisiones
  Future<void> exampleDecisionStats() async {
    print('\n=== Ejemplo: Estadísticas de Decisiones ===');
    
    try {
      const totalApplicants = 10;
      const hiredCount = 3;
      const declinedCount = 2;
      
      final stats = _applicantsUseCase.getDecisionStats(
        totalApplicants: totalApplicants,
        hiredCount: hiredCount,
        declinedCount: declinedCount,
      );
      
      print('📊 Estadísticas de decisiones:');
      stats.forEach((key, value) {
        print('  - $key: $value');
      });
      
      print('\n📈 Resumen:');
      print('  - Total applicants: ${stats['totalApplicants']}');
      print('  - Contratados: ${stats['hiredCount']} (${stats['hireRate']}%)');
      print('  - Rechazados: ${stats['declinedCount']} (${stats['declineRate']}%)');
      print('  - Pendientes: ${stats['pendingCount']}');
      
    } catch (e) {
      print('❌ Error: $e');
    }
  }

  /// Ejemplo completo de flujo de decisión
  Future<void> exampleCompleteDecisionFlow() async {
    print('\n=== Ejemplo: Flujo Completo de Decisión ===');
    
    try {
      // Simular datos de applicants
      final applicants = [
        {'id': 'app1', 'name': 'Juan Pérez', 'status': 'pending'},
        {'id': 'app2', 'name': 'María García', 'status': 'pending'},
        {'id': 'app3', 'name': 'Carlos López', 'status': 'pending'},
      ];
      
      print('👥 Applicants iniciales:');
      for (final applicant in applicants) {
        print('  - ${applicant['name']} (${applicant['id']}): ${applicant['status']}');
      }
      
      // Contratar primer applicant
      print('\n🎯 Contratando primer applicant...');
      final hireResult = await _applicantsUseCase.hireApplicant(
        applicationId: 'app1',
        startDate: '2025-10-01T00:00:00Z',
        endDate: '2025-12-31T23:59:59Z',
        reason: 'Excelente experiencia',
      );
      
      if (hireResult.isSuccess) {
        print('✅ Juan Pérez contratado exitosamente');
        applicants[0]['status'] = 'hired';
      }
      
      // Rechazar segundo applicant
      print('\n🚫 Rechazando segundo applicant...');
      final declineResult = await _applicantsUseCase.declineApplicant(
        applicationId: 'app2',
        reason: 'No cumple requisitos',
      );
      
      if (declineResult.isSuccess) {
        print('✅ María García rechazada exitosamente');
        applicants[1]['status'] = 'declined';
      }
      
      // Mostrar estado final
      print('\n📋 Estado final de applicants:');
      for (final applicant in applicants) {
        print('  - ${applicant['name']} (${applicant['id']}): ${applicant['status']}');
      }
      
      // Calcular estadísticas
      final hiredCount = applicants.where((a) => a['status'] == 'hired').length;
      final declinedCount = applicants.where((a) => a['status'] == 'declined').length;
      
      final stats = _applicantsUseCase.getDecisionStats(
        totalApplicants: applicants.length,
        hiredCount: hiredCount,
        declinedCount: declinedCount,
      );
      
      print('\n📊 Estadísticas finales:');
      print('  - Contratados: ${stats['hiredCount']} (${stats['hireRate']}%)');
      print('  - Rechazados: ${stats['declinedCount']} (${stats['declineRate']}%)');
      print('  - Pendientes: ${stats['pendingCount']}');
      
    } catch (e) {
      print('❌ Error en flujo completo: $e');
    }
  }
}
