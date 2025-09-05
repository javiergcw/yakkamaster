import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../../../config/app_flavor.dart';
import '../../presentation/pages/documents_screen.dart';

class PreviousEmployerController extends GetxController {
  // Variables reactivas para los supervisores
  final Rx<Map<String, String>?> firstSupervisor = Rx<Map<String, String>?>(null);
  final Rx<Map<String, String>?> secondSupervisor = Rx<Map<String, String>?>(null);
  
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  @override
  void onInit() {
    super.onInit();
    // Si se pasa un flavor específico, usarlo
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
  }

  void showEditSupervisorModal(bool isFirstSupervisor) {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive para el modal
    final modalHeight = screenHeight * 0.75;
    final modalPadding = screenWidth * 0.06;
    final titleFontSize = screenWidth * 0.048;
    final labelFontSize = screenWidth * 0.038;
    final buttonFontSize = screenWidth * 0.035;
    final verticalSpacing = screenHeight * 0.02;

    // Obtener datos existentes del supervisor
    final supervisor = isFirstSupervisor ? firstSupervisor.value : secondSupervisor.value;
    
    // Controllers para el modal con datos existentes
    final nameController = TextEditingController(text: supervisor!['name']);
    final companyController = TextEditingController(text: supervisor['company']);
    final phoneController = TextEditingController(text: supervisor['phone']);
    
    // Variables para intl_phone_field
    String initialCountryCode = 'US';
    String initialPhoneNumber = supervisor['phone'] ?? '';

    Get.bottomSheet(
      Container(
        height: modalHeight,
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2C), // Dark grey background
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Header del modal
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: modalPadding,
                vertical: modalPadding * 1.2,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF2C2C2C),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Text(
                'Edit Supervisor',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            
            // Contenido del modal
            Expanded(
              child: Container(
                color: const Color(0xFF2C2C2C),
                padding: EdgeInsets.all(modalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Campo Name
                    Text(
                      "Name",
                      style: TextStyle(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: verticalSpacing * 0.5),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Enter Name Contact",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 2),
                    
                    // Campo Company Type
                    Text(
                      "Company Type",
                      style: TextStyle(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: verticalSpacing * 0.5),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: companyController,
                        decoration: InputDecoration(
                          hintText: "Enter Company Name",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 2),
                    
                    // Campo Phone Number
                    Text(
                      "Phone Number",
                      style: TextStyle(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: verticalSpacing * 0.5),
                    IntlPhoneField(
                      controller: phoneController,
                      initialCountryCode: initialCountryCode,
                      decoration: InputDecoration(
                        hintText: "Enter Phone Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value))),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      style: TextStyle(
                        fontSize: labelFontSize,
                        color: Colors.black,
                      ),
                      dropdownTextStyle: TextStyle(
                        fontSize: labelFontSize,
                        color: Colors.black,
                      ),
                      onChanged: (phone) {
                        // El número completo se actualiza automáticamente
                      },
                    ),
                    
                    const Spacer(),
                    
                    // Botones EXIT y SAVE
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: ElevatedButton(
                              onPressed: () => Get.back(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'EXIT',
                                style: TextStyle(
                                  fontSize: buttonFontSize,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: modalPadding * 0.5),
                        Expanded(
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (nameController.text.trim().isNotEmpty &&
                                    companyController.text.trim().isNotEmpty &&
                                    phoneController.text.trim().isNotEmpty) {
                                  if (isFirstSupervisor) {
                                    firstSupervisor.value = {
                                      'name': nameController.text.trim(),
                                      'company': companyController.text.trim(),
                                      'phone': phoneController.text.trim(),
                                    };
                                  } else {
                                    secondSupervisor.value = {
                                      'name': companyController.text.trim(),
                                      'company': companyController.text.trim(),
                                      'phone': phoneController.text.trim(),
                                    };
                                  }
                                  Get.back();
                                } else {
                                  // No mostrar toast, solo no hacer nada
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'SAVE',
                                style: TextStyle(
                                  fontSize: buttonFontSize,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: verticalSpacing),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void showAddSupervisorModal(bool isFirstSupervisor) {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive para el modal
    final modalHeight = screenHeight * 0.75;
    final modalPadding = screenWidth * 0.06;
    final titleFontSize = screenWidth * 0.048;
    final labelFontSize = screenWidth * 0.038;
    final buttonFontSize = screenWidth * 0.035;
    final verticalSpacing = screenHeight * 0.02;

    // Controllers para el modal
    final nameController = TextEditingController();
    final companyController = TextEditingController();
    final phoneController = TextEditingController();
    
    // Variables para intl_phone_field
    String initialCountryCode = 'US';

    Get.bottomSheet(
      Container(
        height: modalHeight,
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2C), // Dark grey background
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Header del modal
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: modalPadding,
                vertical: modalPadding * 1.2,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF2C2C2C),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Text(
                'Add your Previous employer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            
            // Contenido del modal
            Expanded(
              child: Container(
                color: const Color(0xFF2C2C2C),
                padding: EdgeInsets.all(modalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Campo Name
                    Text(
                      "Name",
                      style: TextStyle(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: verticalSpacing * 0.5),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Enter Name Contact",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 2),
                    
                    // Campo Company Type
                    Text(
                      "Company Type",
                      style: TextStyle(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: verticalSpacing * 0.5),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: companyController,
                        decoration: InputDecoration(
                          hintText: "Enter Company Name",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 2),
                    
                    // Campo Phone Number
                    Text(
                      "Phone Number",
                      style: TextStyle(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: verticalSpacing * 0.5),
                    IntlPhoneField(
                      controller: phoneController,
                      initialCountryCode: initialCountryCode,
                      decoration: InputDecoration(
                        hintText: "Enter Phone Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value))),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      style: TextStyle(
                        fontSize: labelFontSize,
                        color: Colors.black,
                      ),
                      dropdownTextStyle: TextStyle(
                        fontSize: labelFontSize,
                        color: Colors.black,
                      ),
                      onChanged: (phone) {
                        // El número completo se actualiza automáticamente
                      },
                    ),
                    
                    const Spacer(),
                    
                    // Botones EXIT y SAVE
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: ElevatedButton(
                              onPressed: () => Get.back(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'EXIT',
                                style: TextStyle(
                                  fontSize: buttonFontSize,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: modalPadding * 0.5),
                        Expanded(
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (nameController.text.trim().isNotEmpty &&
                                    companyController.text.trim().isNotEmpty &&
                                    phoneController.text.trim().isNotEmpty) {
                                  if (isFirstSupervisor) {
                                    firstSupervisor.value = {
                                      'name': nameController.text.trim(),
                                      'company': companyController.text.trim(),
                                      'phone': phoneController.text.trim(),
                                    };
                                  } else {
                                    secondSupervisor.value = {
                                      'name': nameController.text.trim(),
                                      'company': companyController.text.trim(),
                                      'phone': phoneController.text.trim(),
                                    };
                                  }
                                  Get.back();
                                } else {
                                  // No mostrar toast, solo no hacer nada
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'SAVE',
                                style: TextStyle(
                                  fontSize: buttonFontSize,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: verticalSpacing),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void handleContinue() {
    // Navegar a la pantalla de Documents
    Get.toNamed(DocumentsScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void showDeleteConfirmationDialog(bool isFirstSupervisor) {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final titleFontSize = screenWidth * 0.045;
    final buttonFontSize = screenWidth * 0.035;
    
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Eliminar Supervisor',
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        content: Text(
          '¿Estás seguro de que quieres eliminar este supervisor? Esta acción no se puede deshacer.',
          style: TextStyle(
            fontSize: buttonFontSize,
            color: Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancelar',
              style: TextStyle(
                fontSize: buttonFontSize,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (isFirstSupervisor) {
                firstSupervisor.value = null;
              } else {
                secondSupervisor.value = null;
              }
              Get.back();
            },
            child: Text(
              'Eliminar',
              style: TextStyle(
                fontSize: buttonFontSize,
                fontWeight: FontWeight.w600,
                color: Colors.red[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleSkip() {
    // Aquí irías al siguiente paso del stepper
    // Get.toNamed('/next-step', arguments: {'flavor': currentFlavor.value});
  }
}
