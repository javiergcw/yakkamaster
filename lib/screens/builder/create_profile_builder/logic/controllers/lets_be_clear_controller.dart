import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../presentation/pages/profile_created_screen.dart';

class LetsBeClearController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  void handleBackNavigation() {
    Get.back();
  }

  void handleAccept() {
    // Navegar a la pantalla de éxito
    Get.offAllNamed(ProfileCreatedScreen.id);
  }
}
