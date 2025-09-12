import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
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
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2C),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              // Quick message options
              _buildQuickMessageBubble('Can you start immediately?'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildQuickMessageBubble('Great job, Mate!')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildQuickMessageBubble('Where are u?')),
                ],
              ),
              const SizedBox(height: 12),
              _buildQuickMessageBubble('Please confirm your availability'),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  Widget _buildQuickMessageBubble(String message) {
    return GestureDetector(
      onTap: () {
        Get.back();
        addQuickMessage(message);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 15,
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
            
            // Camera Option
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
            
            // Gallery Option
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
            
            // Location Option
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
                  Icons.location_on,
                  color: Colors.grey[700],
                  size: 20,
                ),
              ),
              title: const Text(
                'Location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              onTap: () {
                Get.back();
                selectLocation();
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

  Future<void> selectLocation() async {
    try {
      // TODO: Implementar lógica para obtener la ubicación actual
      // Por ahora, simulamos la selección de ubicación
      
      // Simular coordenadas de ejemplo (Sydney, Australia)
      final latitude = -33.8688;
      final longitude = 151.2093;
      
      // Agregar mensaje con la ubicación
      messages.add({
        'text': '📍 Ubicación enviada: $latitude, $longitude',
        'isMe': true,
        'timestamp': DateTime.now(),
      });
      
      // Mostrar mensaje de confirmación
      Get.snackbar(
        'Ubicación enviada',
        'Se ha compartido tu ubicación actual',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Error al obtener ubicación: $e');
      Get.snackbar(
        'Error',
        'Error al obtener ubicación: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void showUserOptionsMenu() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Opción Share user
              InkWell(
                onTap: () {
                  Get.back();
                  // TODO: Implementar compartir usuario
                },
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
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
                      const SizedBox(width: 12),
                      const Text(
                        'Share user',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Divider
              Container(
                height: 1,
                color: Colors.grey[200],
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              
              // Opción Report user
              InkWell(
                onTap: () {
                  Get.back();
                  // TODO: Implementar reportar usuario
                },
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
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
                      const SizedBox(width: 12),
                      const Text(
                        'Report user',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Future<void> initiateCall() async {
    try {
      // Obtener el nombre del destinatario desde los argumentos
      final arguments = Get.arguments;
      final recipientName = arguments?['recipientName'] ?? 'Builder';
      
      // Por ahora usamos un número de ejemplo, en una implementación real
      // esto vendría de los datos del usuario
      final phoneNumber = '+1234567890'; // Número de ejemplo
      
      // Crear la URL para llamar
      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
      
      // Verificar si se puede lanzar la URL
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
        
        // Mostrar mensaje de confirmación
        Get.snackbar(
          'Llamada iniciada',
          'Llamando a $recipientName',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        // Si no se puede abrir la app de teléfono, mostrar error
        Get.snackbar(
          'Error',
          'No se puede abrir la aplicación de teléfono',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      // Manejar errores
      Get.snackbar(
        'Error',
        'Error al iniciar la llamada: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }
}
