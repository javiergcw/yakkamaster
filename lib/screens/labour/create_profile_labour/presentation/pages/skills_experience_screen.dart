import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../widgets/progress_indicator.dart';
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
              
              // Header con botón de retroceso y barra de progreso centrada
              Row(
                children: [
                  // Botón de retroceso con padding negativo para moverlo más a la izquierda
                  Transform.translate(
                    offset: Offset(-screenWidth * 0.02, 0), // Mover 2% del ancho hacia la izquierda
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: screenWidth * 0.065,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ProgressIndicatorWidget(
                        currentStep: 3,
                        totalSteps: 5,
                        flavor: controller.currentFlavor.value,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.065), // Espacio para balancear el layout
                ],
              ),

              SizedBox(height: verticalSpacing * 1.2),

              // Título principal centrado
              Center(
                child: Obx(() => Text(
                  controller.selectedSkills.isEmpty 
                      ? "Choose at least one skill"
                      : "Your skills and experience?",
                  style: GoogleFonts.poppins(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                )),
              ),

              SizedBox(height: verticalSpacing * 0.5),

              // Reset selection alineado a la derecha
              Align(
                alignment: Alignment.centerRight,
                child: Obx(() => GestureDetector(
                  onTap: controller.resetSelections,
                  child: Text(
                    controller.selectedSkills.isEmpty 
                        ? "Reset selection"
                        : "Reset selection (${controller.selectedSkills.length})",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                )),
              ),

              SizedBox(height: verticalSpacing * 1.5),

              // Campo de búsqueda
              CustomTextField(
                controller: controller.searchController,
                hintText: "Select your skills",
                showBorder: true,
                borderRadius: 16.0,
                suffixIcon: Icon(Icons.search),
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
