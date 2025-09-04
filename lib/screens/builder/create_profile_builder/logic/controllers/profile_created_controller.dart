import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../builder/home/presentation/pages/builder_home_screen.dart';

class ProfileCreatedController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  void handleNext() {
    // Navegar al BuilderHomeScreen usando GetX
    Get.offAllNamed(BuilderHomeScreen.id);
  }
}
