import 'package:get/get.dart';
import '../../screens/builder/home/logic/controllers/builder_home_controller.dart';
import '../../screens/builder/home/logic/controllers/profile_screen_controller.dart';
import '../../screens/builder/home/logic/controllers/messages_screen_controller.dart';
import '../../screens/builder/home/logic/controllers/notifications_screen_controller.dart';
import '../../screens/builder/home/logic/controllers/edit_personal_details_controller.dart';
import '../../screens/builder/home/logic/controllers/job_sites_list_controller.dart';
import '../../screens/builder/home/logic/controllers/map_screen_controller.dart';
import '../../screens/builder/home/logic/controllers/worker_list_controller.dart';
import '../../screens/builder/home/logic/controllers/chat_screen_controller.dart';
import '../../screens/builder/post_job/logic/controllers/post_job_controller.dart';
import '../../screens/builder/post_job/logic/controllers/unified_post_job_controller.dart';
import '../../screens/builder/post_job/logic/controllers/job_site_controller.dart';
import '../../screens/builder/post_job/logic/controllers/job_sites_screen_controller.dart';
import '../../screens/builder/post_job/logic/controllers/create_edit_job_site_screen_controller.dart';
import '../../screens/builder/my_jobs/logic/controllers/my_jobs_controller.dart';
import '../../screens/builder/invoices/logic/controllers/invoices_screen_controller.dart';
import '../../screens/builder/staff/logic/controllers/staff_screen_controller.dart';
import '../../screens/builder/staff/logic/controllers/move_workers_stepper_controller.dart';
import '../../screens/builder/applicants/logic/controllers/applicant_controller.dart';

class BuilderBinding extends Bindings {
  @override
  void dependencies() {
    // Inyectar controladores del módulo builder
    Get.lazyPut<BuilderHomeController>(() => BuilderHomeController());
    Get.lazyPut<ProfileScreenController>(() => ProfileScreenController());
    Get.lazyPut<MessagesScreenController>(() => MessagesScreenController());
    Get.lazyPut<NotificationsScreenController>(() => NotificationsScreenController());
    Get.lazyPut<EditPersonalDetailsController>(() => EditPersonalDetailsController());
    Get.lazyPut<JobSitesListController>(() => JobSitesListController());
    Get.lazyPut<MapScreenController>(() => MapScreenController());
    Get.lazyPut<WorkerListController>(() => WorkerListController());
    Get.lazyPut<ChatScreenController>(() => ChatScreenController());
    Get.lazyPut<PostJobController>(() => PostJobController());
    Get.lazyPut<UnifiedPostJobController>(() => UnifiedPostJobController());
    Get.lazyPut<JobSiteController>(() => JobSiteController());
    Get.lazyPut<JobSitesScreenController>(() => JobSitesScreenController());
    Get.lazyPut<CreateEditJobSiteScreenController>(() => CreateEditJobSiteScreenController());
    Get.lazyPut<MyJobsController>(() => MyJobsController());
    Get.lazyPut<InvoicesScreenController>(() => InvoicesScreenController());
    Get.lazyPut<StaffScreenController>(() => StaffScreenController());
    Get.lazyPut<MoveWorkersStepperController>(() => MoveWorkersStepperController());
    Get.lazyPut<ApplicantController>(() => ApplicantController());
  }
}
