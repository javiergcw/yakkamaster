import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/assets_config.dart';
import '../../../../../config/app_flavor.dart';

class DigitalIdAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double size;
  final Color? backgroundColor;
  final AppFlavor? flavor;

  const DigitalIdAvatar({
    super.key,
    this.avatarUrl,
    this.size = 80,
    this.backgroundColor,
    this.flavor,
  });

  AppFlavor get _currentFlavor => flavor ?? AppFlavorConfig.currentFlavor;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final avatarSize = size * (screenWidth / 375); // Responsive sizing

    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
        border: Border.all(
          color: Colors.grey[400] ?? Colors.grey,
          width: 2,
        ),
      ),
      child: avatarUrl != null && avatarUrl!.isNotEmpty
          ? ClipOval(
              child: Image.network(
                avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultAvatar(avatarSize);
                },
              ),
            )
          : _buildDefaultAvatar(avatarSize),
    );
  }

  Widget _buildDefaultAvatar(double size) {
    // Crear un avatar con el color del flavor
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
      ),
      child: Center(
        child: Icon(
          Icons.person,
          size: size * 0.6,
          color: Colors.white,
        ),
      ),
    );
  }
}
