import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../widgets/progress_indicator.dart';
import '../../logic/controllers/create_profile_controller.dart';

class LocationScreen extends StatelessWidget {
  static const String id = '/location';
  
  LocationScreen({super.key});

  final CreateProfileController controller = Get.find<CreateProfileController>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header con botón de regreso y barra de progreso centrada
                    Row(
                      children: [
                        // Botón de retroceso con padding negativo para moverlo más a la izquierda
                        Transform.translate(
                          offset: Offset(-screenWidth * 0.02, 0), // Mover 2% del ancho hacia la izquierda
                          child: IconButton(
                            onPressed: () => Get.back(),
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: screenWidth * 0.065,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: ProgressIndicatorWidget(
                              currentStep: 4,
                              totalSteps: 5,
                              flavor: controller.currentFlavor.value,
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.065), // Espacio para balancear el layout
                      ],
                    ),
                    
                    SizedBox(height: verticalSpacing * 2),
                    
                    // Título principal centrado
                    Center(
                      child: Text(
                        "Where do you live?",
                        style: GoogleFonts.poppins(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 2),
                    
                    // Campo de dirección
                    CustomTextField(
                      controller: controller.addressController,
                      hintText: "Insert your address (Required)",
                      showBorder: true,
                      flavor: controller.currentFlavor.value,
                    ),
                    
                    SizedBox(height: verticalSpacing * 2),
                  ],
                ),
              ),
            ),
            
            // Botón Continue fijo en la parte inferior
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: CustomButton(
                text: "Continue",
                                    onPressed: controller.handleLocationContinue,
                showShadow: false,
              ),
            ),
            
            SizedBox(height: verticalSpacing * 2),
          ],
        ),
      ),
    );
  }
}