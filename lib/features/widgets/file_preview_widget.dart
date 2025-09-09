import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class FilePreviewWidget extends StatelessWidget {
  final String fileName;
  final String? filePath;
  final int? fileSize;
  final VoidCallback? onRemove;
  final double? width;
  final double? height;

  const FilePreviewWidget({
    super.key,
    required this.fileName,
    this.filePath,
    this.fileSize,
    this.onRemove,
    this.width,
    this.height,
  });

  bool get isImage {
    final extension = fileName.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
  }

  bool get isPdf {
    return fileName.toLowerCase().endsWith('.pdf');
  }

  bool get isDocument {
    final extension = fileName.toLowerCase().split('.').last;
    return ['doc', 'docx', 'txt', 'rtf'].contains(extension);
  }

  IconData get fileIcon {
    if (isImage) return Icons.image;
    if (isPdf) return Icons.picture_as_pdf;
    if (isDocument) return Icons.description;
    return Icons.insert_drive_file;
  }

  Color get fileColor {
    if (isImage) return Colors.green;
    if (isPdf) return Colors.red;
    if (isDocument) return Colors.blue;
    return Colors.grey;
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final previewWidth = width ?? screenWidth * 0.25;
    final previewHeight = height ?? screenWidth * 0.25;

    return Container(
      width: previewWidth,
      height: previewHeight,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Stack(
        children: [
          // Contenido principal
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Preview del archivo
                Expanded(
                  flex: 3,
                  child: _buildFilePreview(),
                ),
                const SizedBox(height: 4),
                // Nombre del archivo
                Expanded(
                  flex: 2,
                  child: Text(
                    fileName,
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.025,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Tamaño del archivo
                if (fileSize != null)
                  Text(
                    formatFileSize(fileSize!),
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.02,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          // Botón de eliminar
          if (onRemove != null)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.red,
                    size: screenWidth * 0.04,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilePreview() {
    if (isImage && filePath != null) {
      // Preview de imagen
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(filePath!),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return _buildIconPreview();
          },
        ),
      );
    } else {
      // Preview con icono
      return _buildIconPreview();
    }
  }

  Widget _buildIconPreview() {
    return Builder(
      builder: (context) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: fileColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: fileColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                fileIcon,
                color: fileColor,
                size: MediaQuery.of(context).size.width * 0.08,
              ),
              const SizedBox(height: 4),
              Text(
                _getFileTypeText(),
                style: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.width * 0.02,
                  color: fileColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getFileTypeText() {
    if (isImage) return 'Imagen';
    if (isPdf) return 'PDF';
    if (isDocument) return 'Documento';
    return 'Archivo';
  }
}
