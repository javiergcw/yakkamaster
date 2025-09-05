import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/upload_progress_widget.dart';
import '../../logic/controllers/edit_documents_controller.dart';

class EditDocumentsScreen extends StatelessWidget {
  static const String id = '/edit-documents';
  
  final AppFlavor? flavor;

  const EditDocumentsScreen({
    super.key,
    this.flavor,
  });

  AppFlavor get _currentFlavor => flavor ?? AppFlavorConfig.currentFlavor;

  @override
  Widget build(BuildContext context) {
    final EditDocumentsController controller = Get.find<EditDocumentsController>();
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
                            "Edit documents",
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
                  
                  SizedBox(height: verticalSpacing * 0.3),
                  
                  // Widget de progreso de subida
                  Obx(() {
                    if (controller.isUploading.value) {
                      return UploadProgressWidget(
                        progress: controller.uploadProgress.value,
                        fileName: controller.uploadingFileName.value,
                        onCancel: () {
                          // Aquí podrías implementar la cancelación de la subida
                          controller.isUploading.value = false;
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  
                  SizedBox(height: verticalSpacing * 2),
                  
                  // Sección Add Credentials
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Add your Credentials",
                          style: GoogleFonts.poppins(
                            fontSize: sectionFontSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Obx(() => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding * 0.5,
                          vertical: verticalSpacing * 0.3,
                        ),
                        decoration: BoxDecoration(
                          color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${controller.uploadedDocumentsCount} subidos',
                          style: GoogleFonts.poppins(
                            fontSize: buttonFontSize * 0.8,
                            color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )),
                    ],
                  ),
                  
                  SizedBox(height: verticalSpacing * 2),
                  
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
                                    controller.selectedCredential.value.isNotEmpty 
                                        ? controller.selectedCredential.value 
                                        : "Select credential",
                                    style: GoogleFonts.poppins(
                                      fontSize: buttonFontSize,
                                      color: controller.selectedCredential.value.isNotEmpty 
                                          ? Colors.black 
                                          : Colors.grey[600],
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
                          onTap: controller.addCredential,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding * 0.3,
                              vertical: verticalSpacing * 0.5,
                            ),
                            decoration: BoxDecoration(
                              color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
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
                  
                  // Documentos opcionales
                  Obx(() => Column(
                    children: List.generate(controller.documents.length, (index) {
                      final document = controller.documents[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título del documento
                          Text(
                            document.type,
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
                                  onTap: () async => await controller.uploadDocument(index),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: horizontalPadding * 0.8,
                                      vertical: verticalSpacing * 0.8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)).withOpacity(0.3)),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.upload_file,
                                          color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                          size: screenWidth * 0.05,
                                        ),
                                        SizedBox(width: horizontalPadding * 0.5),
                                        Expanded(
                                          child: Text(
                                            "Upload ${document.type.toLowerCase()}",
                                            style: GoogleFonts.poppins(
                                              fontSize: buttonFontSize,
                                              fontWeight: FontWeight.w500,
                                              color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
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
                          if (controller.isDocumentReallyUploaded(document)) ...[
                            SizedBox(height: verticalSpacing * 0.5),
                            Padding(
                              padding: EdgeInsets.only(left: horizontalPadding * 0.8),
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
                                      SizedBox(width: horizontalPadding * 0.3),
                                      Expanded(
                                        child: Text(
                                          document.fileName,
                                          style: GoogleFonts.poppins(
                                            fontSize: buttonFontSize * 0.8,
                                            color: Colors.green[700],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => controller.deleteDocument(index),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: screenWidth * 0.04,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (document.fileSize != null) ...[
                                    SizedBox(height: verticalSpacing * 0.3),
                                    Text(
                                      'Tamaño: ${controller.formatFileSize(document.fileSize!)}',
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
                          SizedBox(height: verticalSpacing * 2),
                        ],
                      );
                    }),
                  )),
                  
                  const Spacer(),
                  
                  // Botón Save
                  CustomButton(
                    text: "Save",
                    onPressed: controller.saveDocuments,
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
    );
  }
}
