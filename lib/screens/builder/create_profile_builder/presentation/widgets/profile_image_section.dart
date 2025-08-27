import 'package:flutter/material.dart';
import 'dart:io';
import '../../../../../config/app_flavor.dart';

class ProfileImageSection extends StatelessWidget {
  final File? profileImage;
  final VoidCallback onTap;
  final AppFlavor? flavor;
  final double? imageSize;
  final double? editIconSize;
  final double? cameraIconSize;

  const ProfileImageSection({
    super.key,
    this.profileImage,
    required this.onTap,
    this.flavor,
    this.imageSize,
    this.editIconSize,
    this.cameraIconSize,
  });

  @override
  Widget build(BuildContext context) {
    final currentFlavor = flavor ?? AppFlavorConfig.currentFlavor;
    final profileImageSize = imageSize ?? MediaQuery.of(context).size.width * 0.25;
    final editIconSize = this.editIconSize ?? MediaQuery.of(context).size.width * 0.06;
    final cameraIconSize = this.cameraIconSize ?? MediaQuery.of(context).size.width * 0.08;

    return Center(
      child: GestureDetector(
        onTap: onTap,
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
              ),
              child: profileImage != null
                  ? ClipOval(
                      child: Image.file(
                        profileImage!,
                        width: profileImageSize,
                        height: profileImageSize,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.business,
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
                  color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor)),
                  shape: BoxShape.circle,
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
    );
  }
}
