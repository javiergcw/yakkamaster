import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../app/routes/app_pages.dart';
import '../../presentation/pages/location_screen.dart';

class SkillsExperienceController extends GetxController {
  // Controller para el campo de búsqueda
  final TextEditingController searchController = TextEditingController();
  
  // Lista de habilidades disponibles
  final List<String> allSkills = [
    'General Labourer',
    'Paver Operator',
    'Carpenter',
    'Truck LR Driver',
    'Asbestos Remover',
    'Elevator operator',
    'Foreman',
    'Tow Truck Driver',
    'Lawn mower',
    'Construction Foreman',
    'Bulldozer Operator',
    'Plumber',
    'Heavy Rigid Truck Driver',
    'Traffic Controller',
    'Excavator Operator',
    'Bartender',
    'Gardener',
    'Truck HC Driver',
    'Waitress / Waiter',
    'Truck Driver',
    'Crane Operator - Mobile',
  ];
  
  // Lista de habilidades filtradas
  final RxList<String> filteredSkills = <String>[].obs;
  
  // Habilidades seleccionadas
  final RxSet<String> selectedSkills = <String>{}.obs;
  
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  @override
  void onInit() {
    super.onInit();
    // Si se pasa un flavor específico, usarlo
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
    
    // Inicializar habilidades filtradas
    filteredSkills.value = List.from(allSkills);
    
    // Agregar listener para búsqueda
    searchController.addListener(() {
      handleSearch(searchController.text);
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void handleSearch(String query) {
    if (query.isEmpty) {
      filteredSkills.value = List.from(allSkills);
    } else {
      filteredSkills.value = allSkills
          .where((skill) => skill.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void toggleSkill(String skill) {
    if (selectedSkills.contains(skill)) {
      selectedSkills.remove(skill);
    } else {
      selectedSkills.add(skill);
      // Mostrar modal de nivel de experiencia
      showExperienceLevelModal(skill);
    }
  }

  void showExperienceLevelModal(String selectedSkill) {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive para el modal
    final modalHeight = screenHeight * 0.65;
    final modalPadding = screenWidth * 0.06;
    final titleFontSize = screenWidth * 0.048;
    final buttonFontSize = screenWidth * 0.032;
    final verticalSpacing = screenHeight * 0.025;
    
    // Opciones de nivel de experiencia
    final experienceLevels = [
      'Less than a month',
      'Less than 6 months',
      'More than 6 Months',
      'More than 1 Year',
      'More than 2 Years',
      'More than 5 Years',
    ];

    // Variable para mantener la selección
    String? selectedExperienceLevel;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: modalHeight,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Header del modal con color primario del flavor
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: modalPadding,
                    vertical: modalPadding * 1.2,
                  ),
                  decoration: BoxDecoration(
                    color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)), // Color primario del flavor
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Select Experience Level',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                
                // Contenido del modal con fondo elegante
                Expanded(
                  child: Container(
                    color: const Color(0xFFF8FAFC), // Gris muy claro y elegante
                    padding: EdgeInsets.all(modalPadding),
                    child: Column(
                      children: [
                        // Grid de opciones de experiencia
                        Expanded(
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 3.2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: experienceLevels.length,
                            itemBuilder: (context, index) {
                              final level = experienceLevels[index];
                              return GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    selectedExperienceLevel = level;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: selectedExperienceLevel == level 
                                        ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value))
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: selectedExperienceLevel == level 
                                          ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value))
                                          : const Color(0xFFE5E7EB), // Borde más suave
                                      width: selectedExperienceLevel == level ? 2 : 1,
                                    ),
                                    boxShadow: selectedExperienceLevel == level 
                                        ? [
                                            BoxShadow(
                                              color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)).withOpacity(0.4),
                                              offset: const Offset(0, 6),
                                              blurRadius: 12,
                                              spreadRadius: 0,
                                            ),
                                          ]
                                        : [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.06),
                                              offset: const Offset(0, 2),
                                              blurRadius: 4,
                                              spreadRadius: 0,
                                            ),
                                          ],
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        level,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: buttonFontSize,
                                          color: selectedExperienceLevel == level 
                                              ? Colors.black 
                                              : const Color(0xFF374151),
                                          fontWeight: selectedExperienceLevel == level 
                                              ? FontWeight.w600 
                                              : FontWeight.w500,
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        
                        SizedBox(height: modalPadding * 1.5),
                        
                        // Botón NEXT con colores mejorados
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)), // Gris oscuro consistente
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xFF000000),
                                offset: Offset(0, 8),
                                blurRadius: 20,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: selectedExperienceLevel != null 
                                ? () {
                                    Get.back();
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'NEXT',
                              style: TextStyle(
                                fontSize: buttonFontSize * 1.1,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: modalPadding),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  void resetSelections() {
    selectedSkills.clear();
  }

  void handleContinue() {
    // Navegar al siguiente paso del stepper
    Get.toNamed(LocationScreen.id, arguments: {'flavor': currentFlavor.value});
  }
}
