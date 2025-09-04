import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';

class MessagesScreenController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  // Lista de mensajes de ejemplo
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[
    {
      'id': '1',
      'name': 'Zeta Roman',
      'lastMessage': 'hello',
      'timestamp': '8:05 AM',
      'avatar': 'Z',
      'unreadCount': 0,
    },
    {
      'id': '2',
      'name': 'John Smith',
      'lastMessage': 'Thanks for the job!',
      'timestamp': 'Yesterday',
      'avatar': 'J',
      'unreadCount': 2,
    },
    {
      'id': '3',
      'name': 'Sarah Wilson',
      'lastMessage': 'When can you start?',
      'timestamp': '2 days ago',
      'avatar': 'S',
      'unreadCount': 0,
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // Establecer flavor si se proporciona en los argumentos
    final arguments = Get.arguments;
    if (arguments != null && arguments['flavor'] != null) {
      currentFlavor.value = arguments['flavor'];
    }
  }

  void handleMessageTap(Map<String, dynamic> message) {
    Get.toNamed('/labour/chat', arguments: {
      'recipientName': message['name'],
      'recipientAvatar': message['avatar'],
      'flavor': currentFlavor.value,
    });
  }

  void handleBackNavigation() {
    Get.offAllNamed('/labour/home', arguments: {'flavor': currentFlavor.value});
  }
}
