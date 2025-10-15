import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;

  void addNotification(NotificationModel noti) {
    _notifications.insert(0, noti);
    notifyListeners();
  }

  int countUnread() {
    return _notifications.where((n) => !n.isRead).length;
  }

  Future<void> fetchNotification({int page = 1, int limit = 100}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await NotificationService.getAllNotifications(
          page: page, limit: limit);

      if (response.status == 'success' && response.data != null) {
        _notifications = response.data!;
        notifyListeners();
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void markAllAsRead() async {
    final response = await NotificationService.markAllAsRead();
    if (response.status == 'success') {
      _notifications =
          _notifications.map((noti) => noti.copyWith(isRead: true)).toList();
      notifyListeners();
    }
  }

  void deleteAllNotifications() async {
    final response = await NotificationService.deleteAllNotifications();
    if (response.status == 'success') {
      _notifications.clear();
      notifyListeners();
    }
  }
}
