import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../logic/controllers/invoice_controller.dart';
import '../../../staff/presentation/pages/move_workers_stepper.dart';
import '../../../staff/presentation/pages/extend_shifts_stepper.dart';
import '../../../staff/presentation/pages/unhire_workers_stepper.dart';
import '../../../staff/data/dto/worker_dto.dart';
import '../../../staff/data/dto/jobsite_workers_dto.dart';
import '../../presentation/widgets/report_modal.dart';

class InvoicesScreenController extends GetxController with GetSingleTickerProviderStateMixin {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final Rx<TextEditingController> searchController = TextEditingController().obs;
  late TabController tabController;
  late InvoiceController invoiceController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    searchController.value.text = '';
    invoiceController = Get.put(InvoiceController());
  }

  @override
  void onClose() {
    tabController.dispose();
    searchController.value.dispose();
    super.onClose();
  }

  void handleBackNavigation() {
    Get.back();
  }

  void handleTabChange(int index) {
    tabController.animateTo(index);
    invoiceController.setCurrentTabIndex(index);
  }

  void handleSearchChanged(String value) {
    invoiceController.setSearchQuery(value);
  }

  void handleJobsiteChanged(String? value) {
    invoiceController.setSelectedJobsite(value!);
  }

  void handleSkillSelected(String? skill) {
    invoiceController.setSelectedSkill(skill ?? '');
  }

  void navigateToMoveWorkers() {
    // Convertir invoices a JobsiteWorkersDto para compatibilidad
    final workersData = invoiceController.jobsiteInvoices.map((jobsite) {
      return JobsiteWorkersDto(
        jobsiteId: jobsite.jobsiteId,
        jobsiteName: jobsite.jobsiteName,
        jobsiteAddress: jobsite.jobsiteAddress,
        workers: jobsite.invoices.map((invoice) => WorkerDto(
          id: invoice.id,
          name: invoice.workerName,
          role: invoice.workerRole,
          hourlyRate: '\$${invoice.total.toStringAsFixed(2)}',
          imageUrl: invoice.workerImageUrl,
          isActive: !invoice.isPaid,
          jobsiteId: jobsite.jobsiteId,
          jobsiteName: jobsite.jobsiteName,
        )).toList(),
      );
    }).toList();
    
    Get.toNamed(MoveWorkersStepper.id, arguments: {
      'flavor': currentFlavor.value,
      'workers': workersData,
    });
  }

  void navigateToExtendShifts() {
    // Convertir invoices a JobsiteWorkersDto para compatibilidad
    final workersData = invoiceController.jobsiteInvoices.map((jobsite) {
      return JobsiteWorkersDto(
        jobsiteId: jobsite.jobsiteId,
        jobsiteName: jobsite.jobsiteName,
        jobsiteAddress: jobsite.jobsiteAddress,
        workers: jobsite.invoices.map((invoice) => WorkerDto(
          id: invoice.id,
          name: invoice.workerName,
          role: invoice.workerRole,
          hourlyRate: '\$${invoice.total.toStringAsFixed(2)}',
          imageUrl: invoice.workerImageUrl,
          isActive: !invoice.isPaid,
          jobsiteId: jobsite.jobsiteId,
          jobsiteName: jobsite.jobsiteName,
        )).toList(),
      );
    }).toList();
    
    Get.toNamed(ExtendShiftsStepper.id, arguments: {
      'flavor': currentFlavor.value,
      'workers': workersData,
    });
  }

  void navigateToUnhireWorkers() {
    // Convertir invoices a JobsiteWorkersDto para compatibilidad
    final workersData = invoiceController.jobsiteInvoices.map((jobsite) {
      return JobsiteWorkersDto(
        jobsiteId: jobsite.jobsiteId,
        jobsiteName: jobsite.jobsiteName,
        jobsiteAddress: jobsite.jobsiteAddress,
        workers: jobsite.invoices.map((invoice) => WorkerDto(
          id: invoice.id,
          name: invoice.workerName,
          role: invoice.workerRole,
          hourlyRate: '\$${invoice.total.toStringAsFixed(2)}',
          imageUrl: invoice.workerImageUrl,
          isActive: !invoice.isPaid,
          jobsiteId: jobsite.jobsiteId,
          jobsiteName: jobsite.jobsiteName,
        )).toList(),
      );
    }).toList();
    
    Get.toNamed(UnhireWorkersStepper.id, arguments: {
      'flavor': currentFlavor.value,
      'workers': workersData,
    });
  }

  void showReportModal(String invoiceId, String workerName) {
    Get.bottomSheet(
      ReportModal(
        flavor: currentFlavor.value,
        invoiceId: invoiceId,
        workerName: workerName,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
