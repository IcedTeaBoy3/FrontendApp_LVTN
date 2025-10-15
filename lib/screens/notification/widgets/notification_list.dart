import 'package:flutter/material.dart';
import 'package:frontend_app/screens/notification/widgets/notification_card.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/providers/notification_provider.dart';
import 'package:frontend_app/widgets/custom_loading.dart';
import 'no_notification.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, child) {
        final notifications = notificationProvider.notifications;
        if (notificationProvider.isLoading) {
          return const CustomLoading();
        } else if (notifications.isEmpty) {
          return const NoNotification();
        }
        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final noti = notifications[index];
            return NotificationCard(notification: noti);
          },
        );
      },
    );
  }
}
