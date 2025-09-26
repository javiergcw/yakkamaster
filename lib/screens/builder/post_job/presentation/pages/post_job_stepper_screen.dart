import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/search_input_field.dart';
import '../../logic/controllers/unified_post_job_controller.dart';

class PostJobStepperScreen extends StatelessWidget {
  static const String id = '/builder/post-job';

  final AppFlavor? flavor;
  final List<dynamic>? selectedJobSites;

  PostJobStepperScreen({super.key, this.flavor, this.selectedJobSites});

  final UnifiedPostJobController controller = Get.put(UnifiedPostJobController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    // Establecer el flavor en el controlador
    if (flavor != null) {
      controller.currentFlavor.value = flavor!;
    }

    // Si hay jobsites seleccionados, inicializarlos en el controlador
    if (selectedJobSites != null && selectedJobSites!.isNotEmpty) {
      // TODO: Pasar los jobsites seleccionados al controlador
      print('Selected job sites: ${selectedJobSites}');
    }

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize =
        screenWidth * 0.055; // Tamaño normal para el título del appbar
    final iconSize = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing * 0.6, // Appbar más pequeño
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
              ),
              child: Row(
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () {
                      controller.handleBackNavigation();
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: iconSize,
                    ),
                  ),

                  SizedBox(width: horizontalPadding),

                  // Title
                  Expanded(
                    child: Text(
                      "Post a job",
                      style: GoogleFonts.poppins(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(
                    width: horizontalPadding + iconSize,
                  ), // Espacio para balancear
                ],
              ),
            ),

            // Progress Indicator
            Container(
              width: double.infinity,
              height: 2,
              child: Row(
                children: [
                  // Progress (yellow) - 1 step completed
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Color(
                        AppFlavorConfig.getPrimaryColor(
                          controller.currentFlavor.value,
                        ),
                      ),
                    ),
                  ),
                  // Remaining (grey)
                  Expanded(flex: 8, child: Container(color: Colors.grey[300])),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: verticalSpacing * 1.0),
                    
                    // Título principal centrado
                    Center(
                      child: Obx(() => Text(
                        controller.selectedSkills.isEmpty 
                            ? "What kind of worker do you need?"
                            : "Selected skills",
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.075,
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
                    SearchInputField(
                      controller: controller.searchController,
                      hintText: "Search for a type of labour",
                      flavor: controller.currentFlavor.value,
                      onChanged: (value) {
                        controller.performSearch();
                      },
                      onSearch: controller.performSearch,
                    ),

                    SizedBox(height: verticalSpacing * 0.8),

                    // Lista de categorías y subcategorías
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoadingSkills.value) {
                          return Container(
                            padding: EdgeInsets.all(verticalSpacing * 2),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                                  ),
                                  SizedBox(height: verticalSpacing),
                                  Text(
                                    'Loading skills...',
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.035,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        
                        if (controller.filteredSkills.isEmpty) {
                          return Container(
                            padding: EdgeInsets.all(verticalSpacing * 2),
                            child: Center(
                              child: Text(
                                'No skills available',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          );
                        }
                        
                        return SingleChildScrollView(
                          child: Column(
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
                                              fontSize: screenWidth * 0.035,
                                              color: isSelected || isExpanded ? Colors.white : Colors.black87,
                                              fontWeight: isSelected || isExpanded ? FontWeight.w600 : FontWeight.w500,
                                            ),
                                          ),
                                          if (isExpanded) ...[
                                            SizedBox(width: 4),
                                            Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 16,
                                              color: Colors.white,
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
                                    fontSize: screenWidth * 0.035 * 1.1,
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
                                            fontSize: screenWidth * 0.035 * 1.05,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Wrap(
                                          spacing: 6.0,
                                          runSpacing: 6.0,
                                          children: controller.getSubcategoriesForCategory(category).map((subcategory) {
                                            final uniqueId = "${category}_$subcategory";
                                            final isSelected = controller.selectedSkills.contains(uniqueId);
                                            
                                            return GestureDetector(
                                              onTap: () => controller.toggleSubcategory(subcategory, category),
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
                                                    fontSize: screenWidth * 0.035 * 0.9,
                                                    color: isSelected ? Colors.white : Colors.black87,
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
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),

            // Continue Button
            Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: Obx(
                () => CustomButton(
                  text: "Continue",
                  onPressed: controller.canProceedToNextStep()
                      ? controller.handleContinue
                      : null,
                  type: ButtonType.secondary,
                  flavor: controller.currentFlavor.value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
