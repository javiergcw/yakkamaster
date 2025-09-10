import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/invoice_dto.dart';

class PdfViewerController extends GetxController {
  // Variables observables para el estado
  final RxBool isLoading = true.obs;
  
  InvoiceDto? invoice;

  @override
  void onInit() {
    super.onInit();
    // Obtener la factura de los argumentos
    final arguments = Get.arguments;
    if (arguments != null && arguments['invoice'] != null) {
      invoice = arguments['invoice'];
      _loadPdf();
    } else {
      print('Error: No invoice provided in arguments');
      Get.back();
    }
  }

  void _loadPdf() {
    // Simular carga del PDF
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
    });
  }

  void downloadPdf() {
    Get.snackbar(
      'Download',
      'Descargando PDF...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue[600],
      colorText: Colors.white,
    );
  }

  void sharePdf() {
    Get.snackbar(
      'Share',
      'Compartiendo PDF...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green[600],
      colorText: Colors.white,
    );
  }

  void openPdfInBrowser() async {
    // URL de ejemplo - aquí usarías la URL real del PDF
    final url = Uri.parse('https://example.com/invoice.pdf');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'No se pudo abrir el PDF',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
      );
    }
  }
}
