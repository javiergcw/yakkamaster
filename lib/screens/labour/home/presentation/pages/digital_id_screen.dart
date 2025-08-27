import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'dart:typed_data';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../logic/digital_id_controller.dart';
import '../widgets/digital_id_avatar.dart';
import '../widgets/qr_code_widget.dart';

class DigitalIdScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const DigitalIdScreen({
    super.key,
    this.flavor,
  });

  @override
  State<DigitalIdScreen> createState() => _DigitalIdScreenState();
}

class _DigitalIdScreenState extends State<DigitalIdScreen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  late DigitalIdController _controller;
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = DigitalIdController();
    _controller.onDataChanged = () => setState(() {});
    _controller.onLoadingChanged = () => setState(() {});
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _shareScreen() async {
    try {
      // Capturar la pantalla
      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();
      
      // Guardar la imagen temporalmente
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/digital_id_${DateTime.now().millisecondsSinceEpoch}.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(pngBytes);
      
      // Compartir la imagen
      await Share.shareXFiles([XFile(imagePath)], text: 'Mi Digital ID de Yakka');
    } catch (e) {
      print('Error sharing screen: $e');
      // Fallback: compartir solo texto
      await Share.share('Mi Digital ID de Yakka: ${_controller.digitalIdData?.name}');
    }
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
    final bodyFontSize = screenWidth * 0.035;
    final iconSize = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      body: RepaintBoundary(
        key: _globalKey,
        child: SafeArea(
        child: Stack(
          children: [
            // Header (Dark Grey)
            Container(
              width: double.infinity,
              height: screenHeight * 0.15, // Aumentado para evitar corte
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing * 2,
              ),
              decoration: BoxDecoration(
                color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
              ),
              child: Row(
                children: [
                  // Back Button
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: iconSize,
                    ),
                  ),
                  
                  // Title
                  Expanded(
                    child: Text(
                      "DIGITAL ID",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  
                  // Espacio para balancear el layout
                  SizedBox(width: iconSize),
                ],
              ),
            ),
            
            // Main Content
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.15), // Ajustado al nuevo header
              child: _controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _controller.digitalIdData != null
                      ? _buildMainContent(
                          horizontalPadding,
                          verticalSpacing,
                          bodyFontSize,
                        )
                      : const Center(child: Text('No data available')),
            ),
          ],
        ),
        ),
      ),
      
      // Floating Action Button (Yellow) - Usando flavor
      floatingActionButton: FloatingActionButton(
        onPressed: _shareScreen,
        backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
        child: Icon(
          Icons.share,
          color: Colors.white,
          size: iconSize,
        ),
      ),
    );
  }

  Widget _buildMainContent(
    double horizontalPadding,
    double verticalSpacing,
    double bodyFontSize,
  ) {
    final data = _controller.digitalIdData!;
    
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        children: [
          SizedBox(height: verticalSpacing * 3),
          
          // Identification Section
          _buildIdentificationSection(data, verticalSpacing, bodyFontSize),
          
          SizedBox(height: verticalSpacing * 4),
          
          // QR Code Section
          _buildQrCodeSection(data, verticalSpacing, bodyFontSize),
          
          SizedBox(height: verticalSpacing * 3),
        ],
      ),
    );
  }

  Widget _buildIdentificationSection(
    dynamic data,
    double verticalSpacing,
    double bodyFontSize,
  ) {
    return Column(
      children: [
        // Label
        Text(
          "IDENTIFICATION",
          style: GoogleFonts.poppins(
            fontSize: bodyFontSize * 0.8,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
            letterSpacing: 1.2,
          ),
        ),
        
        SizedBox(height: verticalSpacing * 2),
        
        // Avatar
        DigitalIdAvatar(
          avatarUrl: data.avatarUrl,
          size: 100,
          flavor: _currentFlavor,
        ),
        
        SizedBox(height: verticalSpacing * 1.5),
        
        // Name
        Text(
          data.name,
          style: GoogleFonts.poppins(
            fontSize: bodyFontSize * 1.2,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildQrCodeSection(
    dynamic data,
    double verticalSpacing,
    double bodyFontSize,
  ) {
    return Column(
      children: [
        // QR Code
        QrCodeWidget(
          data: data.qrCodeData,
          size: 250,
        ),
        
        SizedBox(height: verticalSpacing * 2),
        
        // Powered By Section
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Powered by ",
              style: GoogleFonts.poppins(
                fontSize: bodyFontSize * 0.9,
                color: Colors.grey[600],
              ),
            ),
            
                         // Yakka Logo - Usando assets_config.dart
             Row(
               children: [
                 SvgPicture.asset(
                   AssetsConfig.getLogo(_currentFlavor),
                   width: 20,
                   height: 20,
                   fit: BoxFit.contain,
                 ),
                 SizedBox(width: 4),
               ],
             ),
          ],
        ),
      ],
    );
  }
}
