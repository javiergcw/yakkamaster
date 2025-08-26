import 'package:flutter/material.dart';
import '../data/notification_dto.dart';

class NotificationsController {
  // Lista de notificaciones de ejemplo
  late final List<NotificationItem> _allNotifications;
  late final List<NotificationItem> _hireNotifications;
  late final List<NotificationItem> _hiredNotifications;
  late final List<NotificationItem> _paymentNotifications;
  late final List<NotificationItem> _timesheetNotifications;

  // Estado para el tab seleccionado
  int _selectedTabIndex = 0;

  NotificationsController() {
    _initializeNotifications();
  }

  void _initializeNotifications() {
    final now = DateTime.now();
    
    // Notificaciones de contratar a la persona (para builder)
    _hireNotifications = [
      NotificationItem(
        id: '1',
        title: 'Nueva solicitud de trabajo',
        message: 'Juan Pérez ha solicitado trabajar en tu proyecto de construcción',
        timestamp: now.subtract(Duration(hours: 2)),
        type: NotificationType.hireRequest,
        jobTitle: 'Construction Worker',
        companyName: 'ABC Construction',
      ),
      NotificationItem(
        id: '2',
        title: 'Solicitud de trabajo pendiente',
        message: 'María García quiere trabajar en tu proyecto de renovación',
        timestamp: now.subtract(Duration(hours: 5)),
        type: NotificationType.hireRequest,
        jobTitle: 'Renovation Specialist',
        companyName: 'ABC Construction',
      ),
    ];

    // Notificaciones de has sido contratado (para labour)
    _hiredNotifications = [
      NotificationItem(
        id: '3',
        title: '¡Has sido contratado!',
        message: 'Has sido seleccionado para el trabajo de Construction Worker',
        timestamp: now.subtract(Duration(hours: 1)),
        type: NotificationType.hired,
        jobTitle: 'Construction Worker',
        companyName: 'ABC Construction',
      ),
      NotificationItem(
        id: '4',
        title: 'Contratación confirmada',
        message: 'Tu solicitud para Renovation Specialist ha sido aprobada',
        timestamp: now.subtract(Duration(days: 1)),
        type: NotificationType.hired,
        jobTitle: 'Renovation Specialist',
        companyName: 'XYZ Renovations',
      ),
    ];

    // Notificaciones de han realizado un pago (para labour)
    _paymentNotifications = [
      NotificationItem(
        id: '5',
        title: 'Pago recibido',
        message: 'Has recibido un pago por tu trabajo en Construction Worker',
        timestamp: now.subtract(Duration(hours: 3)),
        type: NotificationType.payment,
        jobTitle: 'Construction Worker',
        companyName: 'ABC Construction',
        amount: 450.00,
      ),
      NotificationItem(
        id: '6',
        title: 'Pago procesado',
        message: 'Tu pago por Renovation Specialist ha sido procesado',
        timestamp: now.subtract(Duration(days: 2)),
        type: NotificationType.payment,
        jobTitle: 'Renovation Specialist',
        companyName: 'XYZ Renovations',
        amount: 380.00,
      ),
    ];

    // Notificaciones de han realizado una timesheet (para builder)
    _timesheetNotifications = [
      NotificationItem(
        id: '7',
        title: 'Timesheet enviada',
        message: 'Juan Pérez ha enviado su timesheet para esta semana',
        timestamp: now.subtract(Duration(hours: 4)),
        type: NotificationType.timesheet,
        jobTitle: 'Construction Worker',
        companyName: 'ABC Construction',
      ),
      NotificationItem(
        id: '8',
        title: 'Timesheet pendiente de revisión',
        message: 'María García ha completado su timesheet y está esperando tu aprobación',
        timestamp: now.subtract(Duration(hours: 6)),
        type: NotificationType.timesheet,
        jobTitle: 'Renovation Specialist',
        companyName: 'ABC Construction',
      ),
    ];

    // Combinar todas las notificaciones
    _allNotifications = [
      ..._hireNotifications,
      ..._hiredNotifications,
      ..._paymentNotifications,
      ..._timesheetNotifications,
    ];
  }

  // Getters
  int get selectedTabIndex => _selectedTabIndex;
  List<NotificationItem> get allNotifications => _allNotifications;
  List<NotificationItem> get hireNotifications => _hireNotifications;
  List<NotificationItem> get hiredNotifications => _hiredNotifications;
  List<NotificationItem> get paymentNotifications => _paymentNotifications;
  List<NotificationItem> get timesheetNotifications => _timesheetNotifications;

  List<NotificationItem> get currentNotifications {
    switch (_selectedTabIndex) {
      case 0:
        return _allNotifications;
      case 1:
        return _hireNotifications;
      case 2:
        return _hiredNotifications;
      case 3:
        return _paymentNotifications;
      case 4:
        return _timesheetNotifications;
      default:
        return _allNotifications;
    }
  }

  // Métodos de utilidad
  String getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  IconData getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.hireRequest:
        return Icons.person_add;
      case NotificationType.hired:
        return Icons.work;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.timesheet:
        return Icons.schedule;
    }
  }

  Color getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.hireRequest:
        return Colors.blue;
      case NotificationType.hired:
        return Colors.green;
      case NotificationType.payment:
        return Colors.orange;
      case NotificationType.timesheet:
        return Colors.purple;
    }
  }

  // Métodos de acción
  void setSelectedTabIndex(int index) {
    _selectedTabIndex = index;
  }

  void refreshNotifications() {
    _initializeNotifications();
  }

  void markAllAsRead() {
    // En una implementación real, esto actualizaría la base de datos
    print('Marking all notifications as read');
  }

  void handleNotificationTap(NotificationItem notification) {
    // Aquí puedes implementar la lógica específica para cada tipo de notificación
    print('Notification tapped: ${notification.title}');
  }
}
