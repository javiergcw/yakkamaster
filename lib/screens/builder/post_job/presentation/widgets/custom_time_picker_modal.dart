import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';

class CustomTimePickerModal extends StatefulWidget {
  final AppFlavor? flavor;
  final TimeOfDay? initialTime;
  final Function(TimeOfDay) onTimeSelected;

  const CustomTimePickerModal({
    super.key,
    this.flavor,
    this.initialTime,
    required this.onTimeSelected,
  });

  @override
  State<CustomTimePickerModal> createState() => _CustomTimePickerModalState();
}

class _CustomTimePickerModalState extends State<CustomTimePickerModal> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  
  late int _selectedHour;
  late int _selectedMinute;
  late bool _isPM;

  @override
  void initState() {
    super.initState();
    final initialTime = widget.initialTime ?? TimeOfDay.now();
    _selectedHour = initialTime.hourOfPeriod;
    _selectedMinute = initialTime.minute;
    _isPM = initialTime.period == DayPeriod.pm;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 340,
        height: 240, // Más alto para evitar overflow
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Title
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Text(
                "Enter time",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            
            // Time display
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hour - clickeable
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => _showNativeTimePicker(context, true),
                        child: Container(
                          width: 70,
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)), 
                              width: 2
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Text(
                                  _selectedHour.toString().padLeft(2, '0'),
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 6,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Hour",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      ":",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  
                  // Minute - clickeable
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => _showNativeTimePicker(context, false),
                        child: Container(
                          width: 70,
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              _selectedMinute.toString().padLeft(2, '0'),
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Minute",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(width: 20),
                  
                  // AM/PM
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _isPM = false),
                        child: Container(
                          width: 45,
                          height: 30,
                          decoration: BoxDecoration(
                            color: !_isPM 
                                ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                                : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Center(
                            child: Text(
                              "AM",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: !_isPM ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      GestureDetector(
                        onTap: () => setState(() => _isPM = true),
                        child: Container(
                          width: 45,
                          height: 30,
                          decoration: BoxDecoration(
                            color: _isPM 
                                ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                                : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Center(
                            child: Text(
                              "PM",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: _isPM ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            Spacer(),
            
            // Action buttons
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Clock icon and Cancel button
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _showNativeTimePicker(context, true),
                        child: Icon(
                          Icons.access_time,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 10),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // OK button
                  TextButton(
                    onPressed: () {
                      final selectedTime = TimeOfDay(
                        hour: _isPM ? (_selectedHour == 12 ? 12 : _selectedHour + 12) : (_selectedHour == 12 ? 0 : _selectedHour),
                        minute: _selectedMinute,
                      );
                      widget.onTimeSelected(selectedTime);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "OK",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNativeTimePicker(BuildContext context, bool isHour) async {
    // Crear el tiempo actual basado en la selección
    final currentTime = TimeOfDay(
      hour: _isPM ? (_selectedHour == 12 ? 12 : _selectedHour + 12) : (_selectedHour == 12 ? 0 : _selectedHour),
      minute: _selectedMinute,
    );

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );

    if (picked != null) {
      setState(() {
        if (isHour) {
          // Solo actualizar la hora y AM/PM, mantener los minutos
          _selectedHour = picked.hourOfPeriod;
          _selectedMinute = picked.minute; // Mantener los minutos actuales
          _isPM = picked.period == DayPeriod.pm;
        } else {
          // Solo actualizar los minutos, mantener la hora y AM/PM
          _selectedMinute = picked.minute;
          // No cambiar _selectedHour ni _isPM
        }
      });
    }
  }
}
