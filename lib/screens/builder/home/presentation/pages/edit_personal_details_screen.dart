import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../../../../../features/widgets/phone_input.dart';
import '../../../create_profile_builder/presentation/widgets/company_selection_dialog_v2.dart';
import '../../../create_profile_builder/presentation/widgets/profile_image_section.dart';
import '../../../create_profile_builder/presentation/pages/register_new_company_screen.dart';
import '../../logic/controllers/edit_personal_details_controller.dart';

class EditPersonalDetailsScreen extends StatelessWidget {
  static const String id = '/builder/edit-personal-details';
  
  final AppFlavor? flavor;

  EditPersonalDetailsScreen({
    super.key,
    this.flavor,
  });

  EditPersonalDetailsController get controller => Get.find<EditPersonalDetailsController>(tag: 'builder');

  // Sombras tipo tarjeta (igual que en create_profile_builder_screen)
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



  // Función para mostrar el diálogo de selección de empresa
  void _showCompanySelectionDialog() {
    print('Opening company selection dialog...');
    try {
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: CompanySelectionDialogV2(
            flavor: controller.currentFlavor.value,
            onCompanySelected: (String company) {
              print('Company selected: $company');
              controller.companyNameController.text = company;
              controller.selectedCompanyName.value = company;
            },
            onRegisterNewCompany: () {
              print('Register new company tapped');
              Get.toNamed(RegisterNewCompanyScreen.id, arguments: {
                'flavor': controller.currentFlavor.value,
                'source': 'edit_personal_details'
              });
            },
            additionalCompanies: controller.userCreatedCompanies,
          ),
        ),
      );
      print('Dialog opened successfully');
    } catch (e) {
      print('Error opening dialog: $e');
      Get.snackbar(
        'Error',
        'Error opening company selection: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _handleSave() {
    print('Save Changes button pressed');
    controller.handleSave();
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
                          onPressed: () => controller.navigateBack(),
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: screenWidth * 0.065,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "Edit Personal Details",
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
                    Obx(() => ProfileImageSection(
                      profileImage: controller.profileImage.value,
                      onTap: controller.showImageSourceDialog,
                      flavor: controller.currentFlavor.value,
                      imageSize: profileImageSize,
                      editIconSize: editIconSize,
                      cameraIconSize: cameraIconSize,
                    )),

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
                    Obx(() => GestureDetector(
                      onTap: () {
                        print('Company field tapped!');
                        _showCompanySelectionDialog();
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
                                controller.selectedCompanyName.value.isEmpty 
                                    ? "Company Name" 
                                    : controller.selectedCompanyName.value,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: controller.selectedCompanyName.value.isEmpty 
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
                    )),

                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom + verticalSpacing * 3),

                    // Botón Save sin sombra
                    CustomButton(
                      text: "Save Changes",
                      onPressed: _handleSave,
                      isLoading: false,
                      showShadow: false,
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
