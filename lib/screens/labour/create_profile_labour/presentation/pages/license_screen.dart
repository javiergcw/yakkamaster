import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/file_preview_widget.dart';
import '../widgets/progress_indicator.dart';
import '../../logic/controllers/create_profile_controller.dart';

class LicenseScreen extends StatelessWidget {
  static const String id = '/license';
  
  LicenseScreen({super.key});

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
    final sectionFontSize = screenWidth * 0.045;
    final buttonFontSize = screenWidth * 0.035;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
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
                      "Finally, add one licence",
                      style: GoogleFonts.poppins(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing * 2),
                  
                  // Sección Add Credentials
                  Text(
                    "Add your Credentials",
                    style: GoogleFonts.poppins(
                      fontSize: sectionFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing * 0.8),
                  
                  // Dropdown y botón Add License
                  Row(
                    children: [
                                             Expanded(
                         flex: 3,
                         child: GestureDetector(
                           onTap: controller.showCredentialDropdown,
                           child: Container(
                             padding: EdgeInsets.symmetric(
                               horizontal: horizontalPadding * 0.8,
                               vertical: verticalSpacing * 0.8,
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
                                     controller.selectedCredential?.value ?? "Select credential",
                                     style: GoogleFonts.poppins(
                                       fontSize: buttonFontSize,
                                       color: controller.selectedCredential?.value != null ? Colors.black : Colors.grey[600],
                                     ),
                                   )),
                                 ),
                                 Icon(
                                   Icons.keyboard_arrow_down,
                                   color: Colors.grey[600],
                                   size: screenWidth * 0.05,
                                 ),
                               ],
                             ),
                           ),
                         ),
                       ),
                       SizedBox(width: horizontalPadding * 0.5),
                       Expanded(
                         flex: 1,
                         child: GestureDetector(
                           onTap: controller.addLicense,
                           child: Container(
                             padding: EdgeInsets.symmetric(
                               horizontal: horizontalPadding * 0.3,
                               vertical: verticalSpacing * 0.5,
                             ),
                             decoration: BoxDecoration(
                               color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                               borderRadius: BorderRadius.circular(12),
                             ),
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Icon(
                                   Icons.add,
                                   color: Colors.black,
                                   size: screenWidth * 0.04,
                                 ),
                                 SizedBox(height: verticalSpacing * 0.1),
                                 Text(
                                   "Add License",
                                   style: GoogleFonts.poppins(
                                     fontSize: buttonFontSize * 0.6,
                                     fontWeight: FontWeight.w600,
                                     color: Colors.black,
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ),
                       ),
                    ],
                  ),
                  
                  SizedBox(height: verticalSpacing * 1.5),
                  
                  // Licencias agregadas
                  Obx(() => Column(
                    children: List.generate(controller.licenses.length, (index) {
                      final license = controller.licenses[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título del documento con botón de eliminar
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  license['type'],
                                  style: GoogleFonts.poppins(
                                    fontSize: buttonFontSize,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => controller.removeLicense(index),
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: screenWidth * 0.04,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (license['uploaded'] == true) ...[
                            SizedBox(height: verticalSpacing * 0.5),
                            Padding(
                              padding: EdgeInsets.only(left: horizontalPadding * 0.8),
                              child: FilePreviewWidget(
                                fileName: license['file'] ?? 'Archivo',
                                filePath: license['path'],
                                fileSize: license['size'],
                                width: screenWidth * 0.3,
                                height: screenWidth * 0.25,
                              ),
                            ),
                          ] else ...[
                            // Solo mostrar el botón de upload si no hay archivo subido
                            SizedBox(height: verticalSpacing * 0.5),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async => await controller.uploadLicense(index),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: horizontalPadding * 0.8,
                                        vertical: verticalSpacing * 0.8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)).withOpacity(0.3)),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.upload_file,
                                            color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                                            size: screenWidth * 0.05,
                                          ),
                                          SizedBox(width: horizontalPadding * 0.5),
                                          Expanded(
                                            child: Text(
                                              "Upload ${license['type'].toString().toLowerCase()}",
                                              style: GoogleFonts.poppins(
                                                fontSize: buttonFontSize,
                                                fontWeight: FontWeight.w500,
                                                color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: horizontalPadding * 0.5),
                                Text(
                                  "(Optional)",
                                  style: GoogleFonts.poppins(
                                    fontSize: buttonFontSize * 0.8,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: verticalSpacing * 0.5),
                            Padding(
                              padding: EdgeInsets.only(left: horizontalPadding * 0.8),
                              child: Text(
                                ".pdf .doc .docx",
                                style: GoogleFonts.poppins(
                                  fontSize: buttonFontSize * 0.8,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                          SizedBox(height: verticalSpacing * 1.2),
                        ],
                      );
                    }),
                  )),
                  
                  // Mensaje informativo (solo se muestra si no hay licencias añadidas)
                  Obx(() {
                    if (controller.licenses.isEmpty) {
                      return Center(
                        child: Text(
                          "*To avoid scammers we require minimum 1 licence to verify your Identity",
                          style: GoogleFonts.poppins(
                            fontSize: sectionFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return SizedBox.shrink(); // No mostrar nada si hay licencias
                  }),
                  
                  SizedBox(height: verticalSpacing * 2),
                  
                  const Spacer(),
                  
                  // Botón Continue
                  CustomButton(
                    text: "Continue",
                    onPressed: controller.handleLicenseContinue,
                    isLoading: false,
                    showShadow: false,
                  ),
                  
                  SizedBox(height: verticalSpacing),
                  
                  
                  SizedBox(height: verticalSpacing * 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
