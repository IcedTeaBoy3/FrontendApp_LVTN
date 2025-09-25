import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieDialog {
  static void show(
    BuildContext context, {
    required String animationPath,
    required String type,
    required String message,
    int duration = 2, // thời gian hiển thị (giây)
    VoidCallback? onClosed, // callback khi dialog đóng
  }) {
    showDialog(
      context: context,
      barrierDismissible: false, // bấm ngoài không tắt
      builder: (dialogContext) {
        // Auto đóng sau {duration} giây
        Future.delayed(Duration(seconds: duration), () {
          if (Navigator.of(dialogContext).canPop()) {
            Navigator.of(dialogContext).pop();
            if (onClosed != null) onClosed(); // gọi callback
          }
        });

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animation
                Lottie.asset(
                  animationPath,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  repeat: false, // chạy 1 lần
                ),
                const SizedBox(height: 12),
                // Title theo type
                Text(
                  type.toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _getColorByType(type),
                  ),
                ),
                const SizedBox(height: 8),
                // Message
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper chọn màu theo type
  static Color _getColorByType(String type) {
    switch (type.toLowerCase()) {
      case "success":
        return Colors.green;
      case "error":
        return Colors.red;
      case "warning":
        return Colors.orange;
      case "info":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
