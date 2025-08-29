import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../logic/controllers/job_site_controller.dart';
import '../widgets/job_site_card.dart';
import 'create_edit_job_site_screen.dart';
import 'post_job_stepper_screen.dart';

class JobSitesScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const JobSitesScreen({
    super.key,
    this.flavor,
  });

  @override
  State<JobSitesScreen> createState() => _JobSitesScreenState();
}

class _JobSitesScreenState extends State<JobSitesScreen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  late JobSiteController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(JobSiteController());
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final descriptionFontSize = screenWidth * 0.035;
    final buttonFontSize = screenWidth * 0.04;
    final iconSize = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
                         // Header (Dark Grey)
             Container(
               width: double.infinity,
               padding: EdgeInsets.symmetric(
                 horizontal: horizontalPadding,
                 vertical: verticalSpacing * 1.5,
               ),
               decoration: BoxDecoration(
                 color: Colors.grey[800],
               ),
              child: Column(
                children: [
                                     // Header Row
                   Row(
                     children: [
                       // Back Button
                       GestureDetector(
                         onTap: () => Navigator.of(context).pop(),
                         child: Icon(
                           Icons.arrow_back,
                           color: Colors.white,
                           size: iconSize,
                         ),
                       ),
                       
                       SizedBox(width: horizontalPadding),
                       
                       // Title
                       Expanded(
                         child: Text(
                           "Jobsites",
                           style: GoogleFonts.poppins(
                             fontSize: titleFontSize,
                             fontWeight: FontWeight.bold,
                             color: Colors.white,
                           ),
                           textAlign: TextAlign.left,
                         ),
                       ),
                       
                       // More Options Button
                       GestureDetector(
                         onTap: () {
                           // TODO: Mostrar opciones adicionales
                           print('More options pressed');
                         },
                         child: Icon(
                           Icons.more_vert,
                           color: Colors.white,
                           size: iconSize,
                         ),
                       ),
                     ],
                   ),
                  
                                     SizedBox(height: verticalSpacing * 0.5),
                   
                   // Description
                   Text(
                     "Here you can see all your jobsites. You can edit, add or remove any job site.",
                     style: GoogleFonts.poppins(
                       fontSize: descriptionFontSize * 0.9,
                       fontWeight: FontWeight.w400,
                       color: Colors.white.withOpacity(0.9),
                     ),
                     textAlign: TextAlign.left,
                   ),
                ],
              ),
            ),
            
            // Main Content
            Expanded(
              child: Obx(() {
                if (_controller.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                if (_controller.errorMessage.isNotEmpty) {
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
                          _controller.errorMessage,
                          style: GoogleFonts.poppins(
                            fontSize: descriptionFontSize,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: verticalSpacing),
                        ElevatedButton(
                          onPressed: () => _controller.loadJobSites(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                
                if (_controller.jobSites.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off,
                          size: iconSize * 2,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: verticalSpacing),
                        Text(
                          "No job sites found",
                          style: GoogleFonts.poppins(
                            fontSize: descriptionFontSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: verticalSpacing * 0.5),
                        Text(
                          "Add your first job site to get started",
                          style: GoogleFonts.poppins(
                            fontSize: descriptionFontSize * 0.9,
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
                     vertical: verticalSpacing * 0.5,
                   ),
                   itemCount: _controller.jobSites.length + 1, // +1 para el botón de crear
                   itemBuilder: (context, index) {
                     if (index == _controller.jobSites.length) {
                       // Botón para crear job site al final
                       return Container(
                         margin: EdgeInsets.only(top: verticalSpacing),
                         child: ElevatedButton.icon(
                           onPressed: _handleCreateJobSite,
                           style: ElevatedButton.styleFrom(
                             backgroundColor: Colors.grey[100],
                             foregroundColor: Colors.grey[700],
                             padding: EdgeInsets.symmetric(
                               horizontal: horizontalPadding,
                               vertical: verticalSpacing * 0.8,
                             ),
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(8),
                               side: BorderSide(
                                 color: Colors.grey[300]!,
                                 width: 1,
                               ),
                             ),
                             elevation: 0,
                           ),
                           icon: Icon(
                             Icons.add,
                             size: iconSize * 0.8,
                           ),
                           label: Text(
                             "Create new job site",
                             style: GoogleFonts.poppins(
                               fontSize: buttonFontSize * 0.8,
                               fontWeight: FontWeight.w500,
                             ),
                           ),
                         ),
                       );
                     }
                     
                     final jobSite = _controller.jobSites[index];
                     return JobSiteCard(
                       jobSite: jobSite,
                       isSelected: jobSite.isSelected,
                       onTap: () {
                         _controller.toggleJobSiteSelection(jobSite.id);
                       },
                       onEdit: () {
                         _handleEditJobSite(jobSite);
                       },
                     );
                   },
                 );
              }),
            ),
            
                         // Request Workers Button
             Obx(() => Container(
               width: double.infinity,
               padding: EdgeInsets.symmetric(
                 horizontal: horizontalPadding,
                 vertical: verticalSpacing * 0.5,
               ),
               child: ElevatedButton(
                 onPressed: _controller.selectedJobSites.isNotEmpty
                     ? _handleRequestWorkers
                     : null,
                 style: ElevatedButton.styleFrom(
                   backgroundColor: _controller.selectedJobSites.isNotEmpty
                       ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                       : Colors.grey[400],
                   foregroundColor: Colors.white,
                   padding: EdgeInsets.symmetric(vertical: verticalSpacing * 1.0),
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(6),
                   ),
                   elevation: 1,
                 ),
                 child: Text(
                   "Request workers",
                   style: GoogleFonts.poppins(
                     fontSize: buttonFontSize * 0.9,
                     fontWeight: FontWeight.w600,
                   ),
                 ),
               ),
             )),
          ],
        ),
      ),
    );
  }

     void _handleEditJobSite(dynamic jobSite) {
     Navigator.of(context).push(
       MaterialPageRoute(
         builder: (context) => CreateEditJobSiteScreen(
           flavor: _currentFlavor,
           jobSite: jobSite,
         ),
       ),
     );
   }

     void _handleRequestWorkers() {
       // Navegar al stepper de post job con los jobsites seleccionados
       Navigator.of(context).push(
         MaterialPageRoute(
           builder: (context) => PostJobStepperScreen(
             flavor: _currentFlavor,
             selectedJobSites: _controller.selectedJobSites.toList(),
           ),
         ),
       );
     }

   void _handleCreateJobSite() {
     Navigator.of(context).push(
       MaterialPageRoute(
         builder: (context) => CreateEditJobSiteScreen(
           flavor: _currentFlavor,
         ),
       ),
     );
   }
}
