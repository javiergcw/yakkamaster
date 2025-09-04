import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../logic/controllers/post_job_controller.dart';

class PostJobStepperController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final PostJobController postJobController = Get.find<PostJobController>();
  
  final TextEditingController searchController = TextEditingController();
  final RxList<String> filteredSkills = <String>[].obs;
  
  // Lista completa de habilidades
  final List<String> allSkills = [
    'General Labourer',
    'Carpenter',
    'Electrician',
    'Plumber',
    'Bricklayer',
    'Concreter',
    'Painter',
    'Excavator Operator',
    'Truck Driver',
    'Forklift Driver',
    'Paver Operator',
    'Truck LR Driver',
    'Asbestos Remover',
    'Elevator operator',
    'Foreman',
    'Tow Truck Driver',
    'Lawn mower',
    'Construction Foreman',
    'Bulldozer Operator',
    'Heavy Rigid Truck Driver',
    'Traffic Controller',
    'Bartender',
    'Gardener',
    'Truck HC Driver',
  ];

  @override
  void onInit() {
    super.onInit();
    // Asegurar que el controlador esté en el paso correcto
    postJobController.goToStep(1);
    filteredSkills.assignAll(allSkills);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void performSearch() {
    final query = searchController.text.toLowerCase().trim();
    
    if (query.isEmpty) {
      filteredSkills.assignAll(allSkills);
    } else {
      filteredSkills.assignAll(
        allSkills.where((skill) => skill.toLowerCase().contains(query)).toList()
      );
    }
  }

  void handleBackNavigation() {
    postJobController.handleBackNavigation();
  }

  bool canProceedToNextStep() {
    return postJobController.canProceedToNextStep();
  }

  void nextStep() {
    postJobController.nextStep();
  }

  void updateSelectedSkill(String skill) {
    postJobController.updateSelectedSkill(skill);
  }

  void navigateToStep2() {
    Get.toNamed('/builder/post-job/step2', arguments: {'flavor': currentFlavor.value});
  }

  void handleContinue() {
    if (canProceedToNextStep()) {
      nextStep();
      navigateToStep2();
    }
  }
}
