import 'package:get/get.dart';
import '../controllers/filter_jobsites_controller.dart';

class FilterJobSitesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FilterJobSitesController>(FilterJobSitesController());
  }
}
