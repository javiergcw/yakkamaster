import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../widgets/profile_menu_item.dart';
import '../../logic/controllers/profile_screen_controller.dart';

class ProfileScreen extends StatelessWidget {
  static const String id = '/labour/profile';
  
  final AppFlavor? flavor;
  ProfileScreen({super.key, this.flavor});

  final ProfileScreenController controller = Get.put(ProfileScreenController());

  @override
  Widget build(BuildContext context) {
    // Establecer el flavor en el controlador si se proporciona
    if (flavor != null) {
      controller.currentFlavor.value = flavor!;
    }

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final subtitleFontSize = screenWidth * 0.035;
    final profileImageSize = screenWidth * 0.2; // Reducido de 0.25 a 0.2
  


    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C), // Fondo gris oscuro
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
              ),
            );
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    controller.errorMessage,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => controller.refreshProfile(),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
            // Header con información del perfil
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing * 1.5, // Reducido de 3 a 1.5
              ),
              child: Column(
                children: [
                  // Nombre del usuario
                  Text(
                    controller.userFullName,
                    style: GoogleFonts.poppins(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing * 0.5),
                
                  
                  SizedBox(height: verticalSpacing * 0.3),
                  
                  Text(
                    "user ID #${controller.userId}",
                    style: GoogleFonts.poppins(
                      fontSize: subtitleFontSize,
                      color: Colors.grey[300],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing),
                  
                  // Foto de perfil con botón de actualización
                  Center(
                    child: Stack(
                      children: [
                        // Foto de perfil principal
                        Container(
                          width: profileImageSize,
                          height: profileImageSize,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A6741), // Verde oscuro
                            shape: BoxShape.circle,
                          ),
                          child: Obx(() {
                            final selectedImage = controller.selectedImage.value;
                            return selectedImage != null
                                ? ClipOval(
                                    child: Image.file(
                                      File(selectedImage.path),
                                      width: profileImageSize,
                                      height: profileImageSize,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                              : Center(
                                  child: Icon(
                                    Icons.person,
                                    size: profileImageSize * 0.6,
                                    color: const Color(0xFF8BC34A), // Verde claro
                                  ),
                                );
                          }),
                        ),
                        
                        // Botón de edición de imagen
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: controller.handleEditProfileImage,
                            child: Container(
                              width: profileImageSize * 0.35,
                              height: profileImageSize * 0.35,
                              decoration: BoxDecoration(
                                color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF2C2C2C),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.edit,
                                size: profileImageSize * 0.2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing * 1.5),
                  
                  // Botones de acción
                  Column(
                    children: [
                      // Botón Complete your profile
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: horizontalPadding * 1.5),
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Implementar navegación a completar perfil
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: verticalSpacing * 0.8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.edit,
                                    size: screenWidth * 0.04,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: horizontalPadding * 0.3),
                                  Text(
                                    'Complete your profile',
                                    style: GoogleFonts.poppins(
                                      fontSize: subtitleFontSize * 0.9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Punto de notificación
                          Positioned(
                            top: 6,
                            right: horizontalPadding * 1.5 + 6,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: verticalSpacing * 0.6),
                      
                      // Botón View profile
                      TextButton(
                        onPressed: () {
                          // TODO: Implementar navegación a ver perfil
                        },
                        child: Text(
                          'View profile',
                          style: GoogleFonts.poppins(
                            fontSize: subtitleFontSize * 0.9,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Lista de opciones del menú
            Container(
              margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                    ProfileMenuItem(
                      icon: Icons.chat,
                      title: "Help",
                      onTap: controller.handleHelp,
                      flavor: controller.currentFlavor.value,
                    ),
                    ProfileMenuItem(
                      icon: Icons.person,
                      title: "Edit personal details",
                      onTap: controller.handleEditPersonalDetails,
                      flavor: controller.currentFlavor.value,
                    ),
                    ProfileMenuItem(
                      icon: Icons.qr_code,
                      title: "Edit documents",
                      onTap: controller.handleEditDocuments,
                      flavor: controller.currentFlavor.value,
                    ),
                    ProfileMenuItem(
                      icon: Icons.account_balance,
                      title: "Edit bank details",
                      onTap: controller.handleEditBankDetails,
                      flavor: controller.currentFlavor.value,
                    ),
                    ProfileMenuItem(
                      icon: Icons.description,
                      title: "Terms and conditions",
                      onTap: controller.handleTermsAndConditions,
                      flavor: controller.currentFlavor.value,
                    ),
                    ProfileMenuItem(
                      icon: Icons.delete,
                      title: "Delete account",
                      onTap: controller.handleDeleteAccount,
                      flavor: controller.currentFlavor.value,
                    ),
                    ProfileMenuItem(
                      icon: Icons.logout,
                      title: "Log out",
                      onTap: controller.handleLogOut,
                      flavor: controller.currentFlavor.value,
                    ),
                ],
              ),
            ),
            
            SizedBox(height: verticalSpacing * 2), // Espaciado al final
            ],
          ));
        }),
      ),
    );
  }
}
