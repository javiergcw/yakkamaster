import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../../logic/controllers/post_job_controller.dart';
import '../widgets/custom_time_picker_modal.dart';
import 'post_job_stepper_step6_screen.dart';

class PostJobStepperStep5Screen extends StatefulWidget {
  final AppFlavor? flavor;

  const PostJobStepperStep5Screen({
    super.key,
    this.flavor,
  });

  @override
  State<PostJobStepperStep5Screen> createState() => _PostJobStepperStep5ScreenState();
}

class _PostJobStepperStep5ScreenState extends State<PostJobStepperStep5Screen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  late PostJobController _controller;
  
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  String? _selectedJobType;

  final List<String> _jobTypes = [
    'Casual Job',
    'Part time',
    'Full time',
    'Farms Job',
    'Mining Job',
    'FIFO',
    'Seasonal job',
    'W&H visa',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _controller = Get.find<PostJobController>();
    // Asegurar que el controlador esté en el paso correcto
    _controller.goToStep(5);
    
    // Inicializar datos si ya existen en el controlador
    if (_controller.postJobData.startTime != null) {
      _selectedStartTime = _controller.postJobData.startTime;
    }
    if (_controller.postJobData.endTime != null) {
      _selectedEndTime = _controller.postJobData.endTime;
    }
    if (_controller.postJobData.jobType != null) {
      _selectedJobType = _controller.postJobData.jobType;
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
                  // Progress (yellow) - 5 steps completed
                  Expanded(
                    flex: 5,
                    child: Container(
                      color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                    ),
                  ),
                  // Remaining (grey)
                  Expanded(
                    flex: 4,
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
                    
                    // First Question - Time
                    Text(
                      "At what time?",
                      style: GoogleFonts.poppins(
                        fontSize: questionFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing),
                    
                    // Subtitle
                    Text(
                      "Select the start and end time",
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        color: Colors.black87,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 1.5),
                    
                    // Time input fields
                    _buildTimeInputFields(),
                    
                    SizedBox(height: verticalSpacing * 3),
                    
                    // Second Question - Job Type
                    Text(
                      "What kind of job are you offering?",
                      style: GoogleFonts.poppins(
                        fontSize: questionFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 1.5),
                    
                    // Job type chips
                    _buildJobTypeChips(),
                    
                    SizedBox(height: verticalSpacing * 3),
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

  Widget _buildTimeInputFields() {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;

    return Row(
      children: [
        // Start time field
        Expanded(
          child: GestureDetector(
            onTap: () => _showTimePicker(true),
            child: CustomTextField(
              labelText: "Start time",
              hintText: "hh:mm",
              controller: TextEditingController(
                text: _selectedStartTime != null 
                    ? "${_selectedStartTime!.hour.toString().padLeft(2, '0')}:${_selectedStartTime!.minute.toString().padLeft(2, '0')}"
                    : "",
              ),
              enabled: false,
              flavor: _currentFlavor,
            ),
          ),
        ),
        
        SizedBox(width: horizontalPadding * 0.5),
        
        // End time field
        Expanded(
          child: GestureDetector(
            onTap: () => _showTimePicker(false),
            child: CustomTextField(
              labelText: "End time",
              hintText: "hh:mm",
              controller: TextEditingController(
                text: _selectedEndTime != null 
                    ? "${_selectedEndTime!.hour.toString().padLeft(2, '0')}:${_selectedEndTime!.minute.toString().padLeft(2, '0')}"
                    : "",
              ),
              enabled: false,
              flavor: _currentFlavor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJobTypeChips() {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final chipHeight = screenHeight * 0.045; // Reducido de 0.06 a 0.045
    final chipFontSize = screenWidth * 0.03; // Reducido de 0.035 a 0.03

    return Wrap(
      spacing: horizontalPadding * 0.5,
      runSpacing: verticalSpacing * 0.8,
      children: _jobTypes.map((jobType) {
        final isSelected = _selectedJobType == jobType;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedJobType = jobType;
            });
            _controller.updateJobType(jobType);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding * 0.8,
              vertical: verticalSpacing * 0.6,
            ),
            decoration: BoxDecoration(
              color: isSelected 
                  ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                  : Colors.white,
              borderRadius: BorderRadius.circular(chipHeight * 0.5),
              border: Border.all(
                color: isSelected
                    ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                    : Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Text(
              jobType,
              style: GoogleFonts.poppins(
                fontSize: chipFontSize,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showTimePicker(bool isStartTime) {
    print('_showTimePicker called: ${isStartTime ? "Start" : "End"} time');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomTimePickerModal(
        flavor: _currentFlavor,
        initialTime: isStartTime 
            ? (_selectedStartTime ?? TimeOfDay.now())
            : (_selectedEndTime ?? _selectedStartTime ?? TimeOfDay.now()),
        onTimeSelected: (selectedTime) {
          print('Time selected: ${selectedTime.format(context)}');
          setState(() {
            if (isStartTime) {
              _selectedStartTime = selectedTime;
              _controller.updateStartTime(selectedTime);
            } else {
              _selectedEndTime = selectedTime;
              _controller.updateEndTime(selectedTime);
            }
          });
        },
      ),
    );
  }

  bool _canProceed() {
    return _selectedStartTime != null && 
           _selectedEndTime != null &&
           _selectedJobType != null &&
           _selectedJobType!.isNotEmpty;
  }

  void _handleContinue() {
    if (_canProceed()) {
      _controller.nextStep();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PostJobStepperStep6Screen(flavor: _currentFlavor),
        ),
      );
    }
  }
}
