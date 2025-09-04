import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../data/notification_dto.dart';
import '../../logic/notifications_controller.dart';

class NotificationsScreenController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  
  // Controlador de notificaciones
  late final NotificationsController notificationsController;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
    notificationsController = NotificationsController();
  }

  void markAllAsRead() {
    notificationsController.markAllAsRead();
    
    Get.snackbar(
      'Success',
      'All notifications marked as read',
      backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void handleNotificationTap(NotificationItem notification) {
    notificationsController.handleNotificationTap(notification);
    
    // Ejemplo: mostrar un diálogo con más detalles
    Get.dialog(
      AlertDialog(
        title: Text(notification.title),
        content: Text(notification.message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void refreshNotifications() {
    notificationsController.refreshNotifications();
  }

  void setSelectedTabIndex(int index) {
    notificationsController.setSelectedTabIndex(index);
  }

  void navigateBack() {
    Get.back();
  }
}
