import 'package:flutter/material.dart';
import './widgets/notification_list.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/providers/notification_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  void _handleShowBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 30,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        padding: EdgeInsets.zero, // bỏ padding mặc định
                        constraints:
                            const BoxConstraints(), // bỏ constraint thừa
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                color: Colors.grey.shade100,
                child: ListTile(
                  leading: const FaIcon(FontAwesomeIcons.check, size: 18),
                  title: const Text(
                    'Đánh dấu đã đọc tất cả',
                  ),
                  onTap: () {
                    context.read<NotificationProvider>().markAllAsRead();
                    context.pop();
                  },
                ),
              ),
              Card(
                color: Colors.grey.shade100,
                child: ListTile(
                  leading: const FaIcon(FontAwesomeIcons.trash, size: 18),
                  title: const Text(
                    'Xoá tất cả thông báo',
                  ),
                  onTap: () {
                    context
                        .read<NotificationProvider>()
                        .deleteAllNotifications();
                    context.pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Thông báo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _handleShowBottomSheet(context);
            },
          )
        ],
      ),
      body: const NotificationList(),
    );
  }
}
