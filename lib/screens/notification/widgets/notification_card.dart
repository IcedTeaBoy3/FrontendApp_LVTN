import 'package:flutter/material.dart';
import 'package:frontend_app/models/notification.dart';
import 'package:frontend_app/utils/date_utils.dart';
import 'package:go_router/go_router.dart';
import 'notification_bottom_sheet.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (notification.type == 'appointment') {
          context.goNamed('home', queryParameters: {'initialIndex': '3'});
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
          color: notification.isRead ? Colors.white : Colors.blue.shade50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      notification.isRead
                          ? Icons.notifications_none
                          : Icons.notifications_active_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      notification.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: () {
                    showNotificationBottomSheet(
                      context,
                      notificationId: notification.notificationId,
                    );
                  },
                ),
              ],
            ),
            Text(
              notification.message,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '${formatTime(notification.createdAt)} - ${formatDate(notification.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
