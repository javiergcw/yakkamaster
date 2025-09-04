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
    final instructionFontSize = screenWidth * 0.035;
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
              child: SingleChildScrollView(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: verticalSpacing * 1.0,
                    ), // Reducido el espacio después del progreso
                    // Main Question
                    Text(
                      "What kind of worker do you need?",
                      style: GoogleFonts.poppins(
                        fontSize:
                            screenWidth * 0.075, // Título principal más grande
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(
                      height: verticalSpacing * 0.5,
                    ), // Reducido el espacio entre pregunta y descripción
                    // Instruction
                    Center(
                      child: Text(
                        "You can only choose 1 skill",
                        style: GoogleFonts.poppins(
                          fontSize: instructionFontSize,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(
                      height: verticalSpacing * 1.0,
                    ), // Reducido el espacio antes del input
                    // Search Bar
                    SearchInputField(
                      controller: controller.searchController,
                      hintText: "Search for a type of labour",
                      flavor: controller.currentFlavor.value,
                      onChanged: (value) {
                        controller.performSearch(); // Búsqueda en tiempo real
                      },
                      onSearch: controller.performSearch,
                    ),

                    SizedBox(height: verticalSpacing * 2),

                    // Skills Grid
                    Obx(
                      () => Wrap(
                        spacing:
                            horizontalPadding *
                            0.3, // Reducido el espaciado horizontal
                        runSpacing:
                            verticalSpacing *
                            0.5, // Reducido el espaciado vertical
                        children: controller.filteredSkills
                            .map((skill) => _buildSkillChip(skill))
                            .toList(),
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 3),
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

  Widget _buildSkillChip(String skill) {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final chipFontSize = screenWidth * 0.03; // Reducido para chips más pequeños

    return Obx(() {
      final isSelected =
          controller.postJobData.selectedSkill == skill;

      return GestureDetector(
        onTap: () {
          controller.updateSelectedSkill(skill);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal:
                horizontalPadding * 0.5, // Reducido el padding horizontal
            vertical: verticalSpacing * 0.4, // Reducido el padding vertical
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? Color(
                    AppFlavorConfig.getPrimaryColor(
                      controller.currentFlavor.value,
                    ),
                  )
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(
              15,
            ), // Reducido el border radius
            border: Border.all(
              color: isSelected
                  ? Color(
                      AppFlavorConfig.getPrimaryColor(
                        controller.currentFlavor.value,
                      ),
                    )
                  : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Text(
            skill,
            style: GoogleFonts.poppins(
              fontSize: chipFontSize,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.black : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    });
  }
}
