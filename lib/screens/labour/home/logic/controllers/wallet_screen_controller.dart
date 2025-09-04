import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../logic/wallet_controller.dart';

class WalletScreenController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final WalletController walletController = Get.put(WalletController());

  @override
  void onInit() {
    super.onInit();
    // Establecer flavor si se proporciona en los argumentos
    final arguments = Get.arguments;
    if (arguments != null && arguments['flavor'] != null) {
      currentFlavor.value = arguments['flavor'];
    }
    print('WalletScreen initialized');
  }

  void handleBackNavigation() {
    Get.back();
  }

  void addMoney() {
    walletController.addMoney();
  }

  void withdrawBalance() {
    walletController.withdrawBalance();
  }

  void setSort(String value) {
    walletController.setSort(value);
  }
}
