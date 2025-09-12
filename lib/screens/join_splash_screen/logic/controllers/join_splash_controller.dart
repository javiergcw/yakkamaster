import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_flavor.dart';
import '../../../../app/routes/app_pages.dart';

class JoinSplashController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController logoController;
  late AnimationController textController;
  late Animation<double> logoAnimation;
  late Animation<double> textAnimation;
  
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Si se pasa un flavor específico, usarlo
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
    
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: logoController, curve: Curves.elasticOut),
    );

    textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: textController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    logoController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    textController.forward();

    await Future.delayed(const Duration(milliseconds: 3000));
    if (Get.isRegistered<JoinSplashController>()) {
      Get.offAllNamed('/login', arguments: {'flavor': currentFlavor.value});
    }
  }

  @override
  void onClose() {
    logoController.dispose();
    textController.dispose();
    super.onClose();
  }

  String getJoinTitle() {
    switch (currentFlavor.value) {
      case AppFlavor.labour:
        return 'WORK OR HIRE';
      case AppFlavor.sport:
        return ' Connecting sport People';
      case AppFlavor.hospitality:
        return 'SERVE OR ENJOY';
    }
  }

  String getJoinSubtitle() {
    switch (currentFlavor.value) {
      case AppFlavor.labour:
        return 'No worries.';
      case AppFlavor.sport:
        return 'No limits.';
      case AppFlavor.hospitality:
        return 'No boundaries.';
    }
  }

  String getJoinDescription() {
    switch (currentFlavor.value) {
      case AppFlavor.labour:
        return 'Construction &\nHospitality Jobs';
      case AppFlavor.sport:
        return 'Work or hire';
      case AppFlavor.hospitality:
        return 'Hospitality &\nService Industry';
    }
  }
}
