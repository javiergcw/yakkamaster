import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../logic/controllers/staff_controller.dart';
import '../../data/data.dart';
import '../../presentation/pages/move_workers_stepper.dart';
import '../../presentation/pages/extend_shifts_stepper.dart';
import '../../presentation/pages/unhire_workers_stepper.dart';
import '../../presentation/widgets/feedback_modal.dart';
import '../../presentation/widgets/extend_shifts_modal.dart';
import '../../presentation/widgets/unhire_confirmation_modal.dart';
import '../../../home/presentation/pages/chat_screen.dart';
import '../../presentation/pages/worker_profile_screen.dart';

class StaffScreenController extends GetxController with GetSingleTickerProviderStateMixin {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final Rx<TextEditingController> searchController = TextEditingController().obs;
  late TabController tabController;
  late StaffController staffController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    searchController.value.text = '';
    staffController = Get.put(StaffController());
  }

  @override
  void onClose() {
    tabController.dispose();
    searchController.value.dispose();
    super.onClose();
  }

  void handleBackNavigation() {
    Get.back();
  }

  void handleTabChange(int index) {
    tabController.animateTo(index);
  }

  void handleSearchChanged(String value) {
    staffController.setSearchQuery(value);
  }

  void handleJobsiteChanged(String? value) {
    staffController.setSelectedJobsite(value!);
  }

  void handleSkillSelected(String? skill) {
    staffController.setSelectedSkill(skill ?? '');
  }

  void navigateToMoveWorkers() {
    Get.toNamed(MoveWorkersStepper.id, arguments: {
      'flavor': currentFlavor.value,
      'workers': staffController.jobsiteWorkers,
    });
  }

  void navigateToExtendShifts() {
    Get.toNamed(ExtendShiftsStepper.id, arguments: {
      'flavor': currentFlavor.value,
      'workers': staffController.jobsiteWorkers,
    });
  }

  void navigateToUnhireWorkers() {
    Get.toNamed(UnhireWorkersStepper.id, arguments: {
      'flavor': currentFlavor.value,
      'workers': staffController.jobsiteWorkers,
    });
  }

  void navigateToChat(String recipientName, String recipientAvatar) {
    Get.to(() => ChatScreen(
      recipientName: recipientName,
      recipientAvatar: recipientAvatar,
      flavor: currentFlavor.value,
    ));
  }

  void navigateToWorkerProfile(WorkerDto worker) {
    Get.toNamed(WorkerProfileScreen.id, arguments: {
      'worker': worker,
      'flavor': currentFlavor.value,
    });
  }

  void showFeedbackModal(String workerId, String workerName) {
    Get.bottomSheet(
      FeedbackModal(
        flavor: currentFlavor.value,
        workerName: workerName,
        onSubmit: (rating, feedback) {
          staffController.rateWorker(workerId, rating);
          print('Rating: $rating, Feedback: $feedback for $workerName');
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void showExtendShiftsModal(String workerId, String workerName) {
    Get.bottomSheet(
      ExtendShiftsModal(
        flavor: currentFlavor.value,
        workerName: workerName,
        onSubmit: (startDate, endDate, isFullDay, isMorning, isAfternoon) {
          print('Extended shifts for $workerName from $startDate to $endDate');
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void showUnhireConfirmationModal(String workerId, String workerName) {
    Get.bottomSheet(
      UnhireConfirmationModal(
        flavor: currentFlavor.value,
        workerName: workerName,
        workerRole: 'Worker', // Default role
        onConfirm: () {
          staffController.unhireWorker(workerId);
          print('Unhired $workerName');
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
