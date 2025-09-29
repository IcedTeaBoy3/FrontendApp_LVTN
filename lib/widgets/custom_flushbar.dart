import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class CustomFlushbar {
  static void show(
    BuildContext context, {
    required String status,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    Color backgroundColor = Colors.black,
    FlushbarPosition flushbarPosition = FlushbarPosition.TOP,
  }) {
    Flushbar(
      title: _convertMessage(status),
      icon: Icon(
        _convertIcon(status),
        size: 28,
        color: Colors.white,
      ),
      message: message,
      duration: duration,
      backgroundColor: _convertColor(status),
      flushbarPosition: flushbarPosition,
      borderRadius: BorderRadius.circular(8),
      margin: const EdgeInsets.all(8),
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withAlpha(30),
          offset: const Offset(0, 2),
          blurRadius: 6,
        ),
      ],
    ).show(context);
  }

  static String _convertMessage(String status) {
    switch (status) {
      case 'success':
        return 'Thành công';
      case 'error':
        return 'Thất bại';
      case 'warning':
        return 'Cảnh báo';
      default:
        return 'Thông báo';
    }
  }

  static Color _convertColor(String status) {
    switch (status) {
      case 'success':
        return Colors.green;
      case 'error':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  static IconData _convertIcon(String status) {
    switch (status) {
      case 'success':
        return Icons.check_circle_outline;
      case 'error':
        return Icons.error_outline;
      case 'warning':
        return Icons.warning_amber_outlined;
      default:
        return Icons.info_outline;
    }
  }
}
