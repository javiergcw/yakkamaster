import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../presentation/pages/respect_screen.dart';

class EmployeeSelectionController extends GetxController {
  final RxString? selectedEmployeeRange = RxString('');
  
  final List<String> employeeRanges = [
    '0-1',
    '2-6',
    '7-15',
    '16-49',
    '50+',
  ];
  
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
  }

  void selectEmployeeRange(String range) {
    selectedEmployeeRange?.value = range;
  }

  void handleNext() {
    if (selectedEmployeeRange?.value.isNotEmpty == true) {
      // Navegar a la pantalla de respeto
      Get.toNamed(RespectScreen.id, arguments: {'flavor': currentFlavor.value});
    }
  }
}
