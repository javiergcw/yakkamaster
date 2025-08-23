import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../../../../config/app_flavor.dart';
import '../../../../config/assets_config.dart';
import '../../../../features/widgets/custom_button.dart';
import '../../../../features/widgets/custom_text_field.dart';
import '../../../../features/widgets/phone_input.dart';
import 'skills_experience_screen.dart';

class CreateProfileScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const CreateProfileScreen({
    super.key,
    this.flavor,
  });

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  
  // Controllers para los campos de texto
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(text: '0412345678');
  final TextEditingController _emailController = TextEditingController(text: 'testing22@gmail.com');
  final TextEditingController _birthCountryController = TextEditingController();
  
  // Variables para la imagen de perfil
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // Sombras tipo tarjeta (igual que en industry_selection_screen)
  final List<BoxShadow> strongCardShadows = const [
    BoxShadow(
      color: Color(0xFF000000), // 100% negro (totalmente negro)
      offset: Offset(6, 8),
      blurRadius: 0,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0xFF000000), // 100% negro (totalmente negro)
      offset: Offset(0, 18),
      blurRadius: 28,
      spreadRadius: 0,
    ),
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _birthCountryController.dispose();
    super.dispose();
  }

  // Función para mostrar opciones de selección de imagen
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
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
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Seleccionar imagen',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Cámara'),
                subtitle: const Text('Tomar una nueva foto'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: const Text('Galería'),
                subtitle: const Text('Seleccionar de la galería'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // Función para verificar y solicitar permisos
  Future<bool> _requestPermissions(ImageSource source) async {
    if (source == ImageSource.camera) {
      // Solicitar permiso de cámara
      PermissionStatus status = await Permission.camera.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Permiso de Cámara'),
              content: const Text('Esta aplicación necesita acceso a la cámara para tomar fotos. Por favor, concede el permiso en la configuración.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    openAppSettings();
                  },
                  child: const Text('Configuración'),
                ),
              ],
            );
          },
        );
        return false;
      }
      return status.isGranted;
    } else {
      // Para galería, verificar permisos de almacenamiento
      PermissionStatus status = await Permission.photos.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        // Intentar con permisos de almacenamiento como fallback
        status = await Permission.storage.request();
      }
      return status.isGranted;
    }
  }

  // Función para seleccionar imagen
  Future<void> _pickImage(ImageSource source) async {
    try {
      // Verificar permisos primero
      bool hasPermission = await _requestPermissions(source);
      if (!hasPermission) {
        return;
      }

      // Mostrar indicador de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Intentar seleccionar imagen con configuración más simple
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      // Cerrar indicador de carga
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
        
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Imagen seleccionada exitosamente'),
            backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Cerrar indicador de carga si está abierto
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      // Manejo específico de errores
      String errorMessage = 'Error al seleccionar imagen';
      
      if (e.toString().contains('channel-error')) {
        errorMessage = 'Error de comunicación. Intenta:\n1. Reiniciar la app\n2. Verificar permisos de cámara\n3. Usar galería en lugar de cámara';
      } else if (e.toString().contains('permission')) {
        errorMessage = 'Permisos no concedidos. Ve a:\nConfiguración > Aplicaciones > Yakka Sports > Permisos';
      } else if (e.toString().contains('camera')) {
        errorMessage = 'Error al acceder a la cámara. Intenta usar la galería.';
      } else if (e.toString().contains('pigeon')) {
        errorMessage = 'Error interno del plugin. Intenta:\n1. Reiniciar la app\n2. Usar galería en lugar de cámara';
      }
      
      // Mostrar diálogo de error más informativo
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Si es error de cámara, sugerir usar galería
                  if (source == ImageSource.camera && 
                      (e.toString().contains('channel-error') || 
                       e.toString().contains('camera') ||
                       e.toString().contains('pigeon'))) {
                    _pickImage(ImageSource.gallery);
                  }
                },
                child: const Text('Intentar con galería'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ],
          );
        },
      );
      
      // Log del error para debugging
      print('Error al seleccionar imagen: $e');
    }
  }

  void _handleNext() {
    // Validar campos requeridos
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }
    
    // Navegar a la pantalla de habilidades
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SkillsExperienceScreen(flavor: _currentFlavor),
      ),
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
    final profileImageSize = screenWidth * 0.25; // 25% del ancho para la imagen de perfil
    final editIconSize = screenWidth * 0.06;
    final cameraIconSize = screenWidth * 0.08;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: verticalSpacing),
                    
                    // Header con botón de retroceso y título
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: screenWidth * 0.065,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "Create profile",
                              style: GoogleFonts.poppins(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.065), // Espacio para balancear el layout
                      ],
                    ),

                    SizedBox(height: verticalSpacing * 2),

                    // Imagen de perfil con botón de edición
                    Center(
                      child: GestureDetector(
                        onTap: _showImageSourceDialog,
                        child: Stack(
                          children: [
                            // Círculo principal de la imagen de perfil
                            Container(
                              width: profileImageSize,
                              height: profileImageSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 2,
                                ),
                                // Sin sombra
                              ),
                              child: _profileImage != null
                                  ? ClipOval(
                                      child: Image.file(
                                        _profileImage!,
                                        width: profileImageSize,
                                        height: profileImageSize,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(
                                      Icons.camera_alt,
                                      size: cameraIconSize,
                                      color: Colors.grey[600],
                                    ),
                            ),
                            
                            // Botón de edición (círculo amarillo con icono de lápiz)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: editIconSize,
                                height: editIconSize,
                                decoration: BoxDecoration(
                                  color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                  shape: BoxShape.circle,
                                  // Sin sombra
                                ),
                                child: Icon(
                                  Icons.edit,
                                  size: editIconSize * 0.5,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 3),

                    // Campos de entrada
                    CustomTextField(
                      controller: _firstNameController,
                      hintText: "First Name",
                      showBorder: true,
                    ),

                    SizedBox(height: verticalSpacing * 1.5),

                    CustomTextField(
                      controller: _lastNameController,
                      hintText: "Last Name",
                      showBorder: true,
                    ),

                    SizedBox(height: verticalSpacing * 1.5),

                    // Campo de teléfono usando el componente PhoneInput
                    PhoneInput(
                      controller: _phoneController,
                    ),

                    SizedBox(height: verticalSpacing * 1.5),

                    CustomTextField(
                      controller: _emailController,
                      hintText: "Email",
                      showBorder: true,
                    ),

                    SizedBox(height: verticalSpacing * 1.5),

                    CustomTextField(
                      controller: _birthCountryController,
                      hintText: "Enter your birth country",
                      showBorder: true,
                    ),

                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom + verticalSpacing * 3),

                    // Botón Next con sombra personalizada
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: strongCardShadows,
                      ),
                      child: CustomButton(
                        text: "Next",
                        onPressed: _handleNext,
                        isLoading: false,
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 2),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
