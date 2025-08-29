import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/search_input_field.dart';
import 'post_job_stepper_step2_screen.dart';
import '../../logic/controllers/post_job_controller.dart';

class PostJobStepperScreen extends StatefulWidget {
  final AppFlavor? flavor;
  final List<dynamic>? selectedJobSites;

  const PostJobStepperScreen({
    super.key,
    this.flavor,
    this.selectedJobSites,
  });

  @override
  State<PostJobStepperScreen> createState() => _PostJobStepperScreenState();
}

class _PostJobStepperScreenState extends State<PostJobStepperScreen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  late PostJobController _controller;
  
  final _searchController = TextEditingController();
  List<String> _filteredSkills = [];
  
  // Lista completa de habilidades
  final List<String> _allSkills = [
    'General Labourer',
    'Carpenter',
    'Electrician',
    'Plumber',
    'Bricklayer',
    'Concreter',
    'Painter',
    'Excavator Operator',
    'Truck Driver',
    'Forklift Driver',
    'Paver Operator',
    'Truck LR Driver',
    'Asbestos Remover',
    'Elevator operator',
    'Foreman',
    'Tow Truck Driver',
    'Lawn mower',
    'Construction Foreman',
    'Bulldozer Operator',
    'Heavy Rigid Truck Driver',
    'Traffic Controller',
    'Bartender',
    'Gardener',
    'Truck HC Driver',
  ];

  @override
  void initState() {
    super.initState();
    _controller = Get.put(PostJobController());
    // Asegurar que el controlador esté en el paso correcto
    _controller.goToStep(1);
    _filteredSkills = List.from(_allSkills);
    
    // Si hay jobsites seleccionados, inicializarlos en el controlador
    if (widget.selectedJobSites != null && widget.selectedJobSites!.isNotEmpty) {
      // TODO: Pasar los jobsites seleccionados al controlador
      print('Selected job sites: ${widget.selectedJobSites}');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
         final titleFontSize = screenWidth * 0.055; // Tamaño normal para el título del appbar
    final questionFontSize = screenWidth * 0.045;
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
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                                     // Back Button
                   GestureDetector(
                     onTap: () {
                       _controller.handleBackNavigation();
                       Navigator.of(context).pop();
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
                  
                  SizedBox(width: horizontalPadding + iconSize), // Espacio para balancear
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
                      color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                    ),
                  ),
                  // Remaining (grey)
                  Expanded(
                    flex: 8,
                    child: Container(
                      color: Colors.grey[300],
                    ),
                  ),
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
                  SizedBox(height: verticalSpacing * 1.0), // Reducido el espacio después del progreso
                  
                                     // Main Question
                   Text(
                     "What kind of worker do you need?",
                     style: GoogleFonts.poppins(
                       fontSize: screenWidth * 0.075, // Título principal más grande
                       fontWeight: FontWeight.bold,
                       color: Colors.black,
                     ),
                   ),
                  
                  SizedBox(height: verticalSpacing * 0.5), // Reducido el espacio entre pregunta y descripción
                  
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
                  
                  SizedBox(height: verticalSpacing * 1.0), // Reducido el espacio antes del input
                    
                                                              // Search Bar
                     SearchInputField(
                       controller: _searchController,
                       hintText: "Search for a type of labour",
                       flavor: _currentFlavor,
                       onChanged: (value) {
                         _performSearch(); // Búsqueda en tiempo real
                       },
                       onSearch: _performSearch,
                     ),
                    
                    SizedBox(height: verticalSpacing * 2),
                    
                    // Skills Grid
                    Wrap(
                      spacing: horizontalPadding * 0.3, // Reducido el espaciado horizontal
                      runSpacing: verticalSpacing * 0.5, // Reducido el espaciado vertical
                      children: _filteredSkills.map((skill) => _buildSkillChip(skill)).toList(),
                    ),
                    
                    SizedBox(height: verticalSpacing * 3),
                  ],
                ),
              ),
            ),
            
            // Continue Button
            Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: Obx(() => CustomButton(
                text: "Continue",
                onPressed: _controller.canProceedToNextStep() ? _handleContinue : null,
                type: ButtonType.secondary,
                flavor: _currentFlavor,
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final chipFontSize = screenWidth * 0.03; // Reducido para chips más pequeños
    
    return Obx(() {
      final isSelected = _controller.postJobData.selectedSkill == skill;
      
      return GestureDetector(
        onTap: () {
          _controller.updateSelectedSkill(skill);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding * 0.5, // Reducido el padding horizontal
            vertical: verticalSpacing * 0.4, // Reducido el padding vertical
          ),
          decoration: BoxDecoration(
            color: isSelected 
                ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(15), // Reducido el border radius
            border: Border.all(
              color: isSelected 
                  ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
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

  void _performSearch() {
    final query = _searchController.text.toLowerCase().trim();
    
    setState(() {
      if (query.isEmpty) {
        _filteredSkills = List.from(_allSkills);
      } else {
        _filteredSkills = _allSkills
            .where((skill) => skill.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _handleContinue() {
    if (_controller.canProceedToNextStep()) {
      _controller.nextStep();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PostJobStepperStep2Screen(flavor: _currentFlavor),
        ),
      );
    }
  }
}
