import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../data/applied_job_dto.dart';
import '../../../../job_listings/presentation/pages/job_details_screen.dart';
import '../../../../job_listings/data/dto/job_details_dto.dart';
import 'quick_notify_modal.dart';
import 'timesheet_modal.dart';

class AppliedJobCard extends StatelessWidget {
  final AppliedJobDto job;
  final VoidCallback? onShowDetails;
  final VoidCallback? onSubmitTimesheet;
  final VoidCallback? onQuickNotify;

  const AppliedJobCard({
    Key? key,
    required this.job,
    this.onShowDetails,
    this.onSubmitTimesheet,
    this.onQuickNotify,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.045;
    final bodyFontSize = screenWidth * 0.035;
    final buttonFontSize = screenWidth * 0.035;

        return IntrinsicHeight(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: verticalSpacing * 0.1),
        padding: EdgeInsets.all(horizontalPadding * 0.8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Company Name
          Text(
            job.companyName,
            style: GoogleFonts.poppins(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          
          SizedBox(height: verticalSpacing * 0.2),
          
          // Job Title with icon
          Row(
            children: [
              Icon(
                Icons.build,
                size: bodyFontSize * 1.2,
                color: Colors.grey[600],
              ),
              SizedBox(width: horizontalPadding * 0.3),
              Text(
                job.jobTitle,
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          
          SizedBox(height: verticalSpacing * 0.1),
          
          // Location with icon
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: bodyFontSize * 1.2,
                color: Colors.grey[600],
              ),
              SizedBox(width: horizontalPadding * 0.3),
              Text(
                job.location,
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          
          SizedBox(height: verticalSpacing * 0.3),
          
          // Action Buttons
          Row(
            children: [
                             // Submit Timesheet Button
               Expanded(
                 child: ElevatedButton.icon(
                   onPressed: () {
                     showModalBottomSheet(
                       context: context,
                       isScrollControlled: true,
                       backgroundColor: Colors.transparent,
                       builder: (context) => TimesheetModal(
                         companyName: job.companyName,
                         onClose: () => Navigator.of(context).pop(),
                         onSubmit: (timesheetData) {
                           print('Timesheet submitted: $timesheetData');
                           // Aquí puedes agregar la lógica para enviar el timesheet
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                               content: Text('Timesheet submitted successfully!'),
                               backgroundColor: Colors.green,
                             ),
                           );
                         },
                       ),
                     );
                   },
                  icon: Icon(
                    Icons.calendar_today,
                    size: bodyFontSize * 1.1,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Submit timesheet',
                    style: GoogleFonts.poppins(
                      fontSize: buttonFontSize * 0.9,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: verticalSpacing * 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: horizontalPadding * 0.4),
              
                             // Quick Notify Button
               Expanded(
                 child: OutlinedButton(
                   onPressed: () {
                     showModalBottomSheet(
                       context: context,
                       isScrollControlled: true,
                       backgroundColor: Colors.transparent,
                       builder: (context) => QuickNotifyModal(
                         onClose: () => Navigator.of(context).pop(),
                         onOptionSelected: (option) {
                           print('Selected option: $option');
                           Navigator.of(context).pop();
                           // Aquí puedes agregar la lógica específica para cada opción
                           switch (option) {
                             case 'check-in':
                               print('Check-in selected');
                               break;
                             case 'running-late':
                               print('Running late selected');
                               break;
                             case 'leaving-early':
                               print('Leaving early selected');
                               break;
                             case 'hazard-incident':
                               print('Hazard/Incident report selected');
                               break;
                             case 'cancel-shift':
                               print('Cancel shift selected');
                               break;
                           }
                         },
                       ),
                     );
                   },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: BorderSide(color: Colors.grey[400]!),
                    padding: EdgeInsets.symmetric(vertical: verticalSpacing * 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Quick Notify',
                    style: GoogleFonts.poppins(
                      fontSize: buttonFontSize * 0.9,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: verticalSpacing * 0.3),
          
                    // Show Details Link
          Center(
            child: TextButton(
              onPressed: () {
                // Convertir AppliedJobDto a JobDetailsDto para la navegación
                final jobDetails = JobDetailsDto(
                  id: job.id,
                  title: job.jobTitle,
                  hourlyRate: 25.0,
                  location: job.location,
                  dateRange: '${job.appliedDate.toString().split(' ')[0]} - ${job.appliedDate.toString().split(' ')[0]}',
                  jobType: 'Full-time',
                  source: job.companyName,
                  postedDate: job.appliedDate.toString().split(' ')[0],
                  company: job.companyName,
                  address: job.location,
                  suburb: '',
                  city: '',
                  startDate: job.appliedDate.toString().split(' ')[0],
                  time: '9:00 AM - 5:00 PM',
                  paymentExpected: 'Within 7 days',
                  aboutJob: 'This is a detailed description of the job position.',
                  requirements: [
                    'Valid driver license',
                    'Previous experience required',
                    'Good communication skills',
                  ],
                  latitude: -33.8688,
                  longitude: 151.2093,
                );
                
                                 Navigator.of(context).push(
                   MaterialPageRoute(
                     builder: (context) => JobDetailsScreen(
                       jobDetails: jobDetails,
                       flavor: AppFlavorConfig.currentFlavor,
                       isFromAppliedJobs: true,
                     ),
                   ),
                 );
              },
              child: Text(
                'Show details',
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize * 0.9,
                  fontWeight: FontWeight.w500,
                  color: Color(AppFlavorConfig.getPrimaryColor(AppFlavorConfig.currentFlavor)),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
         ],
       ),
     ),
   );
 }
}
