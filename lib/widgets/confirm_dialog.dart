import 'package:flutter/material.dart';

class ConfirmDialog {
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String content,
    String cancelText = "Hủy",
    String confirmText = "Xác nhận",
    Color confirmColor = Colors.red,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible:
          false, // không cho đóng dialog khi bấm ra ngoài → tránh return null
      builder: (BuildContext dialogContext) {
        return Center(
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            content: Text(content, style: const TextStyle(fontSize: 16)),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext, rootNavigator: true).pop(false);
                  if (onCancel != null) onCancel();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black87,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  cancelText,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext, rootNavigator: true).pop(true);
                  if (onConfirm != null) onConfirm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: confirmColor,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  confirmText,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    // đảm bảo luôn trả về bool, không bị null
    return result ?? false;
  }
}
