import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../../../../../features/widgets/phone_input.dart';
import '../../logic/controllers/create_profile_controller.dart';

class CreateProfileScreen extends StatelessWidget {
  static const String id = '/create-profile-labour';
  
  CreateProfileScreen({super.key});

  final CreateProfileController controller = Get.put(CreateProfileController());

  // Sombras tipo tarjeta (igual que en industry_selection_screen)
  final List<BoxShadow> strongCardShadows = const [
    BoxShadow(
      color: Color(0xFF000000), // 100% negro (totalmente negro)
      offset: Offset(6, 8),
      blurRadius: 0,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0xFF000000), // 100% negro (totalmente negro)
      offset: Offset(0, 18),
      blurRadius: 28,
      spreadRadius: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final profileImageSize = screenWidth * 0.25; // 25% del ancho para la imagen de perfil
    final editIconSize = screenWidth * 0.06;
    final cameraIconSize = screenWidth * 0.08;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).viewInsets.bottom,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: verticalSpacing),
                    
                    // Header con botón de retroceso y título
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: screenWidth * 0.065,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "Create profile",
                              style: GoogleFonts.poppins(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.065), // Espacio para balancear el layout
                      ],
                    ),

                    SizedBox(height: verticalSpacing * 2),

                    // Imagen de perfil con botón de edición
                    Center(
                      child: GestureDetector(
                        onTap: controller.showImageSourceDialog,
                        child: Stack(
                          children: [
                            // Círculo principal de la imagen de perfil
                            Container(
                              width: profileImageSize,
                              height: profileImageSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 2,
                                ),
                                // Sin sombra
                              ),
                              child: Obx(() => controller.profileImage.value != null
                                  ? ClipOval(
                                      child: Image.file(
                                        controller.profileImage.value!,
                                        width: profileImageSize,
                                        height: profileImageSize,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(
                                      Icons.camera_alt,
                                      size: cameraIconSize,
                                      color: Colors.grey[600],
                                    )),
                            ),
                            
                            // Botón de edición (círculo amarillo con icono de lápiz)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: editIconSize,
                                height: editIconSize,
                                decoration: BoxDecoration(
                                  color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                                  shape: BoxShape.circle,
                                  // Sin sombra
                                ),
                                child: Icon(
                                  Icons.edit,
                                  size: editIconSize * 0.5,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 3),

                    // Campos de entrada
                    CustomTextField(
                      controller: controller.firstNameController,
                      hintText: "First Name",
                      showBorder: true,
                    ),

                    SizedBox(height: verticalSpacing * 0.8),

                    CustomTextField(
                      controller: controller.lastNameController,
                      hintText: "Last Name",
                      showBorder: true,
                    ),

                    SizedBox(height: verticalSpacing * 0.8),

                    // Campo de teléfono usando el componente PhoneInput
                    PhoneInput(
                      controller: controller.phoneController,
                    ),

                    SizedBox(height: verticalSpacing * 0.8),

                    CustomTextField(
                      controller: controller.emailController,
                      hintText: "Email",
                      showBorder: true,
                    ),

                    SizedBox(height: verticalSpacing * 0.8),

                    CustomTextField(
                      controller: controller.birthCountryController,
                      hintText: "Enter your birth country",
                      showBorder: true,
                    ),

                    SizedBox(height: verticalSpacing * 2),

                    // Botón Next con bordes personalizados
                    CustomButton(
                      text: "Next",
                      onPressed: controller.handleNext,
                      isLoading: false,
                      showShadow: false,
                      customBorder: Border(
                        top: BorderSide(
                          color: Colors.black.withOpacity(0.9),
                          width: 1,
                        ),
                        left: BorderSide(
                          color: Colors.black.withOpacity(0.9),
                          width: 1,
                        ),
                        right: BorderSide(
                          color: Colors.black.withOpacity(0.9),
                          width: 4,
                        ),
                        bottom: BorderSide(
                          color: Colors.black.withOpacity(0.9),
                          width: 4,
                        ),
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 1.5),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}
