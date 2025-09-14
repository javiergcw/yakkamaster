import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../../logic/controllers/create_invoice_controller.dart';

class AddClientModal extends StatelessWidget {
  final AppFlavor? flavor;

  const AddClientModal({
    super.key,
    this.flavor,
  });

  @override
  Widget build(BuildContext context) {
    final CreateInvoiceController controller = Get.find<CreateInvoiceController>();
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final labelFontSize = screenWidth * 0.04;

    return Container(
      height: screenHeight * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header con botón de cerrar y título
          Container(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalSpacing),
            child: Row(
              children: [
                SizedBox(width: screenWidth * 0.06),
                Expanded(
                  child: Center(
                    child: Text(
                      "Bill to",
                      style: GoogleFonts.poppins(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.close,
                    color: Colors.black,
                    size: screenWidth * 0.06,
                  ),
                ),
              ],
            ),
          ),

          // Contenido del formulario
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Billing name field
                  Text(
                    "Billing name*",
                    style: GoogleFonts.poppins(
                      fontSize: labelFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: verticalSpacing * 0.5),
                  CustomTextField(
                    controller: controller.billingNameController,
                    hintText: "Enter billing name",
                    showBorder: true,
                  ),

                  SizedBox(height: verticalSpacing),

                  // Mobile field
                  Text(
                    "Mobile",
                    style: GoogleFonts.poppins(
                      fontSize: labelFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: verticalSpacing * 0.5),
                  CustomTextField(
                    controller: controller.mobileController,
                    hintText: "Enter mobile number",
                    showBorder: true,
                    keyboardType: TextInputType.phone,
                  ),

                  SizedBox(height: verticalSpacing),

                  // Email field with add button
                  Text(
                    "Email",
                    style: GoogleFonts.poppins(
                      fontSize: labelFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: verticalSpacing * 0.5),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: controller.emailController,
                          hintText: "Enter email address",
                          showBorder: true,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      GestureDetector(
                        onTap: controller.handleAddEmail,
                        child: Container(
                          width: screenWidth * 0.12,
                          height: screenWidth * 0.12,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.grey[600],
                            size: screenWidth * 0.05,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Lista de emails agregados
                  Obx(() => controller.emailList.isNotEmpty
                      ? Column(
                          children: [
                            SizedBox(height: verticalSpacing),
                            ...controller.emailList.asMap().entries.map((entry) {
                              final index = entry.key;
                              final email = entry.value;
                              return Container(
                                margin: EdgeInsets.only(bottom: verticalSpacing * 0.5),
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04,
                                  vertical: verticalSpacing * 0.5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        email,
                                        style: GoogleFonts.poppins(
                                          fontSize: labelFontSize * 0.9,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => controller.handleRemoveEmail(index),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.grey[600],
                                        size: screenWidth * 0.04,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        )
                      : const SizedBox.shrink()),

                  SizedBox(height: verticalSpacing),

                  // Billing address field with dropdown
                  Text(
                    "Billing address",
                    style: GoogleFonts.poppins(
                      fontSize: labelFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: verticalSpacing * 0.5),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _showAddressDropdown(context, controller, screenWidth, verticalSpacing, labelFontSize),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: verticalSpacing * 0.8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Obx(() => Text(
                              controller.selectedAddress.value.isEmpty 
                                  ? "Select or enter address"
                                  : controller.selectedAddress.value,
                              style: GoogleFonts.poppins(
                                fontSize: labelFontSize * 0.9,
                                color: controller.selectedAddress.value.isEmpty 
                                    ? Colors.grey[600] 
                                    : Colors.black,
                              ),
                            )),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      GestureDetector(
                        onTap: () => _showAddressDropdown(context, controller, screenWidth, verticalSpacing, labelFontSize),
                        child: Container(
                          width: screenWidth * 0.12,
                          height: screenWidth * 0.12,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey[600],
                            size: screenWidth * 0.05,
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

          // Botón Save
          Container(
            padding: EdgeInsets.all(horizontalPadding),
            child: CustomButton(
              text: "Save",
              onPressed: () {
                controller.handleSaveClient();
                Get.back();
              },
              flavor: flavor ?? AppFlavorConfig.currentFlavor,
              showShadow: false,
            ),
          ),

          SizedBox(height: verticalSpacing * 0.5),
        ],
      ),
    );
  }

  void _showAddressDropdown(BuildContext context, CreateInvoiceController controller, double screenWidth, double verticalSpacing, double labelFontSize) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06, vertical: verticalSpacing),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Select Address",
                      style: GoogleFonts.poppins(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                      size: screenWidth * 0.06,
                    ),
                  ),
                ],
              ),
            ),
            
            // Campo para agregar nueva dirección
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: controller.billingAddressController,
                      hintText: "Enter new address",
                      showBorder: true,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  GestureDetector(
                    onTap: () {
                      controller.handleAddNewAddress();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: screenWidth * 0.12,
                      height: screenWidth * 0.12,
                      decoration: BoxDecoration(
                        color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: screenWidth * 0.05,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: verticalSpacing),
            
            // Lista de direcciones guardadas
            Expanded(
              child: Obx(() => controller.addressList.isEmpty
                  ? Center(
                      child: Text(
                        "No saved addresses",
                        style: GoogleFonts.poppins(
                          fontSize: labelFontSize * 0.9,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                      itemCount: controller.addressList.length,
                      itemBuilder: (context, index) {
                        final address = controller.addressList[index];
                        return ListTile(
                          title: Text(
                            address,
                            style: GoogleFonts.poppins(
                              fontSize: labelFontSize * 0.9,
                              color: Colors.black87,
                            ),
                          ),
                          onTap: () {
                            controller.handleSelectAddress(address);
                            Navigator.pop(context);
                          },
                        );
                      },
                    )),
            ),
          ],
        ),
      ),
    );
  }
}
