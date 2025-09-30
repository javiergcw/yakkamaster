import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../../../job_listings/data/dto/job_details_dto.dart';
import '../../../../job_listings/presentation/widgets/job_map.dart';
import '../../../../job_listings/presentation/widgets/application_success_modal.dart';
import '../../../logic/controllers/labour_job_details_controller.dart';

/*
 * CONFIGURACIÓN DE VERIFICACIÓN BANCARIA EN LABOUR JOB DETAILS:
 * 
 * Para activar/desactivar la verificación de datos bancarios antes de aplicar:
 * - Cambiar _enableBankVerification a true: El usuario debe configurar datos bancarios antes de aplicar
 * - Cambiar _enableBankVerification a false: El usuario puede aplicar sin verificación bancaria
 * 
 * Para simular que el usuario tiene datos bancarios configurados:
 * - Cambiar _hasBankDetails() para retornar true
 */

class LabourJobDetailsScreen extends StatelessWidget {
  static const String id = '/labour-job-details';
  
  final AppFlavor? flavor;
  final bool isFromAppliedJobs;

  LabourJobDetailsScreen({
    super.key,
    this.flavor,
    this.isFromAppliedJobs = false,
  });

  final LabourJobDetailsController controller = Get.put(LabourJobDetailsController());

  // Método para obtener los datos del job desde los argumentos o controlador
  JobDetailsDto _getJobDataFromController() {
    // Primero intentar obtener datos de los argumentos (igual que builder)
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments['jobDetails'] != null) {
      print('LabourJobDetailsScreen - Using jobDetails from arguments: ${arguments['jobDetails'].id}');
      return arguments['jobDetails'] as JobDetailsDto;
    }
    
