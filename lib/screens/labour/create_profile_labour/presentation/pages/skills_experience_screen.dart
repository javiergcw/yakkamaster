import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../widgets/progress_indicator.dart';
import '../../logic/controllers/create_profile_controller.dart';

class SkillsExperienceScreen extends StatelessWidget {
  static const String id = '/skills-experience';
  
  SkillsExperienceScreen({super.key});

  final CreateProfileController controller = Get.find<CreateProfileController>();

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

              // Reset selection y skills seleccionadas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skills seleccionadas
                  Expanded(
                    child: Obx(() {
                      if (controller.selectedSkills.isNotEmpty) {
                        return Wrap(
                          spacing: 4.0,
                          runSpacing: 4.0,
                          children: controller.selectedSkills.map((uniqueId) {
                            // Obtener el nombre de la skill desde el ID único
                            String skillName = controller.getSkillNameFromUniqueId(uniqueId);
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                skillName,
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.032,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                      return SizedBox.shrink();
                    }),
                  ),
                  
                  // Reset button
                  Obx(() => GestureDetector(
                    onTap: controller.resetSelections,
                    child: Text(
                      controller.selectedSkills.isEmpty 
                          ? "Reset selection"
                          : "Reset (${controller.selectedSkills.length})",
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  )),
                ],
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

              // Lista de categorías y subcategorías
              Expanded(
                child: SingleChildScrollView(
                  child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Lista de categorías principales
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: controller.filteredSkills.map((skill) {
                          final isSelected = controller.selectedSkills.contains(skill);
                          final isExpanded = controller.expandedCategories.contains(skill);
                          
                          return GestureDetector(
                            onTap: () => controller.toggleCategory(skill),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected || isExpanded
                                    ? Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value))
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                                border: isExpanded ? Border.all(
                                  color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                                  width: 2,
                                ) : null,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    skill,
                                    style: GoogleFonts.poppins(
                                      fontSize: skillTagFontSize,
                                      color: isSelected || isExpanded ? Colors.black : Colors.black87,
                                      fontWeight: isSelected || isExpanded ? FontWeight.w600 : FontWeight.w500,
                                    ),
                                  ),
                                  if (isExpanded) ...[
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      
                      // Mostrar subcategorías de todas las categorías expandidas
                      if (controller.expandedCategories.isNotEmpty) ...[
                        SizedBox(height: verticalSpacing),
                        Text(
                          "Select specific skills:",
                          style: GoogleFonts.poppins(
                            fontSize: skillTagFontSize * 1.1,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: verticalSpacing * 0.5),
                        
                        // Mostrar todas las categorías expandidas
                        ...controller.expandedCategories.map((category) {
                          return Container(
                            margin: EdgeInsets.only(bottom: verticalSpacing * 0.8),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category,
                                  style: GoogleFonts.poppins(
                                    fontSize: skillTagFontSize * 1.05,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Wrap(
                                  spacing: 6.0,
                                  runSpacing: 6.0,
                                  children: controller.getSubcategoriesForCategory(category).map((subcategory) {
                                    final uniqueId = controller.getUniqueSubcategoryId(subcategory);
                                    final isSelected = controller.selectedSkills.contains(uniqueId);
                                    
                                    return GestureDetector(
                                      onTap: () => controller.toggleSubcategory(subcategory),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected 
                                              ? Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value))
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: isSelected 
                                                ? Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value))
                                                : Colors.grey[300]!,
                                          ),
                                        ),
                                        child: Text(
                                          subcategory,
                                          style: GoogleFonts.poppins(
                                            fontSize: skillTagFontSize * 0.9,
                                            color: isSelected ? Colors.black : Colors.black87,
                                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ],
                  )),
                ),
              ),

              // Botón Continue - sin espacios
              CustomButton(
                text: "Continue",
                                    onPressed: controller.handleSkillsContinue,
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
