import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../logic/controllers/create_invoice_controller.dart';

class CreateInvoiceScreen extends StatelessWidget {
  static const String id = '/labour/create-invoice';
  
  final AppFlavor? flavor;

  const CreateInvoiceScreen({
    super.key,
    this.flavor,
  });

  @override
  Widget build(BuildContext context) {
    final CreateInvoiceController controller = Get.put(CreateInvoiceController());
    
    // Establecer el flavor en el controlador si se proporciona
    if (flavor != null) {
      controller.currentFlavor.value = flavor!;
    }
    
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
                    onPressed: controller.handleBackNavigation,
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
                    SizedBox(height: verticalSpacing),

                    // Invoice Details Section
                    _buildInvoiceDetailsSection(controller, screenWidth, verticalSpacing, bodyFontSize, labelFontSize, titleFontSize),
                    
                    SizedBox(height: verticalSpacing),
                    _buildDivider(),
                    SizedBox(height: verticalSpacing),

                    // Bill To Section
                    _buildBillToSection(controller, screenWidth, verticalSpacing, bodyFontSize, labelFontSize),
                    
                    SizedBox(height: verticalSpacing),
                    _buildDivider(),
                    SizedBox(height: verticalSpacing),

                    // Items Section
                    _buildItemsSection(controller, screenWidth, verticalSpacing, bodyFontSize, labelFontSize),
                    
                    SizedBox(height: verticalSpacing),

                    // Financial Summary Section
                    _buildFinancialSummarySection(controller, screenWidth, verticalSpacing, bodyFontSize, labelFontSize),
                    
                    SizedBox(height: verticalSpacing),
                    _buildDivider(),
                    SizedBox(height: verticalSpacing),

                    // Due Date Section
                    _buildDueDateSection(controller, screenWidth, verticalSpacing, bodyFontSize, labelFontSize),
                    
                    SizedBox(height: verticalSpacing),
                    _buildDivider(),
                    SizedBox(height: verticalSpacing),

                    // Payment Instruction Section
                    _buildPaymentInstructionSection(controller, screenWidth, verticalSpacing, bodyFontSize, labelFontSize),
                    
                    SizedBox(height: verticalSpacing * 4),
                  ],
                ),
              ),
            ),

            // Continue Button
            Container(
              padding: EdgeInsets.all(horizontalPadding),
              child: Obx(() => CustomButton(
                text: "Continue",
                onPressed: controller.handleContinue,
                isLoading: controller.isLoading.value,
                flavor: controller.currentFlavor.value,
                showShadow: false,
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceDetailsSection(CreateInvoiceController controller, double screenWidth, double verticalSpacing, double bodyFontSize, double labelFontSize, double titleFontSize) {
    final now = DateTime.now();
    final day = now.day;
    final month = _getMonthName(now.month);
    final daySuffix = _getDaySuffix(day);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${daySuffix} $month",
          style: GoogleFonts.poppins(
            fontSize: bodyFontSize,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: verticalSpacing * 0.5),
        Row(
          children: [
            Obx(() => Text(
              controller.invoiceName.value,
              style: GoogleFonts.poppins(
                fontSize: titleFontSize * 1.3,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            )),
            SizedBox(width: screenWidth * 0.02),
            GestureDetector(
              onTap: controller.handleEditInvoiceName,
              child: Icon(
                Icons.edit,
                size: screenWidth * 0.04,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBillToSection(CreateInvoiceController controller, double screenWidth, double verticalSpacing, double bodyFontSize, double labelFontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bill to",
          style: GoogleFonts.poppins(
            fontSize: labelFontSize,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: verticalSpacing),
        GestureDetector(
          onTap: controller.handleAddClient,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: screenWidth * 0.08,
                height: screenWidth * 0.08,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: screenWidth * 0.04,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: Obx(() {
                  if (controller.selectedClient.value.isEmpty) {
                    return Text(
                      "Add client",
                      style: GoogleFonts.poppins(
                        fontSize: bodyFontSize,
                        color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                        decoration: TextDecoration.underline,
                      ),
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre del cliente (grande y en negrita) con ícono de lápiz
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                controller.selectedClient.value,
                                style: GoogleFonts.poppins(
                                  fontSize: labelFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Icon(
                              Icons.edit,
                              size: screenWidth * 0.04,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                        SizedBox(height: verticalSpacing * 0.2),
                        // Teléfono
                        if (controller.mobileController.text.isNotEmpty)
                          Text(
                            controller.mobileController.text,
                            style: GoogleFonts.poppins(
                              fontSize: bodyFontSize * 0.9,
                              color: Colors.black87,
                            ),
                          ),
                        // Dirección
                        if (controller.selectedAddress.value.isNotEmpty) ...[
                          if (controller.mobileController.text.isNotEmpty)
                            SizedBox(height: verticalSpacing * 0.1),
                          Text(
                            controller.selectedAddress.value,
                            style: GoogleFonts.poppins(
                              fontSize: bodyFontSize * 0.9,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ],
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemsSection(CreateInvoiceController controller, double screenWidth, double verticalSpacing, double bodyFontSize, double labelFontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Text(
          "${controller.itemCount.value} Items",
          style: GoogleFonts.poppins(
            fontSize: labelFontSize,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        )),
        SizedBox(height: verticalSpacing),
        
        // Lista de items agregados
        Obx(() => controller.itemsList.isNotEmpty
            ? Column(
                children: [
                  ...controller.itemsList.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Container(
                      margin: EdgeInsets.only(bottom: verticalSpacing),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Item name (grande y en negrita)
                          Text(
                            item.name,
                            style: GoogleFonts.poppins(
                              fontSize: labelFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: verticalSpacing * 0.3),
                          // Item description
                          if (item.description.isNotEmpty)
                            Text(
                              item.description,
                              style: GoogleFonts.poppins(
                                fontSize: bodyFontSize * 0.9,
                                color: Colors.black87,
                              ),
                            ),
                          SizedBox(height: verticalSpacing * 0.3),
                          // Rate x Quantity
                          Text(
                            "\$${item.rate.toStringAsFixed(2)} x ${item.quantity.toStringAsFixed(2)} qty",
                            style: GoogleFonts.poppins(
                              fontSize: bodyFontSize * 0.9,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: verticalSpacing * 0.5),
                          // Total price (derecha inferior)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "\$${item.total.toStringAsFixed(2)}",
                              style: GoogleFonts.poppins(
                                fontSize: labelFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  SizedBox(height: verticalSpacing),
                ],
              )
            : const SizedBox.shrink()),
        
        // Botón Add items
        GestureDetector(
          onTap: controller.handleAddItems,
          child: Row(
            children: [
              Container(
                width: screenWidth * 0.08,
                height: screenWidth * 0.08,
                decoration: BoxDecoration(
                  color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  size: screenWidth * 0.04,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Text(
                "Add items",
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize,
                  color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialSummarySection(CreateInvoiceController controller, double screenWidth, double verticalSpacing, double bodyFontSize, double labelFontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Subtotal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Subtotal",
              style: GoogleFonts.poppins(
                fontSize: bodyFontSize,
                color: Colors.black,
              ),
            ),
            Obx(() => Text(
              "\$${controller.subtotal.value.toStringAsFixed(2)}",
              style: GoogleFonts.poppins(
                fontSize: bodyFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            )),
          ],
        ),
        SizedBox(height: verticalSpacing * 0.8),
        _buildDivider(),
        SizedBox(height: verticalSpacing * 0.8),
        
        // GST
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "GST",
              style: GoogleFonts.poppins(
                fontSize: bodyFontSize,
                color: Colors.black,
              ),
            ),
            Obx(() => Text(
              "\$${controller.gstAmount.value.toStringAsFixed(2)}",
              style: GoogleFonts.poppins(
                fontSize: bodyFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            )),
          ],
        ),
        SizedBox(height: verticalSpacing * 0.8),
        
         // GST Rate Dropdown
         GestureDetector(
           onTap: () => _showGstRateDropdown(controller, screenWidth, verticalSpacing, bodyFontSize),
           child: Container(
             width: double.infinity,
             padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: verticalSpacing * 0.5),
             decoration: BoxDecoration(
               border: Border.all(color: Colors.grey[300]!),
               borderRadius: BorderRadius.circular(8),
             ),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       "Rate",
                       style: GoogleFonts.poppins(
                         fontSize: bodyFontSize * 0.8,
                         color: Colors.grey[600],
                       ),
                     ),
                     Obx(() => Text(
                       controller.selectedGstRate.value,
                       style: GoogleFonts.poppins(
                         fontSize: bodyFontSize,
                         fontWeight: FontWeight.bold,
                         color: Colors.black,
                       ),
                     )),
                   ],
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
        SizedBox(height: verticalSpacing * 0.8),
        
        // Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total",
              style: GoogleFonts.poppins(
                fontSize: bodyFontSize,
                color: Colors.black,
              ),
            ),
            Obx(() => Text(
              "\$${controller.total.value.toStringAsFixed(2)}",
              style: GoogleFonts.poppins(
                fontSize: bodyFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildDueDateSection(CreateInvoiceController controller, double screenWidth, double verticalSpacing, double bodyFontSize, double labelFontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Due Date",
          style: GoogleFonts.poppins(
            fontSize: labelFontSize,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: verticalSpacing),
        GestureDetector(
          onTap: () => _showDatePicker(controller, screenWidth, verticalSpacing, bodyFontSize),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: screenWidth * 0.04,
                color: Colors.grey[600],
              ),
              SizedBox(width: screenWidth * 0.03),
              Obx(() => Text(
                controller.selectedDueDate.value.isEmpty ? "Add date" : controller.selectedDueDate.value,
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize,
                  color: controller.selectedDueDate.value.isEmpty 
                    ? Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value))
                    : Colors.black,
                  decoration: controller.selectedDueDate.value.isEmpty 
                    ? TextDecoration.underline 
                    : TextDecoration.none,
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInstructionSection(CreateInvoiceController controller, double screenWidth, double verticalSpacing, double bodyFontSize, double labelFontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Payment instruction",
          style: GoogleFonts.poppins(
            fontSize: labelFontSize,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: verticalSpacing),
        GestureDetector(
          onTap: () => _showFilePicker(controller, screenWidth, verticalSpacing, bodyFontSize),
          child: Row(
            children: [
              Container(
                width: screenWidth * 0.08,
                height: screenWidth * 0.08,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  size: screenWidth * 0.04,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Obx(() => Text(
                controller.selectedFile.value.isEmpty ? "Add payment instruction" : controller.selectedFile.value,
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize,
                  color: controller.selectedFile.value.isEmpty 
                    ? Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value))
                    : Colors.black,
                  decoration: controller.selectedFile.value.isEmpty 
                    ? TextDecoration.underline 
                    : TextDecoration.none,
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Colors.grey[300],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

   String _getDaySuffix(int day) {
     if (day >= 11 && day <= 13) {
       return '${day}th';
     }
     switch (day % 10) {
       case 1:
         return '${day}st';
       case 2:
         return '${day}nd';
       case 3:
         return '${day}rd';
       default:
         return '${day}th';
     }
   }

   void _showGstRateDropdown(CreateInvoiceController controller, double screenWidth, double verticalSpacing, double bodyFontSize) {
     final gstRates = ['0%', '5%', '10%', '15%', '20%'];
     
     showModalBottomSheet(
       context: Get.context!,
       backgroundColor: Colors.white,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
       ),
       builder: (context) => Container(
         padding: EdgeInsets.all(verticalSpacing),
         child: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             Container(
               width: screenWidth * 0.1,
               height: 4,
               decoration: BoxDecoration(
                 color: Colors.grey[300],
                 borderRadius: BorderRadius.circular(2),
               ),
             ),
             SizedBox(height: verticalSpacing),
             Text(
               "Select GST Rate",
               style: GoogleFonts.poppins(
                 fontSize: bodyFontSize * 1.2,
                 fontWeight: FontWeight.bold,
                 color: Colors.black,
               ),
             ),
             SizedBox(height: verticalSpacing),
             ...gstRates.map((rate) => ListTile(
               title: Text(
                 rate,
                 style: GoogleFonts.poppins(
                   fontSize: bodyFontSize,
                   color: Colors.black,
                 ),
               ),
               onTap: () {
                 controller.handleGstRateChange(rate);
                 Get.back();
               },
             )).toList(),
           ],
         ),
       ),
     );
   }

   void _showDatePicker(CreateInvoiceController controller, double screenWidth, double verticalSpacing, double bodyFontSize) async {
     final DateTime? picked = await showDatePicker(
       context: Get.context!,
       initialDate: DateTime.now(),
       firstDate: DateTime.now().subtract(Duration(days: 365)), // Permite fechas hasta 1 año atrás
       lastDate: DateTime.now().add(Duration(days: 365)), // Permite fechas hasta 1 año adelante
       builder: (context, child) {
         return Theme(
           data: Theme.of(context).copyWith(
             colorScheme: ColorScheme.light(
               primary: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
               onPrimary: Colors.white,
               surface: Colors.white,
               onSurface: Colors.black,
             ),
           ),
           child: child!,
         );
       },
     );
     
     if (picked != null) {
       final formattedDate = "${picked.day}/${picked.month}/${picked.year}";
       controller.handleDueDateChange(formattedDate);
     }
   }

   void _showFilePicker(CreateInvoiceController controller, double screenWidth, double verticalSpacing, double bodyFontSize) {
     showModalBottomSheet(
       context: Get.context!,
       backgroundColor: Colors.white,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
       ),
       builder: (context) => Container(
         padding: EdgeInsets.all(verticalSpacing),
         child: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             Container(
               width: screenWidth * 0.1,
               height: 4,
               decoration: BoxDecoration(
                 color: Colors.grey[300],
                 borderRadius: BorderRadius.circular(2),
               ),
             ),
             SizedBox(height: verticalSpacing),
             Text(
               "Select File Type",
               style: GoogleFonts.poppins(
                 fontSize: bodyFontSize * 1.2,
                 fontWeight: FontWeight.bold,
                 color: Colors.black,
               ),
             ),
             SizedBox(height: verticalSpacing),
             ListTile(
               leading: Icon(Icons.image, color: Colors.blue),
               title: Text(
                 "Upload Image",
                 style: GoogleFonts.poppins(
                   fontSize: bodyFontSize,
                   color: Colors.black,
                 ),
               ),
               onTap: () async {
                 Get.back();
                 await _pickFile(controller, FileType.image);
               },
             ),
             ListTile(
               leading: Icon(Icons.picture_as_pdf, color: Colors.red),
               title: Text(
                 "Upload PDF",
                 style: GoogleFonts.poppins(
                   fontSize: bodyFontSize,
                   color: Colors.black,
                 ),
               ),
               onTap: () async {
                 Get.back();
                 await _pickFile(controller, FileType.custom, allowedExtensions: ['pdf']);
               },
             ),
             ListTile(
               leading: Icon(Icons.description, color: Colors.green),
               title: Text(
                 "Upload Document",
                 style: GoogleFonts.poppins(
                   fontSize: bodyFontSize,
                   color: Colors.black,
                 ),
               ),
               onTap: () async {
                 Get.back();
                 await _pickFile(controller, FileType.custom, allowedExtensions: ['doc', 'docx', 'txt']);
               },
             ),
             ListTile(
               leading: Icon(Icons.folder, color: Colors.orange),
               title: Text(
                 "Any File",
                 style: GoogleFonts.poppins(
                   fontSize: bodyFontSize,
                   color: Colors.black,
                 ),
               ),
               onTap: () async {
                 Get.back();
                 await _pickFile(controller, FileType.any);
               },
             ),
           ],
         ),
       ),
     );
   }

   Future<void> _pickFile(CreateInvoiceController controller, FileType fileType, {List<String>? allowedExtensions}) async {
     try {
       FilePickerResult? result = await FilePicker.platform.pickFiles(
         type: fileType,
         allowedExtensions: allowedExtensions,
         allowMultiple: false,
       );

       if (result != null && result.files.single.path != null) {
         PlatformFile file = result.files.first;
         controller.handleFileUpload(file.name, file.path!);
       }
     } catch (e) {
       Get.snackbar(
         'Error',
         'Error al seleccionar archivo: $e',
         backgroundColor: Colors.red,
         colorText: Colors.white,
       );
     }
   }
 }
