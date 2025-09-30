import 'package:get/get.dart';
import '../../screens/labour/logic/controllers/labour_job_details_controller.dart';

class LabourJobDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LabourJobDetailsController>(() => LabourJobDetailsController());
  }
}
