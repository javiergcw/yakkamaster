import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_flavor.dart';
import '../../data/dto/job_details_dto.dart';
import '../../../../features/logic/builder/models/receive/dto_receive_job.dart';
import '../../../../features/logic/builder/use_case/jobs_use_case.dart';
import '../../presentation/pages/job_details_screen.dart';

class JobDetailsScreenController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final RxBool hasApplied = false.obs;
  final RxBool showSuccessModal = false.obs;
  final Rx<JobDetailsDto?> jobDetails = Rx<JobDetailsDto?>(null);
  final Rx<DtoReceiveJob?> realJob = Rx<DtoReceiveJob?>(null);
  final RxBool isFromAppliedJobs = false.obs;
  final RxBool isFromBuilder = false.obs;
  
  // Estados de carga
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  // Caso de uso para jobs
  final JobsUseCase _jobsUseCase = JobsUseCase();

  // Variable para activar/desactivar la verificación bancaria
  static const bool enableBankVerification = false; // Cambiar a false para desactivar

  @override
  void onInit() {
    super.onInit();
    
    // Procesar argumentos inmediatamente
    processArguments();
  }

  /// Procesa los argumentos pasados a la pantalla
  void processArguments() {
    final arguments = Get.arguments;
    print('JobDetailsScreenController._processArguments - Arguments: $arguments');
    
    if (arguments != null) {
      if (arguments['jobDetails'] != null) {
        jobDetails.value = arguments['jobDetails'];
        print('JobDetailsScreenController._processArguments - jobDetails set: ${jobDetails.value?.id}');
      }
      if (arguments['realJob'] != null) {
        realJob.value = arguments['realJob'];
        print('JobDetailsScreenController._processArguments - realJob set: ${realJob.value?.id}');
      }
      if (arguments['jobId'] != null) {
        // Cargar datos del job desde el API usando el ID
        loadJobDetails(arguments['jobId']);
        print('JobDetailsScreenController._processArguments - jobId set: ${arguments['jobId']}');
      }
      if (arguments['flavor'] != null) {
        currentFlavor.value = arguments['flavor'];
        print('JobDetailsScreenController._processArguments - flavor set: ${currentFlavor.value}');
      }
      if (arguments['isFromAppliedJobs'] != null) {
        isFromAppliedJobs.value = arguments['isFromAppliedJobs'];
        // Si viene de trabajos aplicados, marcar como ya aplicado
        hasApplied.value = arguments['isFromAppliedJobs'];
        print('JobDetailsScreenController._processArguments - isFromAppliedJobs set: ${isFromAppliedJobs.value}');
      }
      if (arguments['isFromBuilder'] != null) {
        isFromBuilder.value = arguments['isFromBuilder'];
        print('JobDetailsScreenController._processArguments - isFromBuilder set: ${isFromBuilder.value}');
      }
      // Verificar si hay información de aplicación en los argumentos
      if (arguments['hasApplied'] != null) {
        hasApplied.value = arguments['hasApplied'];
        print('JobDetailsScreenController._processArguments - hasApplied set: ${hasApplied.value}');
      }
    }
  }

  // Función para verificar si el usuario tiene datos bancarios configurados
  bool hasBankDetails() {
    // TODO: Implementar verificación real de datos bancarios
    // Por ahora, simulamos que no tiene datos bancarios para probar el flujo
    return false; // Cambiar a true cuando tenga datos bancarios reales
  }

  /// Carga los detalles del job desde el API usando el ID
  Future<void> loadJobDetails(String jobId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      print('JobDetailsScreenController.loadJobDetails - Loading job: $jobId');
      
      // Llamar al caso de uso para obtener los detalles del job
      final result = await _jobsUseCase.getJobById(jobId);
      
      if (result.isSuccess && result.data != null) {
        print('JobDetailsScreenController.loadJobDetails - Job details loaded successfully');
        
        // Establecer los datos del job
        realJob.value = result.data!;
        
        // Mapear a JobDetailsDto
        jobDetails.value = convertRealJobToJobDetailsDto(realJob.value!);
        
        // Determinar estado de aplicación (DtoReceiveJob del builder no tiene application)
        hasApplied.value = false; // Por defecto, no aplicado
        
        print('JobDetailsScreenController.loadJobDetails - hasApplied: ${hasApplied.value}');
        print('JobDetailsScreenController.loadJobDetails - job title: ${jobDetails.value?.title}');
        print('JobDetailsScreenController.loadJobDetails - job hourly rate: ${jobDetails.value?.hourlyRate}');
      } else {
        errorMessage.value = result.message ?? 'Error loading job details';
        print('JobDetailsScreenController.loadJobDetails - Error: ${result.message}');
      }
    } catch (e) {
      errorMessage.value = 'Error loading job details: $e';
      print('JobDetailsScreenController.loadJobDetails - Error loading job details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Convierte DtoReceiveJob a JobDetailsDto
  JobDetailsDto convertRealJobToJobDetailsDto(DtoReceiveJob realJobData) {
    // Crear título con skill + número de labours (igual que en builder)
    final skillName = _getSkillName(realJobData);
    final title = '${skillName} x${realJobData.manyLabours}';
    
    return JobDetailsDto(
      id: realJobData.id,
      title: title,
      hourlyRate: realJobData.totalWage ?? _calculateHourlyRateFromRealJob(realJobData),
      location: realJobData.jobsite?.address ?? 'Job Site ${realJobData.id.substring(0, 8)}...',
      dateRange: '${_formatDateFromString(realJobData.startDateWork)} - ${_formatDateFromString(realJobData.endDateWork)}',
      jobType: realJobData.jobType?.name ?? _getJobTypeDisplayFromRealJob(realJobData),
      source: realJobData.builderProfile?.displayName ?? 'Builder Company',
      postedDate: _formatDateFromString(realJobData.createdAt),
      company: realJobData.builderProfile?.displayName ?? 'Builder Company',
      address: realJobData.jobsite?.address ?? 'Job Site ${realJobData.id.substring(0, 8)}...',
      suburb: realJobData.jobsite?.suburb ?? 'Construction Site',
      city: realJobData.jobsite?.address.split(',').last.trim() ?? 'Sydney',
      startDate: _formatDateFromString(realJobData.startDateWork),
      time: '${realJobData.startTime} - ${realJobData.endTime}',
      paymentExpected: _getPaymentExpectedFromRealJob(realJobData),
      aboutJob: _getAboutJobDescriptionFromRealJob(realJobData),
      requirements: _getJobRequirementsFromRealJob(realJobData),
      latitude: realJobData.jobsite?.latitude ?? -33.8688,
      longitude: realJobData.jobsite?.longitude ?? 151.2093,
      // Datos de salarios reales del API
      wageSiteAllowance: realJobData.wageSiteAllowance,
      wageLeadingHandAllowance: realJobData.wageLeadingHandAllowance,
      wageProductivityAllowance: realJobData.wageProductivityAllowance,
      extrasOvertimeRate: realJobData.extrasOvertimeRate,
      wageHourlyRate: realJobData.wageHourlyRate,
      travelAllowance: realJobData.travelAllowance,
      gst: realJobData.gst,
    );
  }

  void handleBackNavigation() {
    Get.back();
  }

  void handleApply() {
    // Verificar si el usuario tiene datos bancarios configurados (solo si está habilitado)
    if (enableBankVerification && !hasBankDetails()) {
      // Mostrar diálogo para configurar datos bancarios
      showBankDetailsDialog();
      return;
    }
    
    // Si tiene datos bancarios o la verificación está deshabilitada, proceder con la aplicación
    hasApplied.value = true;
    showSuccessModal.value = true;
    print('Apply for job: ${jobDetails.value?.title}');
  }

  void showBankDetailsDialog() {
    final double screenWidth = Get.width;
    final double screenHeight = Get.height;
    
    // Calcular tamaños responsive
    final dialogWidth = screenWidth * 0.85;
    final titleFontSize = screenWidth * 0.045;
    final bodyFontSize = screenWidth * 0.035;
    final buttonFontSize = screenWidth * 0.035;
    
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: dialogWidth,
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.4,
          ),
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icono y título
              Container(
                width: screenWidth * 0.12,
                height: screenWidth * 0.12,
                decoration: BoxDecoration(
                  color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.account_balance,
                  color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                  size: screenWidth * 0.06,
                ),
              ),
              
              SizedBox(height: screenHeight * 0.02),
              
              // Título
              Text(
                'Bank Details Required',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              
              SizedBox(height: screenHeight * 0.015),
              
              // Mensaje
              Text(
                'You need to configure your bank details before applying for this job. This ensures you can receive payments.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: bodyFontSize,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              
              SizedBox(height: screenHeight * 0.025),
              
              // Botones
              Row(
                children: [
                  // Botón Cancel
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: Colors.grey[400]!,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(width: screenWidth * 0.03),
                  
                  // Botón Configure Now
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.toNamed('/labour/edit-bank-details');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                        foregroundColor: Colors.black87,
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Configure Now',
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void handleCloseModal() {
    showSuccessModal.value = false;
  }

  void handleViewAppliedJobs() {
    // TODO: Navegar a la pantalla de trabajos aplicados
    print('Navigate to applied jobs');
    handleCloseModal();
    Get.toNamed('/labour/applied-jobs');
  }

  void handleReportJob() {
    // TODO: Implementar lógica de reporte
    print('Report job: ${jobDetails.value?.title}');
  }

  // Métodos helper para mapeo de datos
  String _getSkillName(DtoReceiveJob job) {
    print('JobDetailsScreenController - _getSkillName - jobSkills.length: ${job.jobSkills.length}');
    
    if (job.jobSkills.isNotEmpty) {
      final firstSkill = job.jobSkills.first;
      print('JobDetailsScreenController - _getSkillName - firstSkill: ${firstSkill.toString()}');
      
      if (firstSkill.skillSubcategory != null) {
        print('JobDetailsScreenController - _getSkillName - skillSubcategory: ${firstSkill.skillSubcategory!.name}');
        return firstSkill.skillSubcategory!.name;
      }
      if (firstSkill.skillCategory != null) {
        print('JobDetailsScreenController - _getSkillName - skillCategory: ${firstSkill.skillCategory!.name}');
        return firstSkill.skillCategory!.name;
      }
    }
    
    // Si no hay skills, usar el jobType como fallback
    if (job.jobType != null && job.jobType!.name.isNotEmpty) {
      print('JobDetailsScreenController - _getSkillName - jobType: ${job.jobType!.name}');
      return job.jobType!.name;
    }
    
    if (job.description.isNotEmpty) {
      print('JobDetailsScreenController - _getSkillName - description: ${job.description}');
      return job.description;
    }
    
    print('JobDetailsScreenController - _getSkillName - fallback: Skill');
    return 'Skill';
  }

  double _calculateHourlyRateFromRealJob(DtoReceiveJob realJobData) {
    double baseRate = realJobData.wageSiteAllowance;
    if (realJobData.wageHourlyRate != null && realJobData.wageHourlyRate! > 0) {
      baseRate = realJobData.wageHourlyRate!;
    }
    return baseRate;
  }

  String _getJobTypeDisplayFromRealJob(DtoReceiveJob realJobData) {
    if (realJobData.ongoingWork) {
      return 'Ongoing Work';
    } else {
      return 'Fixed Term';
    }
  }

  String _getPaymentExpectedFromRealJob(DtoReceiveJob realJobData) {
    switch (realJobData.paymentType) {
      case 'WEEKLY':
        return 'Weekly payment';
      case 'FIXED_DAY':
        return 'Payment on day ${realJobData.paymentDay} of month';
      default:
        return realJobData.paymentType;
    }
  }

  String _getAboutJobDescriptionFromRealJob(DtoReceiveJob realJobData) {
    String description = realJobData.description.isNotEmpty 
        ? realJobData.description 
        : 'Construction work position';
    
    String additionalInfo = '';
    if (realJobData.ongoingWork) {
      additionalInfo += ' This is an ongoing work position.';
    }
    if (realJobData.workSaturday || realJobData.workSunday) {
      additionalInfo += ' Weekend work may be required.';
    }
    
    return description + additionalInfo;
  }

  List<String> _getJobRequirementsFromRealJob(DtoReceiveJob realJobData) {
    print('JobDetailsScreenController - _getJobRequirementsFromRealJob - jobRequirements.length: ${realJobData.jobRequirements.length}');
    print('JobDetailsScreenController - _getJobRequirementsFromRealJob - jobLicenses.length: ${realJobData.jobLicenses.length}');
    
    List<String> requirements = [
      'Workers needed: ${realJobData.manyLabours}',
      'Work schedule: ${realJobData.startTime} - ${realJobData.endTime}',
      'Work days: ${_getWorkDaysFromRealJob(realJobData)}',
    ];

    // Agregar requisitos del API
    for (final requirement in realJobData.jobRequirements) {
      print('JobDetailsScreenController - _getJobRequirementsFromRealJob - requirement: ${requirement.name}, isActive: ${requirement.isActive}');
      if (requirement.isActive) {
        requirements.add(requirement.name);
      }
    }

    // Agregar licencias requeridas
    for (final license in realJobData.jobLicenses) {
      print('JobDetailsScreenController - _getJobRequirementsFromRealJob - license: ${license.license.name}');
      requirements.add('License required: ${license.license.name}');
    }

    if (realJobData.requiresSupervisorSignature) {
      requirements.add('Supervisor signature required');
      if (realJobData.supervisorName.isNotEmpty) {
        requirements.add('Supervisor: ${realJobData.supervisorName}');
      }
    }

    if (realJobData.wageLeadingHandAllowance > 0) {
      requirements.add('Leading hand allowance: \$${realJobData.wageLeadingHandAllowance.toStringAsFixed(2)}');
    }
    if (realJobData.wageProductivityAllowance > 0) {
      requirements.add('Productivity allowance: \$${realJobData.wageProductivityAllowance.toStringAsFixed(2)}');
    }
    if (realJobData.extrasOvertimeRate > 0) {
      requirements.add('Overtime rate: ${realJobData.extrasOvertimeRate}x');
    }
    if (realJobData.travelAllowance != null && realJobData.travelAllowance! > 0) {
      requirements.add('Travel allowance: \$${realJobData.travelAllowance!.toStringAsFixed(2)}');
    }

    print('JobDetailsScreenController - _getJobRequirementsFromRealJob - final requirements: $requirements');
    return requirements;
  }

  String _getWorkDaysFromRealJob(DtoReceiveJob realJobData) {
    List<String> days = ['Monday-Friday'];
    if (realJobData.workSaturday) days.add('Saturday');
    if (realJobData.workSunday) days.add('Sunday');
    return days.join(', ');
  }

  String _formatDateFromString(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString; // Retornar el string original si no se puede parsear
    }
  }

  /// Construye el JobDetailsScreen
  Widget buildJobDetailsScreen({
    AppFlavor? flavor,
    bool isFromAppliedJobs = false,
    bool isFromBuilder = false,
  }) {
    // Retornar la pantalla directamente
    return JobDetailsScreen(
      flavor: flavor,
      isFromAppliedJobs: isFromAppliedJobs,
      isFromBuilder: isFromBuilder,
    );
  }
}
