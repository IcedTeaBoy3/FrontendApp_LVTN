import 'package:flutter/material.dart';
import '../models/notification.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

  void addNotification(NotificationModel noti) {
    _notifications.insert(0, noti);
    notifyListeners();
  }

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.notificationId == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }
}
