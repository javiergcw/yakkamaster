import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../logic/controllers/post_job_controller.dart';

class CostEditModal extends StatefulWidget {
  final AppFlavor? flavor;
  final String title;
  final double initialValue;
  final Function(double) onSave;

  const CostEditModal({
    super.key,
    this.flavor,
    required this.title,
    required this.initialValue,
    required this.onSave,
  });

  @override
  State<CostEditModal> createState() => _CostEditModalState();
}

class _CostEditModalState extends State<CostEditModal> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  late TextEditingController _textController;
  double _currentValue = 0.0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _textController = TextEditingController(text: _currentValue.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() {
      _currentValue += 1.0;
      _textController.text = _currentValue.toStringAsFixed(2);
    });
  }

  void _decrement() {
    if (_currentValue > 0) {
      setState(() {
        _currentValue -= 1.0;
        _textController.text = _currentValue.toStringAsFixed(2);
      });
    }
  }

  void _onTextChanged(String value) {
    final newValue = double.tryParse(value);
    if (newValue != null && newValue >= 0) {
      setState(() {
        _currentValue = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.045;
    final instructionFontSize = screenWidth * 0.035;
    final valueFontSize = screenWidth * 0.06;
    final buttonSize = screenWidth * 0.12;

        return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.all(horizontalPadding),
              child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle
            Center(
              child: Container(
                margin: EdgeInsets.only(top: verticalSpacing * 0.5, bottom: verticalSpacing),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
                         // Header
             Row(
               children: [
                 Expanded(
                   child: Text(
                     "Add cost",
                     style: GoogleFonts.poppins(
                       fontSize: titleFontSize,
                       fontWeight: FontWeight.bold,
                       color: Colors.black,
                     ),
                     textAlign: TextAlign.center,
                   ),
                 ),
                 GestureDetector(
                   onTap: () => Navigator.of(context).pop(),
                   child: Icon(
                     Icons.close,
                     color: Colors.black,
                     size: 24,
                   ),
                 ),
               ],
             ),
            
            SizedBox(height: verticalSpacing),
            
            // Instruction
            Text(
              "Introduce a number please",
              style: GoogleFonts.poppins(
                fontSize: instructionFontSize,
                color: Colors.black87,
              ),
            ),
            
            SizedBox(height: verticalSpacing * 2),
            
            // Number Input with +/- buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Decrement button
                GestureDetector(
                  onTap: _decrement,
                  child: Container(
                    width: buttonSize,
                    height: buttonSize,
                    decoration: BoxDecoration(
                      color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.remove,
                      color: Colors.black,
                      size: buttonSize * 0.4,
                    ),
                  ),
                ),
                
                                 SizedBox(width: horizontalPadding * 0.5),
                 
                 // Value display
                 Expanded(
                   child: TextField(
                     controller: _textController,
                     keyboardType: TextInputType.numberWithOptions(decimal: true),
                     inputFormatters: [
                       FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                     ],
                     textAlign: TextAlign.center,
                     style: GoogleFonts.poppins(
                       fontSize: valueFontSize,
                       fontWeight: FontWeight.bold,
                       color: Colors.black,
                     ),
                     decoration: InputDecoration(
                       border: InputBorder.none,
                       contentPadding: EdgeInsets.zero,
                     ),
                     onChanged: _onTextChanged,
                   ),
                 ),
                 
                 SizedBox(width: horizontalPadding * 0.5),
                
                // Increment button
                GestureDetector(
                  onTap: _increment,
                  child: Container(
                    width: buttonSize,
                    height: buttonSize,
                    decoration: BoxDecoration(
                      color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                      size: buttonSize * 0.4,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: verticalSpacing),
            
            // Example text
            Center(
              child: Text(
                "(Example: \$50/hr)",
                style: GoogleFonts.poppins(
                  fontSize: instructionFontSize * 0.8,
                  color: Colors.grey[600],
                ),
              ),
            ),
            
            SizedBox(height: verticalSpacing * 2),
            
            // Apply Button
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: "Apply",
                onPressed: () {
                  widget.onSave(_currentValue);
                  Navigator.of(context).pop();
                },
                type: ButtonType.secondary,
                flavor: _currentFlavor,
              ),
            ),
            
                         SizedBox(height: verticalSpacing),
           ],
         ),
       );
     }
   }
