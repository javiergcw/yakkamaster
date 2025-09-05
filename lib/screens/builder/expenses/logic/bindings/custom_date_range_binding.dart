import 'package:get/get.dart';
import '../controllers/custom_date_range_controller.dart';

class CustomDateRangeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CustomDateRangeController>(CustomDateRangeController());
  }
}
