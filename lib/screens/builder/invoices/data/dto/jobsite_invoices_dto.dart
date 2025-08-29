import 'invoice_dto.dart';

class JobsiteInvoicesDto {
  final String jobsiteId;
  final String jobsiteName;
  final String jobsiteAddress;
  final List<InvoiceDto> invoices;

  JobsiteInvoicesDto({
    required this.jobsiteId,
    required this.jobsiteName,
    required this.jobsiteAddress,
    required this.invoices,
  });

  JobsiteInvoicesDto copyWith({
    String? jobsiteId,
    String? jobsiteName,
    String? jobsiteAddress,
    List<InvoiceDto>? invoices,
  }) {
    return JobsiteInvoicesDto(
      jobsiteId: jobsiteId ?? this.jobsiteId,
      jobsiteName: jobsiteName ?? this.jobsiteName,
      jobsiteAddress: jobsiteAddress ?? this.jobsiteAddress,
      invoices: invoices ?? this.invoices,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jobsiteId': jobsiteId,
      'jobsiteName': jobsiteName,
      'jobsiteAddress': jobsiteAddress,
      'invoices': invoices.map((x) => x.toMap()).toList(),
    };
  }

  factory JobsiteInvoicesDto.fromMap(Map<String, dynamic> map) {
    return JobsiteInvoicesDto(
      jobsiteId: map['jobsiteId'] ?? '',
      jobsiteName: map['jobsiteName'] ?? '',
      jobsiteAddress: map['jobsiteAddress'] ?? '',
      invoices: List<InvoiceDto>.from(map['invoices']?.map((x) => InvoiceDto.fromMap(x)) ?? []),
    );
  }
}
