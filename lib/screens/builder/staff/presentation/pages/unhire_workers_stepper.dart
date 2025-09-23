import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../data/data.dart';
import '../../logic/controllers/unhire_workers_stepper_controller.dart';

class UnhireWorkersStepper extends StatelessWidget {
  static const String id = '/unhire-workers-stepper';
  
  final AppFlavor? flavor;
  final List<JobsiteWorkersDto> workers;

  UnhireWorkersStepper({
    super.key,
    this.flavor,
    required this.workers,
  });

  final UnhireWorkersStepperController controller = Get.put(UnhireWorkersStepperController());

  @override
  Widget build(BuildContext context) {
    // Establecer datos en el controlador
    controller.workers = workers;
    if (flavor != null) {
      controller.currentFlavor.value = flavor!;
    }
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: _buildCurrentStep(),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
                     // Logo
                       SvgPicture.asset(
              AssetsConfig.getLogoMiddle(flavor ?? AppFlavorConfig.currentFlavor),
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
          Spacer(),
          // Title
          Text(
            'Unhire workers',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Spacer(),
                     // Close button
           IconButton(
             onPressed: () {
               controller.handleBackNavigation();
             },
             icon: Icon(Icons.close, color: Colors.black, size: 24),
           ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    return Obx(() {
      switch (controller.currentStep.value) {
        case 0:
          return _buildStep1();
        case 1:
          return _buildStep2();
        default:
          return _buildStep1();
      }
    });
  }

  Widget _buildStep1() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Which workers do you want to unhire?',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'This action cannot be undone',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.red[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 24),
          // Search bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Workers',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      border: InputBorder.none,
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Header with select all
          Row(
            children: [
              Text(
                'Workers',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  if (controller.selectedWorkerIds.length == controller.allWorkers.length) {
                    controller.deselectAllWorkers();
                  } else {
                    controller.selectAllWorkers();
                  }
                },
                child: Row(
                  children: [
                    Text(
                      'Select All',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(4),
                        color: controller.selectedWorkerIds.length == controller.allWorkers.length 
                            ? Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor))
                            : Colors.transparent,
                      ),
                      child: controller.selectedWorkerIds.length == controller.allWorkers.length
                          ? Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
                     
           // Workers list
          Expanded(
            child: ListView.builder(
                              itemCount: controller.allWorkers.length,
                itemBuilder: (context, index) {
                  final worker = controller.allWorkers[index];
                final isSelected = controller.selectedWorkerIds.contains(worker.id);
                
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.red[50] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.red[300]! : Colors.grey[300]!,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Profile picture
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                            image: NetworkImage(worker.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      // Worker info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              worker.name,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              worker.jobsiteName,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Selection checkbox
                      GestureDetector(
                        onTap: () {
                          controller.toggleWorkerSelection(worker.id);
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected 
                                  ? Colors.red[400]!
                                  : Colors.grey[400]!,
                            ),
                            borderRadius: BorderRadius.circular(4),
                            color: isSelected 
                                ? Colors.red[400]!
                                : Colors.transparent,
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Warning icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 40,
                    color: Colors.red[600],
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Are you sure you want to unhire\n${controller.selectedWorkerIds.length} worker${controller.selectedWorkerIds.length > 1 ? 's' : ''}?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'This action cannot be undone and will immediately remove them from all active jobs.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 32),
                // Selected workers preview
                Text(
                  'Workers to be unhired:',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: controller.selectedWorkerIds.map((workerId) {
                    final worker = controller.allWorkers.firstWhere((w) => w.id == workerId);
                    return Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            image: DecorationImage(
                              image: NetworkImage(worker.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              controller.toggleWorkerSelection(worker.id);
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Text(
                            worker.name.split(' ').take(2).join('\n'),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Obx(() => Row(
        children: [
          TextButton(
            onPressed: () {
              if (controller.currentStep.value > 0) {
                controller.previousStep();
              } else {
                controller.handleBackNavigation();
              }
            },
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: _canProceed() ? () {
              if (controller.currentStep.value < 1) {
                controller.nextStep();
              } else {
                controller.completeUnhireWorkers();
              }
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.currentStep.value == 1 ? Colors.red[600] : Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor)),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              controller.currentStep.value == 1 ? 'Unhire ${controller.selectedWorkerIds.length} worker${controller.selectedWorkerIds.length > 1 ? 's' : ''}' : 'Next',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      )),
    );
  }

  bool _canProceed() {
    switch (controller.currentStep.value) {
      case 0:
        return controller.selectedWorkerIds.isNotEmpty;
      case 1:
        return controller.selectedWorkerIds.isNotEmpty;
      default:
        return false;
    }
  }
}
