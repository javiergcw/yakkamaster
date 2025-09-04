import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../presentation/pages/lets_be_clear_screen.dart';

class RespectController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  @override
  void onInit() {
    super.onInit();
    initializeController();
  }

  void initializeController() {
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
  }

  void handleBackNavigation() {
    Get.back();
  }

  void handleCommit() {
    // Navegar a la pantalla "Let's Be Clear" usando GetX
    Get.toNamed(LetsBeClearScreen.id, arguments: {'flavor': currentFlavor.value});
  }
}
