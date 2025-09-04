import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../../../../../features/widgets/phone_input.dart';
import '../widgets/profile_image_section.dart';
import '../../logic/controllers/create_profile_builder_controller.dart';

class CreateProfileBuilderScreen extends StatelessWidget {
  static const String id = '/create-profile-builder';
  
  CreateProfileBuilderScreen({super.key});

  final CreateProfileBuilderController controller = Get.put(CreateProfileBuilderController());

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

    return Obx(() => Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
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
                              "Create Builder Profile",
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
                    ProfileImageSection(
                      profileImage: controller.profileImage.value,
                      onTap: controller.showImageSourceDialog,
                      flavor: controller.currentFlavor.value,
                      imageSize: profileImageSize,
                      editIconSize: editIconSize,
                      cameraIconSize: cameraIconSize,
                    ),

                    SizedBox(height: verticalSpacing * 3),

                    // Campos de entrada
                    CustomTextField(
                      controller: controller.firstNameController,
                      hintText: "First Name",
                      showBorder: true,
                    ),

                    SizedBox(height: verticalSpacing * 1.5),

                    CustomTextField(
                      controller: controller.lastNameController,
                      hintText: "Last Name",
                      showBorder: true,
                    ),

                    SizedBox(height: verticalSpacing * 1.5),

                    // Campo de teléfono usando el componente PhoneInput
                    PhoneInput(
                      controller: controller.phoneController,
                    ),

                    SizedBox(height: verticalSpacing * 1.5),

                    CustomTextField(
                      controller: controller.emailController,
                      hintText: "Email",
                      showBorder: true,
                    ),

                    SizedBox(height: verticalSpacing * 1.5),

                    // Campo de empresa con dropdown
                    GestureDetector(
                      onTap: () {
                        print('Company field tapped!');
                        controller.showCompanySelectionDialog();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                controller.companyNameController.text.isEmpty 
                                    ? "Company Name" 
                                    : controller.companyNameController.text,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: controller.companyNameController.text.isEmpty 
                                      ? Colors.grey[600] 
                                      : Colors.black,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey[600],
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom + verticalSpacing * 3),

                    // Botón Next con sombra personalizada
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: strongCardShadows,
                      ),
                      child: CustomButton(
                        text: "Next",
                        onPressed: controller.handleNext,
                        isLoading: false,
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 2),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
