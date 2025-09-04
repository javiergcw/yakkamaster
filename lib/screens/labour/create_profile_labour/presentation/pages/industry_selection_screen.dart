import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../logic/controllers/industry_selection_controller.dart';

class IndustrySelectionScreen extends StatelessWidget {
  static const String id = '/industry-selection';
  
  IndustrySelectionScreen({super.key});

  final IndustrySelectionController controller = Get.put(IndustrySelectionController());

  // Sombras tipo tarjeta (una sombra dura cercana + una suave más profunda)
  final List<BoxShadow> strongCardShadows = const [
    BoxShadow(
      color: Color(0x33000000), // 20% negro
      offset: Offset(6, 8),
      blurRadius: 0,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x40000000), // 25% negro
      offset: Offset(0, 18),
      blurRadius: 28,
      spreadRadius: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.065;
    final subtitleFontSize = screenWidth * 0.042;
    final cardTitleFontSize = screenWidth * 0.038;
    final cardSubtitleFontSize = screenWidth * 0.032;
    final iconSize = screenWidth * 0.08;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: verticalSpacing),
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
                ],
              ),
              SizedBox(height: verticalSpacing),
              Text(
                "What's your\nindustry?",
                style: GoogleFonts.poppins(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  height: 0.9,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: verticalSpacing * 0.5),
              Text(
                "Choose the field you want to work in:",
                style: GoogleFonts.poppins(
                  fontSize: subtitleFontSize,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: verticalSpacing * 3),
              
              // Cards de arriba simétricas - FORZAR MISMA ALTURA
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch, // Estirar para llenar altura
                  children: [
                    Expanded(
                      child: _buildIndustryCard(
                        title: "CONSTRUCTION",
                        subtitle: "Work in construction projects, farms or warehouses.",
                        icon: Icons.construction,
                        onTap: controller.handleConstructionSelection,
                        iconSize: iconSize,
                        cardTitleFontSize: cardTitleFontSize,
                        cardSubtitleFontSize: cardSubtitleFontSize,
                        iconColor: Colors.amber[600]!,
                        isCompact: false,
                      ),
                    ),
                    SizedBox(width: horizontalPadding * 0.5),
                    Expanded(
                      child: _buildIndustryCard(
                        title: "HOSPITALITY",
                        subtitle: "Join restaurants, cafes or staff for events.",
                        icon: Icons.restaurant,
                        onTap: controller.handleHospitalitySelection,
                        iconSize: iconSize,
                        cardTitleFontSize: cardTitleFontSize,
                        cardSubtitleFontSize: cardSubtitleFontSize,
                        iconColor: Colors.blue[600]!,
                        isCompact: false,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: verticalSpacing * 1.5),
              _buildIndustryCard(
                title: "BOTH",
                subtitle: "Maximize opportunities in both industries.",
                icon: Icons.check_circle,
                onTap: controller.handleBothSelection,
                iconSize: iconSize,
                cardTitleFontSize: cardTitleFontSize,
                cardSubtitleFontSize: cardSubtitleFontSize,
                iconColor: Colors.green[600]!,
                isCompact: true,
                isHorizontal: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndustryCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required double iconSize,
    required double cardTitleFontSize,
    required double cardSubtitleFontSize,
    required Color iconColor,
    bool isCompact = false,
    bool isHorizontal = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isCompact ? 12 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),         // CHANGED: radio ligeramente mayor
          border: Border(
            top: BorderSide(
              color: Colors.black.withOpacity(0.9),
              width: 1,
            ),
            left: BorderSide(
              color: Colors.black.withOpacity(0.9),
              width: 1,
            ),
            right: BorderSide(
              color: Colors.black.withOpacity(0.9),
              width: 4,
            ),
            bottom: BorderSide(
              color: Colors.black.withOpacity(0.9),
              width: 4,
            ),
          ),
        ),
        child: isHorizontal
            ? Row(
                children: [
                  Container(
                    width: iconSize + (isCompact ? 8 : 12),
                    height: iconSize + (isCompact ? 8 : 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: isCompact ? iconSize * 0.9 : iconSize,
                    ),
                  ),
                  SizedBox(width: isCompact ? 8 : 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: cardTitleFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: isCompact ? 4 : 6),
                        Text(
                          subtitle,
                          style: GoogleFonts.poppins(
                            fontSize: cardSubtitleFontSize,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Container(
                    width: iconSize + (isCompact ? 8 : 12),
                    height: iconSize + (isCompact ? 8 : 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: isCompact ? iconSize * 0.9 : iconSize,
                    ),
                  ),
                  SizedBox(height: isCompact ? 8 : 12),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: cardTitleFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: isCompact ? 4 : 6),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: cardSubtitleFontSize,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
