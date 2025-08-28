import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../logic/controllers/post_job_controller.dart';

class PostJobReviewScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const PostJobReviewScreen({
    super.key,
    this.flavor,
  });

  @override
  State<PostJobReviewScreen> createState() => _PostJobReviewScreenState();
}

class _PostJobReviewScreenState extends State<PostJobReviewScreen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  late PostJobController _controller;
  
  bool _isPublic = true;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<PostJobController>();
    
    // Inicializar el estado público/privado
    _isPublic = _controller.postJobData.isPublic ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final questionFontSize = screenWidth * 0.075;
    final subtitleFontSize = screenWidth * 0.045;
    final iconSize = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing * 0.6,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: iconSize,
                    ),
                  ),
                  
                  SizedBox(width: horizontalPadding),
                  
                  // Title
                  Expanded(
                    child: Text(
                      "Post a job",
                      style: GoogleFonts.poppins(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  SizedBox(width: horizontalPadding + iconSize),
                ],
              ),
            ),
            
            // Progress Indicator - Completado
            Container(
              width: double.infinity,
              height: 2,
              child: Row(
                children: [
                  // Progress (yellow) - 9 steps completed
                  Expanded(
                    flex: 9,
                    child: Container(
                      color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                    ),
                  ),
                  // Remaining (grey) - 0 remaining
                  Expanded(
                    flex: 0,
                    child: Container(
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ),
            
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: verticalSpacing * 0.2),
                    
                    // Main Question
                    Text(
                      "Ready to post your job?",
                      style: GoogleFonts.poppins(
                        fontSize: questionFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing),
                    
                                         // Public/Private Toggle Section
                     Row(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(
                                 "Public",
                                 style: GoogleFonts.poppins(
                                   fontSize: subtitleFontSize,
                                   fontWeight: FontWeight.w600,
                                   color: Colors.black,
                                 ),
                               ),
                               SizedBox(height: verticalSpacing * 0.2),
                               Text(
                                 "Turn off job visibility to hide this job temporarily. Only you'll see it.",
                                 style: GoogleFonts.poppins(
                                   fontSize: screenWidth * 0.032,
                                   color: Colors.black87,
                                 ),
                                 softWrap: true,
                               ),
                             ],
                           ),
                         ),
                         Switch(
                           value: _isPublic,
                           onChanged: (value) {
                             setState(() {
                               _isPublic = value;
                             });
                             _controller.updateIsPublic(value);
                           },
                           activeColor: Colors.black,
                           activeTrackColor: Colors.grey[400],
                           inactiveThumbColor: Colors.white,
                           inactiveTrackColor: Colors.grey[300],
                         ),
                       ],
                     ),
                    
                                         SizedBox(height: verticalSpacing),
                     
                     // Job Summary Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(horizontalPadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Job Title and Rate
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _controller.postJobData.selectedSkill ?? "Truck Driver",
                                  style: GoogleFonts.poppins(
                                    fontSize: subtitleFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Text(
                                "\$${(_controller.postJobData.hourlyRate ?? 28.0).toStringAsFixed(1)}/hr",
                                style: GoogleFonts.poppins(
                                  fontSize: subtitleFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: verticalSpacing),
                          
                          // Job Details
                          _buildJobDetail(
                            Icons.location_on,
                            "Address: 1 test ridge",
                            "Suburb: Sydney",
                            "City: Sydney, New South Wales",
                          ),
                          
                          SizedBox(height: verticalSpacing * 0.8),
                          
                          _buildJobDetail(
                            Icons.calendar_today,
                            "Dates: ${_formatDateRange()}",
                          ),
                          
                          SizedBox(height: verticalSpacing * 0.8),
                          
                          _buildJobDetail(
                            Icons.access_time,
                            "Time: ${_formatTimeRange()}",
                          ),
                          
                          SizedBox(height: verticalSpacing * 0.8),
                          
                          _buildJobDetail(
                            Icons.description,
                            "Payment is expected: ${_formatPaymentFrequency()}",
                          ),
                          
                          SizedBox(height: verticalSpacing * 0.8),
                          
                          _buildJobDetail(
                            Icons.list,
                            "Description: ${_controller.postJobData.jobDescription ?? "asd"}",
                          ),
                        ],
                      ),
                    ),
                    
                                         SizedBox(height: verticalSpacing),
                  ],
                ),
              ),
            ),
            
            // Action Buttons
            Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: Column(
                children: [
                                     // Edit Button
                   SizedBox(
                     width: double.infinity,
                     child: CustomButton(
                       text: "Edit",
                       onPressed: _handleEdit,
                       type: ButtonType.secondary,
                       flavor: _currentFlavor,
                       showShadow: false,
                     ),
                   ),
                  
                  SizedBox(height: verticalSpacing),
                  
                                     // Confirm Button
                   SizedBox(
                     width: double.infinity,
                     child: CustomButton(
                       text: "Confirm",
                       onPressed: _handleConfirm,
                       type: ButtonType.primary,
                       flavor: _currentFlavor,
                       showShadow: false,
                     ),
                   ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobDetail(IconData icon, String mainText, [String? subtitle1, String? subtitle2]) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final verticalSpacing = mediaQuery.size.height * 0.025;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.grey[600],
          size: screenWidth * 0.04,
        ),
        SizedBox(width: screenWidth * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mainText,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.032,
                  color: Colors.black87,
                ),
              ),
              if (subtitle1 != null) ...[
                SizedBox(height: verticalSpacing * 0.2),
                Text(
                  subtitle1,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.032,
                    color: Colors.black87,
                  ),
                ),
              ],
              if (subtitle2 != null) ...[
                SizedBox(height: verticalSpacing * 0.2),
                Text(
                  subtitle2,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.032,
                    color: Colors.black87,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _formatDateRange() {
    final startDate = _controller.postJobData.startDate;
    final endDate = _controller.postJobData.endDate;
    
    if (startDate == null) return "Not set";
    
    final startFormatted = "${startDate.day.toString().padLeft(2, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.year}";
    
    if (endDate == null || _controller.postJobData.isOngoingWork == true) {
      return "$startFormatted - Ongoing";
    }
    
    final endFormatted = "${endDate.day.toString().padLeft(2, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.year}";
    return "$startFormatted - $endFormatted";
  }

  String _formatTimeRange() {
    final startTime = _controller.postJobData.startTime;
    final endTime = _controller.postJobData.endTime;
    
    if (startTime == null || endTime == null) return "Not set";
    
    final startFormatted = startTime.format(context);
    final endFormatted = endTime.format(context);
    
    return "$startFormatted - $endFormatted";
  }

  String _formatPaymentFrequency() {
    final frequency = _controller.postJobData.paymentFrequency;
    
    switch (frequency) {
      case "weekly":
        return "Weekly payment";
      case "fortnightly":
        return "Fortnightly payment";
      case "choose_pay_day":
        final payDay = _controller.postJobData.payDay;
        if (payDay != null) {
          return "Specific date: ${payDay.day.toString().padLeft(2, '0')}-${payDay.month.toString().padLeft(2, '0')}-${payDay.year}";
        }
        return "Choose pay day";
      default:
        return "Not set";
    }
  }

  void _handleEdit() {
    // TODO: Implementar navegación de vuelta al primer paso para editar
    Navigator.of(context).pop();
  }

  void _handleConfirm() {
    // TODO: Implementar lógica de confirmación y publicación
    _controller.postJob();
    
    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Job posted successfully!'),
        backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
        duration: Duration(seconds: 2),
      ),
    );
    
    // Navegar de vuelta a la pantalla principal
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
