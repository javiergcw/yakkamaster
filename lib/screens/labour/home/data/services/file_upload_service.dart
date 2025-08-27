import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import '../../../../../config/api_config.dart';

class FileUploadService {
  final Dio _dio = Dio();

  FileUploadService() {
    _dio.options.baseUrl = ApiConfig.currentBaseUrl;
    _dio.options.connectTimeout = Duration(seconds: ApiConfig.connectionTimeout);
    _dio.options.receiveTimeout = Duration(seconds: ApiConfig.receiveTimeout);
  }

  /// Sube un archivo al servidor
  Future<Map<String, dynamic>> uploadDocument({
    required File file,
    required String documentType,
    String? userId,
    Function(int sent, int total)? onProgress,
  }) async {
    try {
      // Obtener el tipo MIME del archivo
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      
      // Crear el nombre del archivo con timestamp para evitar duplicados
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      
      // Crear FormData para la subida
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: DioMediaType.parse(mimeType),
        ),
        'documentType': documentType,
        if (userId != null) 'userId': userId,
      });

      // Realizar la petición POST
      final response = await _dio.post(
        ApiConfig.uploadDocumentEndpoint,
        data: formData,
        onSendProgress: onProgress ?? (int sent, int total) {
          // Aquí puedes implementar el progreso de subida
          final progress = (sent / total * 100).round();
          print('Progreso de subida: $progress%');
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': response.data,
          'message': 'Archivo subido exitosamente',
        };
      } else {
        return {
          'success': false,
          'message': 'Error en la respuesta del servidor',
          'statusCode': response.statusCode,
        };
      }
    } on DioException catch (e) {
      String errorMessage = 'Error al subir el archivo';
      
      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Tiempo de conexión agotado';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Tiempo de respuesta agotado';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Error de conexión';
      } else if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? 'Error del servidor';
      }

      return {
        'success': false,
        'message': errorMessage,
        'error': e.toString(),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error inesperado: $e',
        'error': e.toString(),
      };
    }
  }

  /// Elimina un documento del servidor
  Future<Map<String, dynamic>> deleteDocument({
    required String documentId,
    String? userId,
  }) async {
    try {
      final response = await _dio.delete(
        '${ApiConfig.deleteDocumentEndpoint}/$documentId',
        queryParameters: {
          if (userId != null) 'userId': userId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Documento eliminado exitosamente',
        };
      } else {
        return {
          'success': false,
          'message': 'Error al eliminar el documento',
          'statusCode': response.statusCode,
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': 'Error al eliminar el documento: ${e.message}',
        'error': e.toString(),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error inesperado: $e',
        'error': e.toString(),
      };
    }
  }

  /// Obtiene la lista de documentos del usuario
  Future<Map<String, dynamic>> getUserDocuments({
    String? userId,
  }) async {
    try {
      final response = await _dio.get(
        ApiConfig.getUserDocumentsEndpoint,
        queryParameters: {
          if (userId != null) 'userId': userId,
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
          'message': 'Documentos obtenidos exitosamente',
        };
      } else {
        return {
          'success': false,
          'message': 'Error al obtener los documentos',
          'statusCode': response.statusCode,
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': 'Error al obtener los documentos: ${e.message}',
        'error': e.toString(),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error inesperado: $e',
        'error': e.toString(),
      };
    }
  }
}
