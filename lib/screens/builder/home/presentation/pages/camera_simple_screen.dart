import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../../../config/app_flavor.dart';

class CameraSimpleScreen extends StatefulWidget {
  static const String id = '/camera-simple';
  
  final AppFlavor flavor;
  final Function(File) onImageCaptured;

  const CameraSimpleScreen({
    super.key,
    required this.flavor,
    required this.onImageCaptured,
  });

  @override
  State<CameraSimpleScreen> createState() => _CameraSimpleScreenState();
}

class _CameraSimpleScreenState extends State<CameraSimpleScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isCapturing = false;
  int _currentCameraIndex = 0;
  

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        // Buscar la cámara frontal primero
        int frontCameraIndex = _cameras!.indexWhere((camera) => camera.lensDirection == CameraLensDirection.front);
        if (frontCameraIndex != -1) {
          _currentCameraIndex = frontCameraIndex;
        } else {
          _currentCameraIndex = 0; // Fallback a la primera cámara disponible
        }
        
        _cameraController = CameraController(
          _cameras![_currentCameraIndex],
          ResolutionPreset.high,
          enableAudio: false,
        );

        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
      Get.snackbar(
        'Error',
        'Error initializing camera: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length <= 1) return;
    
    try {
      setState(() {
        _isInitialized = false;
      });
      
      // Liberar la cámara actual
      await _cameraController?.dispose();
      
      // Cambiar al siguiente índice de cámara
      _currentCameraIndex = (_currentCameraIndex + 1) % _cameras!.length;
      
      // Inicializar la nueva cámara
      _cameraController = CameraController(
        _cameras![_currentCameraIndex],
        ResolutionPreset.high,
        enableAudio: false,
      );
      
      await _cameraController!.initialize();
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      print('Error switching camera: $e');
      Get.snackbar(
        'Error',
        'Error switching camera: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _captureImage() async {
    print('_captureImage method called');
    
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      print('Camera not initialized, returning');
      return;
    }

    print('Setting _isCapturing to true');
    setState(() {
      _isCapturing = true;
    });

    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = 'license_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = '${appDir.path}/$fileName';

      final XFile image = await _cameraController!.takePicture();
      final File imageFile = File(image.path);
      
      // Copiar la imagen al directorio de la aplicación
      await imageFile.copy(filePath);
      final File finalImage = File(filePath);
      
      print('Image saved to: ${finalImage.path}');
      
      // Ejecutar el callback
      print('About to execute callback with image: ${finalImage.path}');
      try {
        print('Executing callback...');
        widget.onImageCaptured(finalImage);
        print('Callback executed successfully');
      } catch (e) {
        print('Error executing callback: $e');
      }
      
      // Cerrar la pantalla y retornar la imagen
      print('Closing camera screen and returning image...');
      Get.back(result: finalImage);
      print('Camera screen closed and image returned');
    } catch (e) {
      print('Error capturing image: $e');
      Get.snackbar(
        'Error',
        'Error capturing image: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      
      // Cerrar la pantalla incluso si hay error
      print('Closing camera screen due to error...');
      Get.back(result: null);
      print('Camera screen closed due to error');
    } finally {
      print('Setting _isCapturing to false');
      setState(() {
        _isCapturing = false;
      });
      print('_captureImage method completed');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Vista previa de la cámara
          if (_isInitialized && _cameraController != null)
            Positioned.fill(
              child: CameraPreview(_cameraController!),
            )
          else
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),

          // Botón de cerrar
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Color(AppFlavorConfig.getPrimaryColor(widget.flavor)),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  print('Close button tapped');
                  Get.back();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),

          // Botón de cambiar cámara
          if (_cameras != null && _cameras!.length > 1)
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: _isCapturing ? null : () {
                    print('Switch camera button tapped');
                    _switchCamera();
                  },
                  icon: const Icon(
                    Icons.flip_camera_ios,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),

          // Botón de capturar
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _isCapturing ? null : () {
                  print('Capture button tapped');
                  _captureImage();
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isCapturing 
                        ? Colors.grey[400] 
                        : Color(AppFlavorConfig.getPrimaryColor(widget.flavor)),
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: _isCapturing
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 36,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
