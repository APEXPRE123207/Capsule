import 'package:flutter/material.dart';

/// Desktop Notification model displayed in the Dynamic Island
class CapsuleNotification {
  const CapsuleNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.sourceApp,
    required this.timestamp,
    this.iconData = Icons.notifications_active_rounded,
    this.actionLabel,
    this.onAction,
  });

  final String id;
  final String title;
  final String body;
  final String sourceApp;
  final DateTime timestamp;
  final IconData iconData;
  final String? actionLabel;
  final VoidCallback? onAction;
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final List<CapsuleNotification> _notifications = [];
  List<CapsuleNotification> get notifications => List.unmodifiable(_notifications);

  void postNotification(CapsuleNotification notification) {
    _notifications.insert(0, notification);
    if (_notifications.length > 20) _notifications.removeLast();
  }

  void dismiss(String id) {
    _notifications.removeWhere((n) => n.id == id);
  }

  void clearAll() {
    _notifications.clear();
  }
}
