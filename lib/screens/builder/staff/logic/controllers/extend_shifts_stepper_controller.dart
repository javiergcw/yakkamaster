import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../data/data.dart';

class ExtendShiftsStepperController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final RxInt currentStep = 0.obs;
  final RxList<String> selectedWorkerIds = <String>[].obs;
  final Rx<DateTime?> selectedEndDate = Rx<DateTime?>(null);
  final RxList<JobsiteWorkersDto> jobsiteWorkers = <JobsiteWorkersDto>[].obs;
  
  List<JobsiteWorkersDto> workers = [];

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }

  void _loadMockData() {
    // Mock data for jobsites
    jobsiteWorkers.addAll([
      JobsiteWorkersDto(
        jobsiteId: '1',
        jobsiteName: '56 Fuller St',
        jobsiteAddress: '56 Fuller St, Mount Druitt, Sydney',
        workers: [],
      ),
      JobsiteWorkersDto(
        jobsiteId: '2',
        jobsiteName: '123 Main St',
        jobsiteAddress: '123 Main St, Parramatta, Sydney',
        workers: [],
      ),
      JobsiteWorkersDto(
        jobsiteId: '3',
        jobsiteName: '456 Oak Ave',
        jobsiteAddress: '456 Oak Ave, Blacktown, Sydney',
        workers: [],
      ),
    ]);
  }

  List<WorkerDto> get allWorkers {
    List<WorkerDto> allWorkers = [];
    for (var jobsite in workers) {
      allWorkers.addAll(jobsite.workers);
    }
    return allWorkers;
  }

  void handleBackNavigation() {
    Get.back();
  }

  void nextStep() {
    if (currentStep.value < 2) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void toggleWorkerSelection(String workerId) {
    if (selectedWorkerIds.contains(workerId)) {
      selectedWorkerIds.remove(workerId);
    } else {
      selectedWorkerIds.add(workerId);
    }
  }

  void selectAllWorkers() {
    selectedWorkerIds.clear();
    selectedWorkerIds.addAll(allWorkers.map((worker) => worker.id));
  }

  void deselectAllWorkers() {
    selectedWorkerIds.clear();
  }

  void setSelectedEndDate(DateTime? date) {
    selectedEndDate.value = date;
  }

  void completeExtendShifts() {
    // TODO: Implement actual extend shifts logic
    print('Extending shifts for: ${selectedWorkerIds.length} workers until: ${selectedEndDate.value}');
    Get.back();
  }

  bool get canProceedToStep1 {
    return selectedWorkerIds.isNotEmpty;
  }

  bool get canProceedToStep2 {
    return selectedWorkerIds.isNotEmpty && selectedEndDate.value != null;
  }

  bool get canComplete {
    return selectedWorkerIds.isNotEmpty && selectedEndDate.value != null;
  }
}
