import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../logic/invoice_controller.dart';

class InvoiceScreenController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final InvoiceController invoiceController = Get.put(InvoiceController());

  @override
  void onInit() {
    super.onInit();
    // Establecer flavor si se proporciona en los argumentos
    final arguments = Get.arguments;
    if (arguments != null && arguments['flavor'] != null) {
      currentFlavor.value = arguments['flavor'];
    }
    print('InvoiceScreen initialized');
  }

  void handleBackNavigation() {
    Get.back();
  }

  void setFilter(String filter) {
    invoiceController.setFilter(filter);
  }
}
