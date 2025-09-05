import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../data/dto/job_site_dto.dart';
import '../pages/project_overview_screen.dart';


class JobSiteCard extends StatelessWidget {
  final JobSiteDto jobSite;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final bool isSelected;

  const JobSiteCard({
    super.key,
    required this.jobSite,
    required this.onTap,
    required this.onEdit,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.04;
    final subtitleFontSize = screenWidth * 0.032;
    final descriptionFontSize = screenWidth * 0.03;
    final iconSize = screenWidth * 0.05;

    return Container(
      margin: EdgeInsets.only(bottom: verticalSpacing * 0.8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
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
                // Radio Button (Left Section)
                Container(
                  width: iconSize * 0.8,
                  height: iconSize * 0.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Color(AppFlavorConfig.getPrimaryColor(AppFlavorConfig.currentFlavor)) : Colors.grey[400]!,
                      width: 2,
                    ),
                    color: isSelected ? Color(AppFlavorConfig.getPrimaryColor(AppFlavorConfig.currentFlavor)) : Colors.transparent,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          size: iconSize * 0.5,
                          color: Colors.white,
                        )
                      : null,
                ),
                
                SizedBox(width: horizontalPadding * 0.8),
                
                // Job Site Information (Middle Section)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Job Site Name (Bold)
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
                      
                      SizedBox(height: verticalSpacing * 0.2),
                      
                      // City
                      Text(
                        jobSite.city,
                        style: GoogleFonts.poppins(
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      SizedBox(height: verticalSpacing * 0.15),
                      
                      // Address
                      Text(
                        jobSite.address,
                        style: GoogleFonts.poppins(
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      SizedBox(height: verticalSpacing * 0.15),
                      
                      // Code
                      Text(
                        "COD: ${jobSite.code}",
                        style: GoogleFonts.poppins(
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                SizedBox(width: horizontalPadding * 0.5),
                
                // Status and Action (Right Section)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Row
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Status Icon
                        Builder(
                          builder: (context) {
                            final iconPath = jobSite.status == JobSiteStatus.finished 
                                ? AssetsConfig.getFinishedIcon(AppFlavorConfig.currentFlavor)
                                : AssetsConfig.getInProgressIcon(AppFlavorConfig.currentFlavor);
                            print('Loading SVG: $iconPath');
                            return Container(
                              width: iconSize * 0.6,
                              height: iconSize * 0.6,
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                iconPath,
                                width: iconSize * 0.6,
                                height: iconSize * 0.6,
                                placeholderBuilder: (BuildContext context) => Container(
                                  width: iconSize * 0.6,
                                  height: iconSize * 0.6,
                                  color: Colors.red.withOpacity(0.3),
                                  child: Icon(
                                    Icons.error,
                                    size: iconSize * 0.4,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: horizontalPadding * 0.2),
                        // Status Text
                        Text(
                          jobSite.status == JobSiteStatus.finished 
                              ? "Finished" 
                              : "In progress",
                          style: GoogleFonts.poppins(
                            fontSize: descriptionFontSize,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: verticalSpacing * 0.3),
                    
                    // View Project Row
                    GestureDetector(
                      onTap: () {
                        try {
                          Get.toNamed(ProjectOverviewScreen.id, arguments: {
                            'flavor': AppFlavorConfig.currentFlavor,
                            'jobSite': jobSite,
                          });
                        } catch (e) {
                          print('Error navigating to Project Overview: $e');
                          Get.snackbar(
                            'Error',
                            'Could not open project overview',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: iconSize * 0.6,
                            height: iconSize * 0.6,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.visibility,
                              size: iconSize * 0.6,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(width: horizontalPadding * 0.2),
                          Text(
                            "View project",
                            style: GoogleFonts.poppins(
                              fontSize: descriptionFontSize,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
