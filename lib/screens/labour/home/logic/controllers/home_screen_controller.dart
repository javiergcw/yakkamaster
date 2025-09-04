import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../data/applied_job_dto.dart';

class Shift {
  final String companyName;
  final String jobSite;
  final String startTime;
  final String endTime;

  Shift({
    required this.companyName,
    required this.jobSite,
    required this.startTime,
    required this.endTime,
  });
}

class HomeScreenController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final RxInt selectedIndex = 0.obs; // Home tab selected
  final RxBool isSidebarOpen = false.obs; // Control del sidebar
  
  // Variables para el modal de shifts
  final RxBool isShiftsModalOpen = false.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<DateTime> focusedDate = DateTime.now().obs;
  
  // Datos de ejemplo de shifts
  late final Map<String, List<Shift>> shiftsData;
  
  // Datos de ejemplo de trabajos aplicados
  late final List<AppliedJobDto> appliedJobs;
  
  // Variable para alternar entre estados (true = con trabajos, false = sin trabajos)
  final RxBool hasAppliedJobs = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
    
    // Establecer flavor si se proporciona en los argumentos
    final arguments = Get.arguments;
    if (arguments != null && arguments['flavor'] != null) {
      currentFlavor.value = arguments['flavor'];
    }
  }

  void _initializeData() {
    final now = DateTime.now();
    final currentMonth = now.month.toString().padLeft(2, '0');
    final currentYear = now.year;
    
    shiftsData = {
      '$currentYear-$currentMonth-15': [
        Shift(
          companyName: 'Yakka Labour',
          jobSite: 'Australia LTD',
          startTime: '8:00',
          endTime: '6:00pm',
        ),
      ],
      '$currentYear-$currentMonth-18': [
        Shift(
          companyName: 'Yakka Labour',
          jobSite: 'Melbourne Construction',
          startTime: '7:00',
          endTime: '5:00pm',
        ),
      ],
      '$currentYear-$currentMonth-22': [
        Shift(
          companyName: 'Yakka Labour',
          jobSite: 'Sydney Projects',
          startTime: '9:00',
          endTime: '7:00pm',
        ),
      ],
    };
    
    // Datos de ejemplo de trabajos aplicados
    appliedJobs = [
      AppliedJobDto(
        id: '1',
        companyName: 'Test company by yakka',
        jobTitle: 'Truck Driver',
        location: 'Sydney',
        status: 'Active',
        appliedDate: DateTime.now().subtract(Duration(days: 5)),
      ),
      AppliedJobDto(
        id: '2',
        companyName: 'Construction Corp',
        jobTitle: 'Laborer',
        location: 'Melbourne',
        status: 'Active',
        appliedDate: DateTime.now().subtract(Duration(days: 3)),
      ),
    ];
  }

  void handleApplyForJob() {
    // Navegar a la pantalla de job listings
    Get.toNamed('/labour/job-listings', arguments: {'flavor': currentFlavor.value});
  }

  void handleBottomNavTap(int index) {
    if (index == 1) {
      // Si se selecciona el tab de Shifts, abrir el modal
      isShiftsModalOpen.value = true;
    } else {
      selectedIndex.value = index;
      isShiftsModalOpen.value = false;
    }
  }

  void toggleSidebar() {
    isSidebarOpen.value = !isSidebarOpen.value;
  }

  void closeSidebar() {
    isSidebarOpen.value = false;
  }

  void closeShiftsModal() {
    isShiftsModalOpen.value = false;
  }

  void navigateToNotifications() {
    Get.toNamed('/labour/notifications', arguments: {'flavor': currentFlavor.value});
  }

  void navigateToInvoice() {
    Get.toNamed('/labour/invoice', arguments: {'flavor': currentFlavor.value});
  }

  void navigateToAppliedJobs() {
    Get.toNamed('/labour/applied-jobs', arguments: {
      'flavor': currentFlavor.value,
      'appliedJobs': appliedJobs,
    });
  }

  void navigateToDigitalId() {
    Get.toNamed('/labour/digital-id', arguments: {'flavor': currentFlavor.value});
  }

  void navigateToMessages() {
    Get.toNamed('/labour/messages', arguments: {'flavor': currentFlavor.value});
  }

  void navigateToProfile() {
    Get.toNamed('/labour/profile', arguments: {'flavor': currentFlavor.value});
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  void navigateMonth(bool isNext) {
    if (isNext) {
      focusedDate.value = DateTime(
        focusedDate.value.year,
        focusedDate.value.month + 1,
      );
    } else {
      focusedDate.value = DateTime(
        focusedDate.value.year,
        focusedDate.value.month - 1,
      );
    }
  }

  String getMonthYearString(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  bool hasShiftsForSelectedDate() {
    final dateKey = '${selectedDate.value.year}-${selectedDate.value.month.toString().padLeft(2, '0')}-${selectedDate.value.day.toString().padLeft(2, '0')}';
    return shiftsData.containsKey(dateKey);
  }

  List<Shift> getShiftsForSelectedDate() {
    final dateKey = '${selectedDate.value.year}-${selectedDate.value.month.toString().padLeft(2, '0')}-${selectedDate.value.day.toString().padLeft(2, '0')}';
    return shiftsData[dateKey] ?? [];
  }

  bool hasShiftsForDate(DateTime date) {
    final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return shiftsData.containsKey(dateKey);
  }
}
