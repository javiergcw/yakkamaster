import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../widgets/progress_indicator.dart';
import '../../logic/controllers/create_profile_controller.dart';

class ProfilePhotoScreen extends StatelessWidget {
  static const String id = '/profile-photo';
  
  ProfilePhotoScreen({super.key});

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
    final modalFontSize = screenWidth * 0.042;
    final buttonFontSize = screenWidth * 0.035;

    return Scaffold(
      backgroundColor: Colors.white,
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
                              currentStep: 5,
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
                        "Next, add your profile photo",
                        style: GoogleFonts.poppins(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 3),
                    
                    // Círculo para foto de perfil
                    Center(
                      child: Obx(() => GestureDetector(
                        onTap: () => controller.showPhotoOptions(),
                        child: Container(
                          width: screenWidth * 0.4,
                          height: screenWidth * 0.4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFF5F5F5), // Gris muy claro
                            border: Border.all(
                              color: Colors.black,
                              width: 3,
                            ),
                          ),
                          child: controller.profileImage.value != null
                              ? ClipOval(
                                  child: Image.file(
                                    controller.profileImage.value!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  Icons.camera_alt,
                                  size: screenWidth * 0.1,
                                  color: Colors.black,
                                ),
                        ),
                      )),
                    ),
                    
                    SizedBox(height: verticalSpacing * 2),
                    
                    // Botón para abrir modal de opciones
                    Center(
                      child: SizedBox(
                        width: screenWidth * 0.7, // Reducir ancho al 70%
                        child: ElevatedButton(
                          onPressed: () => controller.showPhotoOptions(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: verticalSpacing * 0.8), // Reducir altura
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: buttonFontSize * 1.0, // Reducir tamaño del icono
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Take a photo or upload one?",
                                style: GoogleFonts.poppins(
                                  fontSize: buttonFontSize * 0.9, // Reducir tamaño del texto
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                                    onPressed: controller.handleProfilePhotoContinue,
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
