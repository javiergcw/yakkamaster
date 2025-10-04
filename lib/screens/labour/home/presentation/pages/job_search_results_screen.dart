import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/constants.dart';
import '../../../../job_listings/logic/controllers/job_search_results_screen_controller.dart';
import '../../../../job_listings/presentation/pages/job_search_screen.dart';
import '../../../../../features/logic/labour/models/receive/dto_receive_labour_job.dart';

class JobSearchResultsScreen extends StatefulWidget {
  static const String id = '/job-search-results';
  
  final AppFlavor? flavor;
  final String? whatQuery;
  final String? whereQuery;
  
  JobSearchResultsScreen({
    super.key, 
    this.flavor,
    this.whatQuery,
    this.whereQuery,
  });

  @override
  State<JobSearchResultsScreen> createState() => _JobSearchResultsScreenState();
}

class _JobSearchResultsScreenState extends State<JobSearchResultsScreen> {
  final JobSearchResultsScreenController controller = Get.put(JobSearchResultsScreenController());
  
  // Controladores persistentes para los TextFields
  late TextEditingController _whatController;
  late TextEditingController _whereController;

  @override
  void initState() {
    super.initState();
    
    // Inicializar controladores
    _whatController = TextEditingController();
    _whereController = TextEditingController();
    
    // Establecer el flavor en el controlador si se proporciona
    if (widget.flavor != null) {
      controller.currentFlavor.value = widget.flavor!;
    }
    
    // Inicializar con los valores pasados como argumentos
    if (widget.whatQuery != null) {
      controller.whatQuery.value = widget.whatQuery!;
      _whatController.text = widget.whatQuery!;
    }
    if (widget.whereQuery != null) {
      controller.whereQuery.value = widget.whereQuery!;
      _whereController.text = widget.whereQuery!;
    }
    
    // Escuchar cambios en los observables para actualizar los controladores
    controller.whatQuery.listen((value) {
      if (_whatController.text != value) {
        _whatController.text = value;
      }
    });
    
    controller.whereQuery.listen((value) {
      if (_whereController.text != value) {
        _whereController.text = value;
      }
    });
  }

