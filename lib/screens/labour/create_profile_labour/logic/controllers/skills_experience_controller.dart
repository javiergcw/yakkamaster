import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../presentation/pages/location_screen.dart';
import 'previous_employer_controller.dart';

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
  
  // Referencia guardada
  final Rx<Map<String, String>?> savedReference = Rx<Map<String, String>?>(null);
  
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
    final modalHeight = screenHeight * 0.6;
    final modalPadding = screenWidth * 0.06;
    final titleFontSize = screenWidth * 0.048;
    final buttonFontSize = screenWidth * 0.032;
    

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
                // Header del modal sin color
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: modalPadding,
                    vertical: modalPadding * 1.2,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
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
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                
                // Contenido del modal con fondo blanco
                Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(modalPadding),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Grid de opciones de experiencia
                          Column(
                            children: [
                              // Primera fila: 2 opciones
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildExperienceButton(
                                      'Less than 6 months',
                                      selectedExperienceLevel,
                                      () => setModalState(() => selectedExperienceLevel = 'Less than 6 months'),
                                      buttonFontSize,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: _buildExperienceButton(
                                      '6-12 months',
                                      selectedExperienceLevel,
                                      () => setModalState(() => selectedExperienceLevel = '6-12 months'),
                                      buttonFontSize,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              // Segunda fila: 2 opciones
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildExperienceButton(
                                      '1-2 years',
                                      selectedExperienceLevel,
                                      () => setModalState(() => selectedExperienceLevel = '1-2 years'),
                                      buttonFontSize,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: _buildExperienceButton(
                                      '2-5 years',
                                      selectedExperienceLevel,
                                      () => setModalState(() => selectedExperienceLevel = '2-5 years'),
                                      buttonFontSize,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              // Tercera fila: 1 opción centrada
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: _buildExperienceButton(
                                      'More than 5 years',
                                      selectedExperienceLevel,
                                      () => setModalState(() => selectedExperienceLevel = 'More than 5 years'),
                                      buttonFontSize,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        
                        SizedBox(height: modalPadding),
                        
                        // Texto Add reference (optional) o referencia guardada
                        Obx(() {
                          if (savedReference.value != null) {
                            // Mostrar referencia guardada
                            return Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.green[200]!),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reference Added:',
                                    style: TextStyle(
                                      fontSize: buttonFontSize * 0.9,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${savedReference.value!['name']} - ${savedReference.value!['company']}',
                                    style: TextStyle(
                                      fontSize: buttonFontSize * 0.85,
                                      color: Colors.green[600],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // Mostrar botón para agregar referencia
                            return GestureDetector(
                              onTap: () {
                                // Crear instancia del controlador de supervisor y abrir modal
                                final supervisorController = Get.put(PreviousEmployerController());
                                supervisorController.showAddSupervisorModal(true);
                                
                                // Escuchar cuando se guarde la referencia
                                supervisorController.firstSupervisor.listen((reference) {
                                  if (reference != null) {
                                    savedReference.value = reference;
                                  }
                                });
                              },
                              child: Center(
                                child: Text(
                                  '+add reference (optional)',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: buttonFontSize,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                        
                        SizedBox(height: modalPadding * 0.5),
                        
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
                              'SAVE',
                              style: TextStyle(
                                fontSize: buttonFontSize * 1.1,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: modalPadding * 0.5),
                        ],
                      ),
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

  Widget _buildExperienceButton(
    String level,
    String? selectedLevel,
    VoidCallback onTap,
    double buttonFontSize,
  ) {
    final isSelected = selectedLevel == level;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isSelected 
              ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value))
              : const Color(0xFFF5F5F5), // Gris claro
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value))
                : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected 
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
                color: isSelected 
                    ? Colors.black 
                    : const Color(0xFF374151),
                fontWeight: isSelected 
                    ? FontWeight.w600 
                    : FontWeight.w500,
                height: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
