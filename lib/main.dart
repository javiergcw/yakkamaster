import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'config/app_flavor.dart';
import 'config/assets_config.dart';
import 'screens/join_splash_screen.dart';
import 'app/routes/app_pages.dart';
import 'app/bindings/join_splash_binding.dart';

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
      initialRoute: JoinSplashScreen.id,
      getPages: AppPages.pages,
      defaultTransition: Transition.fadeIn,
      initialBinding: JoinSplashBinding(),
    );
  }
}


