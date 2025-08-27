import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../../logic/controllers/builder_profile_controller.dart';

class CompanyDetailsScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const CompanyDetailsScreen({
    super.key,
    this.flavor,
  });

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  
  // GetX Controller
  final BuilderProfileController _controller = Get.find<BuilderProfileController>();
  
  // Controllers para los campos de texto
  final TextEditingController _companyAddressController = TextEditingController();
  final TextEditingController _companyPhoneController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  // Lista de industrias disponibles
  final List<String> _industries = [
    'Construction',
    'Renovation',
    'Plumbing',
    'Electrical',
    'HVAC',
    'Landscaping',
    'Roofing',
    'Painting',
    'Carpentry',
    'General Contracting',
    'Other'
  ];
  
  // Lista de tamaños de empresa
  final List<String> _companySizes = [
    '1-10 employees',
    '11-50 employees',
    '51-200 employees',
    '201-500 employees',
    '500+ employees'
  ];

  // Sombras tipo tarjeta
  final List<BoxShadow> strongCardShadows = const [
    BoxShadow(
      color: Color(0xFF000000),
      offset: Offset(6, 8),
      blurRadius: 0,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0xFF000000),
      offset: Offset(0, 18),
      blurRadius: 28,
      spreadRadius: 0,
    ),
  ];

  @override
  void dispose() {
    _companyAddressController.dispose();
    _companyPhoneController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleNext() async {
    // Actualizar el controlador con los valores de los campos
    _controller.updateCompanyAddress(_companyAddressController.text);
    _controller.updateCompanyPhone(_companyPhoneController.text);
    _controller.updateWebsite(_websiteController.text);
    _controller.updateDescription(_descriptionController.text);
    
    // Validar campos requeridos usando el controlador
    if (!_controller.isProfileValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_controller.validationErrors.join(', ')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Guardar el perfil usando el controlador
    final success = await _controller.saveProfile();
    
    if (success) {
      // Navegar de vuelta a la pantalla principal o al dashboard del builder
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> options,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            hint: Text(
              'Select $label',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(
                  option,
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
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
                              "Company Details",
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

                    // Dropdown de industria
                    Obx(() => _buildDropdownField(
                      label: 'Industry',
                      value: _controller.profile.industry,
                      options: _industries,
                      onChanged: (value) {
                        if (value != null) {
                          _controller.updateIndustry(value);
                        }
                      },
                    )),

                    SizedBox(height: verticalSpacing * 2),

                    // Dropdown de tamaño de empresa
                    Obx(() => _buildDropdownField(
                      label: 'Company Size',
                      value: _controller.profile.companySize,
                      options: _companySizes,
                      onChanged: (value) {
                        if (value != null) {
                          _controller.updateCompanySize(value);
                        }
                      },
                    )),

                    SizedBox(height: verticalSpacing * 2),

                    // Campo de dirección de la empresa
                    CustomTextField(
                      controller: _companyAddressController,
                      hintText: "Company Address",
                      showBorder: true,
                    ),

                    SizedBox(height: verticalSpacing * 1.5),

                    // Campo de teléfono de la empresa
                    CustomTextField(
                      controller: _companyPhoneController,
                      hintText: "Company Phone (Optional)",
                      showBorder: true,
                    ),

                    SizedBox(height: verticalSpacing * 1.5),

                    // Campo de sitio web
                    CustomTextField(
                      controller: _websiteController,
                      hintText: "Website (Optional)",
                      showBorder: true,
                    ),

                    SizedBox(height: verticalSpacing * 1.5),

                    // Campo de descripción
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Company Description",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _descriptionController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: "Tell us about your company...",
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom + verticalSpacing * 3),

                    // Botón Next con sombra personalizada
                    Obx(() => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: strongCardShadows,
                      ),
                      child: CustomButton(
                        text: "Create Profile",
                        onPressed: _controller.isSaving ? null : _handleNext,
                        isLoading: _controller.isSaving,
                      ),
                    )),

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
