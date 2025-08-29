import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../post_job/data/dto/job_site_dto.dart';

class JobSiteListCard extends StatelessWidget {
  final JobSiteDto jobSite;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const JobSiteListCard({
    super.key,
    required this.jobSite,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.035;
    final subtitleFontSize = screenWidth * 0.03;
    final descriptionFontSize = screenWidth * 0.025;
    final iconSize = screenWidth * 0.05;

    return Container(
      margin: EdgeInsets.only(bottom: verticalSpacing * 0.4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.all(horizontalPadding * 0.8),
            child: Row(
              children: [
                // Job Site Information (sin radio button)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Job Site Name
                      Text(
                        jobSite.name,
                        style: GoogleFonts.poppins(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      SizedBox(height: verticalSpacing * 0.3),
                      
                      // Location
                      Text(
                        jobSite.location,
                        style: GoogleFonts.poppins(
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      // Description (only if not empty)
                      if (jobSite.description.isNotEmpty) ...[
                        SizedBox(height: verticalSpacing * 0.2),
                        Text(
                          jobSite.description,
                          style: GoogleFonts.poppins(
                            fontSize: descriptionFontSize,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                
                SizedBox(width: horizontalPadding * 0.5),
                
                // Edit Button
                GestureDetector(
                  onTap: onEdit,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit,
                        size: iconSize * 0.6,
                        color: Color(AppFlavorConfig.getPrimaryColor(AppFlavorConfig.currentFlavor)),
                      ),
                      SizedBox(width: horizontalPadding * 0.2),
                      Text(
                        "Edit",
                        style: GoogleFonts.poppins(
                          fontSize: descriptionFontSize,
                          fontWeight: FontWeight.w500,
                          color: Color(AppFlavorConfig.getPrimaryColor(AppFlavorConfig.currentFlavor)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
