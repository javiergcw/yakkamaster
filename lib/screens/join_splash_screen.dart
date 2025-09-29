import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../config/app_flavor.dart';
import '../config/assets_config.dart';
import 'join_splash_screen/logic/controllers/join_splash_controller.dart';

class JoinSplashScreen extends StatelessWidget {
  static const String id = '/join';
  
  JoinSplashScreen({super.key});

  final JoinSplashController controller = Get.put(JoinSplashController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              AppFlavorConfig.getJoinBackgroundColor(controller.currentFlavor.value),
              AppFlavorConfig.getJoinBackgroundColor(controller.currentFlavor.value).withOpacity(0.8),
            ],
          ),
        ),
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Animation
            AnimatedBuilder(
              animation: controller.logoAnimation,
              builder: (context, child) {
                final animationValue = controller.logoAnimation.value.clamp(0.0, 1.0);
                return Transform.scale(
                  scale: animationValue,
                  child: Opacity(
                    opacity: animationValue,
                    child: Obx(() => Image.asset(
                      AssetsConfig.getJoinLogo(controller.currentFlavor.value),
                      width: 400,
                      height: 200,
                      fit: BoxFit.contain,
                    )),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            // Text Animation
            AnimatedBuilder(
              animation: controller.textAnimation,
              builder: (context, child) {
                final textAnimationValue = controller.textAnimation.value.clamp(0.0, 1.0);
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - textAnimationValue)),
                  child: Opacity(
                    opacity: textAnimationValue,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          Obx(() => Text(
                            controller.getJoinTitle(),
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                            textAlign: TextAlign.center,
                          )),
                          const SizedBox(height: 8),
                         
                          Obx(() => Text(
                            controller.getJoinDescription(),
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          )),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 60),
            // Loading indicator
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    ));
  }
}
