import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../logic/controllers/register_company_controller.dart';

class RegisterNewCompanyScreen extends StatelessWidget {
  static const String id = '/register-new-company';
  
  RegisterNewCompanyScreen({super.key});

  final RegisterCompanyController controller = Get.put(RegisterCompanyController());

  @override
  Widget build(BuildContext context) {
    
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;

    return Obx(() => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: screenWidth * 0.06,
          ),
        ),
        title: Text(
          "Add Company",
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.055,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: verticalSpacing),
                      
                      // Company or Sole Trader name (Required)
                      _buildTextField(
                        controller: controller.companyNameController,
                        label: "Company or Sole Trader name*",
                        hint: "Enter Name",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter company or sole trader name';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: verticalSpacing * 0.5),
                      
                      // Address (Optional)
                      _buildTextField(
                        controller: controller.addressController,
                        label: "Address (OPTIONAL)",
                        hint: "Enter Address",
                        validator: null, // Optional field
                      ),
                      
                      SizedBox(height: verticalSpacing * 0.5),
                      
                      // ABN (Required) with link
                      _buildTextField(
                        controller: controller.abnController,
                        label: "ABN*",
                        hint: "Enter ABN",
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter ABN';
                          }
                          if (value.length != 11) {
                            return 'ABN must be 11 digits';
                          }
                          return null;
                        },
                      ),
                      
                      // How to get your ABN link
                      Padding(
                        padding: EdgeInsets.only(top: screenWidth * 0.02),
                        child: GestureDetector(
                          onTap: () {
                            // TODO: Implement ABN help functionality
                            print('How to get your ABN? tapped');
                          },
                          child: Text(
                            "How to get your ABN?",
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.035,
                              color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: verticalSpacing * 0.5),
                      
                      // Category (Optional) - Dropdown
                      _buildDropdownField(
                        label: "Category (OPTIONAL)",
                        hint: "Selected category",
                        value: controller.selectedCategory.value,
                        items: controller.categories,
                        onChanged: controller.selectCategory,
                      ),
                      
                      SizedBox(height: verticalSpacing * 0.5),
                      
                      // Company Website (Optional)
                      _buildTextField(
                        controller: controller.websiteController,
                        label: "Company Website (OPTIONAL)",
                        hint: "Enter website",
                        keyboardType: TextInputType.url,
                        validator: null, // Optional field
                      ),
                      
                      SizedBox(height: verticalSpacing * 0.5),
                      
                      // Brief description (Optional)
                      _buildTextField(
                        controller: controller.descriptionController,
                        label: "Brief description (OPTIONAL)",
                        hint: "Enter brief description",
                        maxLines: 3,
                        validator: null, // Optional field
                      ),
                      
                      SizedBox(height: verticalSpacing * 0.5),
                      
                      // Upload logo (Optional)
                      _buildUploadLogoSection(screenWidth),
                      
                      SizedBox(height: verticalSpacing),
                    ],
                  ),
                ),
              ),

              // Submit Button
              Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: "Submit",
                    onPressed: () {
                      print('Submit button pressed');
                      controller.handleSubmit();
                    },
                    type: ButtonType.primary,
                    flavor: controller.currentFlavor.value,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    final screenWidth = MediaQuery.of(Get.context!).size.width;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: screenWidth * 0.015),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[500],
            ),
            filled: true,
            fillColor: Colors.grey[50],
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
              borderSide: BorderSide(
                color: Color(AppFlavorConfig.getPrimaryColor(this.controller.currentFlavor.value)),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red[300]!),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red[500]!),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenWidth * 0.035,
            ),
          ),
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.035,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    final screenWidth = MediaQuery.of(Get.context!).size.width;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: screenWidth * 0.015),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                fontSize: screenWidth * 0.035,
                color: Colors.grey[500],
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenWidth * 0.035,
              ),
            ),
            items: items.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(
                  category,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    color: Colors.black,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.035,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadLogoSection(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Upload logo (Optional)",
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: screenWidth * 0.015),
        
        // Mostrar imagen seleccionada si existe
        Obx(() => controller.logoImage.value != null ? Container(
          width: double.infinity,
          height: screenWidth * 0.3,
          margin: EdgeInsets.only(bottom: screenWidth * 0.02),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              controller.logoImage.value!,
              fit: BoxFit.cover,
            ),
          ),
        ) : const SizedBox.shrink()),
        
        GestureDetector(
          onTap: controller.showImageSourceDialog,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.blue[300]!,
                width: 1,
              ),
            ),
            child: Obx(() => Text(
              controller.logoImage.value != null ? "Change logo" : "Upload logo",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            )),
          ),
        ),
      ],
    );
  }
}
