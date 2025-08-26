import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/app_flavor.dart';
import '../../../../config/assets_config.dart';
import '../../data/dto/job_dto.dart';
import '../../data/dto/job_details_dto.dart';
import '../pages/job_details_screen.dart';

class JobCard extends StatelessWidget {
  final JobDto job;
  final VoidCallback onShare;
  final VoidCallback onShowMore;
  final double horizontalPadding;
  final double verticalSpacing;
  final double titleFontSize;
  final double bodyFontSize;
  final double iconSize;

  const JobCard({
    super.key,
    required this.job,
    required this.onShare,
    required this.onShowMore,
    required this.horizontalPadding,
    required this.verticalSpacing,
    required this.titleFontSize,
    required this.bodyFontSize,
    required this.iconSize,
    this.flavor,
  });

  final AppFlavor? flavor;
  AppFlavor get _currentFlavor => flavor ?? AppFlavorConfig.currentFlavor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: verticalSpacing),
      padding: EdgeInsets.all(horizontalPadding),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and share button
          Row(
            children: [
              Expanded(
                child: Text(
                  job.title,
                  style: GoogleFonts.poppins(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onShare,
                child: Container(
                  width: iconSize * 1.5,
                  height: iconSize * 1.5,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.share,
                    size: iconSize * 0.8,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: verticalSpacing * 0.5),
          
          // Hourly rate
          Text(
            '\$${job.hourlyRate.toStringAsFixed(2)}/hr',
            style: GoogleFonts.poppins(
              fontSize: bodyFontSize * 1.1,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          
          SizedBox(height: verticalSpacing),
          
          // Job details
          _buildDetailRow(
            icon: Icons.location_on,
            text: job.location,
          ),
          
          SizedBox(height: verticalSpacing * 0.5),
          
          _buildDetailRow(
            icon: Icons.business,
            text: job.dateRange,
          ),
          
          SizedBox(height: verticalSpacing * 0.5),
          
          _buildDetailRow(
            icon: Icons.list,
            text: job.jobType,
          ),
          
          SizedBox(height: verticalSpacing * 0.5),
          
          _buildDetailRow(
            icon: Icons.wifi,
            text: 'Source: ${job.source}',
          ),
          
          SizedBox(height: verticalSpacing),
          
          // Footer
          Row(
            children: [
              Text(
                'Posted: ${job.postedDate}',
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize * 0.9,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onShowMore,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding * 0.8,
                    vertical: verticalSpacing * 0.5,
                  ),
                                     decoration: BoxDecoration(
                     color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                     borderRadius: BorderRadius.circular(8),
                   ),
                  child: Text(
                    'Show more',
                    style: GoogleFonts.poppins(
                      fontSize: bodyFontSize * 0.9,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: iconSize * 0.8,
          color: Colors.black87,
        ),
        SizedBox(width: horizontalPadding * 0.5),
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
}
