import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'config/app_flavor.dart';

import 'screens/join_splash_screen.dart';
import 'app/routes/app_pages.dart';
import 'app/bindings/join_splash_binding.dart';
import 'features/logic/generals/use_case/general_use_case.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configurar estilo de la barra de estado
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  
  // Inicializar la aplicación  
  await _initializeApp();
  
  runApp(const YakkaSportsApp());
}

/// Inicializa la aplicación obteniendo el estado del servidor y guardando la licencia
Future<void> _initializeApp() async {
  try {
    print('🚀 Iniciando YakkaSports...');
    
    // Crear instancia del caso de uso de salud
    final healthUseCase = GetHealthUseCase();
    
    // Inicializar la aplicación
    final initResult = await healthUseCase.initializeApp();
    
    if (initResult.isSuccess && initResult.data != null) {
      final initData = initResult.data!;
      
      print('✅ Aplicación inicializada exitosamente');
      print('📊 Servidor saludable: ${initData['isHealthy']}');
      print('🔖 Versión: ${initData['version']}');
      print('🔑 Licencia guardada: ${initData['licenseSaved']}');
      print('⏰ Tiempo de inicialización: ${initData['initializationTime']}');
      
      // Verificar si la licencia se guardó correctamente
      if (initData['licenseSaved'] == true) {
        print('🎉 Licencia configurada correctamente para servicios de masters');
      } else {
        print('⚠️ Advertencia: La licencia no se guardó correctamente');
      }
      
    } else {
      print('❌ Error al inicializar aplicación: ${initResult.message}');
      print('⚠️ La aplicación continuará sin licencia configurada');
      
      // En caso de error, verificar si ya existe una licencia guardada
      final hasStoredLicense = await healthUseCase.hasStoredLicense();
      if (hasStoredLicense) {
        final storedLicense = await healthUseCase.getStoredLicense();
        print('🔑 Usando licencia previamente guardada: ${storedLicense?.substring(0, 10)}...');
      } else {
        print('⚠️ No hay licencia guardada - Los servicios de masters pueden fallar');
      }
    }
    
  } catch (e) {
    print('💥 Error inesperado durante la inicialización: $e');
    print('⚠️ La aplicación continuará sin verificación del servidor');
  }
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
      initialBinding: JoinSplashBinding(),
    );
  }
}