  @override
  void dispose() {
    _whatController.dispose();
    _whereController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final bodyFontSize = screenWidth * 0.035;
    final iconSize = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppConstants.darkGreyColor,
        elevation: 0,
        surfaceTintColor: AppConstants.darkGreyColor,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: iconSize,
          ),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Título de búsqueda
            Obx(() => Text(
              controller.whatQuery.value.isNotEmpty 
                  ? controller.whatQuery.value 
                  : 'Available Jobs',
              style: GoogleFonts.poppins(
                fontSize: bodyFontSize * 1.1,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )),
            // Ubicación
            Obx(() => Text(
              controller.whereQuery.value.isNotEmpty 
                  ? controller.whereQuery.value 
                  : 'All Locations',
              style: GoogleFonts.poppins(
                fontSize: bodyFontSize * 0.9,
                color: Colors.white70,
              ),
            )),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navegar a la pantalla de búsqueda
              print('Navigate to search screen');
              Get.toNamed(
                JobSearchScreen.id,
                arguments: {
                  'flavor': controller.currentFlavor.value,
                },
              );
            },
            icon: Icon(
              Icons.filter_list,
              color: Colors.white,
              size: iconSize,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Contador de trabajos
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing * 0.6,
              ),
              decoration: BoxDecoration(
                color: AppConstants.darkGreyColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: Obx(() => Text(
                  'Available ${controller.jobCount.value} Jobs',
                  style: GoogleFonts.poppins(
                    fontSize: bodyFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
              ),
            ),
            
            // Lista de trabajos
            Expanded(
              child: Container(
                color: Colors.grey[100],
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (controller.errorMessage.value.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: iconSize * 2,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: verticalSpacing),
                          Text(
                            controller.errorMessage.value,
                            style: GoogleFonts.poppins(
                              fontSize: bodyFontSize,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: verticalSpacing),
                          ElevatedButton(
                            onPressed: () => controller.loadJobs(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (controller.jobList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.work_off,
                            size: iconSize * 2,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: verticalSpacing),
                          Text(
                            "No jobs found",
                            style: GoogleFonts.poppins(
                              fontSize: bodyFontSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: verticalSpacing * 0.5),
                          Text(
                            "Try adjusting your search criteria",
                            style: GoogleFonts.poppins(
                              fontSize: bodyFontSize * 0.9,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalSpacing,
                    ),
                    itemCount: controller.jobList.length,
                    itemBuilder: (context, index) {
                      final job = controller.jobList[index];
                      return _buildJobCard(
                        job: job,
                        horizontalPadding: horizontalPadding,
                        verticalSpacing: verticalSpacing,
                        bodyFontSize: bodyFontSize,
                        flavor: controller.currentFlavor.value,
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard({
    required DtoReceiveLabourJob job,
    required double horizontalPadding,
    required double verticalSpacing,
    required double bodyFontSize,
    required AppFlavor flavor,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: verticalSpacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(horizontalPadding * 0.8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con título y botón de compartir
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${controller.getSkillName(job)} x${controller.getManyLabours(job)}',
                    style: GoogleFonts.poppins(
                      fontSize: bodyFontSize * 1.2,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.black87,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Compartir el trabajo
                    _shareJob(job);
                  },
                  child: Icon(
                    Icons.share,
                    size: bodyFontSize * 1.3,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: verticalSpacing * 0.5),
            
            // Salario
            Text(
              '\$${job.totalWage.toStringAsFixed(2)}/hr',
              style: GoogleFonts.poppins(
                fontSize: bodyFontSize * 1.1,
                fontWeight: FontWeight.w600,
                color: Color(AppFlavorConfig.getPrimaryColor(flavor)),
              ),
            ),
            
            SizedBox(height: verticalSpacing * 0.8),
            
            // Detalles del trabajo
            _buildJobDetail(
              icon: Icons.location_on,
              text: job.location,
              bodyFontSize: bodyFontSize,
            ),
            
            SizedBox(height: verticalSpacing * 0.4),
            
            _buildJobDetail(
              icon: Icons.business,
              text: job.builder.displayName,
              bodyFontSize: bodyFontSize,
            ),
            
            SizedBox(height: verticalSpacing * 0.4),
            
            Row(
              children: [
                Expanded(
                  child: _buildJobDetail(
                    icon: Icons.filter_list,
                    text: job.jobType,
                    bodyFontSize: bodyFontSize,
                  ),
                ),
                Text(
                  'Posted ${_formatTimeAgo(job.createdAt)} ago',
                  style: GoogleFonts.poppins(
                    fontSize: bodyFontSize * 0.9,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: verticalSpacing * 0.8),
            
            // Botón de ver detalles
            GestureDetector(
              onTap: () => controller.handleViewDetails(job),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: verticalSpacing * 0.6),
                decoration: BoxDecoration(
                  color: AppConstants.darkGreyColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'View details',
                    style: GoogleFonts.poppins(
                      fontSize: bodyFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobDetail({
    required IconData icon,
    required String text,
    required double bodyFontSize,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: bodyFontSize * 1.1,
          color: Colors.grey[600],
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: bodyFontSize,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }





  /// Calcula el tiempo transcurrido desde una fecha
  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  // Método para compartir un trabajo
  void _shareJob(DtoReceiveLabourJob job) {
    final shareText = '''
🔨 ${controller.getSkillName(job)} x${controller.getManyLabours(job)}

💰 \$${job.totalWage.toStringAsFixed(2)}/hr
📍 ${job.location}
🏢 ${job.builder.displayName}
⏰ ${job.jobType}
📅 Posted ${_formatTimeAgo(job.createdAt)} ago

¡Encuentra más trabajos en Yakka Sports!
''';

    Share.share(
      shareText,
      subject: 'Trabajo: ${controller.getSkillName(job)} x${controller.getManyLabours(job)}',
    );
  }




}
