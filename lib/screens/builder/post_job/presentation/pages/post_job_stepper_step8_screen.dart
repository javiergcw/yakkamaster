import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../../logic/controllers/post_job_controller.dart';
import 'post_job_review_screen.dart';

class PostJobStepperStep8Screen extends StatefulWidget {
  final AppFlavor? flavor;

  const PostJobStepperStep8Screen({
    super.key,
    this.flavor,
  });

  @override
  State<PostJobStepperStep8Screen> createState() => _PostJobStepperStep8ScreenState();
}

class _PostJobStepperStep8ScreenState extends State<PostJobStepperStep8Screen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  late PostJobController _controller;
  
  String? _selectedOption;
  final TextEditingController _supervisorNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = Get.find<PostJobController>();
    // Asegurar que el controlador esté en el paso correcto
    _controller.goToStep(8);
    
    // Inicializar datos si ya existen en el controlador
    if (_controller.postJobData.requiresSupervisorSignature != null) {
      _selectedOption = _controller.postJobData.requiresSupervisorSignature! ? "yes" : "no";
    }
    if (_controller.postJobData.supervisorName != null) {
      _supervisorNameController.text = _controller.postJobData.supervisorName!;
    }
    
    // Agregar listener para actualizar el controlador cuando cambie el texto
    _supervisorNameController.addListener(() {
      _controller.updateSupervisorName(_supervisorNameController.text);
    });
  }

  @override
  void dispose() {
    _supervisorNameController.dispose();
    super.dispose();
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
                  // Progress (yellow) - 8 steps completed
                  Expanded(
                    flex: 8,
                    child: Container(
                      color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                    ),
                  ),
                  // Remaining (grey)
                  Expanded(
                    flex: 1,
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
                      "Does this job require a supervisor's signature?",
                      style: GoogleFonts.poppins(
                        fontSize: questionFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing),
                    
                    // Yes/No buttons
                    Row(
                      children: [
                        // Yes button
                        Expanded(
                          child: _buildSelectionButton(
                            "Yes",
                            isSelected: _selectedOption == "yes",
                            onTap: () {
                              setState(() {
                                _selectedOption = "yes";
                              });
                              _controller.updateRequiresSupervisorSignature(true);
                            },
                          ),
                        ),
                        
                        SizedBox(width: horizontalPadding * 0.5),
                        
                        // No button
                        Expanded(
                          child: _buildSelectionButton(
                            "No",
                            isSelected: _selectedOption == "no",
                            onTap: () {
                              setState(() {
                                _selectedOption = "no";
                              });
                              _controller.updateRequiresSupervisorSignature(false);
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    // Conditional content based on selection
                    if (_selectedOption == "yes") ...[
                      SizedBox(height: verticalSpacing),
                      
                      // Supervisor name section
                      Text(
                        "Add supervisor's name",
                        style: GoogleFonts.poppins(
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      
                      SizedBox(height: verticalSpacing * 0.5),
                      
                      // Supervisor name input
                      CustomTextField(
                        controller: _supervisorNameController,
                        hintText: "Supervisor name",
                        flavor: _currentFlavor,
                      ),
                      
                      SizedBox(height: verticalSpacing),
                      
                      // Information box
                      Container(
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
                                  Icons.info_outline,
                                  color: Colors.blue[600],
                                  size: screenWidth * 0.05,
                                ),
                                SizedBox(width: horizontalPadding * 0.5),
                                Expanded(
                                  child: Text(
                                    "The supervisor must sign before the labourer submit the timesheet.\nIf the labourer completes the timesheet incorrectly, you can always report it and edit it",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.032,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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

  Widget _buildSelectionButton(String text, {required bool isSelected, required VoidCallback onTap}) {
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
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  bool _canProceed() {
    if (_selectedOption == null) return false;
    if (_selectedOption == "yes") {
      return _supervisorNameController.text.trim().isNotEmpty;
    }
    return true;
  }

  void _handleContinue() {
    if (_canProceed()) {
      _controller.nextStep();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PostJobReviewScreen(flavor: _currentFlavor),
        ),
      );
    }
  }
}
