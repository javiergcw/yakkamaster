import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/app_flavor.dart';
import '../../../../config/assets_config.dart';
import '../../../../features/widgets/custom_button.dart';
import '../../../../features/widgets/phone_input.dart';
import '../widgets/login_header.dart';
import '../widgets/terms_conditions.dart';
import '../widgets/login_divider.dart';
import '../../../create_profile_labour/presentation/pages/stepper_selection_screen.dart';
import 'email_login_screen.dart';

class LoginScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const LoginScreen({
    super.key,
    this.flavor,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simular proceso de login
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const StepperSelectionScreen()),
          );
        }
      });
    }
  }

  void _handleEmailLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EmailLoginScreen(flavor: _currentFlavor),
      ),
    );
  }

  void _handleGoogleLogin() {
    // Implementar login con Google
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Google login coming soon!')),
    );
  }

  void _handleAppleLogin() {
    // Implementar login con Apple
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Apple login coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06; // 6% del ancho de pantalla
    final verticalSpacing = screenHeight * 0.02; // 2% de la altura de pantalla
    final buttonSpacing = screenHeight * 0.015; // 1.5% de la altura de pantalla
    
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: horizontalPadding,
            right: horizontalPadding,
            top: horizontalPadding * 0.5,
            bottom: MediaQuery.of(context).viewInsets.bottom + horizontalPadding * 0.5,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header del login
                    LoginHeader(flavor: _currentFlavor),
                    
                    // Phone number input
                    PhoneInput(
                      controller: _phoneController,
                      flavor: _currentFlavor,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (value.length < 9) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: verticalSpacing),
                    
                    // Terms and conditions
                    TermsConditions(flavor: _currentFlavor),
                    
                    SizedBox(height: verticalSpacing * 1.5),
                    
                    // Continue button
                    CustomButton(
                      text: AppFlavorConfig.getContinueButtonText(_currentFlavor),
                      onPressed: _handleContinue,
                      type: ButtonType.secondary,
                      isLoading: _isLoading,
                      flavor: _currentFlavor,
                    ),
                    
                    SizedBox(height: verticalSpacing * 1.5),
                    
                    // Divider
                    LoginDivider(),
                    
                    SizedBox(height: verticalSpacing * 1.5),
                    
                    // Alternative login buttons
                    CustomButton(
                      text: 'Continue with email',
                      onPressed: _handleEmailLogin,
                      type: ButtonType.outline,
                      icon: Icons.email,
                      flavor: _currentFlavor,
                    ),
                    SizedBox(height: buttonSpacing),
                    CustomButton(
                      text: 'Continue with Google',
                      onPressed: _handleGoogleLogin,
                      type: ButtonType.outline,
                      icon: Icons.g_mobiledata, // Placeholder for Google icon
                      flavor: _currentFlavor,
                    ),
                    SizedBox(height: buttonSpacing),
                    CustomButton(
                      text: 'Continue with Apple',
                      onPressed: _handleAppleLogin,
                      type: ButtonType.outline,
                      icon: Icons.apple, // Placeholder for Apple icon
                      flavor: _currentFlavor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
