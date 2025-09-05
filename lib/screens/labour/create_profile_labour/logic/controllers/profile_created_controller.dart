import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../home/presentation/pages/home_screen.dart';
import '../../../../../screens/labour/create_profile_labour/presentation/pages/documents_screen.dart';

class ProfileCreatedController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
  }

  void handleStartUsingYakka() {
    // Navegar a la pantalla home de YAKKA usando GetX
    Get.offAllNamed(HomeScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void handleUploadResume() {
    // Navegar a la pantalla de documentos
    Get.toNamed(DocumentsScreen.id, arguments: {'flavor': currentFlavor.value});
  }
}
