import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../applicants/logic/controllers/applicant_controller.dart';
import '../../presentation/pages/map_screen.dart';
import '../../presentation/pages/messages_screen.dart';
import '../../presentation/pages/profile_screen.dart';
import '../../../post_job/presentation/pages/job_sites_screen.dart';
import '../../../my_jobs/presentation/pages/my_jobs_screen.dart';
import '../../presentation/pages/worker_list_screen.dart';
import '../../presentation/pages/job_sites_list_screen.dart';
import '../../presentation/pages/notifications_screen.dart';
import '../../../invoices/presentation/pages/invoices_screen.dart';

class BuilderHomeController extends GetxController {
  final RxInt selectedIndex = 0.obs; // Home tab selected
  final RxBool isSidebarOpen = false.obs; // Control del sidebar
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  @override
  void onInit() {
    super.onInit();
    // Inicializar el controlador de applicants para el punto rojo
    Get.put(ApplicantController());
    // Asegurar que Home esté seleccionado cuando se navega desde Map
    selectedIndex.value = 0;
  }

  void toggleSidebar() {
    isSidebarOpen.value = !isSidebarOpen.value;
  }

  void closeSidebar() {
    isSidebarOpen.value = false;
  }

  void selectTab(int index) {
    selectedIndex.value = index;
    
    // Navigate to different screens based on index
    if (index == 1) { // Map
      Get.toNamed(MapScreen.id, arguments: {'flavor': currentFlavor.value});
    } else if (index == 2) { // Messages
      Get.toNamed(MessagesScreen.id, arguments: {'flavor': currentFlavor.value});
    } else if (index == 3) { // Profile
      Get.toNamed(ProfileScreen.id, arguments: {'flavor': currentFlavor.value});
    }
  }

  void navigateToJobSites() {
    Get.toNamed(JobSitesScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void navigateToMyJobs() {
    Get.toNamed(MyJobsScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void navigateToApplicants() {
    Get.toNamed(WorkerListScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void navigateToStaff() {
    Get.toNamed(WorkerListScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void navigateToJobSitesList() {
    Get.toNamed(JobSitesListScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void navigateToInvoices() {
    Get.toNamed(InvoicesScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void navigateToNotifications() {
    Get.toNamed(NotificationsScreen.id, arguments: {'flavor': currentFlavor.value});
  }
}
