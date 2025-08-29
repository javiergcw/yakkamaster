import 'package:get/get.dart';
import '../../data/dto/invoice_dto.dart';
import '../../data/dto/jobsite_invoices_dto.dart';
import '../../data/repositories/invoice_repository.dart';

class InvoiceController extends GetxController {
  final InvoiceRepository _repository = MockInvoiceRepository();
  
  final RxList<JobsiteInvoicesDto> _jobsiteInvoices = <JobsiteInvoicesDto>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxString _selectedJobsite = 'All Jobsites'.obs;
  final RxString _selectedSkill = 'All Skills'.obs;
  final RxString _searchQuery = ''.obs;
  final RxInt _currentTabIndex = 0.obs; // 0: Completed jobs, 1: Payment History

  // Getters
  List<JobsiteInvoicesDto> get jobsiteInvoices => _jobsiteInvoices;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  String get selectedJobsite => _selectedJobsite.value;
  String get selectedSkill => _selectedSkill.value;
  String get searchQuery => _searchQuery.value;
  int get currentTabIndex => _currentTabIndex.value;

  @override
  void onInit() {
    super.onInit();
    loadJobsiteInvoices();
  }

  Future<void> loadJobsiteInvoices() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      
      final invoices = await _repository.getJobsiteInvoices();
      _jobsiteInvoices.value = invoices;
    } catch (e) {
      _errorMessage.value = 'Error loading invoices: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  void setSelectedJobsite(String jobsite) {
    _selectedJobsite.value = jobsite;
  }

  void setSelectedSkill(String skill) {
    _selectedSkill.value = skill;
  }

  void setSearchQuery(String query) {
    _searchQuery.value = query;
  }

  void setCurrentTabIndex(int index) {
    _currentTabIndex.value = index;
  }

  List<String> getAvailableJobsites() {
    final jobsites = <String>['All Jobsites'];
    for (final jobsite in _jobsiteInvoices) {
      jobsites.add(jobsite.jobsiteName);
    }
    return jobsites;
  }

  List<String> getAvailableSkills() {
    return ['All Skills', 'Truck Driver', 'Carpenter', 'Electrician', 'Plumber', 'Painter'];
  }

  List<JobsiteInvoicesDto> getFilteredJobsiteInvoices() {
    List<JobsiteInvoicesDto> filtered = List.from(_jobsiteInvoices);

    // Filter by jobsite
    if (_selectedJobsite.value != 'All Jobsites') {
      filtered = filtered.where((jobsite) => 
        jobsite.jobsiteName == _selectedJobsite.value
      ).toList();
    }

    // Filter by skill
    if (_selectedSkill.value != 'All Skills') {
      filtered = filtered.map((jobsite) {
        final filteredInvoices = jobsite.invoices.where((invoice) =>
          invoice.workerRole == _selectedSkill.value
        ).toList();
        return jobsite.copyWith(invoices: filteredInvoices);
      }).where((jobsite) => jobsite.invoices.isNotEmpty).toList();
    }

    // Filter by search query
    if (_searchQuery.value.isNotEmpty) {
      filtered = filtered.map((jobsite) {
        final filteredInvoices = jobsite.invoices.where((invoice) =>
          invoice.workerName.toLowerCase().contains(_searchQuery.value.toLowerCase()) ||
          invoice.workerRole.toLowerCase().contains(_searchQuery.value.toLowerCase())
        ).toList();
        return jobsite.copyWith(invoices: filteredInvoices);
      }).where((jobsite) => jobsite.invoices.isNotEmpty).toList();
    }

    return filtered;
  }

  List<JobsiteInvoicesDto> getOutstandingInvoices() {
    return getFilteredJobsiteInvoices().map((jobsite) {
      final outstandingInvoices = jobsite.invoices.where((invoice) => !invoice.isPaid).toList();
      return jobsite.copyWith(invoices: outstandingInvoices);
    }).where((jobsite) => jobsite.invoices.isNotEmpty).toList();
  }

  List<JobsiteInvoicesDto> getCompletedInvoices() {
    return getFilteredJobsiteInvoices().map((jobsite) {
      final completedInvoices = jobsite.invoices.where((invoice) => invoice.isPaid).toList();
      return jobsite.copyWith(invoices: completedInvoices);
    }).where((jobsite) => jobsite.invoices.isNotEmpty).toList();
  }

  Future<void> payInvoice(String invoiceId) async {
    try {
      await _repository.payInvoice(invoiceId);
      // Update the invoice status in the list
      for (int i = 0; i < _jobsiteInvoices.length; i++) {
        final jobsite = _jobsiteInvoices[i];
        final invoiceIndex = jobsite.invoices.indexWhere((invoice) => invoice.id == invoiceId);
        if (invoiceIndex != -1) {
          final updatedInvoices = List<InvoiceDto>.from(jobsite.invoices);
          updatedInvoices[invoiceIndex] = updatedInvoices[invoiceIndex].copyWith(isPaid: true);
          _jobsiteInvoices[i] = jobsite.copyWith(invoices: updatedInvoices);
          break;
        }
      }
    } catch (e) {
      _errorMessage.value = 'Error paying invoice: $e';
    }
  }

  Future<void> sendInvoice(String invoiceId) async {
    try {
      await _repository.sendInvoice(invoiceId);
    } catch (e) {
      _errorMessage.value = 'Error sending invoice: $e';
    }
  }

  Future<void> viewInvoice(String invoiceId) async {
    try {
      await _repository.viewInvoice(invoiceId);
    } catch (e) {
      _errorMessage.value = 'Error viewing invoice: $e';
    }
  }

  Future<void> reportInvoice(String invoiceId) async {
    try {
      await _repository.reportInvoice(invoiceId);
    } catch (e) {
      _errorMessage.value = 'Error reporting invoice: $e';
    }
  }

  Future<void> toggleInvoiceSelection(String invoiceId) async {
    try {
      await _repository.toggleInvoiceSelection(invoiceId);
      // Update the invoice selection in the list
      for (int i = 0; i < _jobsiteInvoices.length; i++) {
        final jobsite = _jobsiteInvoices[i];
        final invoiceIndex = jobsite.invoices.indexWhere((invoice) => invoice.id == invoiceId);
        if (invoiceIndex != -1) {
          final updatedInvoices = List<InvoiceDto>.from(jobsite.invoices);
          final currentInvoice = updatedInvoices[invoiceIndex];
          updatedInvoices[invoiceIndex] = currentInvoice.copyWith(isSelected: !currentInvoice.isSelected);
          _jobsiteInvoices[i] = jobsite.copyWith(invoices: updatedInvoices);
          break;
        }
      }
    } catch (e) {
      _errorMessage.value = 'Error toggling invoice selection: $e';
    }
  }

  void clearError() {
    _errorMessage.value = '';
  }
}
