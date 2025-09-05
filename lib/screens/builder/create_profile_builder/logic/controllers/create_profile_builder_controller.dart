import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../../../../config/app_flavor.dart';
import '../../presentation/widgets/company_selection_dialog.dart';
import '../../presentation/pages/register_new_company_screen.dart';
import '../../../../builder/home/presentation/pages/builder_home_screen.dart';

class CreateProfileBuilderController extends GetxController {
  // Controllers para los campos de texto
  final TextEditingController firstNameController = TextEditingController(text: 'testing');
  final TextEditingController lastNameController = TextEditingController(text: 'builder');
  final TextEditingController companyNameController = TextEditingController(text: 'Test company by Yakka');
  final TextEditingController phoneController = TextEditingController(text: '2222222');
  final TextEditingController emailController = TextEditingController(text: 'testingbuilder@gmail.com');
  final TextEditingController addressController = TextEditingController();
  
  // Variables para la imagen de perfil
  final Rx<File?> profileImage = Rx<File?>(null);
  final ImagePicker picker = ImagePicker();
  
  // Lista de empresas creadas por el usuario
  final RxList<String> userCreatedCompanies = <String>[].obs;
  
  // Variables para licencias
  final RxList<Map<String, dynamic>> licenses = <Map<String, dynamic>>[].obs;
  final RxString? selectedCredential = RxString('');
  
  
  // Flavor actual
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    companyNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.onClose();
  }

  // Función para mostrar opciones de selección de imagen
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
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Seleccionar imagen',
                style: TextStyle(
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
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text('Galería'),
              subtitle: const Text('Seleccionar de la galería'),
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

  // Función para verificar y solicitar permisos
  Future<bool> requestPermissions(ImageSource source) async {
    if (source == ImageSource.camera) {
      // Solicitar permiso de cámara
      PermissionStatus status = await Permission.camera.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        Get.dialog(
          AlertDialog(
            title: const Text('Permiso de Cámara'),
            content: const Text('Esta aplicación necesita acceso a la cámara para tomar fotos. Por favor, concede el permiso en la configuración.'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  openAppSettings();
                },
                child: const Text('Configuración'),
              ),
            ],
          ),
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
  Future<void> pickImage(ImageSource source) async {
    try {
      // Verificar permisos primero
      bool hasPermission = await requestPermissions(source);
      if (!hasPermission) {
        return;
      }

      // Mostrar indicador de carga
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      // Intentar seleccionar imagen con configuración más simple
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      // Cerrar indicador de carga
      if (Get.isDialogOpen!) {
        Get.back();
      }
      
      if (image != null) {
        profileImage.value = File(image.path);
        
        // Mostrar mensaje de éxito
        Get.snackbar(
          'Éxito',
          'Imagen seleccionada exitosamente',
          backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
          colorText: Colors.black,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      // Cerrar indicador de carga si está abierto
      if (Get.isDialogOpen!) {
        Get.back();
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
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                // Si es error de cámara, sugerir usar galería
                if (source == ImageSource.camera && 
                    (e.toString().contains('channel-error') || 
                     e.toString().contains('camera') ||
                     e.toString().contains('pigeon'))) {
                  pickImage(ImageSource.gallery);
                }
              },
              child: const Text('Intentar con galería'),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      );
      
      // Log del error para debugging
      print('Error al seleccionar imagen: $e');
    }
  }

  // Función para mostrar el diálogo de selección de empresa
  void showCompanySelectionDialog() {
    print('Opening company selection dialog...');
    try {
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: CompanySelectionDialog(
            flavor: currentFlavor.value,
            onCompanySelected: (String company) {
              print('Company selected: $company');
              companyNameController.text = company;
            },
            onRegisterNewCompany: () {
              print('Register new company tapped');
              Get.toNamed(RegisterNewCompanyScreen.id, arguments: {'flavor': currentFlavor.value});
            },
            additionalCompanies: userCreatedCompanies,
          ),
        ),
      );
      print('Dialog opened successfully');
    } catch (e) {
      print('Error opening dialog: $e');
      Get.snackbar(
        'Error',
        'Error opening company selection: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void handleNext() {
    // Validar campos requeridos
    if (firstNameController.text.isEmpty || 
        lastNameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    // Navegar al paso 2
    Get.toNamed('/create-profile-step2-builder', arguments: {'flavor': currentFlavor.value});
  }

  void handleNextStep2() {
    // Validar campos requeridos
    if (emailController.text.isEmpty || 
        phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    // Navegar a la pantalla de ubicación
    Get.toNamed('/location-builder', arguments: {'flavor': currentFlavor.value});
  }

  void handleLocationContinue() {
    // Validar campo de dirección
    if (addressController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in your address',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    // Navegar a la pantalla de foto de perfil
    Get.toNamed('/profile-photo-builder', arguments: {'flavor': currentFlavor.value});
  }

  void handleProfilePhotoContinue() {
    // Navegar a la pantalla de licencias
    Get.toNamed('/license-builder', arguments: {'flavor': currentFlavor.value});
  }

  void handleLicenseContinue() {
    // Navegar a la pantalla de respeto
    Get.toNamed('/builder/respect', arguments: {'flavor': currentFlavor.value});
  }

  // Métodos para la pantalla de respeto
  void handleRespectBackNavigation() {
    Get.back();
  }

  void handleRespectCommit() {
    // Navegar a la pantalla "Let's Be Clear"
    Get.toNamed('/builder/lets-be-clear', arguments: {'flavor': currentFlavor.value});
  }

  // Métodos para la pantalla de perfil creado
  void handleStartUsingYakka() {
    // Navegar al BuilderHomeScreen usando GetX
    Get.offAllNamed(BuilderHomeScreen.id);
  }

  void handleLinkCompany() {
    // Mostrar el diálogo de selección de empresa
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: CompanySelectionDialog(
          flavor: currentFlavor.value,
          onCompanySelected: (String company) {
            // Actualizar el campo de nombre de empresa
            companyNameController.text = company;
            
            // Mostrar mensaje de éxito
            Get.snackbar(
              'Empresa seleccionada',
              'Has seleccionado: $company',
              backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
              colorText: Colors.black,
            );
            
            // Navegar al home después de seleccionar
            Get.offAllNamed(BuilderHomeScreen.id);
          },
          onRegisterNewCompany: () {
            // Navegar a la pantalla de registro de nueva empresa
            Get.toNamed('/register-new-company', arguments: {'flavor': currentFlavor.value});
          },
        ),
      ),
    );
  }

  void addUserCompany(String company) {
    print('Adding user company: $company');
    if (!userCreatedCompanies.contains(company)) {
      userCreatedCompanies.add(company);
      print('Company added to list. Total companies: ${userCreatedCompanies.length}');
    } else {
      print('Company already exists in list');
    }
    
    // Solo actualizar el controller si no está disposed
    try {
      companyNameController.text = company;
      print('Updated companyNameController with: $company');
    } catch (e) {
      print('Warning: Could not update companyNameController, it may be disposed: $e');
      // No es crítico si no se puede actualizar el controller
    }
  }


  // Métodos para manejar licencias
  void addLicense() {
    if (selectedCredential?.value != null && selectedCredential!.value.isNotEmpty) {
      licenses.add({
        'type': selectedCredential!.value,
        'uploaded': false,
        'file': '',
        'path': '',
        'size': null,
      });
      selectedCredential?.value = '';
    }
  }

  void removeLicense(int index) {
    if (index >= 0 && index < licenses.length) {
      licenses.removeAt(index);
    }
  }

  Future<void> uploadLicense(int index) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        licenses[index]['uploaded'] = true;
        licenses[index]['file'] = file.name;
        licenses[index]['path'] = file.path;
        licenses[index]['size'] = file.size;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al subir archivo: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void showCredentialDropdown() {
    final List<String> credentials = [
      'Driver License',
      'Passport',
      'Birth Certificate',
      'Work Visa',
      'Trade Certificate',
      'White Card',
      'First Aid Certificate',
      'Forklift License',
      'Crane License',
      'Excavator License',
      'Other',
    ];

    Get.bottomSheet(
      Container(
        height: MediaQuery.of(Get.context!).size.height * 0.6, // Limitar altura al 60% de la pantalla
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
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
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Select Credential',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: credentials.length,
                itemBuilder: (context, index) {
                  final credential = credentials[index];
                  return ListTile(
                    title: Text(credential),
                    onTap: () {
                      selectedCredential?.value = credential;
                      Get.back();
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
