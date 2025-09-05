import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../../../../../features/widgets/phone_input.dart';
import '../../logic/controllers/edit_personal_details_controller.dart';

class EditPersonalDetailsScreen extends StatelessWidget {
  static const String id = '/edit-personal-details';
  
  final AppFlavor? flavor;

  const EditPersonalDetailsScreen({
    super.key,
    this.flavor,
  });

  AppFlavor get _currentFlavor => flavor ?? AppFlavorConfig.currentFlavor;

  @override
  Widget build(BuildContext context) {
    final EditPersonalDetailsController controller = Get.find<EditPersonalDetailsController>();
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
                              "Edit personal details",
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
                                  color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                  shape: BoxShape.circle,
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

                    // Campo de email DESHABILITADO
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding * 0.8,
                          vertical: verticalSpacing * 1.2,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                controller.emailController.text,
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            Icon(
                              Icons.lock,
                              size: screenWidth * 0.05,
                              color: Colors.grey[500],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 0.8),

                    CustomTextField(
                      controller: controller.birthCountryController,
                      hintText: "Enter your birth country",
                      showBorder: true,
                    ),

                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom + verticalSpacing * 3),

                    // Botón Save con borde personalizado
                    CustomButton(
                      text: "Save",
                      onPressed: controller.handleSave,
                      isLoading: false,
                      showShadow: false,
                      customBorder: Border(
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 4,
                        ),
                        right: BorderSide(
                          color: Colors.black,
                          width: 4,
                        ),
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
    );
  }
}
