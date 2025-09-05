import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';

class CustomDateRangeController extends GetxController {
  // Flavor
  final Rx<AppFlavor> currentFlavor = AppFlavor.sport.obs;

  // Date selection
  final Rx<DateTime?> fromDate = Rx<DateTime?>(null);
  final Rx<DateTime?> untilDate = Rx<DateTime?>(null);
  final Rx<DateTime> currentDate = DateTime.now().obs;

  // Calendar
  final RxList<Map<String, dynamic>> calendarDays = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    initializeController();
  }

  void initializeController() {
    try {
      // Establecer flavor si viene en los argumentos
      if (Get.arguments != null && Get.arguments['flavor'] != null) {
        currentFlavor.value = Get.arguments['flavor'];
      }
      
      // Generar días del calendario
      _generateCalendarDays();
    } catch (e) {
      print('⚠️ Error initializing controller: $e');
      currentFlavor.value = AppFlavor.sport;
    }
  }

  // Getters
  String get currentMonthName {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[currentDate.value.month - 1];
  }

  int get currentYear => currentDate.value.year;

  bool canSave() {
    return fromDate.value != null && untilDate.value != null;
  }

  // Date selection methods
  void selectFromDate() async {
    final date = await _showDatePicker();
    if (date != null) {
      fromDate.value = date;
      _generateCalendarDays();
    }
  }

  void selectUntilDate() async {
    final date = await _showDatePicker();
    if (date != null) {
      untilDate.value = date;
      _generateCalendarDays();
    }
  }

  Future<DateTime?> _showDatePicker() async {
    return await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  void selectDate(int day) {
    final selectedDate = DateTime(currentDate.value.year, currentDate.value.month, day);
    
    if (fromDate.value == null) {
      fromDate.value = selectedDate;
    } else if (untilDate.value == null) {
      if (selectedDate.isAfter(fromDate.value!)) {
        untilDate.value = selectedDate;
      } else {
        untilDate.value = fromDate.value;
        fromDate.value = selectedDate;
      }
    } else {
      // Reset and start new selection
      fromDate.value = selectedDate;
      untilDate.value = null;
    }
    
    _generateCalendarDays();
  }

  // Calendar navigation
  void previousMonth() {
    currentDate.value = DateTime(currentDate.value.year, currentDate.value.month - 1);
    _generateCalendarDays();
  }

  void nextMonth() {
    currentDate.value = DateTime(currentDate.value.year, currentDate.value.month + 1);
    _generateCalendarDays();
  }

  // Clear all dates
  void clearAll() {
    fromDate.value = null;
    untilDate.value = null;
    _generateCalendarDays();
  }

  // Generate calendar days
  void _generateCalendarDays() {
    final days = <Map<String, dynamic>>[];
    final now = currentDate.value;
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    
    // Get the weekday of the first day (0 = Sunday, 1 = Monday, etc.)
    // Convert to Monday = 0, Tuesday = 1, etc.
    int firstWeekday = (firstDayOfMonth.weekday - 1) % 7;
    
    // Add days from previous month
    final previousMonth = DateTime(now.year, now.month - 1, 0);
    for (int i = firstWeekday - 1; i >= 0; i--) {
      final day = previousMonth.day - i;
      days.add({
        'day': day,
        'isCurrentMonth': false,
        'isSelected': false,
        'isInRange': false,
      });
    }
    
    // Add days from current month
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final currentDay = DateTime(now.year, now.month, day);
      final isSelected = _isDateSelected(currentDay);
      final isInRange = _isDateInRange(currentDay);
      
      days.add({
        'day': day,
        'isCurrentMonth': true,
        'isSelected': isSelected,
        'isInRange': isInRange,
      });
    }
    
    // Add days from next month to complete the grid
    int remainingDays = 42 - days.length; // 6 weeks * 7 days
    for (int day = 1; day <= remainingDays; day++) {
      days.add({
        'day': day,
        'isCurrentMonth': false,
        'isSelected': false,
        'isInRange': false,
      });
    }
    
    calendarDays.value = days;
  }

  bool _isDateSelected(DateTime date) {
    if (fromDate.value != null && untilDate.value != null) {
      return _isSameDate(date, fromDate.value!) || _isSameDate(date, untilDate.value!);
    } else if (fromDate.value != null) {
      return _isSameDate(date, fromDate.value!);
    }
    return false;
  }

  bool _isDateInRange(DateTime date) {
    if (fromDate.value != null && untilDate.value != null) {
      return date.isAfter(fromDate.value!) && date.isBefore(untilDate.value!);
    }
    return false;
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }

  // Navigation
  void handleBackNavigation() {
    Get.back();
  }

  void handleSave() {
    if (canSave()) {
      // Return the selected date range
      final result = {
        'fromDate': fromDate.value,
        'untilDate': untilDate.value,
        'fromDateString': _formatDate(fromDate.value!),
        'untilDateString': _formatDate(untilDate.value!),
      };
      
      Get.back(result: result);
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
