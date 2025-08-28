import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../logic/controllers/post_job_controller.dart';
import '../widgets/workers_count_modal.dart';
import 'post_job_stepper_step3_screen.dart';

class PostJobStepperStep2Screen extends StatefulWidget {
  final AppFlavor? flavor;

  const PostJobStepperStep2Screen({
    super.key,
    this.flavor,
  });

  @override
  State<PostJobStepperStep2Screen> createState() => _PostJobStepperStep2ScreenState();
}

class _PostJobStepperStep2ScreenState extends State<PostJobStepperStep2Screen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  late PostJobController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<PostJobController>();
    // Asegurar que el controlador esté en el paso correcto
    _controller.goToStep(2);
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
    final questionFontSize = screenWidth * 0.075;
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
                  // Progress (yellow) - 2 steps completed
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                    ),
                  ),
                  // Remaining (grey)
                  Expanded(
                    flex: 7,
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
                    SizedBox(height: verticalSpacing * 1.0),
                    
                    // Main Question
                    Text(
                      "How many labourers do you need?",
                      style: GoogleFonts.poppins(
                        fontSize: questionFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 2),
                    
                    // Options Grid
                    _buildOptionsGrid(),
                    
                    SizedBox(height: verticalSpacing * 3),
                  ],
                ),
              ),
            ),
            
            // Continue Button
            Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: Obx(() => CustomButton(
                text: "Continue",
                onPressed: _controller.canProceedToNextStep() ? _handleContinue : null,
                type: ButtonType.secondary,
                flavor: _currentFlavor,
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsGrid() {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final buttonHeight = screenHeight * 0.08;
    final buttonFontSize = screenWidth * 0.04;

    final options = ['1', '2', '3', '4', '5', 'More than 5'];

    return Column(
      children: [
        for (int i = 0; i < options.length; i += 2)
          Padding(
            padding: EdgeInsets.only(bottom: verticalSpacing),
            child: Row(
              children: [
                // First button in row
                Expanded(
                  child: _buildOptionButton(
                    options[i],
                    buttonHeight,
                    buttonFontSize,
                  ),
                ),
                
                SizedBox(width: horizontalPadding * 0.5),
                
                // Second button in row (if exists)
                if (i + 1 < options.length)
                  Expanded(
                    child: _buildOptionButton(
                      options[i + 1],
                      buttonHeight,
                      buttonFontSize,
                    ),
                  )
                else
                  Expanded(child: SizedBox()),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildOptionButton(String option, double height, double fontSize) {
    return Obx(() {
      final isSelected = _controller.postJobData.workersNeeded != null &&
          ((option == 'More than 5' && _controller.postJobData.workersNeeded! > 5) ||
           (option != 'More than 5' && _controller.postJobData.workersNeeded == int.parse(option)));

             return GestureDetector(
         onTap: () {
           if (option == 'More than 5') {
             _showWorkersCountModal();
           } else {
             _controller.updateWorkersNeeded(int.parse(option));
           }
         },
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: isSelected 
                ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected 
                  ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                  : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              option,
              style: GoogleFonts.poppins(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.black : Colors.black87,
              ),
            ),
          ),
        ),
      );
    });
  }

  void _showWorkersCountModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WorkersCountModal(flavor: _currentFlavor),
    );
  }

  void _handleContinue() {
    if (_controller.canProceedToNextStep()) {
      _controller.nextStep();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PostJobStepperStep3Screen(flavor: _currentFlavor),
        ),
      );
    }
  }
}
