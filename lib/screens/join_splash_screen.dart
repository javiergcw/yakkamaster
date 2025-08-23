import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config/app_flavor.dart';
import '../config/assets_config.dart';
import 'login/presentation/pages/login_screen.dart';

class JoinSplashScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const JoinSplashScreen({
    super.key,
    this.flavor,
  });

  @override
  State<JoinSplashScreen> createState() => _JoinSplashScreenState();
}

class _JoinSplashScreenState extends State<JoinSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;

  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();

    await Future.delayed(const Duration(milliseconds: 3000));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              LoginScreen(flavor: _currentFlavor),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppFlavorConfig.getJoinBackgroundColor(_currentFlavor),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Animation
            AnimatedBuilder(
              animation: _logoAnimation,
              builder: (context, child) {
                final animationValue = _logoAnimation.value.clamp(0.0, 1.0);
                return Transform.scale(
                  scale: animationValue,
                  child: Opacity(
                    opacity: animationValue,
                    child: SvgPicture.asset(
                      AssetsConfig.getJoinLogo(_currentFlavor),
                      width: 200,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            // Text Animation
            AnimatedBuilder(
              animation: _textAnimation,
              builder: (context, child) {
                final textAnimationValue = _textAnimation.value.clamp(0.0, 1.0);
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - textAnimationValue)),
                  child: Opacity(
                    opacity: textAnimationValue,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          Text(
                            _getJoinTitle(),
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: 1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getJoinSubtitle(),
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),
                          Text(
                            _getJoinDescription(),
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
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
                  Colors.black87.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getJoinTitle() {
    switch (_currentFlavor) {
      case AppFlavor.labour:
        return 'WORK OR HIRE';
      case AppFlavor.sport:
        return 'PLAY OR WATCH';
      case AppFlavor.hospitality:
        return 'SERVE OR ENJOY';
    }
  }

  String _getJoinSubtitle() {
    switch (_currentFlavor) {
      case AppFlavor.labour:
        return 'No worries.';
      case AppFlavor.sport:
        return 'No limits.';
      case AppFlavor.hospitality:
        return 'No boundaries.';
    }
  }

  String _getJoinDescription() {
    switch (_currentFlavor) {
      case AppFlavor.labour:
        return 'Construction &\nHospitality Jobs';
      case AppFlavor.sport:
        return 'Sports &\nFitness Activities';
      case AppFlavor.hospitality:
        return 'Hospitality &\nService Industry';
    }
  }
}
