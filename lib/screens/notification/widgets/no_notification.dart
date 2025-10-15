import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoNotification extends StatelessWidget {
  const NoNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/Notifications.json',
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 30),
          Text(
            'Bạn chưa có thông báo nào',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thông báo của bạn sẽ được hiển thị tại đây.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }
}
