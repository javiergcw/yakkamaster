import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../applicants/logic/controllers/applicant_controller.dart';
import '../../../applicants/presentation/pages/applicants_screen.dart';
import '../../presentation/pages/map_screen.dart';
import '../../presentation/pages/messages_screen.dart';
import '../../presentation/pages/profile_screen.dart';
import '../../../post_job/presentation/pages/job_sites_screen.dart';
import '../../../my_jobs/presentation/pages/my_jobs_screen.dart';
import '../../presentation/pages/job_sites_list_screen.dart';
import '../../presentation/pages/notifications_screen.dart';
import '../../../invoices/presentation/pages/invoices_screen.dart';
import '../../../expenses/presentation/pages/expenses_screen.dart';
import '../../../staff/presentation/pages/staff_screen.dart';

class BuilderHomeController extends GetxController {
  final RxInt selectedIndex = 0.obs; // Home tab selected
  final RxBool isSidebarOpen = false.obs; // Control del sidebar
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;

  @override
  void onInit() {
    super.onInit();
    // Inicializar el controlador de applicants para el punto rojo de manera segura
    try {
      Get.find<ApplicantController>();
    } catch (e) {
      Get.put(ApplicantController());
    }
    // No establecer selectedIndex aquí para evitar conflictos de navegación
  }

  void toggleSidebar() {
    isSidebarOpen.value = !isSidebarOpen.value;
  }

  void closeSidebar() {
    isSidebarOpen.value = false;
  }

  void selectTab(int index) {
    print('=== selectTab called with index: $index ===');
    selectedIndex.value = index;
    
    // Navigate to different screens based on index
    if (index == 1) { // Map
      print('Navigating to MapScreen with flavor: ${currentFlavor.value}');
      Get.toNamed(MapScreen.id, arguments: {'flavor': currentFlavor.value});
    } else if (index == 2) { // Messages
      print('Navigating to MessagesScreen with flavor: ${currentFlavor.value}');
      Get.toNamed(MessagesScreen.id, arguments: {'flavor': currentFlavor.value});
    } else if (index == 3) { // Profile
      print('Navigating to ProfileScreen with flavor: ${currentFlavor.value}');
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
    Get.toNamed(ApplicantsScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void navigateToWorkers() {
    Get.toNamed(MapScreen.id, arguments: {
      'flavor': currentFlavor.value,
      'showList': true, // Indicar que debe mostrar la lista primero
    });
  }

  void navigateToStaff() {
    Get.toNamed(StaffScreen.id, arguments: {'flavor': currentFlavor.value});
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

  void navigateToExpenses() {
    Get.toNamed(ExpensesScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void navigateToMap() {
    print('=== navigateToMap called directly ===');
    Get.toNamed(MapScreen.id, arguments: {'flavor': currentFlavor.value});
  }
}
