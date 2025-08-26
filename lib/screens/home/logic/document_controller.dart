import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../data/models/document_model.dart';
import '../data/services/file_upload_service.dart';

class DocumentController extends GetxController {
  final FileUploadService _fileUploadService = FileUploadService();
  
  final RxList<DocumentModel> documents = <DocumentModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isUploading = false.obs;
  final RxDouble uploadProgress = 0.0.obs;
  final RxString selectedCredential = ''.obs;
  final RxString uploadingFileName = ''.obs;

  final List<String> credentials = [
    'Driver License',
    'Forklift License',
    'White Card',
    'First Aid Certificate',
    'Working at Heights',
    'Confined Spaces',
    'Other'
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeDocuments();
  }

  void _initializeDocuments() {
    // Inicializar con documentos por defecto
    documents.value = [
      DocumentModel(
        id: '1',
        type: 'Resume',
        fileName: 'resume.pdf',
        isUploaded: true,
        fileSize: 1024000,
        localPath: '/path/to/resume.pdf',
        serverId: 'server_1', // ID del servidor para archivos quemados
      ),
      DocumentModel(
        id: '2',
        type: 'Cover letter',
        fileName: '',
        isUploaded: false,
      ),
      DocumentModel(
        id: '3',
        type: 'Police check',
        fileName: 'police_check.pdf',
        isUploaded: true,
        fileSize: 512000,
        localPath: '/path/to/police_check.pdf',
        serverId: 'server_3', // ID del servidor para archivos quemados
      ),
      DocumentModel(
        id: '4',
        type: 'Other',
        fileName: '',
        isUploaded: false,
      ),
    ];
  }

  void setSelectedCredential(String credential) {
    selectedCredential.value = credential;
  }

  Future<void> addCredential() async {
    if (selectedCredential.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Por favor selecciona un tipo de credencial',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF0000),
        colorText: const Color(0xFFFFFFFF),
      );
      return;
    }

    // Aquí podrías implementar la lógica para agregar credenciales
    Get.snackbar(
      'Éxito',
      'Credencial ${selectedCredential.value} agregada',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF4CAF50),
      colorText: const Color(0xFFFFFFFF),
    );
  }

  Future<void> uploadDocument(int index) async {
    try {
      // Mostrar selector de archivos
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result == null) {
        Get.snackbar(
          'Info',
          'Selección de archivo cancelada',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFF9800),
          colorText: const Color(0xFFFFFFFF),
        );
        return;
      }

      PlatformFile platformFile = result.files.first;
      
      if (platformFile.path == null) {
        Get.snackbar(
          'Error',
          'No se pudo obtener la ruta del archivo',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFF0000),
          colorText: const Color(0xFFFFFFFF),
        );
        return;
      }

      File file = File(platformFile.path!);
      
      // Actualizar el documento localmente primero
      documents[index] = documents[index].copyWith(
        fileName: platformFile.name,
        localPath: platformFile.path,
        fileSize: platformFile.size,
        isUploaded: false, // Se marcará como true después de subir al servidor
      );

      // Mostrar indicador de carga
      isUploading.value = true;
      uploadProgress.value = 0.0;
      uploadingFileName.value = platformFile.name;

      // Subir archivo al servidor
      final uploadResult = await _fileUploadService.uploadDocument(
        file: file,
        documentType: documents[index].type,
        userId: 'current_user_id', // Reemplazar con el ID real del usuario
        onProgress: (int sent, int total) {
          uploadProgress.value = (sent / total * 100);
        },
      );

      if (uploadResult['success']) {
        // Actualizar documento con información del servidor
        documents[index] = documents[index].copyWith(
          isUploaded: true,
          uploadedAt: DateTime.now(),
          serverId: uploadResult['data']?['documentId'],
          fileUrl: uploadResult['data']?['fileUrl'],
        );

        Get.snackbar(
          'Éxito',
          '${documents[index].type} subido exitosamente: ${platformFile.name}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: const Color(0xFFFFFFFF),
        );
      } else {
        // Revertir cambios si falló la subida
        documents[index] = documents[index].copyWith(
          fileName: '',
          localPath: null,
          fileSize: null,
          isUploaded: false,
        );

        Get.snackbar(
          'Error',
          uploadResult['message'] ?? 'Error al subir el archivo',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFF0000),
          colorText: const Color(0xFFFFFFFF),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error inesperado: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF0000),
        colorText: const Color(0xFFFFFFFF),
      );
    } finally {
      isUploading.value = false;
      uploadProgress.value = 0.0;
      uploadingFileName.value = '';
    }
  }

  Future<void> deleteDocument(int index) async {
    final document = documents[index];
    
    // Confirmar eliminación siempre, sin importar si está subido o no
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Eliminar documento'),
        content: Text('¿Estás seguro de que quieres eliminar ${document.type}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (result != true) return;

    try {
      // Si tiene serverId (está subido al servidor), intentar eliminar del servidor
      if (document.serverId != null && document.serverId!.isNotEmpty) {
        final deleteResult = await _fileUploadService.deleteDocument(
          documentId: document.serverId!,
          userId: 'current_user_id', // Reemplazar con el ID real del usuario
        );

        if (!deleteResult['success']) {
          Get.snackbar(
            'Error',
            deleteResult['message'] ?? 'Error al eliminar del servidor',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFFFF0000),
            colorText: const Color(0xFFFFFFFF),
          );
          return;
        }
      }

      // Eliminar localmente siempre
      documents[index] = document.copyWith(
        fileName: '',
        localPath: null,
        fileSize: null,
        isUploaded: false,
        serverId: null,
        fileUrl: null,
        uploadedAt: null,
      );

      Get.snackbar(
        'Éxito',
        '${document.type} eliminado',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50),
        colorText: const Color(0xFFFFFFFF),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al eliminar: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF0000),
        colorText: const Color(0xFFFFFFFF),
      );
    }
  }

  Future<void> loadUserDocuments() async {
    try {
      isLoading.value = true;
      
      final result = await _fileUploadService.getUserDocuments(
        userId: 'current_user_id', // Reemplazar con el ID real del usuario
      );

      if (result['success']) {
        final List<dynamic> documentsData = result['data'] ?? [];
        documents.value = documentsData
            .map((doc) => DocumentModel.fromJson(doc))
            .toList();
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Error al cargar documentos',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFF0000),
          colorText: const Color(0xFFFFFFFF),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error inesperado: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF0000),
        colorText: const Color(0xFFFFFFFF),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void saveDocuments() {
    // Aquí podrías implementar la lógica para guardar los cambios
    Get.snackbar(
      'Éxito',
      'Documentos actualizados exitosamente',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF4CAF50),
      colorText: const Color(0xFFFFFFFF),
      duration: const Duration(seconds: 2),
    );
    
    Get.back();
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // Método para verificar si un documento está realmente subido al servidor
  bool isDocumentReallyUploaded(DocumentModel document) {
    return document.isUploaded && document.serverId != null && document.serverId!.isNotEmpty;
  }

  // Getter para contar documentos subidos
  int get uploadedDocumentsCount {
    return documents.where((doc) => isDocumentReallyUploaded(doc)).length;
  }
}
