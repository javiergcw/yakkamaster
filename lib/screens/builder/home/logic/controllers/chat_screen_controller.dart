import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../config/app_flavor.dart';

class ChatScreenController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final TextEditingController messageController = TextEditingController();
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final GlobalKey quickChatButtonKey = GlobalKey();
  
  String recipientName = '';
  String recipientAvatar = '';

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['flavor'] != null) {
        currentFlavor.value = Get.arguments['flavor'];
      }
      if (Get.arguments['recipientName'] != null) {
        recipientName = Get.arguments['recipientName'];
      }
      if (Get.arguments['recipientAvatar'] != null) {
        recipientAvatar = Get.arguments['recipientAvatar'];
      }
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
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
        color: const Color(0xFF4A4A4A),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildQuickMessageBubble('Can you start immediately?'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: buildQuickMessageBubble('Great job, Mate!')),
                      const SizedBox(width: 8),
                      Expanded(child: buildQuickMessageBubble('Where are u?')),
                    ],
                  ),
                  const SizedBox(height: 8),
                  buildQuickMessageBubble('Please confirm your availability'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuickMessageBubble(String message) {
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
          style: GoogleFonts.poppins(
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
              title: Text(
                'Camera',
                style: GoogleFonts.poppins(
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
              title: Text(
                'Gallery',
                style: GoogleFonts.poppins(
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
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
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
              title: Text(
                'Share user',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Get.back();
                // TODO: Implementar compartir usuario
                Get.snackbar(
                  'Info',
                  'Share user feature not implemented yet',
                  backgroundColor: Colors.blue,
                  colorText: Colors.white,
                );
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
              title: Text(
                'Report user',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Get.back();
                // TODO: Implementar reportar usuario
                Get.snackbar(
                  'Info',
                  'Report user feature not implemented yet',
                  backgroundColor: Colors.blue,
                  colorText: Colors.white,
                );
              },
            ),
            const Divider(height: 1, color: Colors.grey),
            ListTile(
              title: Text(
                'Close',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void navigateBack() {
    Get.back();
  }

  void makeCall() {
    // TODO: Implementar llamada
    Get.snackbar(
      'Info',
      'Call feature not implemented yet',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void openCamera() {
    // TODO: Implementar cámara
    Get.snackbar(
      'Info',
      'Camera feature not implemented yet',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void translateMessage() {
    // TODO: Implementar traducción
    Get.snackbar(
      'Info',
      'Translation feature not implemented yet',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }
}
