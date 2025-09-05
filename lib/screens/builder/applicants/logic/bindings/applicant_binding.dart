import 'package:get/get.dart';
import '../controllers/applicant_controller.dart';

class ApplicantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicantController>(() => ApplicantController());
  }
}
