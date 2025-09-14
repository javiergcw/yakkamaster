import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../logic/controllers/create_invoice_controller.dart';

class InvoicePreviewScreen extends StatelessWidget {
  static const String id = '/labour/invoice-preview';
  
  final AppFlavor? flavor;

  const InvoicePreviewScreen({
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
    final bodyFontSize = screenWidth * 0.035;
    final labelFontSize = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header con botón de retroceso y título
            Container(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
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
                        "Create Invoice",
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
            ),

            // Contenido principal
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: verticalSpacing * 0.5),

                    // Invoice Details Section
                    _buildInvoiceDetailsSection(controller, screenWidth, verticalSpacing, bodyFontSize, labelFontSize, titleFontSize),
                    
                    SizedBox(height: verticalSpacing),

                    // Invoice Preview Section
                    _buildInvoicePreviewSection(controller, screenWidth, screenHeight, verticalSpacing, bodyFontSize, labelFontSize),
                    
                    SizedBox(height: verticalSpacing),

                    // Financial Summary Section
                    _buildFinancialSummarySection(controller, screenWidth, verticalSpacing, bodyFontSize, labelFontSize, titleFontSize),
                    
                    SizedBox(height: verticalSpacing),

                    // Action Buttons Section
                    _buildActionButtonsSection(controller, screenWidth, verticalSpacing, bodyFontSize, labelFontSize),
                    
                    SizedBox(height: verticalSpacing),

                    // Additional Options Section
                    _buildAdditionalOptionsSection(controller, screenWidth, verticalSpacing, bodyFontSize, labelFontSize),
                    
                    SizedBox(height: verticalSpacing),

                    // Delete Button
                    _buildDeleteButton(controller, screenWidth, verticalSpacing, bodyFontSize, labelFontSize),
                    
                    SizedBox(height: verticalSpacing * 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceDetailsSection(CreateInvoiceController controller, double screenWidth, double verticalSpacing, double bodyFontSize, double labelFontSize, double titleFontSize) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Text(
                controller.invoiceName.value,
                style: GoogleFonts.poppins(
                  fontSize: titleFontSize * 1.2,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              )),
              SizedBox(height: verticalSpacing * 0.3),
              Text(
                controller.selectedClient.value.isNotEmpty ? controller.selectedClient.value : "Client name",
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            "Edit",
            style: GoogleFonts.poppins(
              fontSize: bodyFontSize,
              color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInvoicePreviewSection(CreateInvoiceController controller, double screenWidth, double screenHeight, double verticalSpacing, double bodyFontSize, double labelFontSize) {
    return Container(
      width: double.infinity,
      height: screenHeight * 0.4,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Stack(
        children: [
          // Preview content placeholder
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long,
                  size: screenWidth * 0.15,
                  color: Colors.grey[400],
                ),
                SizedBox(height: verticalSpacing),
                Text(
                  "Invoice Preview",
                  style: GoogleFonts.poppins(
                    fontSize: labelFontSize,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Preview button overlay
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: verticalSpacing * 2, vertical: verticalSpacing),
              decoration: BoxDecoration(
                color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.visibility,
                    color: Colors.white,
                    size: screenWidth * 0.05,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    "Preview",
                    style: GoogleFonts.poppins(
                      fontSize: bodyFontSize,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSummarySection(CreateInvoiceController controller, double screenWidth, double verticalSpacing, double bodyFontSize, double labelFontSize, double titleFontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Total",
          style: GoogleFonts.poppins(
            fontSize: bodyFontSize,
            color: Colors.black,
          ),
        ),
        SizedBox(height: verticalSpacing * 0.02),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "\$${controller.total.value.toStringAsFixed(2)}",
                    style: GoogleFonts.poppins(
                      fontSize: titleFontSize * 1.1,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: verticalSpacing * 0.1),
                  Text(
                    controller.selectedDueDate.value.isNotEmpty ? "Due ${controller.selectedDueDate.value}" : "Due Today",
                    style: GoogleFonts.poppins(
                      fontSize: bodyFontSize,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: screenWidth * 0.05),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Sent/Unsent tag
                Obx(() => Container(
                  width: screenWidth * 0.25,
                  padding: EdgeInsets.symmetric(horizontal: verticalSpacing * 0.6, vertical: verticalSpacing * 0.2),
                  decoration: BoxDecoration(
                    color: controller.isSent.value ? Colors.green : Colors.grey[200],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        controller.isSent.value ? Icons.check_circle : Icons.info_outline,
                        size: screenWidth * 0.04,
                        color: controller.isSent.value ? Colors.white : Colors.grey[600],
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        controller.isSent.value ? "Sent" : "Unsent",
                        style: GoogleFonts.poppins(
                          fontSize: bodyFontSize * 0.9,
                          color: controller.isSent.value ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )),
                SizedBox(height: verticalSpacing * 0.1),
                // Paid/Unpaid tag
                Obx(() => Container(
                  width: screenWidth * 0.25,
                  padding: EdgeInsets.symmetric(horizontal: verticalSpacing * 0.6, vertical: verticalSpacing * 0.2),
                  decoration: BoxDecoration(
                    color: controller.isPaid.value ? Colors.green : Colors.grey[200],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        controller.isPaid.value ? Icons.check_circle : Icons.info_outline,
                        size: screenWidth * 0.04,
                        color: controller.isPaid.value ? Colors.white : Colors.grey[600],
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        controller.isPaid.value ? "Paid" : "Unpaid",
                        style: GoogleFonts.poppins(
                          fontSize: bodyFontSize * 0.9,
                          color: controller.isPaid.value ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtonsSection(CreateInvoiceController controller, double screenWidth, double verticalSpacing, double bodyFontSize, double labelFontSize) {
    return Column(
      children: [
        // Send reminder button
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: "Send reminder",
            onPressed: () => _handleSendReminder(controller),
            flavor: controller.currentFlavor.value,
            showShadow: false,
          ),
        ),
        SizedBox(height: verticalSpacing),
        // Mark as paid button
        SizedBox(
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              onPressed: () => _handleMarkAsPaid(controller),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: verticalSpacing),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Mark as paid",
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalOptionsSection(CreateInvoiceController controller, double screenWidth, double verticalSpacing, double bodyFontSize, double labelFontSize) {
    return Column(
      children: [
        _buildOptionTile(
          icon: Icons.download,
          title: "Export as .PDF",
          onTap: () => _handleExportPDF(controller),
          screenWidth: screenWidth,
          verticalSpacing: verticalSpacing,
          bodyFontSize: bodyFontSize,
        ),
        SizedBox(height: verticalSpacing * 0.5),
        _buildDivider(),
        SizedBox(height: verticalSpacing * 0.5),
        _buildOptionTile(
          icon: Icons.copy,
          title: "Duplicate invoice",
          onTap: () => _handleDuplicateInvoice(controller),
          screenWidth: screenWidth,
          verticalSpacing: verticalSpacing,
          bodyFontSize: bodyFontSize,
        ),
        SizedBox(height: verticalSpacing * 0.5),
        _buildDivider(),
        SizedBox(height: verticalSpacing * 0.5),
        _buildOptionTile(
          icon: Icons.qr_code,
          title: "Show QR Code",
          onTap: () => _handleShowQRCode(controller),
          screenWidth: screenWidth,
          verticalSpacing: verticalSpacing,
          bodyFontSize: bodyFontSize,
        ),
      ],
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required double screenWidth,
    required double verticalSpacing,
    required double bodyFontSize,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: Colors.black,
        size: screenWidth * 0.06,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: bodyFontSize,
          color: Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildDeleteButton(CreateInvoiceController controller, double screenWidth, double verticalSpacing, double bodyFontSize, double labelFontSize) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ElevatedButton(
          onPressed: () => _handleDeleteInvoice(controller),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.red,
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: verticalSpacing),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            "Delete",
            style: GoogleFonts.poppins(
              fontSize: bodyFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // Action handlers
  void _handleSendReminder(CreateInvoiceController controller) {
    controller.markAsSent();
  }

  void _handleMarkAsPaid(CreateInvoiceController controller) {
    controller.markAsPaid();
  }

  void _handleExportPDF(CreateInvoiceController controller) {
    Get.snackbar(
      'Exporting',
      'PDF is being generated...',
      backgroundColor: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
      colorText: Colors.white,
    );
  }

  void _handleDuplicateInvoice(CreateInvoiceController controller) {
    Get.snackbar(
      'Duplicated',
      'Invoice has been duplicated',
      backgroundColor: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
      colorText: Colors.white,
    );
  }

  void _handleShowQRCode(CreateInvoiceController controller) {
    Get.snackbar(
      'QR Code',
      'QR Code generated successfully',
      backgroundColor: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
      colorText: Colors.white,
    );
  }

  void _handleDeleteInvoice(CreateInvoiceController controller) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Delete Invoice',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete this invoice? This action cannot be undone.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.back(); // Go back to previous screen
              Get.snackbar(
                'Deleted',
                'Invoice has been deleted',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Colors.grey[300],
    );
  }
}
