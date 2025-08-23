import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/app_flavor.dart';
import '../../../../config/assets_config.dart';
import '../../../../features/widgets/custom_button.dart';
import '../../../../features/widgets/custom_text_field.dart';
import 'location_screen.dart';

class SkillsExperienceScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const SkillsExperienceScreen({
    super.key,
    this.flavor,
  });

  @override
  State<SkillsExperienceScreen> createState() => _SkillsExperienceScreenState();
}

class _SkillsExperienceScreenState extends State<SkillsExperienceScreen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  
  // Controller para el campo de búsqueda
  final TextEditingController _searchController = TextEditingController();
  
  // Lista de habilidades disponibles
  final List<String> _allSkills = [
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
  List<String> _filteredSkills = [];
  
  // Habilidades seleccionadas
  final Set<String> _selectedSkills = <String>{};
  
  // Sombras tipo tarjeta (igual que en industry_selection_screen)
  final List<BoxShadow> strongCardShadows = const [
    BoxShadow(
      color: Color(0xFF000000), // 100% negro (totalmente negro)
      offset: Offset(6, 8),
      blurRadius: 0,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0xFF000000), // 100% negro (totalmente negro)
      offset: Offset(0, 18),
      blurRadius: 28,
      spreadRadius: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredSkills = List.from(_allSkills);
    _searchController.addListener(() {
      _handleSearch(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSkills = List.from(_allSkills);
      } else {
        _filteredSkills = _allSkills
            .where((skill) => skill.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _toggleSkill(String skill) {
    setState(() {
      if (_selectedSkills.contains(skill)) {
        _selectedSkills.remove(skill);
      } else {
        _selectedSkills.add(skill);
        // Mostrar modal de nivel de experiencia
        _showExperienceLevelModal(skill);
      }
    });
  }

  void _showExperienceLevelModal(String selectedSkill) {
    final mediaQuery = MediaQuery.of(context);
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
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
                    color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)), // Color primario del flavor
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Select Experience Level',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
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
                                        ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: selectedExperienceLevel == level 
                                          ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                                          : const Color(0xFFE5E7EB), // Borde más suave
                                      width: selectedExperienceLevel == level ? 2 : 1,
                                    ),
                                    boxShadow: selectedExperienceLevel == level 
                                        ? [
                                            BoxShadow(
                                              color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)).withOpacity(0.4),
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
                                        style: GoogleFonts.poppins(
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
                            color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)), // Gris oscuro consistente
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
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Selected: $selectedSkill - $selectedExperienceLevel'),
                                        backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                        behavior: SnackBarBehavior.floating,
                                        margin: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).size.height - 100,
                                          right: 20,
                                          left: 20,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'NEXT',
                              style: GoogleFonts.poppins(
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
    );
  }

  void _resetSelections() {
    setState(() {
      _selectedSkills.clear();
    });
  }

  void _handleContinue() {
    if (_selectedSkills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one skill')),
      );
      return;
    }
    
    // Navegar al siguiente paso del stepper
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LocationScreen(flavor: _currentFlavor),
      ),
    );
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
              SizedBox(height: verticalSpacing),
              
              // Header con botón de retroceso y título
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
                      color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                      borderRadius: BorderRadius.circular(progressBarHeight / 2),
                    ),
                  ),
                ),
              ),

              SizedBox(height: verticalSpacing * 2),

              // Campo de búsqueda y botón reset
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Botón Reset arriba del input
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: _resetSelections,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding * 0.8,
                          vertical: verticalSpacing * 0.8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Reset selections",
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.035,
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
                    controller: _searchController,
                    hintText: "Select your skills",
                    showBorder: true,
                    prefixIcon: Icon(Icons.search),
                  ),
                ],
              ),

              SizedBox(height: verticalSpacing * 2),

              // Lista de habilidades
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3.5,
                    crossAxisSpacing: horizontalPadding * 0.5,
                    mainAxisSpacing: verticalSpacing,
                  ),
                  itemCount: _filteredSkills.length,
                  itemBuilder: (context, index) {
                    final skill = _filteredSkills[index];
                    final isSelected = _selectedSkills.contains(skill);
                    
                    return GestureDetector(
                      onTap: () => _toggleSkill(skill),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            skill,
                            style: GoogleFonts.poppins(
                              fontSize: skillTagFontSize,
                              color: isSelected ? Colors.black : Colors.black87,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: verticalSpacing * 2),

              // Botón Continue con sombra personalizada
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: strongCardShadows,
                ),
                child: CustomButton(
                  text: "Continue",
                  onPressed: _handleContinue,
                  isLoading: false,
                ),
              ),

              SizedBox(height: verticalSpacing * 2),
            ],
          ),
        ),
      ),
    );
  }
}
