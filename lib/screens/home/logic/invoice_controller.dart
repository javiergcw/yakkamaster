import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/invoice_dto.dart';
import '../../../../config/app_flavor.dart';
import '../presentation/pages/pdf_viewer_screen.dart';

class InvoiceController extends GetxController {
  final RxList<InvoiceDto> invoices = <InvoiceDto>[].obs;
  final RxString selectedFilter = 'unpaid'.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeInvoices();
  }

  void _initializeInvoices() {
    // Datos de ejemplo basados en la imagen
    invoices.value = [
      InvoiceDto(
        id: '1',
        dateRange: '2025-08-25 - 2025-08-31',
        recipientName: 'null null',
        recipientStatus: 'N/A',
        recipientImage: 'https://example.com/profile.jpg',
        status: 'unpaid',
        amount: 1250.00,
        startDate: DateTime(2025, 8, 25),
        endDate: DateTime(2025, 8, 31),
      ),
      InvoiceDto(
        id: '2',
        dateRange: '2025-08-18 - 2025-08-24',
        recipientName: 'John Doe',
        recipientStatus: 'Active',
        recipientImage: 'https://example.com/profile2.jpg',
        status: 'paid',
        amount: 980.50,
        startDate: DateTime(2025, 8, 18),
        endDate: DateTime(2025, 8, 24),
      ),
      InvoiceDto(
        id: '3',
        dateRange: '2025-08-11 - 2025-08-17',
        recipientName: 'Jane Smith',
        recipientStatus: 'Pending',
        recipientImage: 'https://example.com/profile3.jpg',
        status: 'unpaid',
        amount: 750.25,
        startDate: DateTime(2025, 8, 11),
        endDate: DateTime(2025, 8, 17),
      ),
    ];
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  List<InvoiceDto> get filteredInvoices {
    if (selectedFilter.value == 'all') {
      return invoices;
    }
    return invoices.where((invoice) => invoice.status == selectedFilter.value).toList();
  }

  void viewInvoice(InvoiceDto invoice) {
    print('View invoice called for: ${invoice.dateRange}');
    // Navegar a la pantalla del PDF
    Get.to(() => PdfViewerScreen(
      invoice: invoice,
      flavor: AppFlavorConfig.currentFlavor,
    ));
  }

  void editInvoice(InvoiceDto invoice) {
    print('Edit invoice called for: ${invoice.dateRange}');
    final primaryColor = Color(AppFlavorConfig.getPrimaryColor(AppFlavorConfig.currentFlavor));
    
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: EdgeInsets.only(top: 16, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header con icono
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.schedule_outlined,
                      color: primaryColor,
                      size: 28,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Modificar Timesheet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            
            // Contenido
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'Para modificar la factura:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  // Fecha destacada
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      invoice.dateRange,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Información
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRowApple(Icons.edit_outlined, 'La timesheet debe ser modificada primero'),
                        SizedBox(height: 12),
                        _buildInfoRowApple(Icons.sync_outlined, 'Los cambios se reflejarán automáticamente en la factura'),
                        SizedBox(height: 12),
                        _buildInfoRowApple(Icons.warning_outlined, 'No se puede editar la factura directamente'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Botón
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Entendido',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildInfoRowApple(IconData icon, String text) {
    final primaryColor = Color(AppFlavorConfig.getPrimaryColor(AppFlavorConfig.currentFlavor));
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: primaryColor,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }



  Future<void> loadInvoices() async {
    try {
      isLoading.value = true;
      
      // Aquí harías la llamada al API
      await Future.delayed(const Duration(seconds: 1)); // Simulación
      
      // Actualizar la lista de facturas
      _initializeInvoices();
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al cargar las facturas: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
