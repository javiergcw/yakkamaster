import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../../logic/controllers/edit_bank_details_controller.dart';
import '../widgets/under_construction_widget.dart';

/*
 * CONFIGURACIÓN DE VERIFICACIÓN BANCARIA:
 * 
 * Para activar/desactivar el comportamiento de verificación de datos bancarios:
 * - Cambiar _enableBankVerification a true: Cuando el usuario marca "I don't have a Pay ID",
 *   será redirigido a la pantalla de detalles bancarios tradicionales (BSB, Account Number, etc.)
 * - Cambiar _enableBankVerification a false: El comportamiento normal se mantiene sin redirección
 */

class EditBankDetailsScreen extends StatelessWidget {
  static const String id = '/edit-bank-details';
  
  final AppFlavor? flavor;
  
  // Booleano para controlar si mostrar el widget de construcción o el contenido normal
  static const bool showUnderConstruction = true;

  const EditBankDetailsScreen({
    super.key,
    this.flavor,
  });

  AppFlavor get _currentFlavor => flavor ?? AppFlavorConfig.currentFlavor;

  @override
  Widget build(BuildContext context) {
    // Si está en modo construcción, mostrar el widget de construcción con AppBar
    if (showUnderConstruction) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: MediaQuery.of(context).size.width * 0.06,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Edit Bank Details',
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.055,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.06,
              vertical: MediaQuery.of(context).size.height * 0.05,
            ),
            child: UnderConstructionWidget(
              flavor: flavor ?? AppFlavorConfig.currentFlavor,
              customMessage: "We are working on improving your bank details management. This will be available soon with enhanced financial security features!",
            ),
          ),
        ),
      );
    }
    final EditBankDetailsController controller = Get.find<EditBankDetailsController>();
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final labelFontSize = screenWidth * 0.04;
    final noteFontSize = screenWidth * 0.035;

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
                              "Edit bank details",
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

                    SizedBox(height: verticalSpacing * 1.5),

                    // Indicador de estado de datos bancarios
                    Obx(() => Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(horizontalPadding * 0.8),
                      decoration: BoxDecoration(
                        color: controller.hasBankDetails() 
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: controller.hasBankDetails() 
                            ? Colors.green.withOpacity(0.3)
                            : Colors.orange.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            controller.hasBankDetails() ? Icons.check_circle : Icons.warning,
                            color: controller.hasBankDetails() ? Colors.green : Colors.orange,
                            size: screenWidth * 0.05,
                          ),
                          SizedBox(width: horizontalPadding * 0.5),
                          Expanded(
                            child: Text(
                              controller.hasBankDetails() 
                                ? 'Bank details are configured'
                                : 'Bank details need to be configured',
                              style: GoogleFonts.poppins(
                                fontSize: noteFontSize,
                                fontWeight: FontWeight.w500,
                                color: controller.hasBankDetails() ? Colors.green[700] : Colors.orange[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),

                    SizedBox(height: verticalSpacing * 1.2),

                    // Campo ABN
                    Text(
                      "ABN",
                      style: GoogleFonts.poppins(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    
                                        SizedBox(height: verticalSpacing * 0.8),

                    CustomTextField(
                      controller: controller.abnController,
                      hintText: "Enter ABN",
                      showBorder: true,
                    ),

                    SizedBox(height: verticalSpacing * 1.2),

                    // Campo Pay ID Type
                    Text(
                      "Pay ID Type",
                      style: GoogleFonts.poppins(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    
                                        SizedBox(height: verticalSpacing * 0.8),

                    GestureDetector(
                      onTap: controller.showPayIdTypeDropdown,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding * 0.8,
                          vertical: screenHeight * 0.015,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Obx(() => Text(
                                controller.selectedPayIdType.value,
                                style: GoogleFonts.poppins(
                                  fontSize: labelFontSize,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              )),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black,
                              size: screenWidth * 0.05,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 1.2),

                    // Campo Pay ID
                    Text(
                      "Pay ID",
                      style: GoogleFonts.poppins(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    
                                        SizedBox(height: verticalSpacing * 0.8),

                    Obx(() => CustomTextField(
                      controller: controller.payIdController,
                      hintText: "Enter Pay ID",
                      showBorder: true,
                      enabled: !controller.dontHavePayId.value,
                    )),

                    SizedBox(height: verticalSpacing * 1.2),

                    // Checkbox "I don't have a Pay ID"
                    Row(
                      children: [
                        GestureDetector(
                          onTap: controller.toggleDontHavePayId,
                          child: Obx(() => Container(
                            width: screenWidth * 0.05,
                            height: screenWidth * 0.05,
                            decoration: BoxDecoration(
                              color: controller.dontHavePayId.value ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)) : Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: controller.dontHavePayId.value ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)) : Colors.grey[400]!,
                                width: 2,
                              ),
                            ),
                            child: controller.dontHavePayId.value
                                ? Icon(
                                    Icons.check,
                                    size: screenWidth * 0.035,
                                    color: Colors.black,
                                  )
                                : null,
                          )),
                        ),
                        SizedBox(width: horizontalPadding * 0.5),
                        Expanded(
                          child: Text(
                            "I don't have a Pay ID",
                            style: GoogleFonts.poppins(
                              fontSize: labelFontSize,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: verticalSpacing * 2),

                    // Nota importante
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(horizontalPadding),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "IMPORTANT: Yakka Labour is not responsible for the payment only the company who hire you.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: noteFontSize,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom + verticalSpacing * 4),

                    // Botón Save
                    CustomButton(
                      text: "Save",
                      onPressed: () => controller.handleSave(_currentFlavor),
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
      ),
    );
  }
}
