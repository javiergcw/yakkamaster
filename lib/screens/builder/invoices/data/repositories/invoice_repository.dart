import '../dto/invoice_dto.dart';
import '../dto/jobsite_invoices_dto.dart';

abstract class InvoiceRepository {
  Future<List<JobsiteInvoicesDto>> getJobsiteInvoices();
  Future<void> payInvoice(String invoiceId);
  Future<void> sendInvoice(String invoiceId);
  Future<void> viewInvoice(String invoiceId);
  Future<void> reportInvoice(String invoiceId);
  Future<void> toggleInvoiceSelection(String invoiceId);
}

class MockInvoiceRepository implements InvoiceRepository {
  @override
  Future<List<JobsiteInvoicesDto>> getJobsiteInvoices() async {
    // Simular delay de red
    await Future.delayed(Duration(milliseconds: 800));
    
    return [
      JobsiteInvoicesDto(
        jobsiteId: '1',
        jobsiteName: '1 test ridge',
        jobsiteAddress: '1 test ridge, Sydney, Sydney',
        invoices: [
          InvoiceDto(
            id: '1',
            workerName: 'testing testing',
            workerRole: 'Truck Driver',
            workerImageUrl: 'https://via.placeholder.com/150/00ff00/000000?text=W',
            jobsiteName: '1 test ridge',
            jobsiteAddress: '1 test ridge, Sydney, Sydney',
            total: 283.05,
            date: '2025-08-25',
            isSelected: false,
            isPaid: false,
          ),
          InvoiceDto(
            id: '2',
            workerName: 'John Smith',
            workerRole: 'Carpenter',
            workerImageUrl: 'https://via.placeholder.com/150/ff0000/ffffff?text=J',
            jobsiteName: '1 test ridge',
            jobsiteAddress: '1 test ridge, Sydney, Sydney',
            total: 450.00,
            date: '2025-08-26',
            isSelected: false,
            isPaid: false,
          ),
        ],
      ),
      JobsiteInvoicesDto(
        jobsiteId: '2',
        jobsiteName: 'Downtown Project',
        jobsiteAddress: '123 Main St, Melbourne, VIC',
        invoices: [
          InvoiceDto(
            id: '3',
            workerName: 'Maria Garcia',
            workerRole: 'Electrician',
            workerImageUrl: 'https://via.placeholder.com/150/0000ff/ffffff?text=M',
            jobsiteName: 'Downtown Project',
            jobsiteAddress: '123 Main St, Melbourne, VIC',
            total: 320.75,
            date: '2025-08-24',
            isSelected: false,
            isPaid: false,
          ),
        ],
      ),
    ];
  }

  @override
  Future<void> payInvoice(String invoiceId) async {
    await Future.delayed(Duration(milliseconds: 500));
    print('Paying invoice: $invoiceId');
  }

  @override
  Future<void> sendInvoice(String invoiceId) async {
    await Future.delayed(Duration(milliseconds: 300));
    print('Sending invoice: $invoiceId');
  }

  @override
  Future<void> viewInvoice(String invoiceId) async {
    await Future.delayed(Duration(milliseconds: 200));
    print('Viewing invoice: $invoiceId');
  }

  @override
  Future<void> reportInvoice(String invoiceId) async {
    await Future.delayed(Duration(milliseconds: 400));
    print('Reporting invoice: $invoiceId');
  }

  @override
  Future<void> toggleInvoiceSelection(String invoiceId) async {
    await Future.delayed(Duration(milliseconds: 100));
    print('Toggling selection for invoice: $invoiceId');
  }
}
