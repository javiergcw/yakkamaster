import 'package:get/get.dart';
import '../../screens/job_listings/logic/controllers/job_listings_screen_controller.dart';
import '../../screens/job_listings/logic/controllers/job_details_screen_controller.dart';

class JobListingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobListingsScreenController>(() => JobListingsScreenController());
    Get.lazyPut<JobDetailsScreenController>(() => JobDetailsScreenController());
  }
}
