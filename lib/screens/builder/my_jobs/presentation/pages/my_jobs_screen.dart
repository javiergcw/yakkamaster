import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/logic/builder/models/receive/dto_receive_job.dart';
import '../../logic/controllers/my_jobs_controller.dart';
import '../widgets/widgets.dart';
import '../../../post_job/presentation/pages/post_job_stepper_screen.dart';
import '../../../../job_listings/presentation/pages/job_details_screen.dart';
import '../../../../job_listings/data/dto/job_details_dto.dart';

class MyJobsScreen extends StatelessWidget {
  static const String id = '/builder/my-jobs';
  
  final AppFlavor? flavor;

  MyJobsScreen({
    super.key,
    this.flavor,
  });

  final MyJobsController controller = Get.put(MyJobsController());

  @override
  Widget build(BuildContext context) {
    // Establecer el flavor en el controlador
    if (flavor != null) {
      controller.currentFlavor.value = flavor!;
    }
    
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(screenWidth),
            
            // Tabs
            _buildTabs(screenWidth),
            
            // Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (controller.errorMessage.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          controller.errorMessage,
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        ElevatedButton(
                          onPressed: () => controller.loadJobs(),
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.jobs.isEmpty) {
                  return EmptyStateWidget(
                    flavor: flavor,
                    onPostJob: _handlePostJob,
                  );
                }

                return _buildJobsList(context);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Container(
      color: Colors.grey[800],
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenWidth * 0.04,
      ),
      child: Row(
        children: [
          // Botón de regreso
          GestureDetector(
            onTap: () => controller.handleBackNavigation(),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: screenWidth * 0.06,
            ),
          ),
          
          SizedBox(width: screenWidth * 0.04),
          
          // Título
          Text(
            "Your Jobs",
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.055,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(double screenWidth) {
    return Container(
      color: Colors.grey[800],
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Row(
        children: [
          // Tab Active
          Expanded(
            child: Obx(() => _buildTab(
              text: "Active",
              isSelected: controller.isActiveTab,
              onTap: () => controller.switchTab(true),
              screenWidth: screenWidth,
            )),
          ),
          
          // Tab Archived
          Expanded(
            child: Obx(() => _buildTab(
              text: "Archived",
              isSelected: !controller.isActiveTab,
              onTap: () => controller.switchTab(false),
              screenWidth: screenWidth,
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
    required double screenWidth,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected 
                ? Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor))
                : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[400],
          ),
        ),
      ),
    );
  }

  Widget _buildJobsList(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = screenHeight * 0.02;
    
    return ListView.builder(
      padding: EdgeInsets.only(top: topPadding),
      itemCount: controller.jobs.length,
      itemBuilder: (context, index) {
        final job = controller.jobs[index];
        return JobCard(
          job: job,
          flavor: flavor,
          onShare: () => _handleShareJob(job.id),
          onDelete: () => _handleDeleteJob(job.id),
          onShowMore: () => _handleShowMore(job.id),
          onVisibilityChanged: (isVisible) => _handleVisibilityChanged(job.id, isVisible),
        );
      },
    );
  }

  void _handlePostJob() {
    Get.toNamed(PostJobStepperScreen.id, arguments: {
      'flavor': flavor,
    });
  }

  void _handleShareJob(String jobId) {
    controller.shareJob(jobId);
  }

  void _handleDeleteJob(String jobId) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Job'),
        content: Text('Are you sure you want to delete this job?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteJob(jobId);
              Get.snackbar(
                'Success',
                'Job deleted successfully',
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 2),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _handleShowMore(String jobId) async {
    print('_handleShowMore called with jobId: $jobId');
    try {
      // Usar el controlador para obtener el job real de la API
      final realJob = await controller.getRealJobById(jobId);
      print('_handleShowMore - realJob: ${realJob?.id}');
      
      if (realJob != null) {
        print('_handleShowMore - Navigating with realJob: ${realJob.id}');
        
        // Crear título con skill + número de labours (igual que en la card)
        final skillName = _getSkillName(realJob);
        final title = '${skillName} x${realJob.manyLabours}';
        
        // Usar total_wage si está disponible, sino usar wage_site_allowance como fallback
        final totalWage = realJob.totalWage ?? realJob.wageSiteAllowance;
        
        // Crear JobDetailsDto directamente desde DtoReceiveJob
        final jobDetails = JobDetailsDto(
          id: realJob.id,
          title: title,
          hourlyRate: totalWage,
          location: realJob.jobsite?.name ?? realJob.jobsite?.address ?? 'Location TBD',
          dateRange: '${_formatDate(realJob.startDateWork)} - ${_formatDate(realJob.endDateWork)}',
          jobType: realJob.jobType?.name ?? realJob.paymentType,
          source: realJob.builderProfile?.displayName ?? 'Builder',
          postedDate: _formatDate(realJob.createdAt),
          company: realJob.builderProfile?.displayName ?? 'Builder',
          address: realJob.jobsite?.address ?? 'Address TBD',
          suburb: realJob.jobsite?.suburb ?? '',
          city: realJob.jobsite?.suburb ?? '', // Usar suburb como city
          startDate: _formatDate(realJob.startDateWork),
          time: '${_formatTimeFromString(realJob.startTime)} - ${_formatTimeFromString(realJob.endTime)}',
          paymentExpected: _formatPaymentDay(realJob.paymentDay),
          aboutJob: realJob.description.isNotEmpty ? realJob.description : 'Construction work position.',
          requirements: [
            ...realJob.jobRequirements.map((req) => req.name).toList(),
            ...realJob.jobSkills.map((skill) => '${skill.skillCategory?.name ?? 'Skill'} - ${skill.skillSubcategory?.name ?? 'Specialization'}').toList(),
          ],
          latitude: realJob.jobsite?.latitude ?? -33.8688,
          longitude: realJob.jobsite?.longitude ?? 151.2093,
          wageSiteAllowance: realJob.wageSiteAllowance,
          wageLeadingHandAllowance: realJob.wageLeadingHandAllowance,
          wageProductivityAllowance: realJob.wageProductivityAllowance,
          extrasOvertimeRate: realJob.extrasOvertimeRate,
          wageHourlyRate: realJob.wageHourlyRate,
          travelAllowance: realJob.travelAllowance,
          gst: realJob.gst,
        );
        
        Get.toNamed('/job-details', arguments: {
          'jobDetails': jobDetails,
          'flavor': flavor,
          'isFromAppliedJobs': false,
          'isFromBuilder': true,
        });
      } else {
        print('_handleShowMore - realJob is null, showing error');
        Get.snackbar(
          'Error',
          'Job details not found',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      print('_handleShowMore - Error: $e');
      Get.snackbar(
        'Error',
        'Failed to load job details: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return 'Date TBD';
    }
  }

  String _formatTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Time TBD';
    }
  }

  /// Formatea un string de tiempo en formato "HH:mm:ss" a "HH:mm"
  String _formatTimeFromString(String timeString) {
    try {
      if (timeString.isEmpty) return 'Time TBD';
      
      // Si ya está en formato "HH:mm:ss", extraer solo "HH:mm"
      if (timeString.contains(':')) {
        final parts = timeString.split(':');
        if (parts.length >= 2) {
          return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
        }
      }
      
      return timeString;
    } catch (e) {
      return 'Time TBD';
    }
  }

  /// Formatea el payment_day de ISO string a formato legible
  String _formatPaymentDay(String paymentDayString) {
    try {
      if (paymentDayString.isEmpty) return 'Payment day TBD';
      
      final date = DateTime.parse(paymentDayString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return 'Payment day TBD';
    }
  }

  /// Obtiene el nombre de la skill del job (igual que en el controlador)
  String _getSkillName(DtoReceiveJob job) {
    // Buscar en job_skills para obtener el nombre de la subcategoría
    if (job.jobSkills.isNotEmpty) {
      final firstSkill = job.jobSkills.first;
      if (firstSkill.skillSubcategory != null) {
        return firstSkill.skillSubcategory!.name;
      }
      if (firstSkill.skillCategory != null) {
        return firstSkill.skillCategory!.name;
      }
    }
    
    // Fallback: usar description si no hay skills
    if (job.description.isNotEmpty) {
      return job.description;
    }
    
    // Último fallback
    return 'Skill';
  }



  void _handleVisibilityChanged(String jobId, bool isVisible) {
    controller.updateJobVisibility(jobId, isVisible);
  }
}
