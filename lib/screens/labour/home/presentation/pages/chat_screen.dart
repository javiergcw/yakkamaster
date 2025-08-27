import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';

class ChatScreen extends StatefulWidget {
  final String recipientName;
  final String recipientAvatar;
  final AppFlavor? flavor;

  const ChatScreen({
    super.key,
    required this.recipientName,
    required this.recipientAvatar,
    this.flavor,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final GlobalKey _quickChatButtonKey = GlobalKey();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _messageController.text.trim(),
          'isMe': true,
          'timestamp': DateTime.now(),
        });
      });
      _messageController.clear();
    }
  }

  void _showQuickChatOptions() {
    final RenderBox? button = _quickChatButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (button == null) return;
    
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      color: const Color(0xFF4A4A4A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      items: [
        PopupMenuItem(
          enabled: false,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
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
        ),
      ],
    );
  }

  Widget _buildQuickMessageBubble(String message) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        _addQuickMessage(message);
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

     void _addQuickMessage(String message) {
     setState(() {
       _messages.add({
         'text': message,
         'isMe': true,
         'timestamp': DateTime.now(),
       });
     });
   }

   void _showImageSourceDialog() {
     showModalBottomSheet(
       context: context,
       backgroundColor: Colors.transparent,
       builder: (context) => Container(
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
             Padding(
               padding: const EdgeInsets.all(20),
               child: Text(
                 'Select image source',
                 style: GoogleFonts.poppins(
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
                 Navigator.of(context).pop();
                 _pickImage(ImageSource.camera);
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
                 Navigator.of(context).pop();
                 _pickImage(ImageSource.gallery);
               },
             ),
             
             const SizedBox(height: 20),
           ],
         ),
       ),
     );
   }

   Future<void> _pickImage(ImageSource source) async {
     try {
       final ImagePicker picker = ImagePicker();
       final XFile? image = await picker.pickImage(source: source);
       
       if (image != null) {
         // TODO: Implementar lógica para enviar la imagen
         print('Imagen seleccionada: ${image.path}');
         
         // Por ahora, agregar un mensaje de texto indicando que se seleccionó una imagen
         setState(() {
           _messages.add({
             'text': '📷 Imagen enviada',
             'isMe': true,
             'timestamp': DateTime.now(),
           });
         });
       }
     } catch (e) {
       print('Error al seleccionar imagen: $e');
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content: Text('Error al seleccionar imagen: $e'),
             backgroundColor: Colors.red,
           ),
         );
       }
     }
   }

   void _showUserOptionsMenu() {
     final double screenWidth = MediaQuery.of(context).size.width;
     final double screenHeight = MediaQuery.of(context).size.height;
     final double horizontalPadding = screenWidth * 0.04;
     final double verticalSpacing = screenHeight * 0.02;

     // Posicionar el menú en la esquina superior derecha de la pantalla
     // con un pequeño padding desde los bordes
     final RelativeRect position = RelativeRect.fromLTRB(
       screenWidth - 200 - horizontalPadding, // Left: screenWidth - menuWidth - paddingRight
       verticalSpacing, // Top: paddingTop
       horizontalPadding, // Right: paddingRight
       screenHeight - verticalSpacing, // Bottom: valor grande para permitir que el menú crezca hacia abajo
     );

           showMenu(
        context: context,
        position: position,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
        elevation: 12,
        constraints: const BoxConstraints(
          minWidth: 180,
          maxWidth: 200,
        ),
        items: [
          PopupMenuItem(
            height: 48,
            child: Row(
              children: [
                Container(
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
                const SizedBox(width: 16),
                Text(
                  'Share user',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            onTap: () {
              // TODO: Implementar compartir usuario
            },
          ),
          PopupMenuItem(
            height: 48,
            child: Row(
              children: [
                Container(
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
                const SizedBox(width: 16),
                Text(
                  'Report user',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            onTap: () {
              // TODO: Implementar reportar usuario
            },
          ),
                     PopupMenuItem(
             enabled: false,
             height: 1,
             child: Container(
               height: 1,
               color: Colors.grey[200],
             ),
           ),
          PopupMenuItem(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Close',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            onTap: () {
              // Solo cerrar el menú
            },
          ),
        ],
      );
   }

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () => Navigator.of(context).pop(),
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
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A4A4A),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.recipientAvatar,
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
                      widget.recipientName,
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
                      // TODO: Implementar llamada
                    },
                    icon: Icon(
                      Icons.call,
                      color: Colors.black,
                      size: screenWidth * 0.05,
                    ),
                  ),
                  
                                     IconButton(
                     onPressed: _showUserOptionsMenu,
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
                     child: _messages.isEmpty
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
                             itemCount: _messages.length,
                             itemBuilder: (context, index) {
                               final message = _messages[index];
                               return _buildMessageBubble(message, horizontalPadding, verticalSpacing, inputFontSize);
                             },
                           ),
                   ),
                   
                                                           // Botón Quick Chat (flotante)
                    if (_messages.isEmpty)
                      Positioned(
                        bottom: verticalSpacing * 2,
                        right: horizontalPadding,
                        child: GestureDetector(
                          key: _quickChatButtonKey,
                          onTap: _showQuickChatOptions,
                         child: Container(
                           padding: EdgeInsets.symmetric(
                             horizontal: horizontalPadding * 0.6,
                             vertical: verticalSpacing * 0.8,
                           ),
                           decoration: BoxDecoration(
                             color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
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
                     onPressed: _showImageSourceDialog,
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
                        controller: _messageController,
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
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  
                                     SizedBox(width: horizontalPadding * 0.3),
                   
                   // Botón de cámara
                   Container(
                     width: buttonSize * 0.8,
                     height: buttonSize * 0.8,
                     decoration: BoxDecoration(
                       color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                       borderRadius: BorderRadius.circular((buttonSize * 0.8) / 2),
                     ),
                     child: IconButton(
                       onPressed: () {
                         // TODO: Implementar cámara
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
                       color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                       borderRadius: BorderRadius.circular((buttonSize * 0.8) / 2),
                     ),
                     child: IconButton(
                       onPressed: () {
                         // TODO: Implementar traducción
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
                       onPressed: _sendMessage,
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
                  ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
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
