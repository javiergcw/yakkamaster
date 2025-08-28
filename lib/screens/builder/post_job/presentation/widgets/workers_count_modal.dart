import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../logic/controllers/post_job_controller.dart';

class WorkersCountModal extends StatefulWidget {
  final AppFlavor? flavor;

  const WorkersCountModal({
    super.key,
    this.flavor,
  });

  @override
  State<WorkersCountModal> createState() => _WorkersCountModalState();
}

class _WorkersCountModalState extends State<WorkersCountModal> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  late PostJobController _controller;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<PostJobController>();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
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
    final inputFontSize = screenWidth * 0.04;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(horizontalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    "How many labourers?",
                    style: GoogleFonts.poppins(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
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
              "Enter the number of labourers that you need.",
              style: GoogleFonts.poppins(
                fontSize: instructionFontSize,
                color: Colors.black87,
              ),
            ),
            
            SizedBox(height: verticalSpacing * 1.5),
            
            // Input Field
            TextField(
              controller: _textController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                hintText: "Enter number",
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey[400],
                  fontSize: inputFontSize,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding * 0.8,
                  vertical: verticalSpacing * 0.6,
                ),
              ),
              style: GoogleFonts.poppins(
                fontSize: inputFontSize,
                color: Colors.black,
              ),
            ),
            
            SizedBox(height: verticalSpacing * 2),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: "Save",
                onPressed: _handleSave,
                type: ButtonType.secondary,
                flavor: _currentFlavor,
              ),
            ),
            
            SizedBox(height: verticalSpacing),
          ],
        ),
      ),
    );
  }

  void _handleSave() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      final number = int.tryParse(text);
      if (number != null && number > 5) {
        _controller.updateWorkersNeeded(number);
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a number greater than 5'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a number'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