    // Si no hay argumentos, usar el controlador (fallback)
    if (controller.isJobLoaded) {
      print('LabourJobDetailsScreen - Using controller job data: ${controller.job?.id}');
      return controller.convertToJobDetailsDto();
    } else {
      throw Exception('No job data available - should be passed as arguments');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Debug: Verificar datos del controlador
    print('LabourJobDetailsScreen - Loading job details for labour');
    print('LabourJobDetailsScreen - Controller: ${controller.runtimeType}');
    
    // Verificar si hay datos en los argumentos (modo principal)
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments['jobDetails'] != null) {
      print('LabourJobDetailsScreen - Using jobDetails from arguments');
      // No necesitamos cargar datos desde la API, ya los tenemos
      return _buildMainContent(context, arguments);
    } else {
      // Solo cargar desde API si no hay argumentos (modo fallback)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (arguments != null && arguments['jobId'] != null) {
          print('LabourJobDetailsScreen - Loading job with ID: ${arguments['jobId']}');
          controller.loadJobDetailWithApplication(arguments['jobId']);
        } else {
          print('LabourJobDetailsScreen - No jobId found in arguments');
        }
      });
      
      // Usar Obx solo para el estado de carga y error
      return Obx(() {
        // Verificar si hay datos disponibles (solo en modo fallback)
        if (controller.isLoading.value) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (controller.errorMessage.value.isNotEmpty) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Recargar datos
                      if (arguments != null && arguments['jobId'] != null) {
                        controller.loadJobDetailWithApplication(arguments['jobId']);
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        
        // Verificar si hay datos del job cargados (solo en modo fallback)
        if (!controller.isJobLoaded) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // Si llegamos aquí, continuar con el resto del build
        return _buildMainContent(context, arguments);
      });
    }
  }

  Widget _buildMainContent(BuildContext context, Map<String, dynamic>? arguments) {
    // Obtener datos del job desde el controlador
    final jobData = _getJobDataFromController();
    
    // Debug: Verificar datos mapeados
    print('LabourJobDetailsScreen - jobData.title: ${jobData.title}');
    print('LabourJobDetailsScreen - jobData.hourlyRate: ${jobData.hourlyRate}');
    print('LabourJobDetailsScreen - jobData.location: ${jobData.location}');
    
    // Establecer flavor en el controlador
    if (flavor != null) {
      controller.currentFlavor.value = flavor!;
    }
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.065;
    final sectionTitleFontSize = screenWidth * 0.045;
    final bodyFontSize = screenWidth * 0.035;
    final iconSize = screenWidth * 0.06;
    final mapHeight = screenHeight * 0.25;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              // AppBar personalizado
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  left: horizontalPadding,
                  right: horizontalPadding,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black87,
                        size: iconSize,
                      ),
                      onPressed: controller.handleBackNavigation,
                    ),
                    Expanded(
                      child: Text(
                        'Job details',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: bodyFontSize * 1.1,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40), // Espacio para balancear
                  ],
                ),
              ),
              
              // Contenido principal
              Expanded(
                child: SafeArea(
                  child: Column(
                    children: [
                      // Contenido principal (scrollable)
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Título del trabajo con precio
                              SizedBox(height: verticalSpacing * 0.2),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      jobData.title,
                                      style: GoogleFonts.poppins(
                                        fontSize: titleFontSize * 0.85,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '\$${jobData.hourlyRate.toStringAsFixed(1)}/hr',
                                    style: GoogleFonts.poppins(
                                      fontSize: titleFontSize * 0.7,
                                      fontWeight: FontWeight.bold,
                                      color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                                    ),
                                  ),
                                ],
                              ),
                              
                              SizedBox(height: verticalSpacing * 2),
                              
                              // Detalles del trabajo
                              _buildDetailRow(
                                icon: Icons.business,
                                label: 'Company',
                                value: jobData.company,
                                iconSize: iconSize,
                                bodyFontSize: bodyFontSize,
                              ),
                              
                              SizedBox(height: verticalSpacing),
                              
                              _buildDetailRow(
                                icon: Icons.location_on,
                                label: 'Suburb',
                                value: jobData.suburb,
                                iconSize: iconSize,
                                bodyFontSize: bodyFontSize,
                              ),
                              
                              SizedBox(height: verticalSpacing),
                              
                              _buildDetailRow(
                                icon: Icons.location_city,
                                label: 'City',
                                value: jobData.city,
                                iconSize: iconSize,
                                bodyFontSize: bodyFontSize,
                              ),
                              
                              SizedBox(height: verticalSpacing),
                              
                              _buildDetailRow(
                                icon: Icons.calendar_today,
                                label: 'Start date',
                                value: jobData.startDate,
                                iconSize: iconSize,
                                bodyFontSize: bodyFontSize,
                              ),
                              
                              SizedBox(height: verticalSpacing),
                              
                              _buildDetailRow(
                                icon: Icons.access_time,
                                label: 'Time',
                                value: jobData.time,
                                iconSize: iconSize,
                                bodyFontSize: bodyFontSize,
                              ),
                              
                              SizedBox(height: verticalSpacing),
                              
                              _buildDetailRow(
                                icon: Icons.description,
                                label: 'Payment is expected',
                                value: jobData.paymentExpected,
                                iconSize: iconSize,
                                bodyFontSize: bodyFontSize,
                              ),
                              
                              SizedBox(height: verticalSpacing * 2),
                              
                              // Divider
                              Container(
                                height: 1,
                                color: Colors.grey[300],
                              ),
                              
                              SizedBox(height: verticalSpacing * 2),
                              
                              // About the job
                              Text(
                                'About the job',
                                style: GoogleFonts.poppins(
                                  fontSize: sectionTitleFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              
                              SizedBox(height: verticalSpacing),
                              
                              Text(
                                jobData.aboutJob,
                                style: GoogleFonts.poppins(
                                  fontSize: bodyFontSize,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                              
                              SizedBox(height: verticalSpacing * 2),
                              
                              // Requirements
                              Text(
                                'Requirements',
                                style: GoogleFonts.poppins(
                                  fontSize: sectionTitleFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              
                              SizedBox(height: verticalSpacing),
                              
                              ...jobData.requirements.map((requirement) => 
                                Padding(
                                  padding: EdgeInsets.only(bottom: verticalSpacing * 0.5),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: verticalSpacing * 0.3),
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: Colors.black87,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: horizontalPadding * 0.5),
                                      Expanded(
                                        child: Text(
                                          requirement,
                                          style: GoogleFonts.poppins(
                                            fontSize: bodyFontSize,
                                            color: Colors.black87,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ).toList(),
                              
                              SizedBox(height: verticalSpacing * 2),
                              
                              // Mapa
                              JobMap(
                                latitude: jobData.latitude,
                                longitude: jobData.longitude,
                                address: jobData.address,
                                height: mapHeight,
                              ),
                              
                              SizedBox(height: verticalSpacing * 2),
                              
                              // Wage details
                              Text(
                                'Wage details',
                                style: GoogleFonts.poppins(
                                  fontSize: sectionTitleFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              
                              SizedBox(height: verticalSpacing),
                              
                              _buildWageDetails(jobData),
                              
                              SizedBox(height: verticalSpacing * 2),
                              
                              // Report job button (solo aparece si ya se aplicó)
                              Obx(() {
                                if (controller.hasApplied.value) {
                                  return Center(
                                    child: TextButton.icon(
                                      onPressed: controller.handleReportJob,
                                      icon: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.report,
                                          size: 12,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      label: Text(
                                        'Report job',
                                        style: GoogleFonts.poppins(
                                          fontSize: bodyFontSize,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              }),
                              
                              SizedBox(height: verticalSpacing * 3),
                            ],
                          ),
                        ),
                      ),
                      
                      // Botones fijos en la parte inferior
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: verticalSpacing * 0.5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, -2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Botón Apply o indicador de ya aplicado
                            SizedBox(
                              width: double.infinity,
                              child: Obx(() {
                                if (controller.hasApplied.value) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: verticalSpacing * 0.5),
                                    decoration: BoxDecoration(
                                      color: Colors.green[50],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.green[300]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green[600],
                                          size: iconSize * 0.8,
                                        ),
                                        SizedBox(width: horizontalPadding * 0.3),
                                        Text(
                                          'Applied Successfully',
                                          style: GoogleFonts.poppins(
                                            fontSize: bodyFontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Obx(() {
                                    if (controller.isLoading.value) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(vertical: verticalSpacing * 1.2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
                                              ),
                                            ),
                                            SizedBox(width: horizontalPadding * 0.3),
                                            Text(
                                              'Applying...',
                                              style: GoogleFonts.poppins(
                                                fontSize: bodyFontSize,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return ElevatedButton(
                                        onPressed: controller.handleApply,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                                          foregroundColor: Colors.black87,
                                          padding: EdgeInsets.symmetric(vertical: verticalSpacing * 1.2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: Text(
                                          'Apply',
                                          style: GoogleFonts.poppins(
                                            fontSize: bodyFontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      );
                                    }
                                  });
                                }
                              }),
                            ),
                            SizedBox(height: verticalSpacing * 0.2),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Modal de éxito de aplicación
          Obx(() {
            if (controller.showSuccessModal.value) {
              return Positioned.fill(
                child: GestureDetector(
                  onTap: controller.handleCloseModal,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {}, // Prevenir que el tap se propague al fondo
                          child: ApplicationSuccessModal(
                            jobDetails: jobData,
                            flavor: controller.currentFlavor.value,
                            onClose: controller.handleCloseModal,
                            onViewAppliedJobs: controller.handleViewAppliedJobs,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required double iconSize,
    required double bodyFontSize,
  }) {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final horizontalPadding = screenWidth * 0.06;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: iconSize,
          color: Colors.black87,
        ),
        SizedBox(width: horizontalPadding * 0.5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label: $value',
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Construye la sección de detalles de salario
  Widget _buildWageDetails(JobDetailsDto jobData) {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final bodyFontSize = screenWidth * 0.035;
    final verticalSpacing = MediaQuery.of(Get.context!).size.height * 0.025;

    // Usar datos del job del controlador si está disponible
    final currentJob = controller.job;

    if (currentJob == null) {
      // Usar datos del JobDetailsDto cuando no hay job del controlador
      List<Widget> wageItems = [];

      // Tarifa base
      if (jobData.wageHourlyRate != null && jobData.wageHourlyRate! > 0) {
        wageItems.add(_buildWageItem('Hourly Rate', '\$${jobData.wageHourlyRate!.toStringAsFixed(2)}', bodyFontSize, verticalSpacing));
      } else {
        wageItems.add(_buildWageItem('Site Allowance', '\$${jobData.wageSiteAllowance.toStringAsFixed(2)}', bodyFontSize, verticalSpacing));
      }

      // Leading hand allowance
      if (jobData.wageLeadingHandAllowance > 0) {
        wageItems.add(_buildWageItem('Leading Hand Allowance', '\$${jobData.wageLeadingHandAllowance.toStringAsFixed(2)}', bodyFontSize, verticalSpacing));
      }

      // Productivity allowance
      if (jobData.wageProductivityAllowance > 0) {
        wageItems.add(_buildWageItem('Productivity Allowance', '\$${jobData.wageProductivityAllowance.toStringAsFixed(2)}', bodyFontSize, verticalSpacing));
      }

      // Travel allowance
      if (jobData.travelAllowance != null && jobData.travelAllowance! > 0) {
        wageItems.add(_buildWageItem('Travel Allowance', '\$${jobData.travelAllowance!.toStringAsFixed(2)}', bodyFontSize, verticalSpacing));
      }

      // Overtime rate
      if (jobData.extrasOvertimeRate > 0) {
        wageItems.add(_buildWageItem('Overtime Rate', '${jobData.extrasOvertimeRate}x', bodyFontSize, verticalSpacing));
      }

      // GST
      if (jobData.gst != null && jobData.gst! > 0) {
        wageItems.add(_buildWageItem('GST', '\$${jobData.gst!.toStringAsFixed(2)}', bodyFontSize, verticalSpacing));
      }

      return Column(children: wageItems);
    }

    // Mostrar detalles reales del job
    List<Widget> wageItems = [];

    // Tarifa base
    if (currentJob.wageHourlyRate != null && currentJob.wageHourlyRate! > 0) {
      wageItems.add(_buildWageItem('Hourly Rate', '\$${currentJob.wageHourlyRate!.toStringAsFixed(2)}', bodyFontSize, verticalSpacing));
    } else {
      wageItems.add(_buildWageItem('Site Allowance', '\$${currentJob.wageSiteAllowance.toStringAsFixed(2)}', bodyFontSize, verticalSpacing));
    }

    // Leading hand allowance
    if (currentJob.wageLeadingHandAllowance > 0) {
      wageItems.add(_buildWageItem('Leading Hand Allowance', '\$${currentJob.wageLeadingHandAllowance.toStringAsFixed(2)}', bodyFontSize, verticalSpacing));
    }

    // Productivity allowance
    if (currentJob.wageProductivityAllowance > 0) {
      wageItems.add(_buildWageItem('Productivity Allowance', '\$${currentJob.wageProductivityAllowance.toStringAsFixed(2)}', bodyFontSize, verticalSpacing));
    }

    // Travel allowance
    if (currentJob.travelAllowance > 0) {
      wageItems.add(_buildWageItem('Travel Allowance', '\$${currentJob.travelAllowance.toStringAsFixed(2)}', bodyFontSize, verticalSpacing));
    }

    // Overtime rate
    if (currentJob.extrasOvertimeRate > 0) {
      wageItems.add(_buildWageItem('Overtime Rate', '${currentJob.extrasOvertimeRate}x', bodyFontSize, verticalSpacing));
    }

    // GST
    if (currentJob.gst > 0) {
      wageItems.add(_buildWageItem('GST', '\$${currentJob.gst.toStringAsFixed(2)}', bodyFontSize, verticalSpacing));
    }

    return Column(children: wageItems);
  }

  /// Construye un item de salario
  Widget _buildWageItem(String label, String value, double bodyFontSize, double verticalSpacing) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: verticalSpacing),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: bodyFontSize,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: bodyFontSize,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
