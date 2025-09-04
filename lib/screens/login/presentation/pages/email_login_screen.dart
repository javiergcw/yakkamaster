import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../config/app_flavor.dart';
import '../../../../config/assets_config.dart';
import '../../../../features/widgets/custom_button.dart';
import '../../../../features/widgets/custom_text_field.dart';
import '../widgets/login_tabs.dart';
import '../widgets/terms_conditions.dart';
import '../../logic/controllers/email_login_controller.dart';

class EmailLoginScreen extends StatelessWidget {
  static const String id = '/email-login';
  
  EmailLoginScreen({super.key});

  final EmailLoginController controller = Get.put(EmailLoginController());

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
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header con botón de regreso
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Get.back(),
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
                      Obx(() => LoginTabs(
                        isLogin: controller.isLogin.value,
                        onTabChanged: controller.handleTabChanged,
                        flavor: controller.currentFlavor.value,
                      )),
                      
                      SizedBox(height: verticalSpacing * 2),
                      
                      // Email field
                      CustomTextField(
                        controller: controller.emailController,
                        hintText: 'Your Email',
                        keyboardType: TextInputType.emailAddress,
                        flavor: controller.currentFlavor.value,
                        validator: controller.validateEmail,
                      ),
                      
                      SizedBox(height: verticalSpacing),
                      
                      // Password field
                      Obx(() => CustomTextField(
                        controller: controller.passwordController,
                        hintText: 'Password',
                        obscureText: controller.obscurePassword.value,
                        flavor: controller.currentFlavor.value,
                        suffixIcon: IconButton(
                          onPressed: controller.togglePasswordVisibility,
                          icon: Icon(
                            controller.obscurePassword.value ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey[600],
                            size: screenWidth * 0.05,
                          ),
                        ),
                        validator: controller.validatePassword,
                      )),
                      
                      // Confirm Password field (solo para Register)
                      Obx(() => !controller.isLogin.value ? Column(
                        children: [
                          SizedBox(height: verticalSpacing),
                          CustomTextField(
                            controller: controller.confirmPasswordController,
                            hintText: 'Confirm Password',
                            obscureText: controller.obscureConfirmPassword.value,
                            flavor: controller.currentFlavor.value,
                            suffixIcon: IconButton(
                              onPressed: controller.toggleConfirmPasswordVisibility,
                              icon: Icon(
                                controller.obscureConfirmPassword.value ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey[600],
                                size: screenWidth * 0.05,
                              ),
                            ),
                            validator: controller.validateConfirmPassword,
                          ),
                        ],
                      ) : const SizedBox.shrink()),
                      
                      SizedBox(height: verticalSpacing),
                      
                      // Remember me and Forgot password (solo para Login)
                      Obx(() => controller.isLogin.value ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Remember me checkbox
                          Row(
                            children: [
                              Checkbox(
                                value: controller.rememberMe.value,
                                onChanged: controller.toggleRememberMe,
                                activeColor: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
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
                            onTap: controller.handleForgotPassword,
                            child: Text(
                              'Forgot password',
                              style: GoogleFonts.poppins(
                                fontSize: linkFontSize,
                                color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ) : const SizedBox.shrink()),
                      
                      // Terms and conditions (solo para Register)
                      Obx(() => !controller.isLogin.value ? Container(
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Transform.translate(
                              offset: Offset(-12, 0),
                              child: Checkbox(
                                value: controller.agreeToTerms.value,
                                onChanged: controller.toggleAgreeToTerms,
                                activeColor: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
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
                                          color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const TextSpan(text: ' & '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                          color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
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
                      ) : const SizedBox.shrink()),
                      
                      SizedBox(height: verticalSpacing * 2),
                      
                      // Login/Register button
                      Obx(() => CustomButton(
                        text: controller.getButtonText(),
                        onPressed: controller.isLogin.value ? controller.handleLogin : controller.handleRegister,
                        type: ButtonType.primary,
                        isLoading: controller.isLoading.value,
                        flavor: controller.currentFlavor.value,
                      )),
                      
                      SizedBox(height: verticalSpacing * 2),
                      
                      // Footer link
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(() => Text(
                              controller.getFooterText(),
                              style: GoogleFonts.poppins(
                                fontSize: linkFontSize,
                                color: Colors.grey[600],
                              ),
                            )),
                            GestureDetector(
                              onTap: controller.toggleMode,
                              child: Obx(() => Text(
                                controller.getFooterLinkText(),
                                style: GoogleFonts.poppins(
                                  fontSize: linkFontSize,
                                  color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
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
