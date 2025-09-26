import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../../features/logic/masters/use_case/master_use_case.dart';
import '../../../../../features/logic/masters/models/receive/dto_receive_license.dart';

class EditDocumentsController extends GetxController {
  // Instancia del caso de uso
  final MasterUseCase _masterUseCase = MasterUseCase();
  
  // Variables observables para el estado
  final RxString selectedCredential = ''.obs;
  final RxBool isUploading = false.obs;
  final RxDouble uploadProgress = 0.0.obs;
  final RxString uploadingFileName = ''.obs;
  final RxList<DocumentModel> documents = <DocumentModel>[].obs;
  
  // Variables para datos dinámicos de la API
  final RxList<DtoReceiveLicense> licensesFromApi = <DtoReceiveLicense>[].obs;
  final RxList<String> credentials = <String>[].obs;
  final RxBool isLoadingCredentials = false.obs;

  int get uploadedDocumentsCount => documents.where((doc) => isDocumentReallyUploaded(doc)).length;

  @override
  void onInit() {
    super.onInit();
    // Cargar credenciales desde la API
    loadCredentialsFromApi();
  }

  /// Carga las credenciales desde la API
  Future<void> loadCredentialsFromApi({bool showSnackbar = true}) async {
    try {
      isLoadingCredentials.value = true;
      
      final result = await _masterUseCase.getLicenses();
      
      if (result.isSuccess && result.data != null) {
        licensesFromApi.value = result.data!;
        credentials.value = result.data!.map((license) => license.name).toList();
      }
    } catch (e) {
      if (showSnackbar) {
        Get.snackbar(
          'Error',
          'Failed to load credentials: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoadingCredentials.value = false;
    }
  }

  void setSelectedCredential(String credential) {
    selectedCredential.value = credential;
  }

  void addCredential() {
    if (selectedCredential.value.isNotEmpty) {
      documents.add(DocumentModel(
        type: selectedCredential.value,
        fileName: '',
        fileSize: null,
        filePath: '',
      ));
      selectedCredential.value = '';
    }
  }

  Future<void> uploadDocument(int index) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        
        // Simular progreso de subida
        isUploading.value = true;
        uploadingFileName.value = file.name;
        uploadProgress.value = 0.0;

        // Simular progreso
        for (int i = 0; i <= 100; i += 10) {
          await Future.delayed(const Duration(milliseconds: 100));
          uploadProgress.value = i / 100;
        }

        // Actualizar documento
        documents[index] = DocumentModel(
          type: documents[index].type,
          fileName: file.name,
          fileSize: file.size,
          filePath: file.path ?? '',
        );

        isUploading.value = false;
        uploadProgress.value = 0.0;
        uploadingFileName.value = '';

        Get.snackbar(
          'Success',
          'Document uploaded successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isUploading.value = false;
      uploadProgress.value = 0.0;
      uploadingFileName.value = '';
      
      Get.snackbar(
        'Error',
        'Failed to upload document: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void deleteDocument(int index) {
    documents.removeAt(index);
    Get.snackbar(
      'Deleted',
      'Document removed',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  bool isDocumentReallyUploaded(DocumentModel document) {
    return document.fileName.isNotEmpty && document.filePath.isNotEmpty;
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  void saveDocuments() {
    Get.snackbar(
      'Success',
      'Documents saved successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
    
    Get.back();
  }

  void showCredentialDropdown() {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final titleFontSize = screenWidth * 0.045;
    final itemFontSize = screenWidth * 0.035;

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Text(
                'Select Credential',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Obx(() {
              if (isLoadingCredentials.value) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: const CircularProgressIndicator(),
                );
              }
              
              if (credentials.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'No credentials available',
                    style: GoogleFonts.poppins(
                      fontSize: itemFontSize,
                      color: Colors.grey[600],
                    ),
                  ),
                );
              }
              
              return Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: credentials.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        credentials[index],
                        style: GoogleFonts.poppins(
                          fontSize: itemFontSize,
                          color: Colors.black87,
                        ),
                      ),
                      onTap: () {
                        setSelectedCredential(credentials[index]);
                        Get.back();
                      },
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}

class DocumentModel {
  final String type;
  final String fileName;
  final int? fileSize;
  final String filePath;

  DocumentModel({
    required this.type,
    required this.fileName,
    this.fileSize,
    required this.filePath,
  });
}
