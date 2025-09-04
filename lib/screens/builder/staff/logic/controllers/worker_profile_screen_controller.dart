import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../data/data.dart';

class WorkerProfileScreenController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final Rx<WorkerDto?> worker = Rx<WorkerDto?>(null);
  
  // Mock jobs data
  final RxList<Map<String, String>> mockJobs = <Map<String, String>>[
    {
      'title': 'Construction Worker - 15 Ernest St',
      'location': '15 Ernest St, Balgowlah Heights, Sydney',
      'date': 'Dec 15, 2024 - Dec 20, 2024',
      'status': 'Active',
      'isSelected': 'false',
    },
    {
      'title': 'Plumber - Downtown Project',
      'location': '123 Main St, Sydney CBD',
      'date': 'Dec 18, 2024 - Dec 25, 2024',
      'status': 'Active',
      'isSelected': 'false',
    },
    {
      'title': 'General Labourer - Warehouse',
      'location': '456 Industrial Ave, Botany',
      'date': 'Dec 10, 2024 - Dec 12, 2024',
      'status': 'Completed',
      'isSelected': 'false',
    },
    {
      'title': 'Electrician - Office Building',
      'location': '789 Business Blvd, North Sydney',
      'date': 'Dec 22, 2024 - Dec 30, 2024',
      'status': 'Active',
      'isSelected': 'false',
    },
  ].obs;

  void setWorker(WorkerDto workerData) {
    worker.value = workerData;
  }

  void handleBackNavigation() {
    Get.back();
  }

  void viewResume() {
    // TODO: Implement view resume functionality
    print('View resume for ${worker.value?.name}');
  }

  void startChat() {
    // TODO: Implement chat functionality
    print('Chat with ${worker.value?.name}');
  }

  void makeCall() {
    // TODO: Implement call functionality
    print('Call ${worker.value?.name}');
  }

  void toggleJobSelection(int index) {
    final job = mockJobs[index];
    if (job['isSelected'] == 'true') {
      job['isSelected'] = 'false';
    } else {
      // Deselect all other jobs
      for (var j in mockJobs) {
        j['isSelected'] = 'false';
      }
      job['isSelected'] = 'true';
    }
    mockJobs.refresh();
  }

  void rehireWorker() {
    // Find selected job and update its status
    final selectedJob = mockJobs.firstWhere(
      (job) => job['isSelected'] == 'true',
      orElse: () => mockJobs.first,
    );
    
    selectedJob['status'] = 'Active';
    selectedJob['isSelected'] = 'false';
    mockJobs.refresh();
    
    // Show success message
    Get.snackbar(
      'Success',
      '${worker.value?.name} has been rehired for ${selectedJob['title']}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

  void showJobsPopup() {
    // This method will be handled by the widget
    // The controller just manages the data
  }
}
