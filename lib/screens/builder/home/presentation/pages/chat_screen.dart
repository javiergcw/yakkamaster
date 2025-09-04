import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../logic/controllers/chat_screen_controller.dart';

class ChatScreen extends StatelessWidget {
  static const String id = '/builder/chat';
  
  final String recipientName;
  final String recipientAvatar;
  final AppFlavor? flavor;

  ChatScreen({
    super.key,
    required this.recipientName,
    required this.recipientAvatar,
    this.flavor,
  });

  final ChatScreenController controller = Get.put(ChatScreenController());

  @override
  Widget build(BuildContext context) {
    // Establecer los datos del destinatario en el controlador
    controller.recipientName = recipientName;
    controller.recipientAvatar = recipientAvatar;
    if (flavor != null) {
      controller.currentFlavor.value = flavor!;
    }

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.045;
    final inputFontSize = screenWidth * 0.035;
    final avatarSize = screenWidth * 0.1;
    final buttonSize = screenWidth * 0.12;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header con información del destinatario
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing * 1.5,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => controller.navigateBack(),
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: screenWidth * 0.065,
                    ),
                  ),
                  
                  // Avatar del destinatario
                  Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4A4A4A),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        recipientAvatar,
                        style: GoogleFonts.poppins(
                          fontSize: avatarSize * 0.4,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(width: horizontalPadding * 0.5),
                  
                  // Nombre del destinatario
                  Expanded(
                    child: Text(
                      recipientName,
                      style: GoogleFonts.poppins(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  
                  // Iconos de acción
                  IconButton(
                    onPressed: () {
                      controller.makeCall();
                    },
                    icon: Icon(
                      Icons.call,
                      color: Colors.black,
                      size: screenWidth * 0.05,
                    ),
                  ),
                  
                  IconButton(
                    onPressed: controller.showUserOptionsMenu,
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                      size: screenWidth * 0.05,
                    ),
                  ),
                ],
              ),
            ),

            // Área de mensajes
            Expanded(
              child: Stack(
                children: [
                  Container(
                    color: Colors.white,
                    child: Obx(() => controller.messages.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  size: screenWidth * 0.15,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: verticalSpacing),
                                Text(
                                  'No messages yet',
                                  style: GoogleFonts.poppins(
                                    fontSize: inputFontSize,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(horizontalPadding),
                            itemCount: controller.messages.length,
                            itemBuilder: (context, index) {
                              final message = controller.messages[index];
                              return _buildMessageBubble(message, horizontalPadding, verticalSpacing, inputFontSize);
                            },
                          ),
                    ),
                  ),
                  
                  // Botón Quick Chat (flotante)
                  Obx(() => controller.messages.isEmpty
                      ? Positioned(
                          bottom: verticalSpacing * 2,
                          right: horizontalPadding,
                          child: GestureDetector(
                            key: controller.quickChatButtonKey,
                            onTap: controller.showQuickChatOptions,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding * 0.6,
                                vertical: verticalSpacing * 0.8,
                              ),
                              decoration: BoxDecoration(
                                color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Text(
                                'Quick\nchat',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: inputFontSize * 0.7,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),

            // Barra de entrada de mensajes
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border(
                  top: BorderSide(
                    color: Colors.grey[300]!,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Botón de adjuntar
                  IconButton(
                    onPressed: controller.showImageSourceDialog,
                    icon: Icon(
                      Icons.attach_file,
                      color: Colors.grey[600],
                      size: screenWidth * 0.05,
                    ),
                  ),
                  
                  // Campo de texto
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding * 0.8,
                        vertical: verticalSpacing * 0.8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: controller.messageController,
                        style: GoogleFonts.poppins(
                          fontSize: inputFontSize,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Write your message',
                          hintStyle: GoogleFonts.poppins(
                            fontSize: inputFontSize,
                            color: Colors.grey[600],
                          ),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => controller.sendMessage(),
                      ),
                    ),
                  ),
                  
                  SizedBox(width: horizontalPadding * 0.3),
                  
                  // Botón de cámara
                  Container(
                    width: buttonSize * 0.8,
                    height: buttonSize * 0.8,
                    decoration: BoxDecoration(
                      color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                      borderRadius: BorderRadius.circular((buttonSize * 0.8) / 2),
                    ),
                    child: IconButton(
                      onPressed: () {
                        controller.openCamera();
                      },
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                        size: screenWidth * 0.04,
                      ),
                    ),
                  ),
                  
                  SizedBox(width: horizontalPadding * 0.2),
                  
                  // Botón de traducción
                  Container(
                    width: buttonSize * 0.8,
                    height: buttonSize * 0.8,
                    decoration: BoxDecoration(
                      color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                      borderRadius: BorderRadius.circular((buttonSize * 0.8) / 2),
                    ),
                    child: IconButton(
                      onPressed: () {
                        controller.translateMessage();
                      },
                      icon: Text(
                        'A文',
                        style: GoogleFonts.poppins(
                          fontSize: inputFontSize * 0.7,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(width: horizontalPadding * 0.2),
                  
                  // Botón de enviar
                  Container(
                    width: buttonSize * 0.8,
                    height: buttonSize * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular((buttonSize * 0.8) / 2),
                    ),
                    child: IconButton(
                      onPressed: controller.sendMessage,
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: screenWidth * 0.04,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(
    Map<String, dynamic> message,
    double horizontalPadding,
    double verticalSpacing,
    double fontSize,
  ) {
    final isMe = message['isMe'] as bool;
    
    return Container(
      margin: EdgeInsets.only(
        bottom: verticalSpacing,
        left: isMe ? horizontalPadding * 2 : 0,
        right: isMe ? 0 : horizontalPadding * 2,
      ),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalSpacing,
            ),
            decoration: BoxDecoration(
              color: isMe 
                  ? Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value))
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              message['text'],
              style: GoogleFonts.poppins(
                fontSize: fontSize,
                color: isMe ? Colors.black : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
