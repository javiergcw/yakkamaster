import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/wallet_dto.dart';
import '../../../../../config/app_flavor.dart';

class WalletController extends GetxController {
  final RxList<WalletDto> transactions = <WalletDto>[].obs;
  final RxDouble balance = 250.49.obs;
  final RxString selectedSort = 'Date'.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeTransactions();
  }

  void _initializeTransactions() {
    // Datos de ejemplo basados en la imagen
    transactions.value = [
      WalletDto(
        id: '1',
        transactionId: '032 - 050 - ******',
        amount: -25.00,
        currency: 'USD',
        status: 'Withdrawn',
        date: DateTime(2023, 9, 5),
        type: 'withdrawn',
      ),
      WalletDto(
        id: '2',
        transactionId: '032 - 050 - ******',
        amount: 25.00,
        currency: 'USD',
        status: 'Received',
        date: DateTime(2023, 9, 5),
        type: 'received',
      ),
      WalletDto(
        id: '3',
        transactionId: '032 - 050 - ******',
        amount: -25.00,
        currency: 'USD',
        status: 'Withdrawn',
        date: DateTime(2023, 9, 5),
        type: 'withdrawn',
      ),
      WalletDto(
        id: '4',
        transactionId: '032 - 050 - ******',
        amount: 25.00,
        currency: 'USD',
        status: 'Received',
        date: DateTime(2023, 9, 5),
        type: 'received',
      ),
      WalletDto(
        id: '5',
        transactionId: '032 - 050 - ******',
        amount: 25.00,
        currency: 'USD',
        status: 'Received',
        date: DateTime(2023, 9, 5),
        type: 'received',
      ),
      WalletDto(
        id: '6',
        transactionId: '032 - 050 - ******',
        amount: -25.00,
        currency: 'USD',
        status: 'Withdrawn',
        date: DateTime(2023, 9, 5),
        type: 'withdrawn',
      ),
    ];
  }

  void setSort(String sort) {
    selectedSort.value = sort;
    _sortTransactions();
  }

  void _sortTransactions() {
    switch (selectedSort.value) {
      case 'Date':
        transactions.sort((a, b) => b.date.compareTo(a.date));
        break;
      case 'Amount':
        transactions.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case 'Status':
        transactions.sort((a, b) => a.status.compareTo(b.status));
        break;
    }
  }

  void withdrawBalance() {
    Get.snackbar(
      'Withdraw',
      'Withdraw functionality will be implemented',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(AppFlavorConfig.getPrimaryColor(AppFlavorConfig.currentFlavor)),
      colorText: Colors.white,
    );
  }

  void addMoney() {
    Get.snackbar(
      'Add Money',
      'Add money functionality will be implemented',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(AppFlavorConfig.getPrimaryColor(AppFlavorConfig.currentFlavor)),
      colorText: Colors.white,
    );
  }

  Future<void> loadTransactions() async {
    try {
      isLoading.value = true;
      
      // Aquí harías la llamada al API
      await Future.delayed(const Duration(seconds: 1)); // Simulación
      
      // Actualizar la lista de transacciones
      _initializeTransactions();
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al cargar las transacciones: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
