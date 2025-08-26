import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../config/app_flavor.dart';
import '../../../../config/assets_config.dart';
import '../../../../features/widgets/custom_button.dart';
import '../../../../features/widgets/upload_progress_widget.dart';
import '../../home_module.dart';

class EditDocumentsScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const EditDocumentsScreen({
    super.key,
    this.flavor,
  });

  @override
  State<EditDocumentsScreen> createState() => _EditDocumentsScreenState();
}

class _EditDocumentsScreenState extends State<EditDocumentsScreen> {
  final DocumentController _documentController = Get.put(DocumentController());
  
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;

  void _showCredentialDropdown() {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final titleFontSize = screenWidth * 0.045;
    final itemFontSize = screenWidth * 0.035;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Text(
                'Select Credential',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _documentController.credentials.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _documentController.credentials[index],
                      style: GoogleFonts.poppins(
                        fontSize: itemFontSize,
                        color: Colors.black87,
                      ),
                    ),
                    onTap: () {
                      _documentController.setSelectedCredential(_documentController.credentials[index]);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addLicense() {
    _documentController.addCredential();
  }

  Future<void> _uploadDocument(int index) async {
    await _documentController.uploadDocument(index);
  }

  void _deleteDocument(int index) {
    _documentController.deleteDocument(index);
  }

  String _formatFileSize(int bytes) {
    return _documentController.formatFileSize(bytes);
  }

  void _handleSave() {
    _documentController.saveDocuments();
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
                        onPressed: () => Navigator.of(context).pop(),
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
                  
                  SizedBox(height: verticalSpacing * 3),
                  
                  // Widget de progreso de subida
                  Obx(() {
                    if (_documentController.isUploading.value) {
                      return UploadProgressWidget(
                        progress: _documentController.uploadProgress.value,
                        fileName: _documentController.uploadingFileName.value,
                        onCancel: () {
                          // Aquí podrías implementar la cancelación de la subida
                          _documentController.isUploading.value = false;
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
                          '${_documentController.uploadedDocumentsCount} subidos',
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
                        child: GestureDetector(
                          onTap: _showCredentialDropdown,
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
                                    _documentController.selectedCredential.value.isNotEmpty 
                                        ? _documentController.selectedCredential.value 
                                        : "Select credential",
                                    style: GoogleFonts.poppins(
                                      fontSize: buttonFontSize,
                                      color: _documentController.selectedCredential.value.isNotEmpty 
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
                      GestureDetector(
                        onTap: _addLicense,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding * 0.8,
                            vertical: verticalSpacing * 0.8,
                          ),
                          decoration: BoxDecoration(
                            color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF000000),
                                offset: const Offset(0, 8),
                                blurRadius: 20,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.black,
                                size: screenWidth * 0.05,
                              ),
                              SizedBox(width: horizontalPadding * 0.3),
                              Text(
                                "Add License",
                                style: GoogleFonts.poppins(
                                  fontSize: buttonFontSize * 0.8,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: verticalSpacing * 3),
                  
                  // Documentos opcionales
                  Obx(() => Column(
                    children: List.generate(_documentController.documents.length, (index) {
                      final document = _documentController.documents[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async => await _uploadDocument(index),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: horizontalPadding * 0.8,
                                      vertical: verticalSpacing * 1.2,
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
                          if (_documentController.isDocumentReallyUploaded(document)) ...[
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
                                        onTap: () => _deleteDocument(index),
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
                                      'Tamaño: ${_formatFileSize(document.fileSize!)}',
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
                    onPressed: _handleSave,
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
    );
  }
}
