import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'config/app_flavor.dart';
import 'config/assets_config.dart';
import 'screens/join_splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const YakkaSportsApp());
}

class YakkaSportsApp extends StatelessWidget {
  const YakkaSportsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppFlavorConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(AppFlavorConfig.primaryColor),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(AppFlavorConfig.primaryColor),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();
    
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _logoController.forward();
    
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              JoinSplashScreen(flavor: AppFlavorConfig.currentFlavor),
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
    super.dispose();
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _logoAnimation,
          builder: (context, child) {
            final animationValue = _logoAnimation.value.clamp(0.0, 1.0);
            return Transform.scale(
              scale: animationValue,
              child: Opacity(
                opacity: animationValue,
                                      child: SvgPicture.asset(
                        AssetsConfig.getLogo(AppFlavorConfig.currentFlavor),
                        width: 200,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
