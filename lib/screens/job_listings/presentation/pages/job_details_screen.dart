import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/app_flavor.dart';
import '../../../../config/assets_config.dart';
import '../../data/dto/job_details_dto.dart';
import '../widgets/job_map.dart';
import '../widgets/application_success_modal.dart';
import '../../../home/presentation/pages/edit_bank_details_screen.dart';

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

class JobDetailsScreen extends StatefulWidget {
  final JobDetailsDto jobDetails;
  final AppFlavor? flavor;
  final bool isFromAppliedJobs;

  const JobDetailsScreen({
    super.key,
    required this.jobDetails,
    this.flavor,
    this.isFromAppliedJobs = false,
  });

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  bool _hasApplied = false; // Estado para controlar si ya se aplicó
  bool _showSuccessModal = false; // Estado para mostrar el modal

  @override
  void initState() {
    super.initState();
    // Si viene de trabajos aplicados, marcar como ya aplicado
    _hasApplied = widget.isFromAppliedJobs;
  }

  // Variable para activar/desactivar la verificación bancaria
  static const bool _enableBankVerification = true; // Cambiar a false para desactivar

  // Función para verificar si el usuario tiene datos bancarios configurados
  bool _hasBankDetails() {
    // TODO: Implementar verificación real de datos bancarios
    // Por ahora, simulamos que no tiene datos bancarios para probar el flujo
    return false; // Cambiar a true cuando tenga datos bancarios reales
  }

  void _handleApply() {
    // Verificar si el usuario tiene datos bancarios configurados (solo si está habilitado)
    if (_enableBankVerification && !_hasBankDetails()) {
      // Mostrar diálogo para configurar datos bancarios
      _showBankDetailsDialog();
      return;
    }
    
    // Si tiene datos bancarios o la verificación está deshabilitada, proceder con la aplicación
    setState(() {
      _hasApplied = true;
      _showSuccessModal = true;
    });
    print('Apply for job: ${widget.jobDetails.title}');
  }

  void _showBankDetailsDialog() {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular tamaños responsive
    final dialogWidth = screenWidth * 0.85;
    final titleFontSize = screenWidth * 0.045;
    final bodyFontSize = screenWidth * 0.035;
    final buttonFontSize = screenWidth * 0.035;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
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
                    color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_balance,
                    color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                    size: screenWidth * 0.06,
                  ),
                ),
                
                SizedBox(height: screenHeight * 0.02),
                
                // Título
                Text(
                  'Bank Details Required',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
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
                  style: GoogleFonts.poppins(
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
                          Navigator.of(context).pop();
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
                          style: GoogleFonts.poppins(
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
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditBankDetailsScreen(
                                flavor: _currentFlavor,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                          foregroundColor: Colors.black87,
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Configure Now',
                          style: GoogleFonts.poppins(
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
        );
      },
    );
  }

  void _handleCloseModal() {
    setState(() {
      _showSuccessModal = false;
    });
  }

  void _handleViewAppliedJobs() {
    // TODO: Navegar a la pantalla de trabajos aplicados
    print('Navigate to applied jobs');
    _handleCloseModal();
  }

  void _handleReportJob() {
    // TODO: Implementar lógica de reporte
    print('Report job: ${widget.jobDetails.title}');
  }

  @override
  Widget build(BuildContext context) {
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
                  bottom: verticalSpacing,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black87,
                        size: iconSize,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Job details',
                            style: GoogleFonts.poppins(
                              fontSize: bodyFontSize * 1.1,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            '\$${widget.jobDetails.hourlyRate.toStringAsFixed(1)}/hr',
                            style: GoogleFonts.poppins(
                              fontSize: bodyFontSize,
                              fontWeight: FontWeight.w600,
                              color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                            ),
                          ),
                        ],
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
                              // Título del trabajo
                              SizedBox(height: verticalSpacing),
                              Text(
                                widget.jobDetails.title,
                                style: GoogleFonts.poppins(
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              
                              SizedBox(height: verticalSpacing * 2),
                              
                              // Detalles del trabajo
                              _buildDetailRow(
                                icon: Icons.business,
                                label: 'Company',
                                value: widget.jobDetails.company,
                                iconSize: iconSize,
                                bodyFontSize: bodyFontSize,
                              ),
                              
                              SizedBox(height: verticalSpacing),
                              
                              _buildDetailRow(
                                icon: Icons.location_on,
                                label: 'Address',
                                value: widget.jobDetails.address,
                                iconSize: iconSize,
                                bodyFontSize: bodyFontSize,
                              ),
                              
                              SizedBox(height: verticalSpacing * 0.5),
                              
                              Padding(
                                padding: EdgeInsets.only(left: iconSize + horizontalPadding * 0.5),
                                child: Text(
                                  'Suburb: ${widget.jobDetails.suburb}',
                                  style: GoogleFonts.poppins(
                                    fontSize: bodyFontSize,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              
                              SizedBox(height: verticalSpacing * 0.5),
                              
                              Padding(
                                padding: EdgeInsets.only(left: iconSize + horizontalPadding * 0.5),
                                child: Text(
                                  'City: ${widget.jobDetails.city}',
                                  style: GoogleFonts.poppins(
                                    fontSize: bodyFontSize,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              
                              SizedBox(height: verticalSpacing),
                              
                              _buildDetailRow(
                                icon: Icons.calendar_today,
                                label: 'Start date',
                                value: widget.jobDetails.startDate,
                                iconSize: iconSize,
                                bodyFontSize: bodyFontSize,
                              ),
                              
                              SizedBox(height: verticalSpacing),
                              
                              _buildDetailRow(
                                icon: Icons.access_time,
                                label: 'Time',
                                value: widget.jobDetails.time,
                                iconSize: iconSize,
                                bodyFontSize: bodyFontSize,
                              ),
                              
                              SizedBox(height: verticalSpacing),
                              
                              _buildDetailRow(
                                icon: Icons.description,
                                label: 'Payment is expected',
                                value: widget.jobDetails.paymentExpected,
                                iconSize: iconSize,
                                bodyFontSize: bodyFontSize,
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
                                widget.jobDetails.aboutJob,
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
                              
                              ...widget.jobDetails.requirements.map((requirement) => 
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
                                latitude: widget.jobDetails.latitude,
                                longitude: widget.jobDetails.longitude,
                                address: widget.jobDetails.address,
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
                                      '\$${widget.jobDetails.hourlyRate.toStringAsFixed(2)}',
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
                              if (_hasApplied)
                                Center(
                                  child: TextButton.icon(
                                    onPressed: _handleReportJob,
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
                                ),
                              
                              SizedBox(height: verticalSpacing * 3),
                            ],
                          ),
                        ),
                      ),
                      
                      // Botones fijos en la parte inferior
                      Container(
                        padding: EdgeInsets.all(horizontalPadding),
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
                              child: _hasApplied
                                  ? Container(
                                      padding: EdgeInsets.symmetric(vertical: verticalSpacing * 0.8),
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
                                      onPressed: _handleApply,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                        foregroundColor: Colors.black87,
                                        padding: EdgeInsets.symmetric(vertical: verticalSpacing * 0.8),
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
                                    ),
                            ),
                            
                            SizedBox(height: verticalSpacing * 0.5),
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
          if (_showSuccessModal)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ApplicationSuccessModal(
                      jobDetails: widget.jobDetails,
                      flavor: _currentFlavor,
                      onClose: _handleCloseModal,
                      onViewAppliedJobs: _handleViewAppliedJobs,
                    ),
                  ],
                ),
              ),
            ),
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
    final mediaQuery = MediaQuery.of(context);
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
