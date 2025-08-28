import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../config/app_flavor.dart';
import '../../data/data.dart';
import 'applicant_card.dart';

class JobsiteApplicantsCard extends StatelessWidget {
  final JobsiteApplicantsDto jobsiteApplicants;
  final AppFlavor? flavor;
  final Function(String) onChat;
  final Function(String) onDecline;
  final Function(String) onHire;

  const JobsiteApplicantsCard({
    super.key,
    required this.jobsiteApplicants,
    this.flavor,
    required this.onChat,
    required this.onDecline,
    required this.onHire,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final cardWidth = screenWidth * 0.85;
    final cardPadding = screenWidth * 0.04;
    final titleFontSize = screenWidth * 0.045;
    final subtitleFontSize = screenWidth * 0.035;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del jobsite
          Container(
            padding: EdgeInsets.all(cardPadding),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jobsiteApplicants.jobsiteName,
                  style: GoogleFonts.poppins(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  jobsiteApplicants.jobsiteAddress,
                  style: GoogleFonts.poppins(
                    fontSize: subtitleFontSize,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  '${jobsiteApplicants.applicants.length} applicant${jobsiteApplicants.applicants.length != 1 ? 's' : ''}',
                  style: GoogleFonts.poppins(
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w500,
                    color: Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor)),
                  ),
                ),
              ],
            ),
          ),
          
                     // Lista de applicants (scroll horizontal)
           Expanded(
             child: jobsiteApplicants.applicants.isEmpty
                 ? Center(
                     child: Padding(
                       padding: EdgeInsets.all(cardPadding),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(
                             Icons.people_outline,
                             size: screenWidth * 0.1,
                             color: Colors.grey[400],
                           ),
                           SizedBox(height: screenHeight * 0.02),
                           Text(
                             'No applicants yet',
                             style: GoogleFonts.poppins(
                               fontSize: subtitleFontSize,
                               color: Colors.grey[600],
                             ),
                           ),
                         ],
                       ),
                     ),
                   )
                 : ListView.builder(
                     scrollDirection: Axis.horizontal,
                     padding: EdgeInsets.all(cardPadding),
                     itemCount: jobsiteApplicants.applicants.length,
                     itemBuilder: (context, index) {
                       final applicant = jobsiteApplicants.applicants[index];
                       return Container(
                         width: screenWidth * 0.7, // Ancho fijo para cada card de applicant
                         margin: EdgeInsets.only(right: cardPadding),
                         child: ApplicantCard(
                           applicant: applicant,
                           flavor: flavor,
                           onChat: () => onChat(applicant.id),
                           onDecline: () => onDecline(applicant.id),
                           onHire: () => onHire(applicant.id),
                         ),
                       );
                     },
                   ),
           ),
        ],
      ),
    );
  }
}
