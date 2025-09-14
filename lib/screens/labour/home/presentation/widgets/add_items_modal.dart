import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../../logic/controllers/create_invoice_controller.dart';

class AddItemsModal extends StatelessWidget {
  final AppFlavor? flavor;

  const AddItemsModal({
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
                      "Add items",
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
                  // Item Name field
                  Text(
                    "Item Name",
                    style: GoogleFonts.poppins(
                      fontSize: labelFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: verticalSpacing * 0.5),
                  CustomTextField(
                    controller: controller.itemNameController,
                    hintText: "Item name",
                    showBorder: true,
                  ),

                  SizedBox(height: verticalSpacing),

                  // Item Description field
                  Text(
                    "Item Description",
                    style: GoogleFonts.poppins(
                      fontSize: labelFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: verticalSpacing * 0.5),
                  CustomTextField(
                    controller: controller.itemDescriptionController,
                    hintText: "Item description",
                    showBorder: true,
                    maxLines: 3,
                  ),

                  SizedBox(height: verticalSpacing),

                  // Rate and Quantity row
                  Row(
                    children: [
                      // Rate field
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rate",
                              style: GoogleFonts.poppins(
                                fontSize: labelFontSize,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: verticalSpacing * 0.5),
                            CustomTextField(
                              controller: controller.itemRateController,
                              hintText: "\$0.00",
                              showBorder: true,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      // Quantity field
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Quantity",
                              style: GoogleFonts.poppins(
                                fontSize: labelFontSize,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: verticalSpacing * 0.5),
                            CustomTextField(
                              controller: controller.itemQuantityController,
                              hintText: "1.00",
                              showBorder: true,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: verticalSpacing * 2),
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
                controller.handleSaveItem();
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
}
