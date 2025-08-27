class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final String? jobTitle;
  final String? companyName;
  final double? amount;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.jobTitle,
    this.companyName,
    this.amount,
  });
}

enum NotificationType {
  hireRequest,      // Para builder: solicitud de contratación
  hired,           // Para labour: has sido contratado
  payment,         // Para labour: han realizado un pago
  timesheet,       // Para builder: han realizado una timesheet
}
