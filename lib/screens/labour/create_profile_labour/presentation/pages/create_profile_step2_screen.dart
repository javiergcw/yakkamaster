import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/country_selector.dart';
import '../../logic/controllers/create_profile_controller.dart';

class CreateProfileStep2Screen extends StatelessWidget {
  static const String id = '/create-profile-step2-labour';
  
  CreateProfileStep2Screen({super.key});

  final CreateProfileController controller = Get.find<CreateProfileController>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.06;
    final buttonFontSize = screenWidth * 0.045;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              SizedBox(height: verticalSpacing),
              
              // Header con botón de retroceso y barra de progreso centrada
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
                        currentStep: 2,
                        totalSteps: 5,
                        flavor: controller.currentFlavor.value,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.065), // Espacio para balancear el layout
                ],
              ),

              SizedBox(height: verticalSpacing * 2),

              // Título principal
              Center(
                child: Text(
                  "Complete your details",
                  style: GoogleFonts.poppins(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: verticalSpacing * 2),

              // Campo Email
              CustomTextField(
                controller: controller.emailController,
                hintText: "Email (Required)",
                showBorder: true,
                flavor: controller.currentFlavor.value,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: verticalSpacing * 0.8),

              // Campos de Country y Phone Number separados
              Row(
                children: [
                  // Selector de país
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Country',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.035,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: verticalSpacing * 0.3),
                        CountrySelector(
                          initialCountryCode: 'AU',
                          onCountryChanged: (country) {
                            // Manejar cambio de país si es necesario
                          },
                          flavor: controller.currentFlavor.value,
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(width: screenWidth * 0.03),
                  
                  // Campo de número de teléfono
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phone number',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.035,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: verticalSpacing * 0.3),
                        CustomTextField(
                          controller: controller.phoneController,
                          hintText: "6123456789",
                          showBorder: true,
                          flavor: controller.currentFlavor.value,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Botón Continue
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.065,
                child: ElevatedButton(
                  onPressed: controller.handleNextStep2,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'CONTINUE',
                    style: GoogleFonts.poppins(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              SizedBox(height: verticalSpacing * 2),
            ],
          ),
        ),
      ),
    );
  }
}
