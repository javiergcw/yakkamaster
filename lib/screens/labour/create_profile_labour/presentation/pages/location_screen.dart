import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import 'previous_employer_screen.dart';

class LocationScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const LocationScreen({
    super.key,
    this.flavor,
  });

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _suburbController = TextEditingController();
  bool _willingToRelocate = true;
  bool _hasCar = true;

  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;

  @override
  void dispose() {
    _addressController.dispose();
    _suburbController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    // Validación básica
    if (_addressController.text.trim().isEmpty || _suburbController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navegar al siguiente paso del stepper
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PreviousEmployerScreen(flavor: _currentFlavor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final labelFontSize = screenWidth * 0.04;
    final questionFontSize = screenWidth * 0.042;
    final optionFontSize = screenWidth * 0.038;
    final progressBarHeight = screenHeight * 0.008;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header con botón de regreso y título
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: screenWidth * 0.065,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Location",
                            style: GoogleFonts.poppins(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.065),
                    ],
                  ),
                  
                  SizedBox(height: verticalSpacing * 2),
                  
                  // Barra de progreso (aproximadamente 1/3 completado)
                  Container(
                    width: double.infinity,
                    height: progressBarHeight,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(progressBarHeight / 2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.33, // 1/3 completado
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                          borderRadius: BorderRadius.circular(progressBarHeight / 2),
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing * 3),
                  
                  // Campo de dirección
                  Text(
                    "Insert your address",
                    style: GoogleFonts.poppins(
                      fontSize: labelFontSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: verticalSpacing * 0.5),
                  CustomTextField(
                    controller: _addressController,
                    hintText: "Address",
                    showBorder: true,
                    flavor: _currentFlavor,
                  ),
                  
                  SizedBox(height: verticalSpacing * 2),
                  
                  // Campo de suburbio
                  Text(
                    "Insert your suburb",
                    style: GoogleFonts.poppins(
                      fontSize: labelFontSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: verticalSpacing * 0.5),
                  CustomTextField(
                    controller: _suburbController,
                    hintText: "Suburb",
                    showBorder: true,
                    flavor: _currentFlavor,
                  ),
                  
                  SizedBox(height: verticalSpacing * 3),
                  
                  // Pregunta sobre relocalización
                  Text(
                    "Are you willing to be relocated?",
                    style: GoogleFonts.poppins(
                      fontSize: questionFontSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: verticalSpacing),
                  
                  // Opciones de relocalización
                  Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: _willingToRelocate,
                        onChanged: (value) {
                          setState(() {
                            _willingToRelocate = value!;
                          });
                        },
                        activeColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                      ),
                      Text(
                        "Yes",
                        style: GoogleFonts.poppins(
                          fontSize: optionFontSize,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: horizontalPadding * 2),
                      Radio<bool>(
                        value: false,
                        groupValue: _willingToRelocate,
                        onChanged: (value) {
                          setState(() {
                            _willingToRelocate = value!;
                          });
                        },
                        activeColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                      ),
                      Text(
                        "No",
                        style: GoogleFonts.poppins(
                          fontSize: optionFontSize,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: verticalSpacing * 2),
                  
                  // Pregunta sobre carro
                  Text(
                    "Do you have a car?",
                    style: GoogleFonts.poppins(
                      fontSize: questionFontSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: verticalSpacing),
                  
                  // Opciones de carro
                  Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: _hasCar,
                        onChanged: (value) {
                          setState(() {
                            _hasCar = value!;
                          });
                        },
                        activeColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                      ),
                      Text(
                        "Yes",
                        style: GoogleFonts.poppins(
                          fontSize: optionFontSize,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: horizontalPadding * 2),
                      Radio<bool>(
                        value: false,
                        groupValue: _hasCar,
                        onChanged: (value) {
                          setState(() {
                            _hasCar = value!;
                          });
                        },
                        activeColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                      ),
                      Text(
                        "No",
                        style: GoogleFonts.poppins(
                          fontSize: optionFontSize,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Botón Continue
                  CustomButton(
                    text: "Continue",
                    onPressed: _handleContinue,
                    isLoading: false,
                    flavor: _currentFlavor,
                  ),
                  
                  SizedBox(height: verticalSpacing * 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
