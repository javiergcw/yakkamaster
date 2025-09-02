import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../../../../features/widgets/custom_button.dart';
import 'respect_screen.dart';

class DocumentsScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const DocumentsScreen({
    super.key,
    this.flavor,
  });

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  String? _selectedCredential;
  final List<String> _credentials = [
    'Driver License',
    'Forklift License',
    'White Card',
    'First Aid Certificate',
    'Working at Heights',
    'Confined Spaces',
    'Other'
  ];

  final List<Map<String, dynamic>> _documents = [
    {'type': 'Resume', 'file': null, 'uploaded': false},
    {'type': 'Cover letter', 'file': null, 'uploaded': false},
    {'type': 'Police check', 'file': null, 'uploaded': false},
    {'type': 'Other', 'file': null, 'uploaded': false},
  ];

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
                itemCount: _credentials.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _credentials[index],
                      style: GoogleFonts.poppins(
                        fontSize: itemFontSize,
                        color: Colors.black87,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedCredential = _credentials[index];
                      });
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
    // No mostrar toast, solo no hacer nada si no hay credencial seleccionada
  }

  Future<void> _uploadDocument(int index) async {
    try {
      // Abrir selector de archivos
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        
        setState(() {
          _documents[index]['uploaded'] = true;
          _documents[index]['file'] = file.name;
          _documents[index]['path'] = file.path;
          _documents[index]['size'] = file.size;
        });

        // Archivo subido exitosamente
      } else {
        // Usuario canceló la selección
      }
    } catch (e) {
      // Error al seleccionar archivo
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  void _handleContinue() {
    // Navegar a la pantalla de Respect
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => RespectScreen(flavor: _currentFlavor)),
    );
  }

  void _handleSkip() {
    // Navegar a la pantalla de Respect
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => RespectScreen(flavor: _currentFlavor)),
    );
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
    final progressBarHeight = screenHeight * 0.008;

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
                            "Documents",
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
                      borderRadius: BorderRadius.circular(progressBarHeight / 2),
                    ),
                                         child: FractionallySizedBox(
                       alignment: Alignment.centerLeft,
                       widthFactor: 1.0, // 100% completado - último paso
                       child: Container(
                        decoration: BoxDecoration(
                          color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                          borderRadius: BorderRadius.circular(progressBarHeight / 2),
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
                  
                  // Dropdown y botón Add License
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
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
                                  child: Text(
                                    _selectedCredential ?? "Select credential",
                                    style: GoogleFonts.poppins(
                                      fontSize: buttonFontSize,
                                      color: _selectedCredential != null ? Colors.black : Colors.grey[600],
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
                          onTap: _addLicense,
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
                  ...List.generate(_documents.length, (index) {
                    final document = _documents[index];
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
                                 onTap: () async => await _uploadDocument(index),
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
                                          "Upload ${document['type'].toString().toLowerCase()}",
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
                                                 if (document['uploaded'] == true) ...[
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
                                     'Tamaño: ${_formatFileSize(document['size'])}',
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
                  
                  const Spacer(),
                  
                  // Botón Continue
                  CustomButton(
                    text: "Continue",
                    onPressed: _handleContinue,
                    isLoading: false,
                    showShadow: false,
                  ),
                  
                  SizedBox(height: verticalSpacing),
                  
                  // Botón Skip
                  Center(
                    child: GestureDetector(
                      onTap: _handleSkip,
                      child: Text(
                        "Skip",
                        style: GoogleFonts.poppins(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
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
