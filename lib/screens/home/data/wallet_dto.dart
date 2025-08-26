class WalletDto {
  final String id;
  final String transactionId;
  final double amount;
  final String currency;
  final String status; // 'withdrawn' o 'received'
  final DateTime date;
  final String type; // 'withdrawn' o 'received'

  WalletDto({
    required this.id,
    required this.transactionId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.date,
    required this.type,
  });

  factory WalletDto.fromJson(Map<String, dynamic> json) {
    return WalletDto(
      id: json['id'] ?? '',
      transactionId: json['transactionId'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'USD',
      status: json['status'] ?? 'received',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      type: json['type'] ?? 'received',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transactionId': transactionId,
      'amount': amount,
      'currency': currency,
      'status': status,
      'date': date.toIso8601String(),
      'type': type,
    };
  }

  WalletDto copyWith({
    String? id,
    String? transactionId,
    double? amount,
    String? currency,
    String? status,
    DateTime? date,
    String? type,
  }) {
    return WalletDto(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      date: date ?? this.date,
      type: type ?? this.type,
    );
  }
}
