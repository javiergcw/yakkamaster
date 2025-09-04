import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';

class MessagesScreenController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  // Lista de mensajes de ejemplo
  final List<Map<String, dynamic>> messages = [
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
  ];

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
  }

  void handleMessageTap(Map<String, dynamic> message) {
    Get.toNamed('/builder/chat', arguments: {
      'recipientName': message['name'],
      'recipientAvatar': message['avatar'],
      'flavor': currentFlavor.value,
    });
  }

  void navigateToHome() {
    Get.offAllNamed('/builder/home', arguments: {'flavor': currentFlavor.value});
  }
}
