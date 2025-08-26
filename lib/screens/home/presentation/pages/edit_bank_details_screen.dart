import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/app_flavor.dart';
import '../../../../config/assets_config.dart';
import '../../../../features/widgets/custom_button.dart';
import '../../../../features/widgets/custom_text_field.dart';
import 'edit_bank_details_no_payid_screen.dart';

/*
 * CONFIGURACIÓN DE VERIFICACIÓN BANCARIA:
 * 
 * Para activar/desactivar el comportamiento de verificación de datos bancarios:
 * - Cambiar _enableBankVerification a true: Cuando el usuario marca "I don't have a Pay ID",
 *   será redirigido a la pantalla de detalles bancarios tradicionales (BSB, Account Number, etc.)
 * - Cambiar _enableBankVerification a false: El comportamiento normal se mantiene sin redirección
 */

class EditBankDetailsScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const EditBankDetailsScreen({
    super.key,
    this.flavor,
  });

  @override
  State<EditBankDetailsScreen> createState() => _EditBankDetailsScreenState();
}

class _EditBankDetailsScreenState extends State<EditBankDetailsScreen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  
  // Controllers para los campos de texto
  final TextEditingController _abnController = TextEditingController(text: '12345678901');
  final TextEditingController _payIdController = TextEditingController(text: 'test@example.com');
  
  // Variables para el estado
  String _selectedPayIdType = 'EMAIL';
  bool _dontHavePayId = false; // Cambiar a false para que el campo Pay ID esté habilitado por defecto
  
  // Variable para activar/desactivar el comportamiento de verificación
  static const bool _enableBankVerification = true; // Cambiar a false para desactivar
  
  final List<String> _payIdTypes = [
    'EMAIL',
    'PHONE',
    'ABN',
    'ORGANISATION_ID'
  ];

  @override
  void initState() {
    super.initState();
    
    // Agregar listeners para actualizar el estado en tiempo real
    _abnController.addListener(() {
      setState(() {});
    });
    
    _payIdController.addListener(() {
      setState(() {});
    });
  }

  void _showPayIdTypeDropdown() {
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
                'Select Pay ID Type',
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
                itemCount: _payIdTypes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _payIdTypes[index],
                      style: GoogleFonts.poppins(
                        fontSize: itemFontSize,
                        color: Colors.black87,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedPayIdType = _payIdTypes[index];
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

  // Función para verificar si el usuario tiene datos bancarios configurados
  bool _hasBankDetails() {
    return _abnController.text.isNotEmpty && 
           (!_dontHavePayId ? _payIdController.text.isNotEmpty : true);
  }

  void _handleSave() {
    // Validar campos requeridos
    if (_abnController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your ABN'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    if (!_dontHavePayId && _payIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your Pay ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Verificar si el usuario no tiene Pay ID y la verificación está habilitada
    if (_dontHavePayId && _enableBankVerification) {
      // Navegar a la pantalla de detalles bancarios tradicionales
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EditBankDetailsNoPayIdScreen(
            flavor: _currentFlavor,
          ),
        ),
      );
      return;
    }
    
    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Bank details updated successfully'),
        backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
        duration: const Duration(seconds: 2),
      ),
    );
    
    // Navegar de vuelta
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _abnController.removeListener(() {});
    _payIdController.removeListener(() {});
    _abnController.dispose();
    _payIdController.dispose();
    super.dispose();
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

                    SizedBox(height: verticalSpacing * 3),

                    // Indicador de estado de datos bancarios
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(horizontalPadding * 0.8),
                      decoration: BoxDecoration(
                        color: _hasBankDetails() 
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _hasBankDetails() 
                            ? Colors.green.withOpacity(0.3)
                            : Colors.orange.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _hasBankDetails() ? Icons.check_circle : Icons.warning,
                            color: _hasBankDetails() ? Colors.green : Colors.orange,
                            size: screenWidth * 0.05,
                          ),
                          SizedBox(width: horizontalPadding * 0.5),
                          Expanded(
                            child: Text(
                              _hasBankDetails() 
                                ? 'Bank details are configured'
                                : 'Bank details need to be configured',
                              style: GoogleFonts.poppins(
                                fontSize: noteFontSize,
                                fontWeight: FontWeight.w500,
                                color: _hasBankDetails() ? Colors.green[700] : Colors.orange[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 2),

                    // Campo ABN
                    Text(
                      "ABN",
                      style: GoogleFonts.poppins(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing),
                    
                    CustomTextField(
                      controller: _abnController,
                      hintText: "Enter ABN",
                      showBorder: true,
                    ),

                    SizedBox(height: verticalSpacing * 2),

                    // Campo Pay ID Type
                    Text(
                      "Pay ID Type",
                      style: GoogleFonts.poppins(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing),
                    
                    GestureDetector(
                      onTap: _showPayIdTypeDropdown,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding * 0.8,
                          vertical: verticalSpacing * 1.2,
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
                                _selectedPayIdType,
                                style: GoogleFonts.poppins(
                                  fontSize: labelFontSize,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
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

                    SizedBox(height: verticalSpacing * 2),

                    // Campo Pay ID
                    Text(
                      "Pay ID",
                      style: GoogleFonts.poppins(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing),
                    
                    CustomTextField(
                      controller: _payIdController,
                      hintText: "Enter Pay ID",
                      showBorder: true,
                      enabled: !_dontHavePayId,
                    ),

                    SizedBox(height: verticalSpacing * 1.5),

                    // Checkbox "I don't have a Pay ID"
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _dontHavePayId = !_dontHavePayId;
                              if (_dontHavePayId) {
                                _payIdController.clear();
                              }
                            });
                          },
                          child: Container(
                            width: screenWidth * 0.05,
                            height: screenWidth * 0.05,
                            decoration: BoxDecoration(
                              color: _dontHavePayId ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)) : Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: _dontHavePayId ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)) : Colors.grey[400]!,
                                width: 2,
                              ),
                            ),
                            child: _dontHavePayId
                                ? Icon(
                                    Icons.check,
                                    size: screenWidth * 0.035,
                                    color: Colors.black,
                                  )
                                : null,
                          ),
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

                    SizedBox(height: verticalSpacing * 3),

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
      ),
    );
  }
}
