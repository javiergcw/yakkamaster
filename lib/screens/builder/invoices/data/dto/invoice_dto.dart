class InvoiceDto {
  final String id;
  final String workerName;
  final String workerRole;
  final String workerImageUrl;
  final String jobsiteName;
  final String jobsiteAddress;
  final double total;
  final String date;
  final bool isSelected;
  final bool isPaid;

  InvoiceDto({
    required this.id,
    required this.workerName,
    required this.workerRole,
    required this.workerImageUrl,
    required this.jobsiteName,
    required this.jobsiteAddress,
    required this.total,
    required this.date,
    this.isSelected = false,
    this.isPaid = false,
  });

  InvoiceDto copyWith({
    String? id,
    String? workerName,
    String? workerRole,
    String? workerImageUrl,
    String? jobsiteName,
    String? jobsiteAddress,
    double? total,
    String? date,
    bool? isSelected,
    bool? isPaid,
  }) {
    return InvoiceDto(
      id: id ?? this.id,
      workerName: workerName ?? this.workerName,
      workerRole: workerRole ?? this.workerRole,
      workerImageUrl: workerImageUrl ?? this.workerImageUrl,
      jobsiteName: jobsiteName ?? this.jobsiteName,
      jobsiteAddress: jobsiteAddress ?? this.jobsiteAddress,
      total: total ?? this.total,
      date: date ?? this.date,
      isSelected: isSelected ?? this.isSelected,
      isPaid: isPaid ?? this.isPaid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workerName': workerName,
      'workerRole': workerRole,
      'workerImageUrl': workerImageUrl,
      'jobsiteName': jobsiteName,
      'jobsiteAddress': jobsiteAddress,
      'total': total,
      'date': date,
      'isSelected': isSelected,
      'isPaid': isPaid,
    };
  }

  factory InvoiceDto.fromMap(Map<String, dynamic> map) {
    return InvoiceDto(
      id: map['id'] ?? '',
      workerName: map['workerName'] ?? '',
      workerRole: map['workerRole'] ?? '',
      workerImageUrl: map['workerImageUrl'] ?? '',
      jobsiteName: map['jobsiteName'] ?? '',
      jobsiteAddress: map['jobsiteAddress'] ?? '',
      total: map['total']?.toDouble() ?? 0.0,
      date: map['date'] ?? '',
      isSelected: map['isSelected'] ?? false,
      isPaid: map['isPaid'] ?? false,
    );
  }
}
