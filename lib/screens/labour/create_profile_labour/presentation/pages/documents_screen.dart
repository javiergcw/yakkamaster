import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../logic/controllers/create_profile_controller.dart';

class DocumentsScreen extends StatelessWidget {
  static const String id = '/documents';

  DocumentsScreen({super.key});

  final CreateProfileController controller =
      Get.find<CreateProfileController>();

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
    final progressBarHeight = screenHeight * 0.008;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  screenHeight -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header con botón de regreso y título
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
                            "Add documents",
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

                  SizedBox(height: verticalSpacing * 2),

                  // Barra de progreso (aproximadamente 70% completado)
                  Container(
                    width: double.infinity,
                    height: progressBarHeight,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(
                        progressBarHeight / 2,
                      ),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 1.0, // 100% completado - último paso
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(
                            AppFlavorConfig.getPrimaryColor(
                              controller.currentFlavor.value,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(
                            progressBarHeight / 2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: verticalSpacing * 1.5),

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

                  // Dropdown y botón Add Credential
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
                                  child: Obx(
                                    () => Text(
                                      controller.selectedCredential?.value ??
                                          "Select credential",
                                      style: GoogleFonts.poppins(
                                        fontSize: buttonFontSize,
                                        color:
                                            controller
                                                    .selectedCredential
                                                    ?.value !=
                                                null
                                            ? Colors.black
                                            : Colors.grey[600],
                                      ),
                                    ),
                                  ),
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
                          onTap: controller.addCredential,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding * 0.3,
                              vertical: verticalSpacing * 0.5,
                            ),
                            decoration: BoxDecoration(
                              color: Color(
                                AppFlavorConfig.getPrimaryColor(
                                  controller.currentFlavor.value,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.upload,
                                  color: Colors.white,
                                  size: screenWidth * 0.04,
                                ),
                                SizedBox(height: verticalSpacing * 0.1),
                                Text(
                                  "Add Credential",
                                  style: GoogleFonts.poppins(
                                    fontSize: buttonFontSize * 0.6,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
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

                  // Documentos opcionales
                  Obx(
                    () => Column(
                      children: List.generate(controller.documents.length, (
                        index,
                      ) {
                        final document = controller.documents[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título del documento
                            Text(
                              document['type'],
                              style: GoogleFonts.poppins(
                                fontSize: buttonFontSize,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: verticalSpacing * 0.5),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async =>
                                        await controller.uploadDocument(index),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: horizontalPadding * 0.8,
                                        vertical: verticalSpacing * 0.8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(
                                          AppFlavorConfig.getPrimaryColor(
                                            controller.currentFlavor.value,
                                          ),
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Color(
                                            AppFlavorConfig.getPrimaryColor(
                                              controller.currentFlavor.value,
                                            ),
                                          ).withOpacity(0.3),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.upload_file,
                                            color: Color(
                                              AppFlavorConfig.getPrimaryColor(
                                                controller.currentFlavor.value,
                                              ),
                                            ),
                                            size: screenWidth * 0.05,
                                          ),
                                          SizedBox(
                                            width: horizontalPadding * 0.5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Upload ${document['type'].toString().toLowerCase()}",
                                              style: GoogleFonts.poppins(
                                                fontSize: buttonFontSize,
                                                fontWeight: FontWeight.w500,
                                                color: Color(
                                                  AppFlavorConfig.getPrimaryColor(
                                                    controller
                                                        .currentFlavor
                                                        .value,
                                                  ),
                                                ),
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
                              padding: EdgeInsets.only(
                                left: horizontalPadding * 0.8,
                              ),
                              child: Text(
                                ".pdf .doc .docx",
                                style: GoogleFonts.poppins(
                                  fontSize: buttonFontSize * 0.8,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            if (document['uploaded'] == true) ...[
                              SizedBox(height: verticalSpacing * 0.5),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: horizontalPadding * 0.8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: screenWidth * 0.04,
                                        ),
                                        SizedBox(
                                          width: horizontalPadding * 0.3,
                                        ),
                                        Expanded(
                                          child: Text(
                                            document['file'],
                                            style: GoogleFonts.poppins(
                                              fontSize: buttonFontSize * 0.8,
                                              color: Colors.green[700],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (document['size'] != null) ...[
                                      SizedBox(height: verticalSpacing * 0.3),
                                      Text(
                                        'Tamaño: ${controller.formatFileSize(document['size'])}',
                                        style: GoogleFonts.poppins(
                                          fontSize: buttonFontSize * 0.7,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                            SizedBox(height: verticalSpacing * 1.2),
                          ],
                        );
                      }),
                    ),
                  ),

                  const Spacer(),

                  // Botón Continue
                  CustomButton(
                    text: "Continue",
                    onPressed: controller.handleDocumentsContinue,
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
    );
  }
}
