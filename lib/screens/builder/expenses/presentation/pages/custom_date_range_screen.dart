import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../logic/controllers/custom_date_range_controller.dart';

class CustomDateRangeScreen extends StatelessWidget {
  static const String id = '/builder/expenses/custom-date-range';

  final AppFlavor? flavor;

  CustomDateRangeScreen({super.key, this.flavor});

  CustomDateRangeController get controller => Get.find<CustomDateRangeController>();

  @override
  Widget build(BuildContext context) {
    // Establecer el flavor en el controlador
    try {
      if (flavor != null) {
        controller.currentFlavor.value = flavor!;
      }
    } catch (e) {
      print('Error setting flavor: $e');
    }

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final bodyFontSize = screenWidth * 0.04;
    final smallFontSize = screenWidth * 0.035;
    final iconSize = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header (Dark Grey)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing * 1.5,
              ),
              decoration: BoxDecoration(color: Colors.grey[800]),
              child: Row(
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => controller.handleBackNavigation(),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: iconSize,
                    ),
                  ),

                  SizedBox(width: horizontalPadding),

                  // Title (Centered)
                  Expanded(
                    child: Text(
                      "Custom",
                      style: GoogleFonts.poppins(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(width: iconSize + horizontalPadding), // Spacer to balance the back button
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: verticalSpacing * 0.5),
                    
                    // Date Custom Section
                    _buildDateCustomSection(horizontalPadding, verticalSpacing, bodyFontSize, smallFontSize),
                    
                    SizedBox(height: verticalSpacing * 2),
                    
                    // Calendar Section
                    Expanded(
                      child: _buildCalendarSection(horizontalPadding, verticalSpacing, bodyFontSize, smallFontSize),
                    ),
                  ],
                ),
              ),
            ),

            // Save Button
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing * 0.8,
              ),
              child: Obx(() => ElevatedButton(
                onPressed: controller.canSave() ? controller.handleSave : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.canSave() 
                      ? Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value))
                      : Colors.grey[400],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: verticalSpacing * 1.2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 1,
                ),
                child: Text(
                  "Save",
                  style: GoogleFonts.poppins(
                    fontSize: bodyFontSize * 1.1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCustomSection(double horizontalPadding, double verticalSpacing, double bodyFontSize, double smallFontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and Clear All
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Date Custom",
              style: GoogleFonts.poppins(
                fontSize: bodyFontSize * 1.2,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            GestureDetector(
              onTap: () => controller.clearAll(),
              child: Text(
                "Clear all",
                style: GoogleFonts.poppins(
                  fontSize: smallFontSize * 1.1,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        
        SizedBox(height: verticalSpacing * 1.5),
        
        // From and Until fields
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                "From",
                controller.fromDate,
                () => controller.selectFromDate(),
                horizontalPadding,
                verticalSpacing,
                bodyFontSize,
                smallFontSize,
              ),
            ),
            SizedBox(width: horizontalPadding * 0.8),
            Expanded(
              child: _buildDateField(
                "Until",
                controller.untilDate,
                () => controller.selectUntilDate(),
                horizontalPadding,
                verticalSpacing,
                bodyFontSize,
                smallFontSize,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField(
    String label,
    Rx<DateTime?> date,
    VoidCallback onTap,
    double horizontalPadding,
    double verticalSpacing,
    double bodyFontSize,
    double smallFontSize,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding * 0.8,
          vertical: verticalSpacing * 0.2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: bodyFontSize * 0.9,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: verticalSpacing * 0.1),
            Obx(() => Text(
              date.value != null 
                  ? "${date.value!.day}/${date.value!.month}/${date.value!.year}"
                  : "Unspecified",
              style: GoogleFonts.poppins(
                fontSize: smallFontSize * 1.1,
                color: date.value != null ? Colors.black87 : Colors.grey[600],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarSection(double horizontalPadding, double verticalSpacing, double bodyFontSize, double smallFontSize) {
    return Column(
      children: [
        // Month/Year Navigation
        _buildMonthNavigation(horizontalPadding, verticalSpacing, bodyFontSize, smallFontSize),
        
        SizedBox(height: verticalSpacing),
        
        // Days of week
        _buildDaysOfWeek(horizontalPadding, verticalSpacing, smallFontSize),
        
        SizedBox(height: verticalSpacing * 0.5),
        
        // Calendar Grid
        Expanded(
          child: _buildCalendarGrid(horizontalPadding, verticalSpacing, bodyFontSize, smallFontSize),
        ),
      ],
    );
  }

  Widget _buildMonthNavigation(double horizontalPadding, double verticalSpacing, double bodyFontSize, double smallFontSize) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalSpacing,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous month button
          GestureDetector(
            onTap: () => controller.previousMonth(),
            child: Container(
              width: 40,
              height: 40,
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
                size: 24,
              ),
            ),
          ),
          
          // Month and Year
          Obx(() => Column(
            children: [
              Text(
                controller.currentMonthName,
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize * 1.3,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                controller.currentYear.toString(),
                style: GoogleFonts.poppins(
                  fontSize: smallFontSize * 1.1,
                  color: Colors.grey[600],
                ),
              ),
            ],
          )),
          
          // Next month button
          GestureDetector(
            onTap: () => controller.nextMonth(),
            child: Container(
              width: 40,
              height: 40,
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
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysOfWeek(double horizontalPadding, double verticalSpacing, double smallFontSize) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((day) => Text(
          day,
          style: GoogleFonts.poppins(
            fontSize: smallFontSize,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid(double horizontalPadding, double verticalSpacing, double bodyFontSize, double smallFontSize) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Obx(() => GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1,
        ),
        itemCount: controller.calendarDays.length,
        itemBuilder: (context, index) {
          final day = controller.calendarDays[index];
          final isCurrentMonth = day['isCurrentMonth'] as bool;
          final dayNumber = day['day'] as int;
          final isSelected = day['isSelected'] as bool;
          final isInRange = day['isInRange'] as bool;
          
          return GestureDetector(
            onTap: isCurrentMonth ? () => controller.selectDate(dayNumber) : null,
            child: Container(
              margin: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isSelected 
                    ? Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value))
                    : isInRange 
                        ? Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)).withOpacity(0.3)
                        : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  dayNumber.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: smallFontSize * 1.1,
                    color: isSelected 
                        ? Colors.white
                        : isCurrentMonth 
                            ? Colors.black 
                            : Colors.grey[400],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      )),
    );
  }
}
