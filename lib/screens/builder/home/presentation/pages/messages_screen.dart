import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../logic/controllers/messages_screen_controller.dart';

class MessagesScreen extends StatelessWidget {
  static const String id = '/builder/messages';
  
  final AppFlavor? flavor;
  MessagesScreen({super.key, this.flavor});

  final MessagesScreenController controller = Get.put(MessagesScreenController());

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final nameFontSize = screenWidth * 0.04;
    final messageFontSize = screenWidth * 0.035;
    final timestampFontSize = screenWidth * 0.03;
    final avatarSize = screenWidth * 0.12;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header con título
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing * 2,
              ),
                                                          decoration: BoxDecoration(
                  color: Colors.grey[800],
                ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => controller.navigateToHome(),
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: screenWidth * 0.065,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Messages",
                      style: GoogleFonts.poppins(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.065),
                ],
              ),
            ),

            // Lista de mensajes
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return _buildMessageItem(
                    message,
                    horizontalPadding,
                    verticalSpacing,
                    nameFontSize,
                    messageFontSize,
                    timestampFontSize,
                    avatarSize,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem(
    Map<String, dynamic> message,
    double horizontalPadding,
    double verticalSpacing,
    double nameFontSize,
    double messageFontSize,
    double timestampFontSize,
    double avatarSize,
  ) {
    return GestureDetector(
      onTap: () => controller.handleMessageTap(message),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalSpacing * 1.5,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[300]!,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                color: const Color(0xFF4A4A4A),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  message['avatar'],
                  style: GoogleFonts.poppins(
                    fontSize: avatarSize * 0.4,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            SizedBox(width: horizontalPadding * 0.8),
            
            // Contenido del mensaje
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre y timestamp
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message['name'],
                          style: GoogleFonts.poppins(
                            fontSize: nameFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        message['timestamp'],
                        style: GoogleFonts.poppins(
                          fontSize: timestampFontSize,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: verticalSpacing * 0.3),
                  
                  // Último mensaje
                  Text(
                    message['lastMessage'],
                    style: GoogleFonts.poppins(
                      fontSize: messageFontSize,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Indicador de mensajes no leídos
            if (message['unreadCount'] > 0) ...[
              SizedBox(width: horizontalPadding * 0.5),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding * 0.3,
                  vertical: verticalSpacing * 0.2,
                ),
                decoration: BoxDecoration(
                  color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message['unreadCount'].toString(),
                  style: GoogleFonts.poppins(
                    fontSize: timestampFontSize * 0.8,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
