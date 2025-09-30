import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../data/dto/job_dto.dart';

class JobCard extends StatelessWidget {
  final JobDto job;
  final AppFlavor? flavor;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;
  final VoidCallback? onShowMore;
  final Function(bool)? onVisibilityChanged;

  const JobCard({
    super.key,
    required this.job,
    this.flavor,
    this.onShare,
    this.onDelete,
    this.onShowMore,
    this.onVisibilityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final horizontalPadding = screenWidth * 0.04;
    final verticalPadding = screenHeight * 0.015;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding * 0.3,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con título y acciones
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onShowMore,
                    child: Text(
                      job.title,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    // Botón compartir
                    GestureDetector(
                      onTap: onShare,
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        child: Icon(
                          Icons.share,
                          size: screenWidth * 0.05,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    // Botón eliminar
                    GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.015),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.delete,
                          size: screenWidth * 0.04,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: verticalPadding * 0.3),

            // Detalles del trabajo
            _buildJobDetail(
              icon: Icons.attach_money,
              text: '${job.rate.toStringAsFixed(2)}/hr',
              screenWidth: screenWidth,
            ),
            _buildJobDetail(
              icon: Icons.location_on,
              text: job.location,
              screenWidth: screenWidth,
            ),
            _buildJobDetail(
              icon: Icons.calendar_today,
              text: '${_formatDate(job.startDate)} - ${_formatDate(job.endDate)}',
              screenWidth: screenWidth,
            ),
            _buildJobDetail(
              icon: Icons.menu,
              text: job.jobType,
              screenWidth: screenWidth,
            ),
            _buildJobDetail(
              icon: Icons.rss_feed,
              text: 'Source: ${job.source}',
              screenWidth: screenWidth,
            ),

            SizedBox(height: verticalPadding * 0.3),

            // Footer con controles
            Row(
              children: [
                // Fecha de publicación
                Expanded(
                  flex: 2,
                  child: Text(
                    'Posted: ${_formatPostedDate(job.postedDate)}',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                
                // Toggle de visibilidad
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text(
                        'Visibility',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Switch(
                        value: job.isVisible,
                        onChanged: onVisibilityChanged,
                        activeColor: Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor)),
                      ),
                    ],
                  ),
                ),
                
                // Botón Show more
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: onShowMore,
                    child: Container(
                                             padding: EdgeInsets.symmetric(
                         horizontal: screenWidth * 0.025,
                         vertical: screenHeight * 0.008,
                       ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Show more',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
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
  }

  Widget _buildJobDetail({
    required IconData icon,
    required String text,
    required double screenWidth,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.01),
      child: Row(
        children: [
          Icon(
            icon,
            size: screenWidth * 0.04,
            color: Colors.grey[600],
          ),
          SizedBox(width: screenWidth * 0.025),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.035,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatPostedDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}';
  }
}
