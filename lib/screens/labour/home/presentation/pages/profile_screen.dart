import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../config/assets_config.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/constants.dart';
import '../widgets/profile_menu_item.dart';
import 'edit_personal_details_screen.dart';
import 'edit_documents_screen.dart';
import 'edit_bank_details_screen.dart';

class ProfileScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const ProfileScreen({
    super.key,
    this.flavor,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  


  void _handleHelp() async {
    // Crear URL de WhatsApp usando las constantes generales
    final String whatsappUrl = 'https://wa.me/${AppConstants.whatsappSupportNumber}?text=${Uri.encodeComponent(AppConstants.whatsappSupportMessage)}';
    
    try {
      // Intentar abrir WhatsApp
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(
          Uri.parse(whatsappUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Si no se puede abrir WhatsApp, mostrar mensaje
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('No se pudo abrir WhatsApp. Asegúrate de tener la aplicación instalada.'),
              backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
            ),
          );
        }
      }
    } catch (e) {
      // Manejar errores
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al abrir WhatsApp: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleEditPersonalDetails() {
    // Navegar a la pantalla de edición de detalles personales
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditPersonalDetailsScreen(flavor: _currentFlavor),
      ),
    );
  }

  void _handleEditDocuments() {
    // Navegar a la pantalla de edición de documentos
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditDocumentsScreen(flavor: _currentFlavor),
      ),
    );
  }

  void _handleEditBankDetails() {
    // Navegar a la pantalla de edición de detalles bancarios
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditBankDetailsScreen(flavor: _currentFlavor),
      ),
    );
  }

  void _handleTermsAndConditions() async {
    try {
      print('Intentando abrir URL: ${AppConstants.termsAndConditionsUrl}');
      
      // Intentar abrir la URL directamente
      final bool launched = await launchUrl(
        Uri.parse(AppConstants.termsAndConditionsUrl),
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No se pudo abrir los términos y condiciones.'),
            backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
          ),
        );
      }
    } catch (e) {
      print('Error al abrir términos y condiciones: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al abrir términos y condiciones: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleDeleteAccount() async {
    try {
      print('Intentando abrir URL de eliminación de cuenta: ${AppConstants.deleteAccountUrl}');
      
      // Intentar abrir la URL directamente
      final bool launched = await launchUrl(
        Uri.parse(AppConstants.deleteAccountUrl),
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No se pudo abrir el formulario de eliminación de cuenta.'),
            backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
          ),
        );
      }
    } catch (e) {
      print('Error al abrir formulario de eliminación de cuenta: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al abrir formulario de eliminación de cuenta: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleLogOut() {
    // TODO: Implementar logout
    print('Log out pressed');
  }

  void _handleEditProfileImage() {
    _showImageSourceDialog();
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: Text(
            'Seleccionar imagen',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))),
                title: Text(
                  'Cámara',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))),
                title: Text(
                  'Galería',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      // Solicitar permisos
      if (source == ImageSource.camera) {
        final status = await Permission.camera.request();
        if (!status.isGranted) {
          _showPermissionDeniedDialog('cámara');
          return;
        }
      } else {
        final status = await Permission.photos.request();
        if (!status.isGranted) {
          _showPermissionDeniedDialog('galería');
          return;
        }
      }

      // Seleccionar imagen
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
        print('Imagen seleccionada: ${image.path}');
      }
    } catch (e) {
      print('Error al seleccionar imagen: $e');
      _showErrorDialog('Error al seleccionar la imagen');
    }
  }

  void _showPermissionDeniedDialog(String permission) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: Text(
            'Permiso requerido',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Se necesita permiso para acceder a la $permission. Por favor, habilita el permiso en la configuración de la aplicación.',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: GoogleFonts.poppins(
                  color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: Text(
                'Configuración',
                style: GoogleFonts.poppins(
                  color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: Text(
            'Error',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: GoogleFonts.poppins(
                  color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                ),
              ),
            ),
          ],
        );
      },
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
    final titleFontSize = screenWidth * 0.055;
    final subtitleFontSize = screenWidth * 0.035;
    final statsFontSize = screenWidth * 0.045;
    final statsLabelFontSize = screenWidth * 0.03;
    final profileImageSize = screenWidth * 0.2; // Reducido de 0.25 a 0.2

    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C), // Fondo gris oscuro
      body: SafeArea(
        child: Column(
          children: [
                         // Header con información del perfil
             Container(
               width: double.infinity,
               padding: EdgeInsets.symmetric(
                 horizontal: horizontalPadding,
                 vertical: verticalSpacing * 1.5, // Reducido de 3 a 1.5
               ),
              child: Column(
                children: [
                                     // Foto de perfil con botón de actualización
                   Center(
                     child: Stack(
                       children: [
                         // Foto de perfil principal
                         Container(
                           width: profileImageSize,
                           height: profileImageSize,
                           decoration: BoxDecoration(
                             color: const Color(0xFF4A6741), // Verde oscuro
                             shape: BoxShape.circle,
                           ),
                           child: _selectedImage != null
                               ? ClipOval(
                                   child: Image.file(
                                     File(_selectedImage!.path),
                                     width: profileImageSize,
                                     height: profileImageSize,
                                     fit: BoxFit.cover,
                                   ),
                                 )
                               : Center(
                                   child: Icon(
                                     Icons.person,
                                     size: profileImageSize * 0.6,
                                     color: const Color(0xFF8BC34A), // Verde claro
                                   ),
                                 ),
                         ),
                         
                         // Botón de edición de imagen
                         Positioned(
                           bottom: 0,
                           right: 0,
                           child: GestureDetector(
                             onTap: _handleEditProfileImage,
                             child: Container(
                               width: profileImageSize * 0.35,
                               height: profileImageSize * 0.35,
                               decoration: BoxDecoration(
                                 color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                 shape: BoxShape.circle,
                                 border: Border.all(
                                   color: const Color(0xFF2C2C2C),
                                   width: 2,
                                 ),
                                 boxShadow: [
                                   BoxShadow(
                                     color: Colors.black.withOpacity(0.3),
                                     offset: const Offset(0, 2),
                                     blurRadius: 4,
                                   ),
                                 ],
                               ),
                               child: Icon(
                                 Icons.edit,
                                 size: profileImageSize * 0.2,
                                 color: Colors.white,
                               ),
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                  
                  SizedBox(height: verticalSpacing), // Reducido de 2 a 1
                  
                  // Nombre del usuario
                  Text(
                    "testing testing",
                    style: GoogleFonts.poppins(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing * 0.5), // Reducido de 1 a 0.5
                  
                  // ID de la empresa
                  Text(
                    "Company linked: user ID #0",
                    style: GoogleFonts.poppins(
                      fontSize: subtitleFontSize,
                      color: Colors.grey[400],
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing), // Reducido de 2 a 1
                  
                  // Estadísticas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Jobs
                      Column(
                        children: [
                          Text(
                            "0",
                            style: GoogleFonts.poppins(
                              fontSize: statsFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Jobs",
                            style: GoogleFonts.poppins(
                              fontSize: statsLabelFontSize,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      
                      // Separador vertical
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: horizontalPadding * 1.5),
                        width: 1,
                        height: verticalSpacing * 2, // Reducido de 3 a 2
                        color: Colors.white,
                      ),
                      
                      // Rating
                      Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "5.0",
                                style: GoogleFonts.poppins(
                                  fontSize: statsFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.star,
                                size: statsFontSize * 0.8,
                                color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                              ),
                            ],
                          ),
                          Text(
                            "Rating",
                            style: GoogleFonts.poppins(
                              fontSize: statsLabelFontSize,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Lista de opciones del menú
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ProfileMenuItem(
                      icon: Icons.chat,
                      title: "Help",
                      onTap: _handleHelp,
                      flavor: _currentFlavor,
                    ),
                    ProfileMenuItem(
                      icon: Icons.person,
                      title: "Edit personal details",
                      onTap: _handleEditPersonalDetails,
                      flavor: _currentFlavor,
                    ),
                    ProfileMenuItem(
                      icon: Icons.qr_code,
                      title: "Edit documents",
                      onTap: _handleEditDocuments,
                      flavor: _currentFlavor,
                    ),
                    ProfileMenuItem(
                      icon: Icons.account_balance,
                      title: "Edit bank details",
                      onTap: _handleEditBankDetails,
                      flavor: _currentFlavor,
                    ),
                    ProfileMenuItem(
                      icon: Icons.description,
                      title: "Terms and conditions",
                      onTap: _handleTermsAndConditions,
                      flavor: _currentFlavor,
                    ),
                    ProfileMenuItem(
                      icon: Icons.delete,
                      title: "Delete account",
                      onTap: _handleDeleteAccount,
                      flavor: _currentFlavor,
                    ),
                    ProfileMenuItem(
                      icon: Icons.logout,
                      title: "Log out",
                      onTap: _handleLogOut,
                      flavor: _currentFlavor,
                    ),
                  ],
                ),
              ),
            ),
            
                         SizedBox(height: verticalSpacing), // Reducido de 2 a 1
          ],
        ),
      ),
    );
  }
}
