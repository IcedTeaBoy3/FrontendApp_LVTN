import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/providers/notification_provider.dart';

void showNotificationBottomSheet(BuildContext context,
    {String? notificationId}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      final notificationProvider = context.read<NotificationProvider>();

      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 30,
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            if (notificationId == null) ...[
              Card(
                color: Colors.grey.shade100,
                child: ListTile(
                  leading: const Icon(Icons.check),
                  title: const Text('Đánh dấu tất cả đã đọc'),
                  onTap: () {
                    notificationProvider.markAllAsRead();
                    Navigator.pop(context);
                  },
                ),
              ),
              Card(
                color: Colors.grey.shade100,
                child: ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Xóa tất cả thông báo'),
                  onTap: () {
                    notificationProvider.deleteAllNotifications();
                    Navigator.pop(context);
                  },
                ),
              ),
            ] else ...[
              Card(
                color: Colors.grey.shade100,
                child: ListTile(
                  leading: const Icon(Icons.check),
                  title: const Text('Đánh dấu đã đọc'),
                  onTap: () {
                    notificationProvider.markAsRead(notificationId);
                    Navigator.pop(context);
                  },
                ),
              ),
              Card(
                color: Colors.grey.shade100,
                child: ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Xóa thông báo này'),
                  onTap: () {
                    notificationProvider.deleteNotification(notificationId);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ],
        ),
      );
    },
  );
}
