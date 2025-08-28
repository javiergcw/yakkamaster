import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../../logic/controllers/post_job_controller.dart';
import 'post_job_stepper_step7_screen.dart';

class PostJobStepperStep6Screen extends StatefulWidget {
  final AppFlavor? flavor;

  const PostJobStepperStep6Screen({
    super.key,
    this.flavor,
  });

  @override
  State<PostJobStepperStep6Screen> createState() => _PostJobStepperStep6ScreenState();
}

class _PostJobStepperStep6ScreenState extends State<PostJobStepperStep6Screen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  late PostJobController _controller;
  
  final List<String> _jobRequirements = [
    'White Card',
    'Clean the Job Place',
    'Good English Level',
    'Heavy Lifting',
    'ABN job',
    'SWMS',
    'RSA',
    'Must have experience',
    'Demolition Job',
    'Women Only',
    'Full PPE',
  ];
  
  final List<String> _credentials = [
    'Driver License',
    'Forklift License',
    'White Card',
    'First Aid Certificate',
    'Working at Heights',
    'Confined Spaces',
    'Other'
  ];
  
  final Set<String> _selectedRequirements = <String>{};
  final Set<String> _selectedCredentials = <String>{};
  String? _selectedCredential;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = Get.find<PostJobController>();
    // Asegurar que el controlador esté en el paso correcto
    _controller.goToStep(6);
    
    // Inicializar datos si ya existen en el controlador
    if (_controller.postJobData.requirements != null) {
      _selectedRequirements.addAll(_controller.postJobData.requirements!);
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final questionFontSize = screenWidth * 0.075;
    final subtitleFontSize = screenWidth * 0.045;
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
                vertical: verticalSpacing * 0.6,
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
                  
                  SizedBox(width: horizontalPadding + iconSize),
                ],
              ),
            ),
            
            // Progress Indicator
            Container(
              width: double.infinity,
              height: 2,
              child: Row(
                children: [
                  // Progress (yellow) - 6 steps completed
                  Expanded(
                    flex: 6,
                    child: Container(
                      color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                    ),
                  ),
                  // Remaining (grey)
                  Expanded(
                    flex: 3,
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
                    SizedBox(height: verticalSpacing * 0.2),
                    
                    // Main Question
                    Text(
                      "What details do you need for this job?",
                      style: GoogleFonts.poppins(
                        fontSize: questionFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                                         SizedBox(height: verticalSpacing),
                     
                     // Job Requirements Section
                     Text(
                       "Job Requirements",
                       style: GoogleFonts.poppins(
                         fontSize: screenWidth * 0.04,
                         fontWeight: FontWeight.w600,
                         color: Colors.black,
                       ),
                     ),
                     
                     SizedBox(height: verticalSpacing),
                     
                     // Requirements chips
                     _buildRequirementsChips(),
                     
                     SizedBox(height: verticalSpacing * 2),
                     
                                          // Licenses Section
                     Text(
                       "List any required licenses, tickets, or insurances.",
                       style: GoogleFonts.poppins(
                         fontSize: screenWidth * 0.035,
                         color: Colors.black87,
                       ),
                     ),
                     
                     SizedBox(height: verticalSpacing),
                     
                                          // Licenses input field with dropdown and add button
                     Row(
                       children: [
                         Expanded(
                           child: GestureDetector(
                             onTap: _showCredentialDropdown,
                             child: Container(
                               padding: EdgeInsets.symmetric(
                                 horizontal: horizontalPadding * 0.8,
                                 vertical: verticalSpacing * 0.8,
                               ),
                               decoration: BoxDecoration(
                                 color: Colors.white,
                                 borderRadius: BorderRadius.circular(12),
                                 border: Border.all(color: Colors.grey[300]!),
                               ),
                               child: Row(
                                 children: [
                                   Expanded(
                                     child: Text(
                                       _selectedCredential ?? "Select credential",
                                       style: GoogleFonts.poppins(
                                         fontSize: screenWidth * 0.035,
                                         color: _selectedCredential != null ? Colors.black : Colors.grey[600],
                                       ),
                                     ),
                                   ),
                                   Icon(
                                     Icons.keyboard_arrow_down,
                                     color: Colors.grey[600],
                                     size: screenWidth * 0.05,
                                   ),
                                 ],
                               ),
                             ),
                           ),
                         ),
                         SizedBox(width: horizontalPadding * 0.5),
                                                   GestureDetector(
                            onTap: _addCredential,
                                                         child: Container(
                               width: screenWidth * 0.12,
                               height: screenWidth * 0.12,
                               decoration: BoxDecoration(
                                 color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                 borderRadius: BorderRadius.circular(12),
                               ),
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                                size: screenWidth * 0.06,
                              ),
                            ),
                          ),
                       ],
                     ),
                     
                                           // Selected credentials display
                      if (_selectedCredentials.isNotEmpty) ...[
                        SizedBox(height: verticalSpacing),
                        Wrap(
                         spacing: horizontalPadding * 0.5,
                         runSpacing: verticalSpacing * 0.5,
                         children: _selectedCredentials.map((credential) {
                           return Container(
                             padding: EdgeInsets.symmetric(
                               horizontal: horizontalPadding * 0.6,
                               vertical: verticalSpacing * 0.4,
                             ),
                             decoration: BoxDecoration(
                               color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)).withOpacity(0.1),
                               borderRadius: BorderRadius.circular(20),
                               border: Border.all(
                                 color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)).withOpacity(0.3),
                               ),
                             ),
                             child: Row(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 Text(
                                   credential,
                                   style: GoogleFonts.poppins(
                                     fontSize: screenWidth * 0.03,
                                     color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                   ),
                                 ),
                                 SizedBox(width: horizontalPadding * 0.3),
                                 GestureDetector(
                                   onTap: () {
                                     setState(() {
                                       _selectedCredentials.remove(credential);
                                     });
                                   },
                                   child: Icon(
                                     Icons.close,
                                     size: screenWidth * 0.035,
                                     color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                   ),
                                 ),
                               ],
                             ),
                           );
                         }).toList(),
                       ),
                                           ],
                     
                     SizedBox(height: verticalSpacing * 2),
                     
                                          // Job Description Section
                     Text(
                       "Briefly explain what the worker will be doing and if they need to bring their own tools.",
                       style: GoogleFonts.poppins(
                         fontSize: screenWidth * 0.035,
                         color: Colors.black87,
                       ),
                     ),
                     
                     SizedBox(height: verticalSpacing),
                     
                                          // Description input field with Done button
                     Row(
                       children: [
                         Expanded(
                           child: CustomTextField(
                             labelText: "Description",
                             hintText: "Description...",
                             controller: _descriptionController,
                             flavor: _currentFlavor,
                             maxLines: 4,
                           ),
                         ),
                         SizedBox(width: horizontalPadding * 0.5),
                         TextButton(
                           onPressed: () {
                             // Hide keyboard
                             FocusScope.of(context).unfocus();
                           },
                           style: TextButton.styleFrom(
                             backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(8),
                             ),
                             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                           ),
                           child: Text(
                             "Done",
                             style: GoogleFonts.poppins(
                               fontSize: 12,
                               color: Colors.white,
                               fontWeight: FontWeight.w500,
                             ),
                           ),
                         ),
                       ],
                                          ),
                   
                   SizedBox(height: verticalSpacing * 2),
                  ],
                ),
              ),
            ),
            
            // Continue Button
            Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: CustomButton(
                text: "Continue",
                onPressed: _canProceed() ? _handleContinue : null,
                type: ButtonType.secondary,
                flavor: _currentFlavor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementsChips() {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final chipHeight = screenHeight * 0.045;
    final chipFontSize = screenWidth * 0.03;

    return Column(
      children: [
        for (int i = 0; i < _jobRequirements.length; i += 2)
          Padding(
            padding: EdgeInsets.only(bottom: verticalSpacing * 0.8),
            child: Row(
              children: [
                // First column
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        final requirement = _jobRequirements[i];
                        if (_selectedRequirements.contains(requirement)) {
                          _selectedRequirements.remove(requirement);
                        } else {
                          _selectedRequirements.add(requirement);
                        }
                      });
                      _controller.updateRequirements(_selectedRequirements.toList());
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding * 0.8,
                        vertical: verticalSpacing * 0.6,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedRequirements.contains(_jobRequirements[i])
                            ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                            : Colors.white,
                        borderRadius: BorderRadius.circular(chipHeight * 0.5),
                        border: Border.all(
                          color: _selectedRequirements.contains(_jobRequirements[i])
                              ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                              : Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _jobRequirements[i],
                        style: GoogleFonts.poppins(
                          fontSize: chipFontSize,
                          fontWeight: FontWeight.w500,
                          color: _selectedRequirements.contains(_jobRequirements[i]) ? Colors.white : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                
                // Spacing between columns
                SizedBox(width: horizontalPadding * 0.5),
                
                // Second column (if exists)
                if (i + 1 < _jobRequirements.length)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          final requirement = _jobRequirements[i + 1];
                          if (_selectedRequirements.contains(requirement)) {
                            _selectedRequirements.remove(requirement);
                          } else {
                            _selectedRequirements.add(requirement);
                          }
                        });
                        _controller.updateRequirements(_selectedRequirements.toList());
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding * 0.8,
                          vertical: verticalSpacing * 0.6,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedRequirements.contains(_jobRequirements[i + 1])
                              ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                              : Colors.white,
                          borderRadius: BorderRadius.circular(chipHeight * 0.5),
                          border: Border.all(
                            color: _selectedRequirements.contains(_jobRequirements[i + 1])
                                ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                                : Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _jobRequirements[i + 1],
                          style: GoogleFonts.poppins(
                            fontSize: chipFontSize,
                            fontWeight: FontWeight.w500,
                            color: _selectedRequirements.contains(_jobRequirements[i + 1]) ? Colors.white : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(child: SizedBox()), // Empty space for odd number of items
              ],
            ),
          ),
      ],
    );
  }

  bool _canProceed() {
    // Para este paso, solo necesitamos que haya al menos un requisito seleccionado
    // o que se haya ingresado una descripción
    return _selectedRequirements.isNotEmpty || 
           (_descriptionController.text.trim().isNotEmpty);
  }

  void _handleContinue() {
    if (_canProceed()) {
      _controller.nextStep();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PostJobStepperStep7Screen(flavor: _currentFlavor),
        ),
      );
    }
  }

  void _showCredentialDropdown() {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final titleFontSize = screenWidth * 0.045;
    final itemFontSize = screenWidth * 0.035;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Text(
                'Select Credential',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _credentials.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _credentials[index],
                      style: GoogleFonts.poppins(
                        fontSize: itemFontSize,
                        color: Colors.black87,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedCredential = _credentials[index];
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addCredential() {
    if (_selectedCredential == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona un tipo de credencial'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _selectedCredentials.add(_selectedCredential!);
      _selectedCredential = null; // Reset selection
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Credencial agregada'),
        backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
      ),
    );
  }
}
