import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../../logic/controllers/edit_bank_details_no_payid_controller.dart';

class EditBankDetailsNoPayIdScreen extends StatelessWidget {
  static const String id = '/edit-bank-details-no-payid';
  
  final AppFlavor? flavor;

  const EditBankDetailsNoPayIdScreen({
    super.key,
    this.flavor,
  });

  AppFlavor get _currentFlavor => flavor ?? AppFlavorConfig.currentFlavor;

  @override
  Widget build(BuildContext context) {
    final EditBankDetailsNoPayIdController controller = Get.find<EditBankDetailsNoPayIdController>();
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
                              "Bank Account Details",
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

                    // Mensaje explicativo
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(horizontalPadding),
                      decoration: BoxDecoration(
                        color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)).withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                            size: screenWidth * 0.06,
                          ),
                          SizedBox(height: verticalSpacing * 0.5),
                          Text(
                            "Since you don't have a Pay ID, please provide your bank account details for payments.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: noteFontSize,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 3),

                    // Campo Account Name
                    Text(
                      "Account Name",
                      style: GoogleFonts.poppins(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing),
                    
                    CustomTextField(
                      controller: controller.accountNameController,
                      hintText: "Enter account holder name",
                      showBorder: true,
                    ),

                    SizedBox(height: verticalSpacing * 2),

                    // Campo BSB
                    Text(
                      "BSB",
                      style: GoogleFonts.poppins(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing),
                    
                    CustomTextField(
                      controller: controller.bsbController,
                      hintText: "Enter BSB (6 digits)",
                      showBorder: true,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                    ),

                    SizedBox(height: verticalSpacing * 2),

                    // Campo Account Number
                    Text(
                      "Account Number",
                      style: GoogleFonts.poppins(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing),
                    
                    CustomTextField(
                      controller: controller.accountNumberController,
                      hintText: "Enter account number",
                      showBorder: true,
                      keyboardType: TextInputType.number,
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
                      controller: controller.abnController,
                      hintText: "Enter ABN",
                      showBorder: true,
                      keyboardType: TextInputType.number,
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
                      child: Column(
                        children: [
                          Icon(
                            Icons.security,
                            color: Colors.grey[600],
                            size: screenWidth * 0.05,
                          ),
                          SizedBox(height: verticalSpacing * 0.5),
                          Text(
                            "IMPORTANT: Your bank details are encrypted and secure. Yakka Labour is not responsible for the payment only the company who hire you.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: noteFontSize,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom + verticalSpacing * 4),

                    // Botón Save
                    Obx(() => CustomButton(
                      text: "Save Bank Details",
                      onPressed: () => controller.handleSave(),
                      isLoading: controller.isLoading.value,
                      flavor: _currentFlavor,
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
