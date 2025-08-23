import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/app_flavor.dart';
import '../../../../config/assets_config.dart';
import '../../../../features/widgets/custom_button.dart';
import '../../../../features/widgets/custom_text_field.dart';
import '../../../../features/widgets/phone_input.dart';
import 'documents_screen.dart';

class PreviousEmployerScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const PreviousEmployerScreen({
    super.key,
    this.flavor,
  });

  @override
  State<PreviousEmployerScreen> createState() => _PreviousEmployerScreenState();
}

class _PreviousEmployerScreenState extends State<PreviousEmployerScreen> {
  Map<String, String>? _firstSupervisor;
  Map<String, String>? _secondSupervisor;

  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;

  void _showEditSupervisorModal(bool isFirstSupervisor) {
    final mediaQuery = MediaQuery.of(context);
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
    final supervisor = isFirstSupervisor ? _firstSupervisor : _secondSupervisor;
    
    // Controllers para el modal con datos existentes
    final nameController = TextEditingController(text: supervisor!['name']);
    final companyController = TextEditingController(text: supervisor['company']);
    final phoneController = TextEditingController(text: supervisor['phone']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
                style: GoogleFonts.poppins(
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
                      style: GoogleFonts.poppins(
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
                      child: CustomTextField(
                        controller: nameController,
                        hintText: "Enter Name Contact",
                        showBorder: false,
                        flavor: _currentFlavor,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 2),
                    
                    // Campo Company Type
                    Text(
                      "Company Type",
                      style: GoogleFonts.poppins(
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
                      child: CustomTextField(
                        controller: companyController,
                        hintText: "Enter Company Name",
                        showBorder: false,
                        flavor: _currentFlavor,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 2),
                    
                    // Campo Phone Number
                    Text(
                      "Phone Number",
                      style: GoogleFonts.poppins(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: verticalSpacing * 0.5),
                    PhoneInput(
                      controller: phoneController,
                      flavor: _currentFlavor,
                    ),
                    
                    const Spacer(),
                    
                    // Botones EXIT y SAVE
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'EXIT',
                                style: GoogleFonts.poppins(
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
                              color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (nameController.text.trim().isNotEmpty &&
                                    companyController.text.trim().isNotEmpty &&
                                    phoneController.text.trim().isNotEmpty) {
                                  setState(() {
                                    if (isFirstSupervisor) {
                                      _firstSupervisor = {
                                        'name': nameController.text.trim(),
                                        'company': companyController.text.trim(),
                                        'phone': phoneController.text.trim(),
                                      };
                                    } else {
                                      _secondSupervisor = {
                                        'name': nameController.text.trim(),
                                        'company': companyController.text.trim(),
                                        'phone': phoneController.text.trim(),
                                      };
                                    }
                                  });
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Supervisor actualizado exitosamente'),
                                      backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Por favor completa todos los campos'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'SAVE',
                                style: GoogleFonts.poppins(
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
    );
  }

  void _showAddSupervisorModal(bool isFirstSupervisor) {
    final mediaQuery = MediaQuery.of(context);
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
                style: GoogleFonts.poppins(
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
                      style: GoogleFonts.poppins(
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
                      child: CustomTextField(
                        controller: nameController,
                        hintText: "Enter Name Contact",
                        showBorder: false,
                        flavor: _currentFlavor,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 2),
                    
                    // Campo Company Type
                    Text(
                      "Company Type",
                      style: GoogleFonts.poppins(
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
                      child: CustomTextField(
                        controller: companyController,
                        hintText: "Enter Company Name",
                        showBorder: false,
                        flavor: _currentFlavor,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 2),
                    
                    // Campo Phone Number
                    Text(
                      "Phone Number",
                      style: GoogleFonts.poppins(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: verticalSpacing * 0.5),
                    PhoneInput(
                      controller: phoneController,
                      flavor: _currentFlavor,
                    ),
                    
                    const Spacer(),
                    
                    // Botones EXIT y SAVE
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'EXIT',
                                style: GoogleFonts.poppins(
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
                              color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (nameController.text.trim().isNotEmpty &&
                                    companyController.text.trim().isNotEmpty &&
                                    phoneController.text.trim().isNotEmpty) {
                                  setState(() {
                                    if (isFirstSupervisor) {
                                      _firstSupervisor = {
                                        'name': nameController.text.trim(),
                                        'company': companyController.text.trim(),
                                        'phone': phoneController.text.trim(),
                                      };
                                    } else {
                                      _secondSupervisor = {
                                        'name': nameController.text.trim(),
                                        'company': companyController.text.trim(),
                                        'phone': phoneController.text.trim(),
                                      };
                                    }
                                  });
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Supervisor agregado exitosamente'),
                                      backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Por favor completa todos los campos'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'SAVE',
                                style: GoogleFonts.poppins(
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
    );
  }

  void _handleContinue() {
    // Navegar al siguiente paso del stepper
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Información de empleador anterior guardada!'),
        backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
      ),
    );
    
    // Navegar a la pantalla de Documents
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => DocumentsScreen(flavor: _currentFlavor)),
    );
  }

  void _showDeleteConfirmationDialog(bool isFirstSupervisor) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final titleFontSize = screenWidth * 0.045;
    final buttonFontSize = screenWidth * 0.035;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Eliminar Supervisor',
            style: GoogleFonts.poppins(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          content: Text(
            '¿Estás seguro de que quieres eliminar este supervisor? Esta acción no se puede deshacer.',
            style: GoogleFonts.poppins(
              fontSize: buttonFontSize,
              color: Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: GoogleFonts.poppins(
                  fontSize: buttonFontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (isFirstSupervisor) {
                    _firstSupervisor = null;
                  } else {
                    _secondSupervisor = null;
                  }
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Supervisor eliminado exitosamente'),
                    backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                  ),
                );
              },
              child: Text(
                'Eliminar',
                style: GoogleFonts.poppins(
                  fontSize: buttonFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.red[600],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleSkip() {
    // Navegar al siguiente paso del stepper sin agregar supervisores
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Paso omitido - continuando...'),
        backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
      ),
    );
    
    // Aquí irías al siguiente paso del stepper
    // Navigator.of(context).push(
    //   MaterialPageRoute(builder: (context) => NextStepScreen(flavor: _currentFlavor)),
    // );
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
    final instructionFontSize = screenWidth * 0.038;
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
                            "Previous employer",
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
                  
                  // Barra de progreso (aproximadamente 50% completado)
                  Container(
                    width: double.infinity,
                    height: progressBarHeight,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(progressBarHeight / 2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.5, // 50% completado
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                          borderRadius: BorderRadius.circular(progressBarHeight / 2),
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing * 3),
                  
                  // Texto instructivo
                  Text(
                    "Please provide the contact information for your previous supervisor or employer. Our team will get in touch with them to verify your work experience. Avoid listing friends as references.",
                    style: GoogleFonts.poppins(
                      fontSize: instructionFontSize,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing * 2),
                  
                  // Primer Supervisor
                  if (_firstSupervisor == null) ...[
                    // Botón Add Supervisor
                    GestureDetector(
                      onTap: () => _showAddSupervisorModal(true),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: verticalSpacing * 1.5,
                        ),
                        decoration: BoxDecoration(
                          color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_add,
                              color: Colors.black,
                              size: screenWidth * 0.06,
                            ),
                            SizedBox(width: horizontalPadding * 0.5),
                            Expanded(
                              child: Text(
                                "Add Supervisor",
                                style: GoogleFonts.poppins(
                                  fontSize: buttonFontSize,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                              size: screenWidth * 0.05,
                            ),
                          ],
                        ),
                      ),
                    ),
                                     ] else ...[
                     // Mostrar solo el nombre del primer supervisor guardado con opción de eliminar
                     Container(
                       width: double.infinity,
                       padding: EdgeInsets.symmetric(
                         horizontal: horizontalPadding,
                         vertical: verticalSpacing * 1.5,
                       ),
                       decoration: BoxDecoration(
                         color: Colors.grey[100],
                         borderRadius: BorderRadius.circular(12),
                         border: Border.all(color: Colors.grey[300]!),
                       ),
                       child: Row(
                         children: [
                           Expanded(
                             child: GestureDetector(
                               onTap: () => _showEditSupervisorModal(true),
                               child: Row(
                                 children: [
                                   Icon(
                                     Icons.person,
                                     color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                     size: screenWidth * 0.05,
                                   ),
                                   SizedBox(width: horizontalPadding * 0.5),
                                   Expanded(
                                     child: Text(
                                       _firstSupervisor!['name']!,
                                       style: GoogleFonts.poppins(
                                         fontSize: buttonFontSize,
                                         fontWeight: FontWeight.w600,
                                         color: Colors.black,
                                       ),
                                     ),
                                   ),
                                   Icon(
                                     Icons.edit,
                                     color: Colors.grey[600],
                                     size: screenWidth * 0.045,
                                   ),
                                 ],
                               ),
                             ),
                           ),
                           SizedBox(width: horizontalPadding * 0.5),
                           GestureDetector(
                             onTap: () => _showDeleteConfirmationDialog(true),
                             child: Container(
                               padding: EdgeInsets.all(8),
                               decoration: BoxDecoration(
                                 color: Colors.red[100],
                                 borderRadius: BorderRadius.circular(8),
                               ),
                               child: Icon(
                                 Icons.delete,
                                 color: Colors.red[600],
                                 size: screenWidth * 0.045,
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                   ],
                  
                  SizedBox(height: verticalSpacing * 2),
                  
                                     // Texto instructivo adicional (siempre visible)
                   Text(
                     "Please provide a second reference in case we are unable to contact the first one.",
                     style: GoogleFonts.poppins(
                       fontSize: instructionFontSize,
                       color: Colors.black54,
                       height: 1.4,
                     ),
                   ),
                   
                   SizedBox(height: verticalSpacing * 2),
                   
                   // Segundo Supervisor
                   if (_secondSupervisor == null) ...[
                     // Segundo botón Add Supervisor
                     GestureDetector(
                       onTap: () => _showAddSupervisorModal(false),
                       child: Container(
                         width: double.infinity,
                         padding: EdgeInsets.symmetric(
                           horizontal: horizontalPadding,
                           vertical: verticalSpacing * 1.5,
                         ),
                         decoration: BoxDecoration(
                           color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                           borderRadius: BorderRadius.circular(12),
                           boxShadow: [
                             BoxShadow(
                               color: Colors.grey.withOpacity(0.3),
                               blurRadius: 8,
                               offset: const Offset(0, 4),
                             ),
                           ],
                         ),
                         child: Row(
                           children: [
                             Icon(
                               Icons.person_add,
                               color: Colors.black,
                               size: screenWidth * 0.06,
                             ),
                             SizedBox(width: horizontalPadding * 0.5),
                             Expanded(
                               child: Text(
                                 "Add Supervisor",
                                 style: GoogleFonts.poppins(
                                   fontSize: buttonFontSize,
                                   fontWeight: FontWeight.w600,
                                   color: Colors.black,
                                 ),
                               ),
                             ),
                             Icon(
                               Icons.arrow_forward_ios,
                               color: Colors.black,
                               size: screenWidth * 0.05,
                             ),
                           ],
                         ),
                       ),
                     ),
                   ] else ...[
                     // Mostrar solo el nombre del segundo supervisor guardado con opción de eliminar
                     Container(
                       width: double.infinity,
                       padding: EdgeInsets.symmetric(
                         horizontal: horizontalPadding,
                         vertical: verticalSpacing * 1.5,
                       ),
                       decoration: BoxDecoration(
                         color: Colors.grey[100],
                         borderRadius: BorderRadius.circular(12),
                         border: Border.all(color: Colors.grey[300]!),
                       ),
                       child: Row(
                         children: [
                           Expanded(
                             child: GestureDetector(
                               onTap: () => _showEditSupervisorModal(false),
                               child: Row(
                                 children: [
                                   Icon(
                                     Icons.person,
                                     color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                     size: screenWidth * 0.05,
                                   ),
                                   SizedBox(width: horizontalPadding * 0.5),
                                   Expanded(
                                     child: Text(
                                       _secondSupervisor!['name']!,
                                       style: GoogleFonts.poppins(
                                         fontSize: buttonFontSize,
                                         fontWeight: FontWeight.w600,
                                         color: Colors.black,
                                       ),
                                     ),
                                   ),
                                   Icon(
                                     Icons.edit,
                                     color: Colors.grey[600],
                                     size: screenWidth * 0.045,
                                   ),
                                 ],
                               ),
                             ),
                           ),
                           SizedBox(width: horizontalPadding * 0.5),
                           GestureDetector(
                             onTap: () => _showDeleteConfirmationDialog(false),
                             child: Container(
                               padding: EdgeInsets.all(8),
                               decoration: BoxDecoration(
                                 color: Colors.red[100],
                                 borderRadius: BorderRadius.circular(8),
                               ),
                               child: Icon(
                                 Icons.delete,
                                 color: Colors.red[600],
                                 size: screenWidth * 0.045,
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                   ],
                  
                  const Spacer(),
                  
                  // Botón Continue
                  CustomButton(
                    text: "Continue",
                    onPressed: _handleContinue,
                    isLoading: false,
                    flavor: _currentFlavor,
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
