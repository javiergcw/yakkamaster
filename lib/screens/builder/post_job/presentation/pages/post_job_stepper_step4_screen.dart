import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../../logic/controllers/unified_post_job_controller.dart';

class PostJobStepperStep4Screen extends StatelessWidget {
  static const String id = '/builder/post-job-step4';
  
  final AppFlavor? flavor;

  PostJobStepperStep4Screen({
    super.key,
    this.flavor,
  });

  final UnifiedPostJobController controller = Get.find<UnifiedPostJobController>();

  @override
  Widget build(BuildContext context) {
    // Establecer el flavor en el controlador
    if (flavor != null) {
      controller.currentFlavor.value = flavor!;
    }

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final questionFontSize = screenWidth * 0.075;
    final iconSize = screenWidth * 0.06;
    
    final currentFlavor = controller.currentFlavor.value;

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
                      controller.handleBackNavigation();
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
                      color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor)),
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
                      _buildOngoingWorkCheckbox(context),
                    
                    SizedBox(height: verticalSpacing * 0.8),
                    
                    // Calendar
                    _buildCalendar(context),
                    
                    SizedBox(height: verticalSpacing * 0.02),
                    
                    // Date input fields
                    _buildDateInputFields(context),
                    
                    SizedBox(height: verticalSpacing * 1.0),
                    
                    // Work days options
                    _buildWorkDaysOptions(context),
                    
                    SizedBox(height: verticalSpacing * 3),
                  ],
                ),
              ),
            ),
            
                         // Continue Button
             Padding(
               padding: EdgeInsets.all(horizontalPadding),
               child: Obx(() {
                 return CustomButton(
                   text: "Continue",
                   onPressed: _canProceed() ? _handleContinue : null,
                   type: ButtonType.secondary,
                   flavor: controller.currentFlavor.value,
                 );
               }),
             ),
          ],
        ),
      ),
    );
  }

  Widget _buildOngoingWorkCheckbox(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    
    final horizontalPadding = screenWidth * 0.06;
    final checkboxSize = screenWidth * 0.05;
    final fontSize = screenWidth * 0.035;

    return Obx(() {
      final currentFlavor = controller.currentFlavor.value;
      final isOngoingWork = controller.postJobData.isOngoingWork ?? false;
      
      return GestureDetector(
        onTap: () {
          controller.updateIsOngoingWork(!isOngoingWork);
          
          // Si se activa "ongoing work", mostrar popup de confirmación
          if (!isOngoingWork) {
            _showOngoingWorkDialog(context);
          }
        },
        child: Row(
          children: [
            Container(
              width: checkboxSize,
              height: checkboxSize,
              decoration: BoxDecoration(
                color: isOngoingWork 
                    ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor))
                    : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isOngoingWork
                      ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor))
                      : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: isOngoingWork
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
    });
  }

     Widget _buildCalendar(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;

    return Obx(() {
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
                    onTap: () => _showMonthPicker(context),
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
                              _getMonthName(controller.focusedDay.value.month),
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
                    onTap: () => _showYearPicker(context),
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
                              controller.focusedDay.value.year.toString(),
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
                          controller.updateFocusedDay(DateTime(controller.focusedDay.value.year, controller.focusedDay.value.month - 1));
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
                          controller.updateFocusedDay(DateTime(controller.focusedDay.value.year, controller.focusedDay.value.month + 1));
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
          _buildCalendarGrid(context),
        ],
      );
    });
  } 


  Widget _buildCalendarGrid(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final daySize = screenWidth * 0.12;
    final dayFontSize = screenWidth * 0.03;
    final headerFontSize = screenWidth * 0.025;

    return Obx(() {
      final currentFlavor = controller.currentFlavor.value;
      
      // Get days of the month
      final daysInMonth = DateTime(controller.focusedDay.value.year, controller.focusedDay.value.month + 1, 0).day;
      final firstDayOfMonth = DateTime(controller.focusedDay.value.year, controller.focusedDay.value.month, 1);
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
                    
                    final currentDate = DateTime(controller.focusedDay.value.year, controller.focusedDay.value.month, dayNumber);
                    final today = DateTime.now();
                    final todayStart = DateTime(today.year, today.month, today.day);
                    final currentDateStart = DateTime(currentDate.year, currentDate.month, currentDate.day);
                    final isPastDay = currentDateStart.isBefore(todayStart);
                    
                    final isSelected = (controller.selectedStartDate.value != null && 
                        currentDate.isAtSameMomentAs(controller.selectedStartDate.value!)) ||
                        (controller.selectedDateRange.value != null &&
                        (currentDate.isAtSameMomentAs(controller.selectedDateRange.value!.start) ||
                         currentDate.isAtSameMomentAs(controller.selectedDateRange.value!.end) ||
                         (currentDate.isAfter(controller.selectedDateRange.value!.start) &&
                          currentDate.isBefore(controller.selectedDateRange.value!.end))));
                    
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
                                  ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor))
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
    });
  }

  Widget _buildDateInputFields(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;

    return Obx(() {
      final currentFlavor = controller.currentFlavor.value;
      
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
                    text: controller.selectedStartDate.value != null 
                        ? "${controller.selectedStartDate.value!.day.toString().padLeft(2, '0')}-${controller.selectedStartDate.value!.month.toString().padLeft(2, '0')}-${controller.selectedStartDate.value!.year}"
                        : "",
                  ),
                  enabled: false,
                  onTap: () => _showDatePicker(context, true),
                  flavor: currentFlavor,
                ),
              ),
             
             SizedBox(width: horizontalPadding * 0.5),
             
              // End date field
              Expanded(
                child: CustomTextField(
                  labelText: "End date",
                  hintText: "dd-mm-yyyy",
                  controller: TextEditingController(
                    text: controller.selectedEndDate.value != null 
                        ? "${controller.selectedEndDate.value!.day.toString().padLeft(2, '0')}-${controller.selectedEndDate.value!.month.toString().padLeft(2, '0')}-${controller.selectedEndDate.value!.year}"
                        : "",
                  ),
                  enabled: false,
                  onTap: () => _showDatePicker(context, false),
                  flavor: currentFlavor,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildWorkDaysOptions(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final checkboxSize = screenWidth * 0.05;
    final fontSize = screenWidth * 0.035;

    return Obx(() {
      final currentFlavor = controller.currentFlavor.value;
      final workOnSaturdays = controller.postJobData.workOnSaturdays ?? false;
      final workOnSundays = controller.postJobData.workOnSundays ?? false;
      
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
              controller.updateWorkOnSaturdays(!workOnSaturdays);
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: verticalSpacing * 0.5),
              child: Row(
                children: [
                  Container(
                    width: checkboxSize,
                    height: checkboxSize,
                    decoration: BoxDecoration(
                      color: workOnSaturdays 
                          ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor))
                          : Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: workOnSaturdays
                            ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor))
                            : Colors.grey[400]!,
                        width: 2,
                      ),
                    ),
                    child: workOnSaturdays
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
              controller.updateWorkOnSundays(!workOnSundays);
            },
            child: Row(
              children: [
                Container(
                  width: checkboxSize,
                  height: checkboxSize,
                  decoration: BoxDecoration(
                    color: workOnSundays 
                        ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor))
                        : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: workOnSundays
                          ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor))
                          : Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                  child: workOnSundays
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
    });
  }

  void _onDaySelected(DateTime selectedDay) {
    controller.onDaySelected(selectedDay);
  }

  void _showDatePicker(BuildContext context, bool isStartDate) {
    final currentFlavor = controller.currentFlavor.value;
    showDatePicker(
      context: context,
      initialDate: isStartDate 
          ? (controller.selectedStartDate.value ?? DateTime.now())
          : (controller.selectedEndDate.value ?? controller.selectedStartDate.value ?? DateTime.now()),
      firstDate: isStartDate ? DateTime.now() : (controller.selectedStartDate.value ?? DateTime.now()),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(AppFlavorConfig.getPrimaryColor(currentFlavor)),
            ),
          ),
          child: child!,
        );
      },
    ).then((selectedDate) {
      if (selectedDate != null) {
          if (isStartDate) {
            controller.selectedStartDate.value = selectedDate;
            controller.updateStartDate(selectedDate);
          } else {
            controller.selectedEndDate.value = selectedDate;
            controller.updateEndDate(selectedDate);
          }
          
          // Update date range if both dates are selected
          if (controller.selectedStartDate.value != null && controller.selectedEndDate.value != null) {
            controller.selectedDateRange.value = DateTimeRange(
              start: controller.selectedStartDate.value!,
              end: controller.selectedEndDate.value!,
            );
          }
        }
    });
  }

     void _showOngoingWorkDialog(BuildContext context) {
     final currentFlavor = controller.currentFlavor.value;
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
              controller.updateIsOngoingWork(false);
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
              controller.updateEndDate(null);
              controller.selectedEndDate.value = null;
              controller.selectedDateRange.value = null;
            },
            child: Text(
              "Confirm",
              style: GoogleFonts.poppins(
                color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor)),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMonthPicker(BuildContext context) {
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
                  controller.focusedDay.value = DateTime(controller.focusedDay.value.year, monthIndex, 1);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showYearPicker(BuildContext context) {
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
                  controller.focusedDay.value = DateTime(year, controller.focusedDay.value.month, 1);
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
    return controller.canProceedToNextStep();
  }

  void _handleContinue() {
    controller.handleContinue();
  }
}
