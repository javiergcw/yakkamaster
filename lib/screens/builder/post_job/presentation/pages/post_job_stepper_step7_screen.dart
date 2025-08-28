import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../logic/controllers/post_job_controller.dart';
import 'post_job_stepper_step8_screen.dart';

class PostJobStepperStep7Screen extends StatefulWidget {
  final AppFlavor? flavor;

  const PostJobStepperStep7Screen({
    super.key,
    this.flavor,
  });

  @override
  State<PostJobStepperStep7Screen> createState() => _PostJobStepperStep7ScreenState();
}

class _PostJobStepperStep7ScreenState extends State<PostJobStepperStep7Screen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  late PostJobController _controller;
  
  String? _selectedPaymentOption;
  DateTime? _selectedPayDay;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<PostJobController>();
    // Asegurar que el controlador esté en el paso correcto
    _controller.goToStep(7);
    
    // Inicializar datos si ya existen en el controlador
    if (_controller.postJobData.paymentFrequency != null) {
      _selectedPaymentOption = _controller.postJobData.paymentFrequency;
    }
    if (_controller.postJobData.payDay != null) {
      _selectedPayDay = _controller.postJobData.payDay;
    }
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
                      _controller.handleBackNavigation();
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
            
            // Progress Indicator
            Container(
              width: double.infinity,
              height: 2,
              child: Row(
                children: [
                  // Progress (yellow) - 7 steps completed
                  Expanded(
                    flex: 7,
                    child: Container(
                      color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                    ),
                  ),
                  // Remaining (grey)
                  Expanded(
                    flex: 2,
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
                      "When will the worker be paid?",
                      style: GoogleFonts.poppins(
                        fontSize: questionFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                                         SizedBox(height: verticalSpacing),
                     
                     // Choose pay day option
                     _buildPaymentOption(
                       "Choose pay day",
                       isSelected: _selectedPaymentOption == "choose_pay_day",
                       onTap: () {
                         setState(() {
                           _selectedPaymentOption = "choose_pay_day";
                         });
                         _controller.updatePaymentFrequency("choose_pay_day");
                         _showPayDayPicker();
                       },
                     ),
                     
                     SizedBox(height: verticalSpacing),
                     
                     // On going jobs section
                     Text(
                       "On going jobs",
                       style: GoogleFonts.poppins(
                         fontSize: subtitleFontSize,
                         fontWeight: FontWeight.w600,
                         color: Colors.black,
                       ),
                     ),
                     
                     SizedBox(height: verticalSpacing * 0.5),
                     
                     // Weekly payment option
                     _buildPaymentOption(
                       "Weekly payment",
                       isSelected: _selectedPaymentOption == "weekly",
                       onTap: () {
                         setState(() {
                           _selectedPaymentOption = "weekly";
                         });
                         _controller.updatePaymentFrequency("weekly");
                       },
                     ),
                     
                     SizedBox(height: verticalSpacing * 0.5),
                     
                     // Fortnightly payment option
                     _buildPaymentOption(
                       "Fortnightly payment",
                       isSelected: _selectedPaymentOption == "fortnightly",
                       onTap: () {
                         setState(() {
                           _selectedPaymentOption = "fortnightly";
                         });
                         _controller.updatePaymentFrequency("fortnightly");
                       },
                     ),
                     
                     SizedBox(height: verticalSpacing * 2),
                    
                                         // Warning box
                     GestureDetector(
                       onTap: _openFAQsPage,
                       child: Container(
                         width: double.infinity,
                         padding: EdgeInsets.all(horizontalPadding),
                         decoration: BoxDecoration(
                           color: Colors.grey[100],
                           borderRadius: BorderRadius.circular(12),
                           border: Border.all(
                             color: Colors.grey[300]!,
                             width: 1,
                           ),
                         ),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Row(
                               children: [
                                 Icon(
                                   Icons.warning_amber_rounded,
                                   color: Colors.orange[600],
                                   size: screenWidth * 0.05,
                                 ),
                                 SizedBox(width: horizontalPadding * 0.5),
                                 Expanded(
                                   child: Text(
                                     "What happens if I don't pay the labourer?",
                                     style: GoogleFonts.poppins(
                                       fontSize: screenWidth * 0.035,
                                       fontWeight: FontWeight.w600,
                                       color: Colors.black,
                                     ),
                                   ),
                                 ),
                                 Icon(
                                   Icons.arrow_forward_ios,
                                   color: Colors.grey[600],
                                   size: screenWidth * 0.04,
                                 ),
                               ],
                             ),
                             SizedBox(height: verticalSpacing * 0.5),
                             Text(
                               "YAKKA cannot get involved. However, if payment is not made, the worker may take legal action, and your reputation on the platform may be affected.",
                               style: GoogleFonts.poppins(
                                 fontSize: screenWidth * 0.032,
                                 color: Colors.black87,
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                  ],
                ),
              ),
            ),
            
            // Continue Button
            Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: CustomButton(
                text: "Continue",
                onPressed: _canProceed() ? _handleContinue : null,
                type: ButtonType.secondary,
                flavor: _currentFlavor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String text, {required bool isSelected, required VoidCallback onTap}) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalSpacing * 0.8,
        ),
                 decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.circular(12),
           border: Border.all(
             color: isSelected 
                 ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                 : Colors.black,
             width: isSelected ? 1 : 2,
           ),
         ),
        child: Row(
          children: [
            // Radio button
                         Container(
               width: screenWidth * 0.05,
               height: screenWidth * 0.05,
               decoration: BoxDecoration(
                 shape: BoxShape.circle,
                 border: Border.all(
                   color: isSelected 
                       ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                       : Colors.black,
                   width: isSelected ? 2 : 3,
                 ),
                 color: isSelected 
                     ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                     : Colors.transparent,
               ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: screenWidth * 0.03,
                      color: Colors.white,
                    )
                  : null,
            ),
            
            SizedBox(width: horizontalPadding * 0.8),
            
            // Text
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            
            // Show selected pay day if applicable
            if (text == "Choose pay day" && _selectedPayDay != null)
              Text(
                _formatDate(_selectedPayDay!),
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.03,
                  color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  void _showPayDayPicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedPayDay ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedPayDay = picked;
      });
      _controller.updatePayDay(picked);
    }
  }

  bool _canProceed() {
    return _selectedPaymentOption != null && _selectedPaymentOption!.isNotEmpty;
  }

  void _handleContinue() {
    if (_canProceed()) {
      _controller.nextStep();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PostJobStepperStep8Screen(flavor: _currentFlavor),
        ),
      );
    }
  }

  void _openFAQsPage() async {
    const url = 'https://yakkalabour.com.au/faqs/';
    
    try {
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Error opening FAQs: $e');
      // No mostrar ningún modal, simplemente no hacer nada
    }
  }
  

}
