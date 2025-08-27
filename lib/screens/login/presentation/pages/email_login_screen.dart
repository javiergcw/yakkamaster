import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/app_flavor.dart';
import '../../../../config/assets_config.dart';
import '../../../../features/widgets/custom_button.dart';
import '../../../../features/widgets/custom_text_field.dart';
import '../widgets/login_tabs.dart';
import '../widgets/terms_conditions.dart';
import 'stepper_selection_screen.dart';

class EmailLoginScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const EmailLoginScreen({
    super.key,
    this.flavor,
  });

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLogin = true;
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleTabChanged(bool isLogin) {
    setState(() {
      _isLogin = isLogin;
      // Limpiar campos cuando se cambia de pestaña
      if (isLogin) {
        _confirmPasswordController.clear();
        _agreeToTerms = false;
      }
    });
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simular proceso de login
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => StepperSelectionScreen(flavor: _currentFlavor)),
          );
        }
      });
    }
  }

  void _handleForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Forgot password coming soon!')),
    );
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simular proceso de registro
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => StepperSelectionScreen(flavor: _currentFlavor)),
          );
        }
      });
    }
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
    final titleFontSize = screenWidth * 0.055; // 5.5% del ancho para el título
    final linkFontSize = screenWidth * 0.035; // 3.5% del ancho para enlaces
    
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
                    // Header con botón de regreso
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.black87,
                            size: screenWidth * 0.06,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          'E-mail login',
                          style: GoogleFonts.poppins(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: verticalSpacing * 2),
                    
                    // Tabs de Login/Register
                    LoginTabs(
                      isLogin: _isLogin,
                      onTabChanged: _handleTabChanged,
                      flavor: _currentFlavor,
                    ),
                    
                    SizedBox(height: verticalSpacing * 2),
                    
                    // Email field
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Your Email',
                      keyboardType: TextInputType.emailAddress,
                      flavor: _currentFlavor,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: verticalSpacing),
                    
                    // Password field
                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      obscureText: _obscurePassword,
                      flavor: _currentFlavor,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey[600],
                          size: screenWidth * 0.05,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    
                    // Confirm Password field (solo para Register)
                    if (!_isLogin) ...[
                      SizedBox(height: verticalSpacing),
                      CustomTextField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirm Password',
                        obscureText: _obscureConfirmPassword,
                        flavor: _currentFlavor,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey[600],
                            size: screenWidth * 0.05,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ],
                    
                    SizedBox(height: verticalSpacing),
                    
                    // Remember me and Forgot password (solo para Login)
                    if (_isLogin) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Remember me checkbox
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                                activeColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                              ),
                              Text(
                                'Remember Me',
                                style: GoogleFonts.poppins(
                                  fontSize: linkFontSize,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          // Forgot password link
                          GestureDetector(
                            onTap: _handleForgotPassword,
                            child: Text(
                              'Forgot password',
                              style: GoogleFonts.poppins(
                                fontSize: linkFontSize,
                                color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                    // Terms and conditions (solo para Register)
                    if (!_isLogin) ...[
                      Container(
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Transform.translate(
                              offset: Offset(-12, 0),
                              child: Checkbox(
                                value: _agreeToTerms,
                                onChanged: (value) {
                                  setState(() {
                                    _agreeToTerms = value ?? false;
                                  });
                                },
                                activeColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            Expanded(
                              child: Transform.translate(
                                offset: Offset(-8, 0),
                                child: RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.poppins(
                                      fontSize: linkFontSize,
                                      color: Colors.grey[600],
                                    ),
                                    children: [
                                      const TextSpan(text: 'I agree to '),
                                      TextSpan(
                                        text: 'Terms of Services',
                                        style: TextStyle(
                                          color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const TextSpan(text: ' & '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                          color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    SizedBox(height: verticalSpacing * 2),
                    
                    // Login/Register button
                    CustomButton(
                      text: _isLogin ? 'Login' : 'Register',
                      onPressed: _isLogin ? _handleLogin : _handleRegister,
                      type: ButtonType.primary,
                      isLoading: _isLoading,
                      flavor: _currentFlavor,
                    ),
                    
                    SizedBox(height: verticalSpacing * 2),
                    
                    // Footer link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isLogin ? "Don't have an account? " : "Have any account? ",
                            style: GoogleFonts.poppins(
                              fontSize: linkFontSize,
                              color: Colors.grey[600],
                            ),
                          ),
                          GestureDetector(
                            onTap: _handleRegister,
                            child: Text(
                              _isLogin ? 'Register' : 'Login',
                              style: GoogleFonts.poppins(
                                fontSize: linkFontSize,
                                color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
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
