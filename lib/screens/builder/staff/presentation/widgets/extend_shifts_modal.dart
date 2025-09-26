import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';

class ExtendShiftsModal extends StatefulWidget {
  final String workerName;
  final Function(DateTime startDate, DateTime endDate, bool isOngoing, bool workSaturdays, bool workSundays) onSubmit;
  final AppFlavor? flavor;

  const ExtendShiftsModal({
    super.key,
    required this.workerName,
    required this.onSubmit,
    this.flavor,
  });

  @override
  State<ExtendShiftsModal> createState() => _ExtendShiftsModalState();
}

class _ExtendShiftsModalState extends State<ExtendShiftsModal> {
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now().add(Duration(days: 7));
  bool _isOngoing = false;
  bool _workSaturdays = false;
  bool _workSundays = false;
  DateTime _focusedDate = DateTime.now();
  DateTime? _rangeStartDate;
  DateTime? _rangeEndDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text(
                  'Add Shifts to the job',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: Colors.grey[600], size: 24),
                ),
              ],
            ),
            
            SizedBox(height: 24),
            
                         // Calendar Section
             Column(
               children: [
                 // Month/Year Header
                 Row(
                   children: [
                                           // Month Selector
                      GestureDetector(
                        onTap: () => _showMonthPicker(),
                        child: Row(
                          children: [
                            Text(
                              _getMonthName(_focusedDate.month),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 20),
                          ],
                        ),
                      ),
                      
                      SizedBox(width: 24),
                      
                      // Year Selector
                      GestureDetector(
                        onTap: () => _showYearPicker(),
                        child: Row(
                          children: [
                            Text(
                              _focusedDate.year.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 20),
                          ],
                        ),
                      ),
                   ],
                 ),
                 
                 SizedBox(height: 16),
                 
                 // Days of week
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
                     return Text(
                       day,
                       style: GoogleFonts.poppins(
                         fontSize: 12,
                         fontWeight: FontWeight.w500,
                         color: Colors.grey[600],
                       ),
                     );
                   }).toList(),
                 ),
                 
                 SizedBox(height: 12),
                 
                 // Calendar Grid
                 _buildCalendarGrid(),
               ],
             ),
            
            SizedBox(height: 24),
            
                         // Date Input Fields
             Row(
               children: [
                 Expanded(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         'Start date:',
                         style: GoogleFonts.poppins(
                           fontSize: 14,
                           fontWeight: FontWeight.w500,
                           color: Colors.black,
                         ),
                       ),
                       SizedBox(height: 8),
                       Container(
                         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                         decoration: BoxDecoration(
                           border: Border.all(color: Colors.grey[300]!),
                           borderRadius: BorderRadius.circular(8),
                         ),
                         child: Text(
                           _rangeStartDate != null 
                               ? '${_rangeStartDate!.day.toString().padLeft(2, '0')}-${_rangeStartDate!.month.toString().padLeft(2, '0')}-${_rangeStartDate!.year}'
                               : 'dd-mm-yyyy',
                           style: GoogleFonts.poppins(
                             fontSize: 14,
                             color: _rangeStartDate != null ? Colors.black : Colors.grey[600],
                           ),
                         ),
                       ),
                     ],
                   ),
                 ),
                 SizedBox(width: 16),
                 Expanded(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         'End date:',
                         style: GoogleFonts.poppins(
                           fontSize: 14,
                           fontWeight: FontWeight.w500,
                           color: Colors.black,
                         ),
                       ),
                       SizedBox(height: 8),
                       Container(
                         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                         decoration: BoxDecoration(
                           border: Border.all(color: Colors.grey[300]!),
                           borderRadius: BorderRadius.circular(8),
                         ),
                         child: Text(
                           _rangeEndDate != null 
                               ? '${_rangeEndDate!.day.toString().padLeft(2, '0')}-${_rangeEndDate!.month.toString().padLeft(2, '0')}-${_rangeEndDate!.year}'
                               : 'dd-mm-yyyy',
                           style: GoogleFonts.poppins(
                             fontSize: 14,
                             color: _rangeEndDate != null ? Colors.black : Colors.grey[600],
                           ),
                         ),
                       ),
                     ],
                   ),
                 ),
               ],
             ),
            
            SizedBox(height: 16),
            
            // Ongoing Work Checkbox
            Row(
              children: [
                Checkbox(
                  value: _isOngoing,
                  onChanged: (value) {
                    setState(() {
                      _isOngoing = value ?? false;
                    });
                  },
                  activeColor: Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)),
                ),
                Text(
                  'On going work',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            
                         // Workday Selection
             Row(
               children: [
                 Checkbox(
                   value: _workSaturdays,
                   onChanged: (value) {
                     setState(() {
                       _workSaturdays = value ?? false;
                     });
                   },
                   activeColor: Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)),
                 ),
                 Text(
                   'Work on Saturdays',
                   style: GoogleFonts.poppins(
                     fontSize: 14,
                     color: Colors.black,
                   ),
                 ),
               ],
             ),
             
             Row(
               children: [
                 Checkbox(
                   value: _workSundays,
                   onChanged: (value) {
                     setState(() {
                       _workSundays = value ?? false;
                     });
                   },
                   activeColor: Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)),
                 ),
                 Text(
                   'Work on Sundays',
                   style: GoogleFonts.poppins(
                     fontSize: 14,
                     color: Colors.black,
                   ),
                 ),
               ],
             ),
            
            SizedBox(height: 24),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                                 onPressed: () {
                   if (_rangeStartDate != null && _rangeEndDate != null) {
                     widget.onSubmit(_rangeStartDate!, _rangeEndDate!, _isOngoing, _workSaturdays, _workSundays);
                     Navigator.pop(context);
                   }
                 },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final lastDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;
    final today = DateTime.now();
    
    List<Widget> calendarDays = [];
    
    // Add empty cells for days before the first day of the month
    for (int i = 0; i < firstWeekday - 1; i++) {
      calendarDays.add(Container());
    }
    
    // Add days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_focusedDate.year, _focusedDate.month, day);
      final isToday = date.day == today.day && date.month == today.month && date.year == today.year;
      final isPast = date.isBefore(DateTime(today.year, today.month, today.day));
      final isInRange = _rangeStartDate != null && _rangeEndDate != null &&
                       date.isAfter(_rangeStartDate!.subtract(Duration(days: 1))) &&
                       date.isBefore(_rangeEndDate!.add(Duration(days: 1)));
      final isRangeStart = _rangeStartDate != null &&
                          date.day == _rangeStartDate!.day &&
                          date.month == _rangeStartDate!.month &&
                          date.year == _rangeStartDate!.year;
      final isRangeEnd = _rangeEndDate != null &&
                        date.day == _rangeEndDate!.day &&
                        date.month == _rangeEndDate!.month &&
                        date.year == _rangeEndDate!.year;
      
      calendarDays.add(
        GestureDetector(
          onTap: isPast ? null : () => _onDaySelected(date),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isInRange 
                  ? Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)).withOpacity(0.2)
                  : null,
              border: isRangeStart || isRangeEnd
                  ? Border.all(
                      color: Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)),
                      width: 2,
                    )
                  : isToday
                      ? Border.all(color: Colors.grey[400]!, width: 1)
                      : null,
            ),
            child: Center(
              child: Text(
                day.toString(),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: (isRangeStart || isRangeEnd) ? FontWeight.w600 : FontWeight.w400,
                  color: isPast 
                      ? Colors.grey[400]
                      : (isRangeStart || isRangeEnd)
                          ? Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor))
                          : Colors.black,
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    // Create grid
    List<Widget> rows = [];
    for (int i = 0; i < calendarDays.length; i += 7) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: calendarDays.skip(i).take(7).toList(),
        ),
      );
    }
    
    return Column(children: rows);
  }

  void _onDaySelected(DateTime date) {
    setState(() {
      if (_rangeStartDate == null || (_rangeStartDate != null && _rangeEndDate != null)) {
        // Start new range
        _rangeStartDate = date;
        _rangeEndDate = null;
      } else {
        // Complete range
        if (date.isBefore(_rangeStartDate!)) {
          _rangeEndDate = _rangeStartDate;
          _rangeStartDate = date;
        } else {
          _rangeEndDate = date;
        }
      }
    });
  }

  Future<void> _showMonthPicker() async {
    final currentYear = DateTime.now().year;
    final currentMonth = DateTime.now().month;
    final selectedMonth = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Select Month'),
        content: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(12, (index) {
              final month = index + 1;
              final isPastMonth = _focusedDate.year < currentYear || 
                                (_focusedDate.year == currentYear && month < currentMonth);
              
              // Solo mostrar meses que no sean pasados
              if (isPastMonth) {
                return SizedBox.shrink(); // No mostrar meses pasados
              }
              
              return ListTile(
                title: Text(_getMonthName(month)),
                selected: month == _focusedDate.month,
                onTap: () => Navigator.pop(context, month),
              );
            }).where((widget) => widget is! SizedBox).toList(),
          ),
        ),
      ),
    );
    
    if (selectedMonth != null) {
      setState(() {
        _focusedDate = DateTime(_focusedDate.year, selectedMonth, 1);
      });
    }
  }

  Future<void> _showYearPicker() async {
    final currentYear = DateTime.now().year;
    final selectedYear = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Select Year'),
        content: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              final year = currentYear + index;
              return ListTile(
                title: Text(year.toString()),
                selected: year == _focusedDate.year,
                onTap: () => Navigator.pop(context, year),
              );
            }),
          ),
        ),
      ),
    );
    
    if (selectedYear != null) {
      setState(() {
        _focusedDate = DateTime(selectedYear, _focusedDate.month, 1);
      });
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }


}
