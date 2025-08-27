import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';

class TimesheetModal extends StatefulWidget {
  final String companyName;
  final VoidCallback? onClose;
  final Function(Map<String, dynamic>)? onSubmit;

  const TimesheetModal({
    Key? key,
    required this.companyName,
    this.onClose,
    this.onSubmit,
  }) : super(key: key);

  @override
  State<TimesheetModal> createState() => _TimesheetModalState();
}

class _TimesheetModalState extends State<TimesheetModal> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay? startTime;
  TimeOfDay? finishTime;
  String selectedBreakDuration = '0 min';
  double overtimeHours = 0.0;
  double additionalAllowance = 0.0;
  final TextEditingController allowanceController = TextEditingController();

  final List<String> breakDurations = [
    '0 min',
    '15 min',
    '30 min',
    '45 min',
    '60 min',
  ];

  final List<double> overtimeOptions = [0.0, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.045;
    final bodyFontSize = screenWidth * 0.035;
    final subtitleFontSize = screenWidth * 0.03;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: EdgeInsets.only(top: verticalSpacing),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: Row(
                children: [
                  Expanded(
                                         child: Text(
                       '${AppFlavorConfig.timesheetTitle}: ${widget.companyName}',
                       style: GoogleFonts.poppins(
                         fontSize: titleFontSize,
                         fontWeight: FontWeight.bold,
                         color: Colors.black87,
                       ),
                       textAlign: TextAlign.center,
                     ),
                  ),
                  IconButton(
                    onPressed: widget.onClose,
                    icon: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Selection
                  _buildInputField(
                    icon: Icons.calendar_today,
                    value:
                        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                    onTap: () => _selectDate(context),
                    showChevron: true,
                  ),

                  SizedBox(height: verticalSpacing * 2),

                                     // Work Time Section
                   Text(
                     AppFlavorConfig.workTimeTitle,
                     style: GoogleFonts.poppins(
                       fontSize: bodyFontSize,
                       fontWeight: FontWeight.bold,
                       color: Colors.black87,
                     ),
                   ),

                   SizedBox(height: verticalSpacing * 0.5),

                   Text(
                     AppFlavorConfig.workTimeSubtitle,
                     style: GoogleFonts.poppins(
                       fontSize: subtitleFontSize,
                       color: Colors.grey[600],
                     ),
                   ),

                  SizedBox(height: verticalSpacing),

                  // Start and Finish Time
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          icon: Icons.access_time,
                          value: startTime?.format(context) ?? 'Start Time',
                          onTap: () => _selectTime(context, true),
                          placeholder: startTime == null,
                        ),
                      ),
                      SizedBox(width: horizontalPadding * 0.5),
                      Expanded(
                        child: _buildInputField(
                          icon: Icons.schedule,
                          value: finishTime?.format(context) ?? 'Finish Time',
                          onTap: () => _selectTime(context, false),
                          placeholder: finishTime == null,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: verticalSpacing),

                  // Break Duration
                  _buildInputField(
                    icon: Icons.coffee,
                    value: selectedBreakDuration,
                    onTap: () => _selectBreakDuration(context),
                    showChevron: true,
                  ),

                  SizedBox(height: verticalSpacing * 2),

                                     // Overtime Section
                   Text(
                     AppFlavorConfig.overtimeQuestion,
                     style: GoogleFonts.poppins(
                       fontSize: bodyFontSize,
                       fontWeight: FontWeight.w500,
                       color: Colors.black87,
                     ),
                   ),

                  SizedBox(height: verticalSpacing),

                  _buildInputField(
                    icon: Icons.schedule,
                    value: overtimeHours > 0
                        ? '${overtimeHours.toStringAsFixed(1)} hr'
                        : 'Overtime (hr)',
                    onTap: () => _selectOvertime(context),
                    placeholder: overtimeHours == 0,
                    showChevron: true,
                  ),

                  SizedBox(height: verticalSpacing * 2),

                                     // Additional Allowance
                   Text(
                     AppFlavorConfig.allowanceQuestion,
                     style: GoogleFonts.poppins(
                       fontSize: bodyFontSize,
                       fontWeight: FontWeight.w500,
                       color: Colors.black87,
                     ),
                   ), 

                  SizedBox(height: verticalSpacing),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.attach_money, size: 20, color: Colors.grey[600]),
                        const SizedBox(width: 12),
                                                 Expanded(
                           child: TextField(
                             controller: allowanceController,
                             keyboardType: const TextInputType.numberWithOptions(decimal: true),
                             textInputAction: TextInputAction.done,
                             decoration: InputDecoration(
                               hintText: '0.00',
                               border: InputBorder.none,
                               hintStyle: GoogleFonts.poppins(
                                 fontSize: 16,
                                 color: Colors.grey[400],
                               ),
                             ),
                             style: GoogleFonts.poppins(
                               fontSize: 16,
                               color: Colors.black87,
                             ),
                             onChanged: (value) {
                               setState(() {
                                 additionalAllowance = double.tryParse(value) ?? 0.0;
                               });
                             },
                             onSubmitted: (value) {
                               // Cerrar el teclado cuando se presiona Enter
                               FocusScope.of(context).unfocus();
                             },
                             onTap: () {
                               // Scroll automático cuando se toca el campo
                               WidgetsBinding.instance.addPostFrameCallback((_) {
                                 Scrollable.ensureVisible(
                                   context,
                                   duration: const Duration(milliseconds: 300),
                                   curve: Curves.easeInOut,
                                 );
                               });
                             },
                           ),
                         ),
                      ],
                    ),
                  ),

                  SizedBox(height: verticalSpacing * 2),

                  // Summary Section
                  Container(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Shift time: ${_calculateShiftTime()} hr',
                          style: GoogleFonts.poppins(
                            fontSize: bodyFontSize,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Overtime: ${overtimeHours.toStringAsFixed(1)} hr',
                          style: GoogleFonts.poppins(
                            fontSize: bodyFontSize,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Total: (${_calculateTotalHours()} hr)',
                          style: GoogleFonts.poppins(
                            fontSize: bodyFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: verticalSpacing * 2),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _canSubmit() ? _handleSubmit : null,
                                             style: ElevatedButton.styleFrom(
                         backgroundColor: AppFlavorConfig.timesheetPrimaryColor,
                         foregroundColor: Colors.black87,
                         padding: EdgeInsets.symmetric(
                           vertical: verticalSpacing * 0.8,
                         ),
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(8),
                         ),
                         elevation: 0,
                       ),
                       child: Text(
                         AppFlavorConfig.submitButtonText,
                         style: GoogleFonts.poppins(
                           fontSize: bodyFontSize,
                           fontWeight: FontWeight.bold,
                           color: Colors.black87,
                         ),
                       ),
                    ),
                  ),

                  SizedBox(height: verticalSpacing * 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String value,
    required VoidCallback onTap,
    bool placeholder = false,
    bool showChevron = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: placeholder ? Colors.grey[400] : Colors.black87,
                ),
              ),
            ),
            if (showChevron)
              Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: Colors.grey[400],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? (startTime ?? TimeOfDay.now())
          : (finishTime ?? TimeOfDay.now()),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
        } else {
          finishTime = picked;
        }
      });
    }
  }

  void _selectBreakDuration(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                                 children: [
                   Icon(Icons.coffee, size: 24, color: AppFlavorConfig.timesheetPrimaryColor),
                   const SizedBox(width: 12),
                  Text(
                    'Select Break Duration',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1),
            
            // Options
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: breakDurations.length,
                itemBuilder: (context, index) {
                  final duration = breakDurations[index];
                  final isSelected = selectedBreakDuration == duration;
                  
                                     return Container(
                     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                     decoration: BoxDecoration(
                       color: isSelected ? AppFlavorConfig.timesheetAccentColor.withOpacity(0.3) : Colors.transparent,
                       borderRadius: BorderRadius.circular(12),
                       border: isSelected 
                         ? Border.all(color: AppFlavorConfig.timesheetPrimaryColor, width: 2)
                         : null,
                     ),
                                         child: ListTile(
                       leading: Icon(
                         Icons.coffee,
                         color: isSelected ? AppFlavorConfig.timesheetPrimaryColor : Colors.grey[600],
                         size: 20,
                       ),
                       title: Text(
                         duration,
                         style: GoogleFonts.poppins(
                           fontSize: 16,
                           fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                           color: isSelected ? AppFlavorConfig.timesheetPrimaryColor : Colors.black87,
                         ),
                       ),
                       trailing: isSelected 
                         ? Icon(Icons.check_circle, color: AppFlavorConfig.timesheetPrimaryColor, size: 24)
                         : null,
                      onTap: () {
                        setState(() {
                          selectedBreakDuration = duration;
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
              ),
            ),
            
            // Bottom padding
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  void _selectOvertime(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                                 children: [
                   Icon(Icons.schedule, size: 24, color: AppFlavorConfig.timesheetPrimaryColor),
                   const SizedBox(width: 12),
                  Text(
                    'Select Overtime Hours',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1),
            
            // Options
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: overtimeOptions.length,
                itemBuilder: (context, index) {
                  final hours = overtimeOptions[index];
                  final isSelected = overtimeHours == hours;
                  
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? AppFlavorConfig.timesheetAccentColor.withOpacity(0.3) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected 
                        ? Border.all(color: AppFlavorConfig.timesheetPrimaryColor, width: 2)
                        : null,
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.schedule,
                        color: isSelected ? AppFlavorConfig.timesheetPrimaryColor : Colors.grey[600],
                        size: 20,
                      ),
                      title: Text(
                        '${hours.toStringAsFixed(1)} hr',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? AppFlavorConfig.timesheetPrimaryColor : Colors.black87,
                        ),
                      ),
                      subtitle: hours > 0 ? Text(
                        'Additional ${hours.toStringAsFixed(1)} hours',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ) : null,
                      trailing: isSelected 
                        ? Icon(Icons.check_circle, color: AppFlavorConfig.timesheetPrimaryColor, size: 24)
                        : null,
                      onTap: () {
                        setState(() {
                          overtimeHours = hours;
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
              ),
            ),
            
            // Bottom padding
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }



  String _calculateShiftTime() {
    if (startTime == null || finishTime == null) return '0.00';

    final startMinutes = startTime!.hour * 60 + startTime!.minute;
    final finishMinutes = finishTime!.hour * 60 + finishTime!.minute;
    final breakMinutes = int.parse(selectedBreakDuration.split(' ')[0]);

    final totalMinutes = finishMinutes - startMinutes - breakMinutes;
    return (totalMinutes / 60).toStringAsFixed(2);
  }

  String _calculateTotalHours() {
    final shiftTime = double.tryParse(_calculateShiftTime()) ?? 0.0;
    return (shiftTime + overtimeHours).toStringAsFixed(2);
  }

  bool _canSubmit() {
    return startTime != null && finishTime != null;
  }

  void _handleSubmit() {
    final timesheetData = {
      'date': selectedDate,
      'startTime': startTime,
      'finishTime': finishTime,
      'breakDuration': selectedBreakDuration,
      'overtimeHours': overtimeHours,
      'additionalAllowance': additionalAllowance,
      'shiftTime': _calculateShiftTime(),
      'totalHours': _calculateTotalHours(),
    };

    widget.onSubmit?.call(timesheetData);
    widget.onClose?.call();
  }

  @override
  void dispose() {
    allowanceController.dispose();
    super.dispose();
  }
}
