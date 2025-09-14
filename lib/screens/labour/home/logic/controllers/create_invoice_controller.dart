import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../screens/labour/home/presentation/pages/edit_bank_details_no_payid_screen.dart';
import '../../../../../screens/labour/home/presentation/pages/invoice_preview_screen.dart';
import '../../presentation/widgets/add_client_modal.dart';
import '../../presentation/widgets/add_items_modal.dart';

class InvoiceItem {
  final String name;
  final String description;
  final double rate;
  final double quantity;
  final double total;

  InvoiceItem({
    required this.name,
    required this.description,
    required this.rate,
    required this.quantity,
  }) : total = rate * quantity;
}

class CreateInvoiceController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final RxBool hasBankDetails = false.obs; // Simular si tiene datos bancarios
  final RxBool isLoading = false.obs;
  
  // Controladores para los campos del formulario
  final invoiceNumberController = TextEditingController();
  final clientController = TextEditingController();
  final itemController = TextEditingController();
  final subtotalController = TextEditingController();
  final gstController = TextEditingController();
  final totalController = TextEditingController();
  final dueDateController = TextEditingController();
  final paymentInstructionController = TextEditingController();
  
  // Controladores para el modal de cliente
  final billingNameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final billingAddressController = TextEditingController();
  
  // Controladores para el modal de items
  final itemNameController = TextEditingController();
  final itemDescriptionController = TextEditingController();
  final itemRateController = TextEditingController();
  final itemQuantityController = TextEditingController();
  
  // Controlador para el nombre de la factura
  final invoiceNameController = TextEditingController();
  
  // Variables reactivas
  final RxString selectedGstRate = '10%'.obs;
  final RxString selectedDueDate = ''.obs;
  final RxString selectedFile = ''.obs;
  final RxString selectedFilePath = ''.obs;
  final RxString selectedClient = ''.obs;
  final RxInt itemCount = 1.obs;
  final RxDouble subtotal = 0.0.obs;
  final RxDouble gstAmount = 0.0.obs;
  final RxDouble total = 0.0.obs;
  
  // Variables para emails múltiples y direcciones
  final RxList<String> emailList = <String>[].obs;
  final RxList<String> addressList = <String>[].obs;
  final RxString selectedAddress = ''.obs;
  
  // Variables para items
  final RxList<InvoiceItem> itemsList = <InvoiceItem>[].obs;
  
  // Variable para el nombre de la factura
  final RxString invoiceName = 'Invoice 1'.obs;
  
  // Variables para el estado de los tags
  final RxBool isSent = false.obs;
  final RxBool isPaid = false.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Establecer flavor si se proporciona en los argumentos
    final arguments = Get.arguments;
    if (arguments != null && arguments['flavor'] != null) {
      currentFlavor.value = arguments['flavor'];
    }
    
    // Verificar si tiene datos bancarios y redirigir si es necesario
    _checkBankDetailsAndRedirect();
    
    // Inicializar valores por defecto
    _initializeDefaultValues();
    
    // Inicializar el controlador del nombre de la factura
    invoiceNameController.text = invoiceName.value;
  }

  void _checkBankDetailsAndRedirect() {
    // Aquí deberías verificar en tu base de datos o servicio si el usuario tiene datos bancarios
    // Por ahora simulamos que no tiene datos bancarios
    hasBankDetails.value = true; // Cambia a true para probar el flujo con datos bancarios
    
    // Si no tiene datos bancarios, redirigir inmediatamente
    if (!hasBankDetails.value) {
      // Usar un pequeño delay para permitir que la pantalla se inicialice
      Future.delayed(const Duration(milliseconds: 100), () {
        Get.toNamed(
          EditBankDetailsNoPayIdScreen.id,
          arguments: {'flavor': currentFlavor.value},
        );
      });
    }
  }


  void _initializeDefaultValues() {
    // Generar número de factura automático
    invoiceNumberController.text = 'Invoice ${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    
    // Calcular fecha actual
    final now = DateTime.now();
    final day = now.day;
    final month = _getMonthName(now.month);
    final year = now.year;
    
    // Formatear fecha como "17th August"
    String daySuffix = _getDaySuffix(day);
    // Aquí asumimos que la fecha mostrada es la actual, pero podrías permitir al usuario cambiarla
    print('Initialized with date: $daySuffix $month $year');
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

  void handleBackNavigation() {
    Get.back();
  }

  void handleAddClient() {
    // Abrir el modal de agregar cliente
    Get.bottomSheet(
      AddClientModal(flavor: currentFlavor.value),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void handleSaveClient() {
    // Guardar los datos del cliente
    selectedClient.value = billingNameController.text.isNotEmpty 
        ? billingNameController.text 
        : 'Add client';
    
    // Aquí podrías guardar los datos en tu base de datos o servicio
    print('Client saved: ${billingNameController.text}');
  }

  void handleAddEmail() {
    if (emailController.text.isNotEmpty) {
      emailList.add(emailController.text);
      emailController.clear();
    }
  }

  void handleRemoveEmail(int index) {
    emailList.removeAt(index);
  }

  void handleSelectAddress(String address) {
    selectedAddress.value = address;
    billingAddressController.text = address;
  }

  void handleAddNewAddress() {
    if (billingAddressController.text.isNotEmpty) {
      addressList.add(billingAddressController.text);
      selectedAddress.value = billingAddressController.text;
    }
  }

  void handleAddItems() {
    // Abrir el modal de agregar items
    Get.bottomSheet(
      AddItemsModal(flavor: currentFlavor.value),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void handleSaveItem() {
    if (itemNameController.text.isNotEmpty) {
      final item = InvoiceItem(
        name: itemNameController.text,
        description: itemDescriptionController.text,
        rate: double.tryParse(itemRateController.text) ?? 0.0,
        quantity: double.tryParse(itemQuantityController.text) ?? 1.0,
      );
      
      itemsList.add(item);
      itemCount.value = itemsList.length;
      _calculateSubtotal();
      
      // Limpiar campos
      itemNameController.clear();
      itemDescriptionController.clear();
      itemRateController.clear();
      itemQuantityController.clear();
      
      print('Item saved: ${item.name}');
    }
  }

  void handleRemoveItem(int index) {
    if (index < itemsList.length) {
      itemsList.removeAt(index);
      itemCount.value = itemsList.length;
      _calculateSubtotal();
    }
  }

  void _calculateSubtotal() {
    subtotal.value = itemsList.fold(0.0, (sum, item) => sum + item.total);
    _calculateTotals();
  }

  void handleGstRateChange(String rate) {
    selectedGstRate.value = rate;
    _calculateTotals();
  }

  void handleDueDateChange(String date) {
    selectedDueDate.value = date;
    print('Due date changed to: $date');
  }

  void handleFileUpload(String fileName, String filePath) {
    selectedFile.value = fileName;
    selectedFilePath.value = filePath;
    print('File uploaded: $fileName at $filePath');
    
    // Aquí podrías subir el archivo a tu servidor
    // _uploadFileToServer(filePath);
  }

  // Método para subir archivo al servidor (implementar según tu backend)
  void _uploadFileToServer(String filePath) {
    // Implementar lógica de subida al servidor
    // Por ejemplo, usando http package o dio
    print('Uploading file to server: $filePath');
  }

  void _calculateTotals() {
    // Calcular GST y total basado en el subtotal y la tasa de GST
    final rate = double.parse(selectedGstRate.value.replaceAll('%', '')) / 100;
    gstAmount.value = subtotal.value * rate;
    total.value = subtotal.value + gstAmount.value;
  }

  void handleContinue() {
    // Si llegamos aquí, significa que el usuario tiene datos bancarios
    // (porque si no los tuviera, ya habría sido redirigido al inicio)
    // Navegar a la pantalla de vista previa de la factura
    Get.toNamed(
      InvoicePreviewScreen.id,
      arguments: {'flavor': currentFlavor.value},
    );
  }

  void _createInvoice() {
    isLoading.value = true;
    
    // Simular proceso de creación de factura
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      
      // Mostrar mensaje de éxito
      Get.snackbar(
        'Éxito',
        'Factura creada correctamente',
        backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
        colorText: Colors.white,
      );
      
      // Navegar de vuelta o a la siguiente pantalla
      Get.back();
    });
  }

  void handleEditInvoiceName() {
    // Mostrar modal para editar el nombre de la factura
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Edit Invoice Name',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: invoiceNameController,
              decoration: InputDecoration(
                hintText: 'Enter invoice name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (invoiceNameController.text.trim().isNotEmpty) {
                invoiceName.value = invoiceNameController.text.trim();
                Get.back();
                Get.snackbar(
                  'Success',
                  'Invoice name updated',
                  backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Save',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void markAsSent() {
    isSent.value = true;
    Get.snackbar(
      'Reminder Sent',
      'Payment reminder has been sent to the client',
      backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
      colorText: Colors.white,
    );
  }

  void markAsPaid() {
    isPaid.value = true;
    Get.snackbar(
      'Invoice Updated',
      'Invoice has been marked as paid',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    invoiceNumberController.dispose();
    clientController.dispose();
    itemController.dispose();
    subtotalController.dispose();
    gstController.dispose();
    totalController.dispose();
    dueDateController.dispose();
    paymentInstructionController.dispose();
    billingNameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    billingAddressController.dispose();
    itemNameController.dispose();
    itemDescriptionController.dispose();
    itemRateController.dispose();
    itemQuantityController.dispose();
    invoiceNameController.dispose();
    super.onClose();
  }
}
