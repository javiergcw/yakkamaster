import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../../logic/controllers/post_job_controller.dart';
import 'post_job_stepper_step5_screen.dart';

class PostJobStepperStep4Screen extends StatefulWidget {
  final AppFlavor? flavor;

  const PostJobStepperStep4Screen({
    super.key,
    this.flavor,
  });

  @override
  State<PostJobStepperStep4Screen> createState() => _PostJobStepperStep4ScreenState();
}

class _PostJobStepperStep4ScreenState extends State<PostJobStepperStep4Screen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  late PostJobController _controller;
  
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<PostJobController>();
    // Asegurar que el controlador esté en el paso correcto
    _controller.goToStep(4);
    
    // Inicializar fechas si ya existen en el controlador
    if (_controller.postJobData.startDate != null) {
      _selectedStartDate = _controller.postJobData.startDate;
      _focusedDay = _selectedStartDate!;
    }
    if (_controller.postJobData.endDate != null) {
      _selectedEndDate = _controller.postJobData.endDate;
    }
    if (_selectedStartDate != null && _selectedEndDate != null) {
      _selectedDateRange = DateTimeRange(
        start: _selectedStartDate!,
        end: _selectedEndDate!,
      );
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
                  // Progress (yellow) - 4 steps completed
                  Expanded(
                    flex: 4,
                    child: Container(
                      color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                    ),
                  ),
                  // Remaining (grey)
                  Expanded(
                    flex: 5,
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
                       "When is the job?",
                      style: GoogleFonts.poppins(
                        fontSize: questionFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing),
                    
                    // Subtitle
                    Text(
                      "Select the start and end date",
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        color: Colors.black87,
                      ),
                    ),
                    
                                         SizedBox(height: verticalSpacing * 1.0),
                     
                                          // Ongoing work checkbox
                      _buildOngoingWorkCheckbox(),
                    
                    SizedBox(height: verticalSpacing * 0.8),
                    
                    // Calendar
                    _buildCalendar(),
                    
                    SizedBox(height: verticalSpacing * 0.02),
                    
                    // Date input fields
                    _buildDateInputFields(),
                    
                    SizedBox(height: verticalSpacing * 1.0),
                    
                    // Work days options
                    _buildWorkDaysOptions(),
                    
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

  Widget _buildOngoingWorkCheckbox() {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final checkboxSize = screenWidth * 0.05;
    final fontSize = screenWidth * 0.035;

    return GestureDetector(
             onTap: () {
         final currentValue = _controller.postJobData.isOngoingWork ?? false;
         _controller.updateIsOngoingWork(!currentValue);
         setState(() {}); // Trigger rebuild
         
         // Si se activa "ongoing work", mostrar popup de confirmación
         if (!currentValue) {
           _showOngoingWorkDialog();
         }
       },
             child: Row(
         children: [
           Container(
             width: checkboxSize,
             height: checkboxSize,
             decoration: BoxDecoration(
               color: (_controller.postJobData.isOngoingWork ?? false) 
                   ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                   : Colors.white,
               borderRadius: BorderRadius.circular(4),
               border: Border.all(
                 color: (_controller.postJobData.isOngoingWork ?? false)
                     ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                     : Colors.grey[400]!,
                 width: 2,
               ),
             ),
             child: (_controller.postJobData.isOngoingWork ?? false)
                 ? Icon(
                     Icons.check,
                     color: Colors.white,
                     size: checkboxSize * 0.6,
                   )
                 : null,
           ),
          
          SizedBox(width: horizontalPadding * 0.5),
          
          Text(
            "Ongoing work?",
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

     Widget _buildCalendar() {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;

    return Column(
      children: [
        // Calendar header
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding * 0.8,
            vertical: verticalSpacing * 0.8,
          ),
          child: Row(
            children: [
              // Month selector
              Expanded(
                child: GestureDetector(
                  onTap: () => _showMonthPicker(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding * 0.5,
                      vertical: verticalSpacing * 0.3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _getMonthName(_focusedDay.month),
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: horizontalPadding * 0.5),
              
              // Year selector
              Expanded(
                child: GestureDetector(
                  onTap: () => _showYearPicker(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding * 0.5,
                      vertical: verticalSpacing * 0.3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _focusedDay.year.toString(),
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: horizontalPadding * 0.5),
              
              // Navigation arrows
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  ),
                  
                  SizedBox(width: 8),
                  
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Calendar grid
        _buildCalendarGrid(),
      ],
    );
  } 


  Widget _buildCalendarGrid() {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final daySize = screenWidth * 0.12;
    final dayFontSize = screenWidth * 0.03;
    final headerFontSize = screenWidth * 0.025;

    // Get days of the month
    final daysInMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0).day;
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final firstWeekday = firstDayOfMonth.weekday;

    return Padding(
      padding: EdgeInsets.all(horizontalPadding * 0.8),
      child: Column(
        children: [
          // Days of week header
          Row(
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
              return Expanded(
                child: Container(
                  height: daySize * 0.6,
                  child: Center(
                    child: Text(
                      day,
                      style: GoogleFonts.poppins(
                        fontSize: headerFontSize,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          SizedBox(height: verticalSpacing * 0.5),
          
          // Calendar days
          ...List.generate((daysInMonth + firstWeekday - 1) ~/ 7 + 1, (weekIndex) {
            return Padding(
              padding: EdgeInsets.only(bottom: verticalSpacing * 0.3),
              child: Row(
                children: List.generate(7, (dayIndex) {
                  final dayNumber = weekIndex * 7 + dayIndex - firstWeekday + 1;
                  
                  if (dayNumber < 1 || dayNumber > daysInMonth) {
                    return Expanded(child: SizedBox(height: daySize));
                  }
                  
                  final currentDate = DateTime(_focusedDay.year, _focusedDay.month, dayNumber);
                  final today = DateTime.now();
                  final todayStart = DateTime(today.year, today.month, today.day);
                  final currentDateStart = DateTime(currentDate.year, currentDate.month, currentDate.day);
                  final isPastDay = currentDateStart.isBefore(todayStart);
                  
                  final isSelected = (_selectedStartDate != null && 
                      currentDate.isAtSameMomentAs(_selectedStartDate!)) ||
                      (_selectedDateRange != null &&
                      (currentDate.isAtSameMomentAs(_selectedDateRange!.start) ||
                       currentDate.isAtSameMomentAs(_selectedDateRange!.end) ||
                       (currentDate.isAfter(_selectedDateRange!.start) &&
                        currentDate.isBefore(_selectedDateRange!.end))));
                  
                  return Expanded(
                    child: GestureDetector(
                      onTap: isPastDay ? null : () => _onDaySelected(currentDate),
                      child: Container(
                        height: daySize,
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(daySize * 0.5),
                          border: Border.all(
                            color: isSelected
                                ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                                : Colors.transparent,
                            width: isSelected ? 2 : 0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            dayNumber.toString(),
                            style: GoogleFonts.poppins(
                              fontSize: dayFontSize,
                              fontWeight: FontWeight.w500,
                              color: isPastDay ? Colors.grey[400] : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDateInputFields() {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
                 Text(
           "Selected dates",
           style: GoogleFonts.poppins(
             fontSize: screenWidth * 0.04,
             fontWeight: FontWeight.w600,
             color: Colors.black,
           ),
         ),
         
                 SizedBox(height: verticalSpacing * 0.3),
         
         Row(
          children: [
                         // Start date field
             Expanded(
               child: CustomTextField(
                 labelText: "Start date",
                 hintText: "dd-mm-yyyy",
                 controller: TextEditingController(
                   text: _selectedStartDate != null 
                       ? "${_selectedStartDate!.day.toString().padLeft(2, '0')}-${_selectedStartDate!.month.toString().padLeft(2, '0')}-${_selectedStartDate!.year}"
                       : "",
                 ),
                 enabled: false,
                 onTap: () => _showDatePicker(true),
                 flavor: _currentFlavor,
               ),
             ),
            
            SizedBox(width: horizontalPadding * 0.5),
            
                         // End date field
             Expanded(
               child: CustomTextField(
                 labelText: "End date",
                 hintText: "dd-mm-yyyy",
                 controller: TextEditingController(
                   text: _selectedEndDate != null 
                       ? "${_selectedEndDate!.day.toString().padLeft(2, '0')}-${_selectedEndDate!.month.toString().padLeft(2, '0')}-${_selectedEndDate!.year}"
                       : "",
                 ),
                 enabled: false,
                 onTap: () => _showDatePicker(false),
                 flavor: _currentFlavor,
               ),
             ),
          ],
        ),
      ],
    );
  }

  Widget _buildWorkDaysOptions() {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final checkboxSize = screenWidth * 0.05;
    final fontSize = screenWidth * 0.035;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Work days",
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        
        SizedBox(height: verticalSpacing),
        
        // Work on Saturdays
        GestureDetector(
                     onTap: () {
             final currentValue = _controller.postJobData.workOnSaturdays ?? false;
             _controller.updateWorkOnSaturdays(!currentValue);
             setState(() {}); // Trigger rebuild
           },
          child: Padding(
            padding: EdgeInsets.only(bottom: verticalSpacing * 0.5),
            child: Row(
              children: [
                                 Container(
                   width: checkboxSize,
                   height: checkboxSize,
                   decoration: BoxDecoration(
                     color: (_controller.postJobData.workOnSaturdays ?? false) 
                         ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                         : Colors.white,
                     borderRadius: BorderRadius.circular(4),
                     border: Border.all(
                       color: (_controller.postJobData.workOnSaturdays ?? false)
                           ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                           : Colors.grey[400]!,
                       width: 2,
                     ),
                   ),
                   child: (_controller.postJobData.workOnSaturdays ?? false)
                       ? Icon(
                           Icons.check,
                           color: Colors.white,
                           size: checkboxSize * 0.6,
                         )
                       : null,
                 ),
                
                SizedBox(width: horizontalPadding * 0.5),
                
                Text(
                  "Work on Saturdays",
                  style: GoogleFonts.poppins(
                    fontSize: fontSize,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Work on Sundays
        GestureDetector(
                     onTap: () {
             final currentValue = _controller.postJobData.workOnSundays ?? false;
             _controller.updateWorkOnSundays(!currentValue);
             setState(() {}); // Trigger rebuild
           },
          child: Row(
            children: [
                             Container(
                 width: checkboxSize,
                 height: checkboxSize,
                 decoration: BoxDecoration(
                   color: (_controller.postJobData.workOnSundays ?? false) 
                       ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                       : Colors.white,
                   borderRadius: BorderRadius.circular(4),
                   border: Border.all(
                     color: (_controller.postJobData.workOnSundays ?? false)
                         ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                         : Colors.grey[400]!,
                     width: 2,
                   ),
                 ),
                 child: (_controller.postJobData.workOnSundays ?? false)
                     ? Icon(
                         Icons.check,
                         color: Colors.white,
                         size: checkboxSize * 0.6,
                       )
                     : null,
               ),
              
              SizedBox(width: horizontalPadding * 0.5),
              
              Text(
                "Work on Sundays",
                style: GoogleFonts.poppins(
                  fontSize: fontSize,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onDaySelected(DateTime selectedDay) {
    // No permitir seleccionar días anteriores a hoy
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final selectedDayStart = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    
    if (selectedDayStart.isBefore(todayStart)) {
      return; // No hacer nada si el día seleccionado es anterior a hoy
    }
    
    setState(() {
      if (_selectedStartDate == null) {
        // First selection - set start date
        _selectedStartDate = selectedDay;
        _selectedEndDate = null;
        _selectedDateRange = null;
      } else if (_selectedEndDate == null) {
        // Second selection - set end date and create range
        if (selectedDay.isBefore(_selectedStartDate!)) {
          // If selected day is before start date, swap them
          _selectedEndDate = _selectedStartDate;
          _selectedStartDate = selectedDay;
        } else {
          _selectedEndDate = selectedDay;
        }
        _selectedDateRange = DateTimeRange(
          start: _selectedStartDate!,
          end: _selectedEndDate!,
        );
      } else {
        // Third selection - start new selection
        _selectedStartDate = selectedDay;
        _selectedEndDate = null;
        _selectedDateRange = null;
      }
      
      // Update controller
      _controller.updateStartDate(_selectedStartDate!);
      if (_selectedEndDate != null) {
        _controller.updateEndDate(_selectedEndDate!);
      }
    });
  }

  void _showDatePicker(bool isStartDate) {
    showDatePicker(
      context: context,
      initialDate: isStartDate 
          ? (_selectedStartDate ?? DateTime.now())
          : (_selectedEndDate ?? _selectedStartDate ?? DateTime.now()),
      firstDate: isStartDate ? DateTime.now() : (_selectedStartDate ?? DateTime.now()),
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
    ).then((selectedDate) {
      if (selectedDate != null) {
        setState(() {
          if (isStartDate) {
            _selectedStartDate = selectedDate;
            _controller.updateStartDate(selectedDate);
          } else {
            _selectedEndDate = selectedDate;
            _controller.updateEndDate(selectedDate);
          }
          
                     // Update date range if both dates are selected
           if (_selectedStartDate != null && _selectedEndDate != null) {
             _selectedDateRange = DateTimeRange(
               start: _selectedStartDate!,
               end: _selectedEndDate!,
             );
           }
           setState(() {}); // Trigger rebuild for button state
        });
      }
    });
  }

     void _showOngoingWorkDialog() {
     showDialog(
       context: context,
       builder: (context) => AlertDialog(
         backgroundColor: Colors.white,
         title: Text(
           "Is there no end date?",
           style: GoogleFonts.poppins(
             fontWeight: FontWeight.bold,
           ),
         ),
        content: Text(
          "This job will be marked as ongoing with no specific end date.",
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Revert the checkbox
              _controller.updateIsOngoingWork(false);
            },
            child: Text(
              "Cancel",
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
                                            // Clear end date when ongoing work is confirmed
               _controller.updateEndDate(null);
               setState(() {
                 _selectedEndDate = null;
                 _selectedDateRange = null;
               });
            },
            child: Text(
              "Confirm",
              style: GoogleFonts.poppins(
                color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMonthPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "Select Month",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              'January', 'February', 'March', 'April', 'May', 'June',
              'July', 'August', 'September', 'October', 'November', 'December'
            ].asMap().entries.map((entry) {
              final monthIndex = entry.key + 1;
              final monthName = entry.value;
              return ListTile(
                title: Text(
                  monthName,
                  style: GoogleFonts.poppins(),
                ),
                onTap: () {
                  setState(() {
                    _focusedDay = DateTime(_focusedDay.year, monthIndex, 1);
                  });
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showYearPicker() {
    final currentYear = DateTime.now().year;
    final startYear = 1990;
    final totalYears = currentYear - startYear + 10; // Desde 1990 hasta 10 años en el futuro
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "Select Year",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Container(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: totalYears,
            itemBuilder: (context, index) {
              final year = startYear + index;
              return ListTile(
                title: Text(
                  year.toString(),
                  style: GoogleFonts.poppins(),
                ),
                onTap: () {
                  setState(() {
                    _focusedDay = DateTime(year, _focusedDay.month, 1);
                  });
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  bool _canProceed() {
    // Si es trabajo continuo, solo necesita fecha de inicio
    if (_controller.postJobData.isOngoingWork == true) {
      return _controller.postJobData.startDate != null;
    }
    // Si no es trabajo continuo, necesita fecha de inicio y fin
    return _controller.postJobData.startDate != null && _controller.postJobData.endDate != null;
  }

  void _handleContinue() {
    if (_canProceed()) {
      _controller.nextStep();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PostJobStepperStep5Screen(flavor: _currentFlavor),
        ),
      );
    }
  }
}
