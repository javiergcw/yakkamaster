import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../features/widgets/custom_button.dart';
import '../../../../features/widgets/phone_input.dart';
import '../widgets/login_header.dart';
import '../widgets/terms_conditions.dart';
import '../widgets/login_divider.dart';
import '../../logic/controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  static const String id = '/login';

  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());

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
            bottom:
                MediaQuery.of(context).viewInsets.bottom +
                horizontalPadding * 0.5,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  screenHeight -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header del login
                    Obx(
                      () => LoginHeader(flavor: controller.currentFlavor.value),
                    ),

                    // Phone number input
                    Obx(
                      () => PhoneInput(
                        controller: controller.phoneController,
                        flavor: controller.currentFlavor.value,
                        validator: controller.validatePhone,
                      ),
                    ),

                    SizedBox(height: verticalSpacing),

                    // Terms and conditions
                    Obx(
                      () => TermsConditions(
                        flavor: controller.currentFlavor.value,
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 1.5),

                    // Continue button
                    Obx(
                      () => CustomButton(
                        text: controller.getContinueButtonText(),
                        onPressed: controller.handleContinue,
                        type: ButtonType.primary,
                        isLoading: controller.isLoading.value,
                        flavor: controller.currentFlavor.value,
                        showShadow: false,
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 2.0),

                    // Divider
                    LoginDivider(),

                    SizedBox(height: verticalSpacing * 1.5),

                    // Alternative login buttons
                    Obx(
                      () => CustomButton(
                        text: 'Continue with email',
                        onPressed: controller.handleEmailLogin,
                        type: ButtonType.outline,
                        icon: Icons.mail_outline,

                        flavor: controller.currentFlavor.value,
                      ),
                    ),
                    SizedBox(height: buttonSpacing),
                    Obx(
                      () => CustomButton(
                        text: 'Continue with Google',
                        onPressed: controller.handleGoogleLogin,
                        type: ButtonType.outline,
                        iconAsset: 'assets/icons/social_media/google-icon.png',
                        flavor: controller.currentFlavor.value,
                      ),
                    ),
                    SizedBox(height: buttonSpacing),
                    Obx(
                      () => CustomButton(
                        text: 'Continue with Apple',
                        onPressed: controller.handleAppleLogin,
                        type: ButtonType.outline,
                        icon: Icons
                            .apple, // Mantener el icono de Apple como Material Design
                        flavor: controller.currentFlavor.value,
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
