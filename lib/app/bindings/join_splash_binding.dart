import 'package:get/get.dart';
import '../../screens/join_splash_screen/logic/controllers/join_splash_controller.dart';

class JoinSplashBinding extends Bindings {
  @override
  void dependencies() {
    // Inyectar el controlador de join splash
    Get.lazyPut<JoinSplashController>(() => JoinSplashController());
  }
}
