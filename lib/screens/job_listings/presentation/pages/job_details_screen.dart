import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../config/app_flavor.dart';
import '../../../../config/assets_config.dart';
import '../../data/dto/job_details_dto.dart';
import '../widgets/job_map.dart';
import '../widgets/application_success_modal.dart';
import '../../logic/controllers/job_details_screen_controller.dart';

/*
 * CONFIGURACIÓN DE VERIFICACIÓN BANCARIA EN JOB DETAILS:
 * 
 * Para activar/desactivar la verificación de datos bancarios antes de aplicar:
 * - Cambiar _enableBankVerification a true: El usuario debe configurar datos bancarios antes de aplicar
 * - Cambiar _enableBankVerification a false: El usuario puede aplicar sin verificación bancaria
 * 
 * Para simular que el usuario tiene datos bancarios configurados:
 * - Cambiar _hasBankDetails() para retornar true
 */

class JobDetailsScreen extends StatelessWidget {
  static const String id = '/job-details';
  
  final JobDetailsDto jobDetails;
  final AppFlavor? flavor;
  final bool isFromAppliedJobs;
  final bool isFromBuilder;

  JobDetailsScreen({
    super.key,
    required this.jobDetails,
    this.flavor,
    this.isFromAppliedJobs = false,
    this.isFromBuilder = false,
  });

  final JobDetailsScreenController controller = Get.put(JobDetailsScreenController());

  @override
  Widget build(BuildContext context) {
    // Establecer datos en el controlador
    controller.jobDetails.value = jobDetails;
    if (flavor != null) {
      controller.currentFlavor.value = flavor!;
    }
    controller.isFromAppliedJobs.value = isFromAppliedJobs;
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
                                      jobDetails.title,
                                      style: GoogleFonts.poppins(
                                        fontSize: titleFontSize * 0.85,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '\$${jobDetails.hourlyRate.toStringAsFixed(1)}/hr',
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
                                value: jobDetails.company,
                                iconSize: iconSize,
                                bodyFontSize: bodyFontSize,
                              ),
                              
                              SizedBox(height: verticalSpacing),
                              
                              _buildDetailRow(
                                icon: Icons.location_on,
                                label: 'Suburb',
                                value: jobDetails.suburb,
                                iconSize: iconSize,
                                bodyFontSize: bodyFontSize,
                              ),
                              
                              SizedBox(height: verticalSpacing),
                              
                              _buildDetailRow(
                                icon: Icons.location_city,
                                label: 'City',
                                value: jobDetails.city,
                                iconSize: iconSize,
                                bodyFontSize: bodyFontSize,
                              ),
                              
                              SizedBox(height: verticalSpacing),
                              
                              _buildDetailRow(
                                icon: Icons.calendar_today,
                                label: 'Start date',
                                value: jobDetails.startDate,
                                iconSize: iconSize,
                                bodyFontSize: bodyFontSize,
                              ),
                              
                              SizedBox(height: verticalSpacing),
                              
                              _buildDetailRow(
                                icon: Icons.access_time,
                                label: 'Time',
                                value: jobDetails.time,
                                iconSize: iconSize,
                                bodyFontSize: bodyFontSize,
                              ),
                              
                              SizedBox(height: verticalSpacing),
                              
                              _buildDetailRow(
                                icon: Icons.description,
                                label: 'Payment is expected',
                                value: jobDetails.paymentExpected,
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
                                jobDetails.aboutJob,
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
                              
                              ...jobDetails.requirements.map((requirement) => 
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
                                latitude: jobDetails.latitude,
                                longitude: jobDetails.longitude,
                                address: jobDetails.address,
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
                              
                              Container(
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
                                      'Hourly Rate',
                                      style: GoogleFonts.poppins(
                                        fontSize: bodyFontSize,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      '\$${jobDetails.hourlyRate.toStringAsFixed(2)}',
                                      style: GoogleFonts.poppins(
                                        fontSize: bodyFontSize,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              SizedBox(height: verticalSpacing * 2),
                              
                              // Report job button (solo aparece si ya se aplicó)
                              Obx(() => controller.hasApplied.value
                                ? Center(
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
                                )
                                : const SizedBox.shrink()),
                              
                              SizedBox(height: verticalSpacing * 3),
                            ],
                          ),
                        ),
                      ),
                      
                      // Botones fijos en la parte inferior (solo si no viene del builder)
                      Obx(() {
                        if (controller.isFromBuilder.value) {
                          return const SizedBox.shrink();
                        }
                        return Container(
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
                                child: Obx(() => controller.hasApplied.value
                                    ? Container(
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
                                      )
                                    : ElevatedButton(
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
                                      )),
                              ),
                              SizedBox(height: verticalSpacing * 0.2),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Modal de éxito de aplicación
          Obx(() => controller.showSuccessModal.value
            ? Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ApplicationSuccessModal(
                      jobDetails: jobDetails,
                      flavor: controller.currentFlavor.value,
                      onClose: controller.handleCloseModal,
                      onViewAppliedJobs: controller.handleViewAppliedJobs,
                    ),
                  ],
                ),
              ),
            )
            : const SizedBox.shrink()),
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
}
