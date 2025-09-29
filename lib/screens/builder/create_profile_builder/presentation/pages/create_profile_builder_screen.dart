import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../widgets/progress_indicator.dart';
import '../../logic/controllers/create_profile_builder_controller.dart';

class CreateProfileBuilderScreen extends StatefulWidget {
  static const String id = '/create-profile-builder';
  
  const CreateProfileBuilderScreen({super.key});

  @override
  State<CreateProfileBuilderScreen> createState() => _CreateProfileBuilderScreenState();
}

class _CreateProfileBuilderScreenState extends State<CreateProfileBuilderScreen> {
  final CreateProfileBuilderController controller = Get.put(CreateProfileBuilderController(), tag: 'builder_profile');
  final FocusNode _firstNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Enfocar automáticamente el primer campo al cargar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _firstNameFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _firstNameFocusNode.dispose();
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
    final titleFontSize = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              SizedBox(height: verticalSpacing),
              
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
                        currentStep: 1,
                        totalSteps: 5,
                        flavor: controller.currentFlavor.value,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.065), // Espacio para balancear el layout
                ],
              ),

              SizedBox(height: verticalSpacing * 2),

              // Título principal
              Center(
                child: Text(
                  "What's your name?",
                  style: GoogleFonts.poppins(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: verticalSpacing * 2),

              // Campo First Name
              CustomTextField(
                controller: controller.firstNameController,
                focusNode: _firstNameFocusNode,
                hintText: "First name (Required)",
                showBorder: true,
                flavor: controller.currentFlavor.value,
              ),

              SizedBox(height: verticalSpacing * 0.8),

              // Campo Last Name
              CustomTextField(
                controller: controller.lastNameController,
                hintText: "Last name (Required)",
                showBorder: true,
                flavor: controller.currentFlavor.value,
              ),

              const Spacer(),

              // Botón Continue
              CustomButton(
                text: "Continue",
                onPressed: controller.handleNext,
                isLoading: false,
                showShadow: false,
              ),

              SizedBox(height: verticalSpacing * 2),
            ],
          ),
        ),
      ),
    );
  }
}
