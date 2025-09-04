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
    notificationsController = NotificationsController();
    
    // Establecer flavor si se proporciona en los argumentos
    final arguments = Get.arguments;
    if (arguments != null && arguments['flavor'] != null) {
      currentFlavor.value = arguments['flavor'];
    }
  }

  void markAllAsRead() {
    notificationsController.markAllAsRead();
    
    Get.snackbar(
      'Success',
      'All notifications marked as read',
      backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
      colorText: Colors.white,
      duration: Duration(seconds: 2),
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
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void handleBackNavigation() {
    Get.back();
  }

  void refreshNotifications() {
    notificationsController.refreshNotifications();
    update(); // Notificar a GetX que el estado ha cambiado
  }

  void setSelectedTabIndex(int index) {
    notificationsController.setSelectedTabIndex(index);
    update(); // Notificar a GetX que el estado ha cambiado
  }

  // Getters para acceder a las propiedades del controlador de notificaciones
  List<NotificationItem> get allNotifications => notificationsController.allNotifications;
  List<NotificationItem> get hireNotifications => notificationsController.hireNotifications;
  List<NotificationItem> get hiredNotifications => notificationsController.hiredNotifications;
  List<NotificationItem> get paymentNotifications => notificationsController.paymentNotifications;
  List<NotificationItem> get timesheetNotifications => notificationsController.timesheetNotifications;
  List<NotificationItem> get currentNotifications => notificationsController.currentNotifications;
  int get selectedTabIndex => notificationsController.selectedTabIndex;
  
  Color getNotificationColor(NotificationType type) => notificationsController.getNotificationColor(type);
  IconData getNotificationIcon(NotificationType type) => notificationsController.getNotificationIcon(type);
  String getTimeAgo(DateTime timestamp) => notificationsController.getTimeAgo(timestamp);
}
