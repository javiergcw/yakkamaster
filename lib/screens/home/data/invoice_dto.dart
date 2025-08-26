class InvoiceDto {
  final String id;
  final String dateRange;
  final String recipientName;
  final String recipientStatus;
  final String recipientImage;
  final String status; // 'paid' o 'unpaid'
  final double amount;
  final DateTime startDate;
  final DateTime endDate;

  InvoiceDto({
    required this.id,
    required this.dateRange,
    required this.recipientName,
    required this.recipientStatus,
    required this.recipientImage,
    required this.status,
    required this.amount,
    required this.startDate,
    required this.endDate,
  });

  factory InvoiceDto.fromJson(Map<String, dynamic> json) {
    return InvoiceDto(
      id: json['id'] ?? '',
      dateRange: json['dateRange'] ?? '',
      recipientName: json['recipientName'] ?? '',
      recipientStatus: json['recipientStatus'] ?? '',
      recipientImage: json['recipientImage'] ?? '',
      status: json['status'] ?? 'unpaid',
      amount: (json['amount'] ?? 0.0).toDouble(),
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(json['endDate'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateRange': dateRange,
      'recipientName': recipientName,
      'recipientStatus': recipientStatus,
      'recipientImage': recipientImage,
      'status': status,
      'amount': amount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  InvoiceDto copyWith({
    String? id,
    String? dateRange,
    String? recipientName,
    String? recipientStatus,
    String? recipientImage,
    String? status,
    double? amount,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return InvoiceDto(
      id: id ?? this.id,
      dateRange: dateRange ?? this.dateRange,
      recipientName: recipientName ?? this.recipientName,
      recipientStatus: recipientStatus ?? this.recipientStatus,
      recipientImage: recipientImage ?? this.recipientImage,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
