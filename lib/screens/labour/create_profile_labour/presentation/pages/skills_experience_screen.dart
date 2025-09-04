import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../../logic/controllers/skills_experience_controller.dart';

class SkillsExperienceScreen extends StatelessWidget {
  static const String id = '/skills-experience';
  
  SkillsExperienceScreen({super.key});

  final SkillsExperienceController controller = Get.put(SkillsExperienceController());

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final progressBarHeight = screenHeight * 0.008;
    final skillTagHeight = screenHeight * 0.045;
    final skillTagFontSize = screenWidth * 0.035;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: verticalSpacing * 0.5),
              
              // Header con botón de retroceso y título
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: screenWidth * 0.065,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Skills and Experience",
                        style: GoogleFonts.poppins(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.065), // Espacio para balancear el layout
                ],
              ),

              SizedBox(height: verticalSpacing * 1.5),

              // Barra de progreso
              Container(
                width: double.infinity,
                height: progressBarHeight,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(progressBarHeight / 2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.25, // 25% de progreso
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                      borderRadius: BorderRadius.circular(progressBarHeight / 2),
                    ),
                  ),
                ),
              ),

              SizedBox(height: verticalSpacing * 1.2),

              // Campo de búsqueda y botón reset
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Botón Reset arriba del input
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: controller.resetSelections,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding * 0.5,
                          vertical: verticalSpacing * 0.4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Reset selections",
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.03,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing * 0.5),
                  
                  // Campo de búsqueda con ancho completo
                  CustomTextField(
                    controller: controller.searchController,
                    hintText: "Select your skills",
                    showBorder: true,
                    borderRadius: 16.0,
                    suffixIcon: Icon(Icons.search),
                  ),
                ],
              ),

              SizedBox(height: verticalSpacing * 0.8),

              // Lista de habilidades como chips
              Expanded(
                child: SingleChildScrollView(
                  child: Obx(() => Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: controller.filteredSkills.map((skill) {
                      final isSelected = controller.selectedSkills.contains(skill);
                      
                      return GestureDetector(
                        onTap: () => controller.toggleSkill(skill),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value))
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            skill,
                            style: GoogleFonts.poppins(
                              fontSize: skillTagFontSize,
                              color: isSelected ? Colors.black : Colors.black87,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )),
                ),
              ),

              // Botón Continue - sin espacios
              CustomButton(
                text: "Continue",
                onPressed: controller.handleContinue,
                isLoading: false,
                showShadow: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
