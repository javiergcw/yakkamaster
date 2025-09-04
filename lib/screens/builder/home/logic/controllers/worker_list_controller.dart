import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';

class WorkerListController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final TextEditingController searchController = TextEditingController();
  
  final List<String> skillChips = [
    'General Labourer',
    'Carpenter',
    'Electrician',
    'Plumber',
    'Painter',
    'Welder',
  ];

  // Mock data for workers
  final List<Map<String, dynamic>> workers = [
    {
      'name': 'Robert James Hannan',
      'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      'skills': 'General Labourer - Carpenter - Lawn mower - Formworker - Steel Fixer - Han...',
      'rating': 5.0,
      'location': null,
    },
    {
      'name': 'Paula Guerrero',
      'image': 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
      'skills': 'Cleaner - General Labourer - Other',
      'rating': 5.0,
      'location': 'Wolli Creek',
    },
    {
      'name': 'Yamil Cardozo',
      'image': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      'skills': 'General Labourer - Electrician - HVAC Technician - Electrician',
      'rating': 5.0,
      'location': 'Argentina',
    },
    {
      'name': 'Tom Guibourt',
      'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
      'skills': 'Gene... Gardener - ...orker - Landscaper - Warehouse Lab.',
      'rating': 5.0,
      'location': null,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
    searchController.text = '';
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void showJobSelectionModal(String workerName) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Select a job',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              // Job Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Truck Driver',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '2025-08-25',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Cancel Button
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // OK Button
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Process hire action
                        Get.back();
                        // Show success message or navigate to next screen
                        Get.snackbar(
                          'Success',
                          'Worker hired successfully!',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor.value)),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: Text(
                        'OK',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToMap() {
    Get.back(); // Go back to map
  }

  void navigateToHome() {
    Get.offAllNamed('/builder/home', arguments: {'flavor': currentFlavor.value});
  }

  void navigateToMessages() {
    Get.toNamed('/builder/messages', arguments: {'flavor': currentFlavor.value});
  }

  void navigateToProfile() {
    // TODO: Navigate to Profile screen
    Get.snackbar(
      'Info',
      'Profile screen navigation not implemented yet',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void openChat() {
    // TODO: Open chat
    Get.snackbar(
      'Info',
      'Chat feature not implemented yet',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }
}
