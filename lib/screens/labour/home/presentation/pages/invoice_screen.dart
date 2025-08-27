import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../logic/invoice_controller.dart';
import '../widgets/invoice_card.dart';

class InvoiceScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const InvoiceScreen({
    super.key,
    this.flavor,
  });

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final InvoiceController _invoiceController = Get.put(InvoiceController());
  
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;

  @override
  void initState() {
    super.initState();
    print('InvoiceScreen initialized');
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
    final tabFontSize = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: screenWidth * 0.12,
                      height: screenWidth * 0.12,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: screenWidth * 0.06,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Invoice labour",
                        style: GoogleFonts.poppins(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.12), // Espacio para balancear
                ],
              ),
            ),
            
            SizedBox(height: verticalSpacing * 2),
            
            // Tabs/Filters
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(() => GestureDetector(
                      onTap: () => _invoiceController.setFilter('unpaid'),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: verticalSpacing),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _invoiceController.selectedFilter.value == 'unpaid'
                                  ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          "Unpaid",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: tabFontSize,
                            fontWeight: FontWeight.w600,
                            color: _invoiceController.selectedFilter.value == 'unpaid'
                                ? Colors.black
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    )),
                  ),
                  Expanded(
                    child: Obx(() => GestureDetector(
                      onTap: () => _invoiceController.setFilter('paid'),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: verticalSpacing),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _invoiceController.selectedFilter.value == 'paid'
                                  ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          "Paid",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: tabFontSize,
                            fontWeight: FontWeight.w600,
                            color: _invoiceController.selectedFilter.value == 'paid'
                                ? Colors.black
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    )),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: verticalSpacing * 2),
            
            // Lista de facturas
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Obx(() {
                  if (_invoiceController.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  
                  final filteredInvoices = _invoiceController.filteredInvoices;
                  
                  if (filteredInvoices.isEmpty) {
                    return Center(
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
                            'No hay facturas ${_invoiceController.selectedFilter.value == 'unpaid' ? 'pendientes' : 'pagadas'}',
                            style: GoogleFonts.poppins(
                              fontSize: tabFontSize,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: filteredInvoices.length,
                    itemBuilder: (context, index) {
                      final invoice = filteredInvoices[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: verticalSpacing),
                        child: InvoiceCard(
                          invoice: invoice,
                          onView: () => _invoiceController.viewInvoice(invoice),
                          onEdit: () => _invoiceController.editInvoice(invoice),
                          flavor: _currentFlavor,
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
