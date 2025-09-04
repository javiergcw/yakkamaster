import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../config/app_flavor.dart';

class ChatScreenController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final TextEditingController messageController = TextEditingController();
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final GlobalKey quickChatButtonKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    // Establecer flavor si se proporciona en los argumentos
    final arguments = Get.arguments;
    if (arguments != null && arguments['flavor'] != null) {
      currentFlavor.value = arguments['flavor'];
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  void handleBackNavigation() {
    Get.back();
  }

  void sendMessage() {
    if (messageController.text.trim().isNotEmpty) {
      messages.add({
        'text': messageController.text.trim(),
        'isMe': true,
        'timestamp': DateTime.now(),
      });
      messageController.clear();
    }
  }

  void showQuickChatOptions() {
    Get.dialog(
      Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuickMessageBubble('Can you start immediately?'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildQuickMessageBubble('Great job, Mate!')),
                const SizedBox(width: 8),
                Expanded(child: _buildQuickMessageBubble('Where are u?')),
              ],
            ),
            const SizedBox(height: 8),
            _buildQuickMessageBubble('Please confirm your availability'),
          ],
        ),
      ),
      barrierDismissible: true,
    );
  }

  Widget _buildQuickMessageBubble(String message) {
    return GestureDetector(
      onTap: () {
        Get.back();
        addQuickMessage(message);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF4A4A4A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void addQuickMessage(String message) {
    messages.add({
      'text': message,
      'isMe': true,
      'timestamp': DateTime.now(),
    });
  }

  void showImageSourceDialog() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Select image source',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            
            // Options
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.grey[700],
                  size: 20,
                ),
              ),
              title: const Text(
                'Camera',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
            
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: Icon(
                  Icons.photo_library,
                  color: Colors.grey[700],
                  size: 20,
                ),
              ),
              title: const Text(
                'Gallery',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              onTap: () {
                Get.back();
                pickImage(ImageSource.gallery);
              },
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      
      if (image != null) {
        // TODO: Implementar lógica para enviar la imagen
        print('Imagen seleccionada: ${image.path}');
        
        // Por ahora, agregar un mensaje de texto indicando que se seleccionó una imagen
        messages.add({
          'text': '📷 Imagen enviada',
          'isMe': true,
          'timestamp': DateTime.now(),
        });
      }
    } catch (e) {
      print('Error al seleccionar imagen: $e');
      Get.snackbar(
        'Error',
        'Error al seleccionar imagen: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void showUserOptionsMenu() {
    Get.dialog(
      Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.share,
                  color: Colors.grey[700],
                  size: 18,
                ),
              ),
              title: const Text(
                'Share user',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Get.back();
                // TODO: Implementar compartir usuario
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.report,
                  color: Colors.grey[700],
                  size: 18,
                ),
              ),
              title: const Text(
                'Report user',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Get.back();
                // TODO: Implementar reportar usuario
              },
            ),
          ],
        ),
      ),
      barrierDismissible: true,
    );
  }
}
